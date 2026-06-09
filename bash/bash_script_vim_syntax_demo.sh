# 测试自定义vim语法高亮，针对bash自定义函数名
# ~/.vim/after/syntax/bash.vim
myFunc() {
    echo $1 $2
    return 1
}

arg2="bar"
 myFunc
myFunc "foo" $arg2
foo=$(myFunc "foo" $arg2)

echo $foo
printf $foo
exit 0
