echo "[ A ] - to -> [ B ]" | graph-easy --as=boxart
echo 'digraph { a -> b; b -> c; a -> c[label="optional"] }' | graph-easy --as=boxart
echo "digraph G {
    nodesep = 2;
    ranksep = 1;
    rankdir = LR;
    a -> b;
    c;
    b -> d;
}
" | graph-easy --as=boxart
