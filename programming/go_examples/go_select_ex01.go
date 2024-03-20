// 没有default分支场景
// Refer: https://blog.csdn.net/wohu1104/article/details/115497151
package main

import "fmt"
import "time"

func main() {
    ch := make(chan int, 3)
    go func() {
        time.Sleep(2 * time.Second) // 延迟往通道里里面发送数据
        ch <- 1
    }()

    for {
        select {
        // 这里需要注意，如果读一个有缓冲且无数据的channel会panic
        case v, ok := <-ch:
            fmt.Printf("v=%v, ok=%v\n", v, ok)
            time.Sleep(1 * time.Second)
        }
        fmt.Println("waiting")
    }
}

// WILL OUTPUT:
//> v=1, ok=true
//> waiting
//> fatal error: all goroutines are asleep - deadlock!
//> 
//> goroutine 1 [chan receive]:
//> main.main()
//>         /home/yuu/helloworld/programming/go_examples/go_select_ex01.go:14 +0x78
//> exit status 2
