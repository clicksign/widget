# Índice

- [Introdução](#introducao)
- [Suporte](#suporte)
- [Funcionamento](#funcionamento)
- [Autenticação](#autenticacao)
- [Opções](#opcoes)
- [Versão](#versao)
- [Exemplo](#exemplo)

# <a name="introducao"></a>Introdução

Muitas vezes um documento precisa ser assinado dentro de um ponto específico de
um determinado fluxo de uma aplicação.  Para isso a Clicksign desenvolveu um
componente que pode ser instalado dentro de outras páginas eletrônicas.  Este
tipo de componente é tradicionalmente chamado de **widget**.

# <a name="funcionamento"></a>Funcionamento

O _widget_ é composto de 3 partes:

1. Um biblioteca _javascript_ que você deverá adicionar à sua página;
2. Um _iframe_ que será criado pela biblioteca acima no _DOM_ de sua página;
3. Um código _HTML_ que será o corpo do _iframe_ acima;

## Passo 1: carregar a biblioteca

A biblioteca _javascript_ da Clicksign precisa ser incluída no corpo da página.
O arquivo pode ser copiado para seu próprio domínio ou você pode utilizar a CDN
da Clicksign.  Recomendamos utilizar a CDN da Clicksign pois vocês será
beneficiado pelas correções automáticas que efetuamos ao descobrir alguma falha
na biblioteca.  Todas as correções visam manter compatibilidade dentro da mesma
versão.  Uma alteração que quebre compatibilidade só pode ser efetuada em uma
nova versão da biblioteca.  Mais detalhas em [versão](#versao).

![step 1](https://github.com/clicksign/widget/blob/master/images/flow-1.png)

## Passo 2: configurar o widget

A biblioteca da Clicksign irá cria um objeto `clicksign` dentro do escopo
padrão, `window`.  Para que o _widget_ seja montado dentro da página você
necessita chamar a função `configure` no objeto `clicksign`.  Você pode conferir
os parâmetros da função `configure` em [opções](#opcoes).

![step 2](https://github.com/clicksign/widget/blob/master/images/flow-2.png)

Ao chamar a função `configure`, será adicionado um _iframe_ dentro de um dos
elementos da página.  O _iframe_ irá carregar o conteúdo da Clicksign, este
contúdo irá executar em contexto próprio, portanto nem o _widget_, nem a página
que o carrega, podem manipular os elementos do outro.

![step 3](https://github.com/clicksign/widget/blob/master/images/flow-3.png)

O _widget_ possui fluxo de navegação independete, isto possibilita à Clicksign
realizar as assinaturas em múltiplas requisições.

![step 4](https://github.com/clicksign/widget/blob/master/images/flow-4.png)

## Passo 3: capturar uma assinatura

Para aplicações que necessitam _reagir_ a um evento de assinatura, o _widget_
fornece uma chamada de _callback_ que será executada dentro do contexto da
página.  Esta é a função do parâmetro `callback`.  Você pode conferir a
utilização do parâmetro `callback` em [opções](#opcoes).

O _callbac_ é implementado utilizando `postMessage`, por este motivo os
navegadores deverão suportar esta tecnologia para que o _callback_ possa
ocorrer.

![step 5](https://github.com/clicksign/widget/blob/master/images/flow-5.png)

# <a name="suporte"></a>Suporte

Devido ao custo de desenvolvimento e possível perda de usabilidade, o **widget**
da Clicksign oferece suporte oficial apenas aos navegadores mais utilizados no
mercado.  Realizamos testes de compatibilidade com os seguintes navegadores
abaixo listados:

- Internet Explorer 9
- Internet Explorer 10 
- Internet Explorer 11
- Chrome 36
- Chrome 37
- Firefox 31
- Firefox 32
- Safari 7
- Opera 23
- Opera 24

Se você utiliza algum navegador que não conste nesta lista não significa que o
**widget** da Clicksign não funcionará adequadamente, significa apenas que não
realizamos testes de compatibilidade com o navegador.  Caso seja necessário que
a Clicksign suporte oficialmente o navagador, você pode solicitar que a equipe
de desenvolvimente o adicione como um navegador homologado através de
suporte@clicksign.com.

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
