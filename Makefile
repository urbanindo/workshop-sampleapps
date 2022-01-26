DOCKER_COMPOSE=docker-compose -f docker-compose.yml -p core-am
DECODE_NETRC=base64 -d build/ci/netrc.enc > .netrc
RM_NETRC=rm -f .netrc fi

init-dev:
	rm -rf app.ini
	@$(RM_NETRC)
	@$(DECODE_NETRC)
	# You have to copy the app.ini and app-secret.ini from gke-nn-id-dev or gke-nn-id-jakarta manually
	# @cp cicd/config/develop/app.ini app.ini

init-release:
	@$(RM_NETRC)
	@$(DECODE_NETRC)
	rm -rf app.ini
	# # You have to copy the app.ini and app-secret.ini from gke-nn-id-dev or gke-nn-id-jakarta manually
	# @cp cicd/config/release/app.ini app.ini

start-dev:
	@$(RM_NETRC)
	@$(DECODE_NETRC)
	@echo "############################"
	@echo "#### core-asset-manager ####"
	@echo "############################"
	@echo
	@echo "Stop dev..."
	@$(DOCKER_COMPOSE) stop
	@echo
	@echo "Start dev..."
	@echo
	@$(DOCKER_COMPOSE) up --build

test:
	@echo "####### SKIPPING UNIT TEST: TBC ##########"

stop-dev:
	@$(DOCKER_COMPOSE) stop

down-dev: stop-dev

clear-before-lint:
	rm -f .lint.txt

lint: clear-before-lint
	@go list ./... | grep -v /vendor/ | xargs -L1 "$(GOPATH)/bin/golint" | tee .lint.txt
	@if [ -s .lint.txt ]; then echo "Lint is not successfull"; exit 1; fi

gofmt:
	sh scripts/syntax_validator/go-fmt.sh

govet:
	sh scripts/syntax_validator/go-vet.sh

golangcli:
	sh scripts/syntax_validator/golangcli.sh