# Clicksign Widget

Integre a Clicksign em seu aplicativo web com nosso widget.

## Iniciando o servidor de exemplo

Certifique-se de que estão instalados:

- Ruby 2.1.2
- Rubygems
- Bundler

Instale as dependências:

```bash
$ cd examples/
$ bundle install
```

Para iniciar o servidor de exemplo, você precisará de um `ACCESS_TOKEN` configurado no servidor para o qual deseja enviar as requisições. O `ACCESS_TOKEN` é disponibilizado pela Clicksign para desenvolvedores autorizados.

Após a configuração das dependências e do `ACCESS_TOKEN`, inicie o servidor:

```bash
$ cd examples/
$ ACCESS_TOKEN=seu-token ruby api-client.rb
```

O servidor de exemplo estará disponível em `http://localhost:4567`.
