package main

import (
	"fmt"
	"log"
	"net/http"

	server "github.com/neemiasjnr/golang-microservice-example/pkg"
)

func main() {
	fmt.Println("Hello world!")
	if err := http.ListenAndServe(":8080", server.New()); err != nil {
		log.Fatalln(err)
	}
}
