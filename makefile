.PHONY: all $(MAKECMDGOALS)
.DEFAULT_GOAL=dev
dev: deps k.all




# # REQUESTS
# /:
# 	curl ${addr}/
# protected:
# 	curl -X POST ${addr}/protected/ -d '{}' -b token=AAAAAF3avy4AAAAAXdwQrgAAAAAAAAABZvLHEexqQgbaTTniiMEqSGlWfoAUPEpfSXRMwQErfrF05DCvVOAFO1JaC/9bld5K4xmfvlwT/cs5FQNVJ7ll6A==
# users/login:
# 	curl -X POST ${addr}/auth/ -i -d '{"email":"user.email@gmail.com", "password":"nopass"}'
# users/check:
# 	curl -X POST ${addr}/users/check -d '{"email":"user.email@gmail.com"}'
# users/register:
# 	curl -X POST ${addr}/users/register -d '{"email":"user.email@gmail.com","password":"nopass"}'
# posts/create:
# 	curl -X POST ${addr}/posts -d '{"title":"someTitle","body":"someBody"}' -b token=AAAAAF3avy4AAAAAXdwQrgAAAAAAAAABZvLHEexqQgbaTTniiMEqSGlWfoAUPEpfSXRMwQErfrF05DCvVOAFO1JaC/9bld5K4xmfvlwT/cs5FQNVJ7ll6A==
# port=8080
# addr=$(if $(filter $(ENV),P),https://api-nmrshll.cloud.okteto.net,http://0.0.0.0:${port})



# # CONTAINERS
# api: pull 
# 	$(eval srvc=api) ${(re)launchContainer} -p 0.0.0.0:8080:8080 -d registry.gitlab.com/nmrshll-weekend-projects/notajobboard-api-hyper:latest
# pg:
# 	$(eval srvc=pg) ${(re)launchContainer} -p 127.0.0.1:5432:5432 -e POSTGRES_PASSWORD=docker -e POSTGRES_USER=docker -e POSTGRES_DB=docker -d postgres:alpine
# adminer: 
# 	$(eval srvc=adminer) ${(re)launchContainer} -d -p 127.0.0.1:7897:8080 adminer:4.2.5
# down:
# 	-docker rm -f -v `docker ps -a -q --filter "name=${current_dir}"`
# logs: 
# 	$(eval srvc=api) docker logs -f ${container_name}
# current_dir = $(notdir $(shell pwd))
# container_name = ${current_dir}-${srvc}
# ifContainerMissing = @docker container inspect ${container_name} > /dev/null 2>&1 || 
# (re)launchContainer = ${ifContainerMissing} docker run --rm --name ${container_name}
# pull:
# 	docker pull registry.gitlab.com/nmrshll-weekend-projects/notajobboard-api-hyper:latest

# K8S
k.all: k.rm.all k.cp
k.cp:
	-$(call cueDo,persistentVolumeClaim.cpdownloads)
	-$(call cueDo,persistentVolumeClaim.cpmovies)
	-$(call cueDo,configMap.couchpotato)
	-$(call cueDo,deployment.couchpotato)
	-$(call cueDo,service.couchpotato)
k.transmission: 
	-$(call cueDo,deployment.transmission)
	-$(call cueDo,persistentVolumeClaim.transmission)
	-$(call cueDo,configMap.transmission)
	-$(call cueDo,service.transmission)
cueDo = cue eval -e $(1) k8s.dply.cue > .cache/k8s/$(1).cue; cue export .cache/k8s/$(1).cue | kubectl $(if $(filter $(DEL),1),delete,apply) -f -
k.rm.all:
	DEL=1 make k.cp



# DEPS
deps: dirs
	# GO111MODULE=off go get -u github.com/cuelang/cue
dirs:
	@mkdir -p .cache/k8s/
s = 2>&1 >/dev/null

