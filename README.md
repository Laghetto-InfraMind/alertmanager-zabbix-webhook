# alertmanager-zabbix-webhook (fork Laghetto)

Fork de [gmauleon/alertmanager-zabbix-webhook](https://github.com/gmauleon/alertmanager-zabbix-webhook),
sem atualizacao desde 2019. Mantido aqui porque a ponte Alertmanager -> Zabbix (trapper) da stack de
observabilidade depende dele, e a imagem original acumulava CVEs da base Alpine/OpenSSL de 2019.

**Comportamento identico ao original** (conferido em 14/11/2026: mesmo pacote `ZBXD` para os mesmos
alertas). O que mudou:

- `go.mod` com dependencias atuais (o original nem usava modulos);
- `os.ReadFile` no lugar de `ioutil`; servidor HTTP com timeouts;
- imagem final `distroless/static-debian12:nonroot` (sem shell, sem gerenciador de pacotes, nao-root);
- CI: build, Trivy (falha em CRITICAL/HIGH com correcao), push no GHCR por tag `vX.Y.Z`, rescan semanal;
- Dependabot para Go, Docker e Actions.

Imagem: `ghcr.io/laghetto-inframind/alertmanager-zabbix-webhook:<versao>`. Licenca: GPL-3.0 (original).

## Uso

Recebe o webhook do Alertmanager em `:8080/alerts` e envia cada alerta ao Zabbix via trapper:
host = anotacao `zabbix_host` (ou `zabbixHostDefault`), key = `<zabbixKeyPrefix>.<alertname minusculo>`,
valor `1` (firing) / `0` (resolved). Configuracao: ver `config.yaml`.
