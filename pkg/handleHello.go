package server

import (
	"net/http"

	"github.com/neemiasjnr/golang-microservice-example/pkg/greeter"
)

func (s *Server) handleHello() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		q := r.URL.Query()
		name := q.Get("name")
		response := greeter.SayHello(name)
		s.respond(w, r, 200, response)
	}
}
