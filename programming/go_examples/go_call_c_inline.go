package main
/*
// https://juejin.im/post/5a62f7cff265da3e4c07e0ab
// C 标志io头文件，你也可以使用里面提供的函数
#include <stdio.h> 

void pri(){
    printf("hey");
}

int add(int a,int b){
    return a+b;
}
*/
import "C"  // 切勿换行再写这个

import "fmt"

func main() {
    fmt.Println(C.add(2, 1))
}
