FROM golang:1.22.5-alpine3.19 AS base
#
WORKDIR /app
#dependencies are stored in go.mod
COPY go.mod .

RUN go mod download
# Copy the source code into the container
COPY . .
# Build the Go application
RUN go build -o main .

#Distroless image for final stage
FROM gcr.io/distroless/base
# Copy the binary from the builder stage
COPY --from=base /app/main .
# Copy the static files from the builder stage"
COPY --from=base /app/static ./static
# Expose the port the app runs on
EXPOSE 8080
# Command to run the binary
CMD ["/main"]