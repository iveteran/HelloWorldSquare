// 有default分支场景
// Refer: https://blog.csdn.net/wohu1104/article/details/115497151
package main

import "fmt"
import "time"

func main() {
    ch := make(chan int, 3)
    go func() {
        time.Sleep(2 * time.Second) // 延迟往通道里里面发送数据
        ch <- 1
        close(ch)  // 关闭channel
    }()

    for {
        select {
        case v, ok := <-ch:
            fmt.Printf("v=%v, ok=%v\n", v, ok)
            time.Sleep(1 * time.Second)
        default:
            fmt.Println("通道没有数据")
            time.Sleep(1 * time.Second)
        }
        fmt.Println("waiting")
    }
}

// WILL OUTPUT:
//> 通道没有数据
//> waiting
//> 通道没有数据
//> waiting
//> v=1, ok=true
//> waiting
//> v=0, ok=false
//> waiting
//> v=0, ok=false
//> waiting
//> v=0, ok=false
//> waiting
//> v=0, ok=false
//> waiting
//> v=0, ok=false
