FROM golang:1.18

WORKDIR /go/bin

COPY ./azure.yml /go/bin
RUN go install github.com/RobustPerception/azure_metrics_exporter@latest

CMD ["./azure_metrics_exporter"]