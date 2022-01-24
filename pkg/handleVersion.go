package server

import (
	"net/http"
	"os"
)

// VersionAPI : version route payload (healthcheck)
type VersionAPI struct {
	Commit      string
	ServiceName string
	Version     string
}

func getCommitSha() string {
	commit := os.Getenv("GIT_COMMIT")
	if commit == "" {
		return "unknown"
	}
	return commit
}

func (s *Server) handleVersion() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		data := VersionAPI{
			Commit:      getCommitSha(),
			ServiceName: "golang-microservice-example",
			Version:     "1.0.0",
		}
		s.respond(w, r, 200, data)
	}
}
