# Cliente API

Para iniciar o cliente de exemplo da api, será necessário você ter instalado:

- Ruby 2.1.2
- Rubygems
- Bundler

Com isto, você poderá executar o `bundle` dentro do diretório **examples** e
todas as dependências serã instaladas.  Para iniciar o servidor de exemplo você
precisará de um *access_token* configurado servidor que deseja enviar as
requisições.

Uma vez com as depências instaladas e com o *access_token* basta executar o
seguinte comando dentro do diretório `examples`.

```bash
ACCESS_TOKEN=aqui-vem-o-token ruby api-client.rb
```

Um servidor na porta 4567 será inicializado e nas configurações padrão você
poderá acessa-lo em [localhost:4567](http://localhost:4567).
