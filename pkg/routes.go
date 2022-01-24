package server

import "net/http"

func useMiddleware(handler http.HandlerFunc, middlewares ...HandlerFunc) http.HandlerFunc {
	for _, middleware := range middlewares {
		handler = middleware(handler)
	}
	return handler
}

func (s *Server) routes() {
	s.router.
		Path("/version").
		Methods("GET").
		HandlerFunc(useMiddleware(
			s.handleVersion(),
			s.logger(),
		))

	s.router.
		Path("/hello").
		Methods("GET").
		HandlerFunc(useMiddleware(
			s.handleHello(),
			s.logger(),
		))
}
