# Build
FROM golang:1.7 AS build
WORKDIR /go/src/github.com/target/pod-reaper
ENV CGO_ENABLED=0 GOOS=linux
RUN go get github.com/Masterminds/glide
COPY glide.* ./
RUN glide install --strip-vendor
COPY *.go ./
COPY rules/*.go ./rules/
RUN go test $(glide nv)
RUN go build -a -installsuffix go

# Application
FROM scratch
COPY --from=build /go/src/github.com/target/pod-reaper/pod-reaper /
CMD ["/pod-reaper"]
