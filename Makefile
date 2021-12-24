all: serve_hostname

TAG ?= 1.1
REPO ?= poorunga

serve_hostname: serve_hostname.go
	CGO_ENABLED=0 go build -a -installsuffix cgo --ldflags '-w' ./serve_hostname.go

container: serve_hostname
	sudo docker build -t gcr.io/google_containers/serve_hostname:$(TAG) .
	sudo docker tag gcr.io/google_containers/serve_hostname:$(TAG) gcr.io/_b_k8s_authenticated_test/serve_hostname:$(TAG)

push:
	gcloud preview docker push gcr.io/google_containers/serve_hostname:$(TAG)
	gcloud preview docker push gcr.io/_b_k8s_authenticated_test/serve_hostname:$(TAG)

buildx:
	docker buildx build --push --platform linux/amd64,linux/arm64 -t $(REPO)/serve_hostname:$(TAG) -f Dockerfile .

clean:
	rm -f serve_hostname
