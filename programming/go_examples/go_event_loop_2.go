package main
import (
    "fmt"
    "time"
)

func main()  {
    bufChan := make(chan int, 5)
    
    go func () {
        time.Sleep(time.Second)
        for {
            <-bufChan
            time.Sleep(5*time.Second)
        }
    }()

    for {
        select {
        case bufChan <- 1:
            fmt.Println("add success")
            time.Sleep(time.Second)
        default:        
            fmt.Println("资源已满，请稍后再试")
            time.Sleep(time.Second)
        } 
    }
}
