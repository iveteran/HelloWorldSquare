# 将 PATH 拆成数组
paths=(${PATH//:/ })

# 过滤掉你不想要的路径
newpath=$(printf ":%s" "${paths[@]}" | sed 's#:/opt/bin##g')

# 去掉开头多余的冒号
export PATH=${newpath#:}
