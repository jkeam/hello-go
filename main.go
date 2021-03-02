package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	log.Print("Server starting at :8080")
	http.HandleFunc("/", server)
	http.ListenAndServe(":8080", nil)
}

func server(w http.ResponseWriter, r *http.Request) {
	var target = r.URL.Path[1:]
	if target == "" {
		target = "World"
	}
	fmt.Fprintf(w, "Hello, %s!", target)
}
