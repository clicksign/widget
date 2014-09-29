# Índice

- [Introdução](#introducao)
- [Suporte](#suporte)
- [Funcionamento](#funcionamento)
- [Autenticação](#autenticacao)
- [Opções](#opcoes)
- [Callback](#callback)
- [Versão](#versao)
- [Exemplo](#exemplo)

# <a name="introducao"></a>Introdução

Muitas vezes um documento precisa ser assinado dentro de uma aplicação.  Para
isso, a Clicksign desenvolveu um componente que pode ser instalado dentro de
outras páginas eletrônicas.  Este tipo de componente é tradicionalmente chamado
de **widget**.  O uso do _widget_ traz as seguintes vantagens:

- Não interrompe um fluxo em andamento
- Evita a troca de contexto do usuário
- Oferece maior consistência à experiência do usuário

Para facilitar a sua vida, a Clicksign já fez a parte difícil e programou um
componente extremamente simples de usar que realiza as partes mais complicadas
desse processo.  Apesar da facilidade, gostamos de deixar claro o que fazemos e
como fazemos, por isto, na próxima seção explicaremos como nosso componente
funciona.  Sinta-se livre para propor melhorias, analisar o código fonte ou
apenas questionar o desenvolvimento através da [página do
projeto](https://github.com/clicksign/widget).

# <a name="funcionamento"></a>Funcionamento

O _widget_ é composto de 3 partes:

1. Um biblioteca _javascript_ que você deverá adicionar à sua página;
2. Um _iframe_ que será criado pela biblioteca acima no _DOM_ de sua página;
3. Um código _HTML_ que será o corpo do _iframe_ acima;

Abaixo iremos explicar como estes três componentes interagem para prover a
funcionalidade esperada, bem como qual as etapas necessárias para você colocar o
_widget_ funcionando em sua aplicação.

## Passo 1: carregar a biblioteca

A biblioteca _javascript_ da Clicksign precisa ser incluída no corpo da página.
O arquivo pode ser copiado para seu próprio domínio ou você pode utilizar a CDN
da Clicksign.  Recomendamos utilizar a CDN da Clicksign pois você será
beneficiado pelas correções automáticas que efetuamos ao descobrir alguma falha
na biblioteca.  Todas as correções visam manter compatibilidade dentro da mesma
versão.  Uma alteração que quebre compatibilidade só pode ser efetuada em uma
nova versão da biblioteca.  Mais detalhes em [versão](#versao).

![Carregando a
biblioteca](https://raw.githubusercontent.com/clicksign/widget/master/images/flow-1.png)

## Passo 2: configurar o _widget_

A biblioteca da Clicksign irá criar um objeto `clicksign` dentro do escopo
padrão, `window`.  Para que o _widget_ seja montado dentro da página você
necessita chamar a função `configure` no objeto `clicksign`.  Você pode conferir
os parâmetros da função `configure` nas [opções](#opcoes).

![Configurando a
biblioteca](https://raw.githubusercontent.com/clicksign/widget/master/images/flow-2.png)

Ao chamar a função `configure`, será adicionado um _iframe_ dentro de um dos
elementos da página.  O _iframe_ irá carregar o conteúdo da Clicksign, este
conteúdo irá executar em contexto próprio, portanto nem o _widget_, nem a página
que o carrega, podem manipular os elementos do outro.

![Montando o
IFRAME](https://raw.githubusercontent.com/clicksign/widget/master/images/flow-3.png)

O _widget_ possui fluxo de navegação independente, isto possibilita à Clicksign
realizar as assinaturas em múltiplas requisições.

![Demonstrando
fluxo](https://raw.githubusercontent.com/clicksign/widget/master/images/flow-4.png)

## Passo 3: capturar uma assinatura

Para aplicações que necessitam _reagir_ a um evento de assinatura, o _widget_
fornece uma chamada de _callback_ que será executada dentro do contexto da
página.  Esta é a função do parâmetro `callback`.  Você pode conferir a
utilização do parâmetro `callback` nas [opções](#opcoes).

![Capturando
assinatura](https://raw.githubusercontent.com/clicksign/widget/master/images/flow-5.png)

# <a name="suporte"></a>Suporte

Devido ao custo de desenvolvimento e possível perda de usabilidade, o _widget_
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
_widget_ da Clicksign não funcionará adequadamente, significa apenas que não
realizamos testes de compatibilidade com o navegador.  Caso seja necessário que
a Clicksign suporte oficialmente o navegador, solicite que a equipe de
desenvolvimento o adicione como um navegador homologado através de
suporte@clicksign.com.

# <a name="autenticacao"></a>Autenticação

A autenticação do usuário é realizada através de um **token** enviado ao e-mail
que foi solicitado a assinatura.  Apenas desta forma nós podemos nos certificar
de que é o dono do e-mail quem está tentado realizar a assinatura.

O _token_ é gerado e enviado através da Clicksign no momento em que o conteúdo
do _iframe_ é solicitado aos nossos servidores.  Abaixo segue um diagrama
  representando o momento e o algoritmo utilizado.

![Envio de
token](https://raw.githubusercontent.com/clicksign/widget/master/images/flow-6.png)

O _token_ é composto de 4 letras, exceto vogais.  Ele possui duração de 10
minutos, após este período, caso o _widget_ seja recarregado, um novo _token_
será gerado e enviado, o mesmo ocorre caso o usuário solicitar o reenvio do
_token_.

# <a name="opcoes"></a>Opções

A realizar a configuração você pode parametrizar alguns propriedades do
_widget_.  A parametrização de algumas propriedades é obrigatória, outras
possuem valores padrão adequados para o ambiente de produção.

|Propriedade         |Obrigatório|Opções            |Valor padrão        |
|--------------------|:---------:|------------------|--------------------|
|container           |x          |DOM ID            |                    |
|key                 |x          |                  |                    |
|signer.email        |x          |E-mail            |                    |
|signer.display\_name|           |                  |                    |
|signer.documentation|           |                  |                    |
|callback            |           |                  |function() {}       |
|protocol            |           |HTTP ou HTTPS     |HTTP                |
|host                |           |URL               |widget.clicksign.com|
|width               |           |600+              |800                 |
|height              |           |500+              |600                 |

<dl>
  <dt>container</dt>
  <dd>ID na DOM do elemento no qual o iframe será inserido</dd>
  <dt>key</dt>
  <dd>Chave do documento a ser assinado</dd>
  <dt>signer.email</dt>
  <dd>E-mail do signatário</dd>
  <dt>signer.display_name</dt>
  <dd>Nome signatário para ser auto-preenchido</dd>
  <dt>signer.documentation</dt>
  <dd>CPF do signatário para ser auto-preenchido</dd>
  <dt>callback</dt>
  <dd>Função que será chamada quando ocorrer algum evento no widget</dd>
  <dt>protocol</dt>
  <dd>Protocolo a ser utilizado na montagem do iframe</dd>
  <dt>host</dt>
  <dd>Host a ser utilizado na montagem do iframe</dd>
  <dt>width</dt>
  <dd>Largura em pixels do iframe</dd>
  <dt>height</dt>
  <dd>Altura em pixels do iframe</dd>
</dl>

Segue abaixo um exemplo de como essa chamada poderia ser realizada para montar
um _wiget_ dentro do elemento do DOM ID ```signature-box``` para o usuário com
e-mail ```john.dow@example.com``` assinar no ambiente de demonstração com
largura de 900 _pixels_ e altura de 1000 _pixels_.

```javascript
clicksign.configure({
  container: "signature-box",
  key: "0123-4567-89AB-CDEF",
  signer: {
    email: "john.doe@example.com",
    display_name: "John Doe",
    documentation: "01234567890"
  },
  host: "widget.clicksign-demo.com",
  width: 900,
  height: 1000
})
```

# <a name="callback"></a>Callback

Determinados eventos que ocorrem no __widget__ podem ser de interesse da
aplicação que o utiliza.  A função __callback__ que é passada como parâmetro na
configuração do __widget__ será executada quando algum desses eventos ocorrerem.
Esta função é executada no contexto da aplicação que utiliza o __widget__, dessa
forma você pode manipular sua DOM ou executar outras funções __javascript__
no contexto da sua aplicação.

Ao chamar a função __callback__ é passsado um único parâmetro à função, que
consiste em uma __String__ com o nome do evento.  Atualmente os eventos
possíveis são:

- requested
- signed

Dessa forma você pode __filtrar__ os eventos que são de seu interessante, p.e.:

```javascript
callback = function(event) {
  return if event != "signed";
  alert("Documento asssinado!");
}
```

# <a name="versao"></a>Versão

O controle de versão do _widget_ é realizado através da arquivo _javascript_ que
você carregar na aplição.  Utilizamos apenas um único número para controle de
versão, caso houver alguma quebra de funcionalidade, o número da versão será
acrescido em um, do contrário, apenas atualizaremos a versão disponível, p.e.:

|Alteração                                |Versão|
|-----------------------------------------|:----:|
|Versão atual                             |1     |
|Correção de bug em callback              |1     |
|Adição callbacks para casos de erro      |1     |
|Alteração de ordem de chamado de callback|2     |

O nome do arquivo determina a versão, p.e.: ```clicksign-v1.js``` é a versão 1,
```clicksign-v2.js``` e a versão 2. Você também pode utilizar a propriedade
```version``` do objeto ```clicksign```.  

# <a name="exemplo"></a>Exemplo

No diretório ```examples/``` há um exemplo de uso do widget escrito em
[ruby](http://ruby-lang.org).  Para iniciar o exemplo certifique-se de que estão
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
documentos e criar a lista de assinatura.  Para fazer uso desta aplicação você
precisa de um **access token** configurado no servidor para o qual deseja enviar
as requisições.  O **access token** é disponibilizado pela Clicksign para
desenvolvedores que foram previamente autorizados.  Para solicitar um **access
token** envie um e-mail para suporte@clicksign.com. O controle do **access
token** é feito através da variável de ambiente ```ACCESS_TOKEN```.

A aplicação de exemplo pode ser configurada para acessar outro servidor que não
seja o servidor de produção da Clicksign, isto pode ser útil caso você deseje
realizar testes em outros ambientes, como _stage_ ou _demo_.  O controle do
_host_ que será direcionada as requisições é feito pela variável de ambiente
```HOST```.  O _host_ padrão é ```widget.clicksign.com```.

O protocolo de uso da API também pode ser configurado através da variável de
ambiente ```PROTOCOL```.  O protocolo padrão é ```HTTPS```.

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
