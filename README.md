# Índice

- [Introdução](#introducao)
- [Suporte](#suporte)
- [Funcionamento](#funcionamento)
- [Autenticação](#autenticacao)
- [Opções](#opcoes)
- [Versão](#versao)
- [Exemplo](#exemplo)

# <a name="introducao"></a>Introdução


# <a name="suporte"></a>Suporte
# <a name="funcionamento"></a>Funcionamento
# <a name="autenticacao"></a>Autenticação
# <a name="opcoes"></a>Opções
# <a name="versao"></a>Versão

# <a name="exemplo"></a>Exemplo

Na diretório `examples` há um exemplo de uso do widget escrito em
[ruby](ruby-lang.org).  Para iniciar o exemplo certifique-se de que estão
instalados:

- Ruby 2.1.2
- Rubygems
- Bundler

Instale as dependências:

```bash
$ cd examples/
$ bundle install
```

O servidor de exemplo utiliza API da Clicksign para realizar o _upload_ dos
documentos e criar a lista de assinatura.  Para fazer uso desta aplicação vocês
irá precisaar de um **access token** configurado no servidor para o qual deseja
enviar as requisições.  O **access token** é disponibilizado pela Clicksign para
desenvolvedores que foram previamente autorizados.  O controle do **access
token** é feito através da variável de ambiente ```ACCESS_TOKEN```.

A aplicação de exemplo pode ser configurada para acessar outro servidor que não
seja o servidor de produção da Clicksign, isto pode ser útil caso você deseje
realizar testes em outros ambientes, como _stage_ ou _demo_.  O controle do
_host_ que será direcionada as requisições é feito pela variável de ambiente
```HOST```.  O _host_ padrão é ```widget.clicksign.com```.

O protocolo de uso da API também pode ser configurado através da variável de
ambiente ```PROTOCOL```.  O protocolo padrão é ```HTTPS````.

|Variável    |Valor padrão        |Obrigatório|
|------------|--------------------|:---------:|
|ACCESS_TOKEN|                    |x          |
|HOST        |widget.clicksign.com|           |
|PROTOCOL    |HTTPS               |           |

Para iniciar o servidor é necessário interpretar o arquivo ```api-client.rb```
com o interpretador Ruby.  Segue abaixo um exemplo de como proceder em um
terminal _Unix_.

```bash
$ cd examples/
$ ACCESS_TOKEN=seu-token ruby api-client.rb
```

O servidor de exemplo executará um _bind_ na **porta 4567**.  Você poderá
acessa-lo em [http://localhost:4567](http://localhost:4567).
