package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
	"strconv"
	"sync"
)

var (
	port      int
	baseURL   string
	shortened = make(map[string]string)
	mu        sync.Mutex
)

func main() {
	flag.IntVar(&port, "port", 8080, "Port to listen on")
	flag.StringVar(&baseURL, "base-url", "http://localhost:8080", "Base URL for shortened URLs")
	flag.Parse()

	http.HandleFunc("/", handleIndex)
	http.HandleFunc("/shorten", handleShorten)
	http.HandleFunc("/s/", handleShortened)

	log.Printf("Listening on port %d...\n", port)
	if err := http.ListenAndServe(fmt.Sprintf(":%d", port), nil); err != nil {
		log.Fatal(err)
	}
}

func handleIndex(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/html")
	fmt.Fprintf(w, `
		<html>
			<body>
				<h1>URL Shortener</h1>
				<form method="POST" action="/shorten">
					<label for="url">URL:</label>
					<input type="text" name="url" id="url" />
					<input type="submit" value="Shorten" />
				</form>
			</body>
		</html>
	`)
}

func handleShorten(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	r.ParseForm()
	url := r.Form.Get("url")

	mu.Lock()
	defer mu.Unlock()

	shortURL := fmt.Sprintf("%s/s/%d", baseURL, len(shortened))
	shortened[shortURL] = url

	w.Header().Set("Content-Type", "text/html")
	fmt.Fprintf(w, `
		<html>
			<body>
				<h1>Shortened URL</h1>
				<p>Original URL: %s</p>
				<p>Short URL: <a href="%s">%s</a></p>
			</body>
		</html>
	`, url, shortURL, shortURL)
}

func handleShortened(w http.ResponseWriter, r *http.Request) {
	mu.Lock()
	defer mu.Unlock()

	url, ok := shortened[r.URL.String()]
	if !ok {
		http.Error(w, "URL not found", http.StatusNotFound)
		return
	}

	http.Redirect(w, r, url, http.StatusFound)
}
