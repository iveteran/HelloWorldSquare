/* ref: https://xwjgo.github.io/2018/03/09/jison%20VS%20PEG.js/ */
/* lexical grammar */
/* 这部分依次从上到下匹配，因此排列顺序很重要 */

%lex
%%

\s+                                             /* skip whitespace */
[0-9]+(\.[0-9]+)?\b                             return 'NUMBER'
"*"                                             return '*'
"/"                                             return '/'
"-"                                             return '-'
"+"                                             return '+'
"("                                             return '('
")"                                             return ')'
<<EOF>>                                         return 'EOF'
.                                               return 'INVALID'

/lex

/* operator associations and precedence */

%left '+' '-'
%left '*' '/'
%right UNARY

%start expressions

%% /* language grammar */

expressions
    : e EOF
        { return $1; }
    ;
e
    : e '+' e
        { $$ = $1 + $3; }
    | e '-' e
        { $$ = $1 - $3; }
    | e '*' e
        { $$ = $1 * $3; }
    | e '/' e
        { $$ = $1 / $3; }
    | '-' e %prec UNARY
        { $$ = -$2; }
    | '+' e %prec UNARY
        { $$ = +$2; }
    | '(' e ')'
        { $$ = $2; }
    | NUMBER
        { $$ = Number($1); }
    ;
