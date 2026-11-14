# Build: Go atual, binario estatico.
FROM golang:1.27.3-alpine AS build
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOFLAGS=-buildvcs=false GOOS=linux go build -trimpath -ldflags="-s -w" -o /out/alertmanager-zabbix-webhook .

# Run: distroless static, sem shell nem gerenciador de pacotes, nao-root.
FROM gcr.io/distroless/static-debian12:nonroot
COPY --from=build /out/alertmanager-zabbix-webhook /usr/bin/alertmanager-zabbix-webhook
COPY config.yaml /etc/webhook/config.yaml
EXPOSE 8080
USER nonroot:nonroot
ENTRYPOINT ["/usr/bin/alertmanager-zabbix-webhook"]
CMD ["-config", "/etc/webhook/config.yaml"]
