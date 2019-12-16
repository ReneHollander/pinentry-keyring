package main

import (
    "log"
    "strings"
    "os"
    "fmt"
    "bufio"

    "github.com/zalando/go-keyring"
)

func main() {
    fmt.Println("OK Ready.")
    keyinfo := ""
    scanner := bufio.NewScanner(os.Stdin)
    for scanner.Scan() {
        l := scanner.Text()
        if strings.HasPrefix(l, "OPTION") {
            // Do nothing.
        } else if strings.HasPrefix(l, "GETINFO") {
            switch strings.TrimSpace(l[len("GETINFO"):]) {
            case "flavor":
                fmt.Println("D pinentry-keyring")

            case "version":
                fmt.Println("D 1.0.0")

            case "pid":
                fmt.Printf("D %d\n", os.Getpid())

            default:
                fmt.Println("ERR unknown command")
                continue
            }
        } else if strings.HasPrefix(l, "SETKEYINFO") {
            args := strings.TrimSpace(l[len("SETKEYINFO"):])
            if args == "--clear" {
                keyinfo = ""
            } else {
                keyinfo = args
            }
        } else if strings.HasPrefix(l, "GETPIN") {
            secret, err := keyring.Get("pinentry-keyring", keyinfo)
            if err != nil {
                err := keyring.Set("pinentry-keyring", keyinfo, "")
                if err != nil {
                    log.Fatal(err)
                }
                fmt.Println("ERR key not yet set.")
                continue
            }
            fmt.Printf("D %s\n", secret)
        }

        fmt.Println("OK")
    }
}
