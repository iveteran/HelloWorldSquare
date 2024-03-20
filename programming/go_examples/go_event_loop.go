package main

import (
    "fmt"
    "time"
)

func main()  {
    bufChan := make(chan int)
    
    go func() {
        for {
            bufChan <-1
            time.Sleep(time.Second)
        }
    }()


    go func() {
        for {
            fmt.Println(<-bufChan)
        }
    }()

    select{}
}
