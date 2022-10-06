#work with the golang image
FROM golang:1.18
#change the  working directory
WORKDIR /go/bin
#move the configuration file
COPY ./azure.yml /go/bin
#Install the needed dependencies
RUN go install github.com/RobustPerception/azure_metrics_exporter@latest
#Run the exporter app 
CMD ["./azure_metrics_exporter"]