package server

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/fasterness/cors"
	"github.com/gorilla/mux"
)

// New : server creation
func New() http.Handler {
	router := mux.NewRouter()
	s := &Server{
		router: router,
		logger: loggerMiddleware,
	}
	s.routes()
	return cors.New(s)
}

// HandlerFunc : useful for middleware creation
type HandlerFunc func(http.HandlerFunc) http.HandlerFunc

// Server : initializing all server dependencies
type Server struct {
	router *mux.Router
	logger func() HandlerFunc
}

func (s Server) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	s.router.ServeHTTP(w, r)
}

func (s Server) respond(w http.ResponseWriter, r *http.Request, status int, data interface{}) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	if err := json.NewEncoder(w).Encode(data); err != nil {
		fmt.Printf("encode response: %s", err)
	}
}

func (s Server) responderr(w http.ResponseWriter, r *http.Request, status int, err error) {
	w.WriteHeader(status)
	var data struct {
		Error string `json:"error"`
	}
	if err != nil {
		data.Error = err.Error()
	} else {
		data.Error = "Something went wrong"
	}
	if err := json.NewEncoder(w).Encode(data); err != nil {
		fmt.Printf("encode response: %s", err)
	}
}

func loggerMiddleware() HandlerFunc {
	return func(next http.HandlerFunc) http.HandlerFunc {
		return func(w http.ResponseWriter, r *http.Request) {
			start := time.Now()

			next.ServeHTTP(w, r)

			log.Printf(
				"%s\t%s\t%s\t%s",
				r.Method,
				r.RequestURI,
				r.Host,
				time.Since(start),
			)
		}
	}
}
