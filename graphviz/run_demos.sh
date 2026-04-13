# apt install graphviz
# dot -V

# Generate graph
echo 'digraph { a -> b }' | dot -Tsvg > output.svg
echo 'digraph { a -> b }' | dot -Tpng > output.png

# refers:
#   https://icodeit.org/2015/11/using-graphviz-drawing/
#   https://zhuanlan.zhihu.com/p/194274635
cat demo1.dot | dot -Tpng > demo1.png
cat demo2.dot | dot -Tpng > demo2.png
#cat demo3.dot | dot -Tpng > demo3.png
cat demo4.dot | dot -Tpng > demo4.png

# Show image
# apt install timg
timg output.png
timg -pi output.png # using iterm2 graph protocol
timg -ps output.png # using sixel graph protocol

timg demo1.png
