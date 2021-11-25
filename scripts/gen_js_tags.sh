find . -not -path "./node_modules/*" |egrep "\.jsx?$" |xargs jsctags {} -f \; | sed '/^$/d' | LANG=C sort > tags
