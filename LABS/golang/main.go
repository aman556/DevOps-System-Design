package main

import (
	"fmt"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "DevOps System Design")
}

func main() {
	http.HandleFunc("/", handler)
	port := ":8080"
	fmt.Printf("Server starting at http://localhost%s\n", port)
	if err := http.ListenAndServe(port, nil); err != nil {
		fmt.Println("Server failed:", err)
	}
}
