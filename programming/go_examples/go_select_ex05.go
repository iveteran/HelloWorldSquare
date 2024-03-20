// Refer: https://juejin.cn/post/7098008563649511432
package main

import (
    "fmt"
    "time"
    "errors"
)

func doSomeThing() <-chan int {
    outCh := make(chan int)
    go func() {
        // do work...
        fmt.Println("Begin do some thing")
        time.Sleep(5 * time.Second)
        fmt.Println("End do some thing")
    }()
    return outCh
}

func doWithTimeOut(timeout time.Duration) (int, error) {
    select {
    case ret := <-doSomeThing():
        return ret, nil
    case <-time.After(timeout):
        return 0, errors.New("timeout")
    }
}

func main() {
    ret, err := doWithTimeOut(1 * time.Second)
    //ret, err := doWithTimeOut(6 * time.Second)
    if err != nil {
        fmt.Printf("error: %s\n", err)
    }
    fmt.Printf("result: %d\n", ret)
}
