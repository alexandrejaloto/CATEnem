CATEnem
================

Este é o repositório da CATEnem, que é uma versão adaptativa do Enem.
CAT é a sigla para Testagem Adaptativa Computadorizada em português.
Nesse tipo de testagem, as questões vão sendo escolhidas de acordo com a
resposta do sujeito. De forma geral, quando a pessoa acerta, o programa
seleciona uma questão mais difícil. Quando ela erra, o programa
seleciona uma questão mais fácil. Dessa maneira, o teste é mais
eficiente porque com menos questões do que no teste tradicional o
programa consegue calcular a nota com menos erro.

A CATEnem contém questões passadas do Enem de 2009 a 2020. Ao final da
prova, o participante receberá uma nota que é calculada da mesma maneira
que a nota do Enem é calculada, incluindo a Teoria de Resposta ao Item
(TRI). É como se esta prova fosse um espelho do Enem: se o Enem fosse
hoje, qual seria a nota do sujeito? Claro que não seria exatamente a
mesma nota, porque no dia da prova outros fatores interferem (como
ansiedade, cansaço e diferença no conteúdo das questões respondidas).
Além disso, o Enem oficial não é adaptativo. De todo modo, acredito que
a CATEnem é um grande exercício preparatório para o Enem. Sugiro que ele
seja aproveitado sem moderação!

PAra saber mais sobre como funciona a aplicação de uma CAT e sobre a
TRI, visite <http://jaloto.shinyapps.io/app_tri> ou entre em contato
comigo: <alexandrejaloto@gmail.com>.

Cada prova tem 20 questões e ela pode ser respondida sem limite de
vezes. Porém, existem algumas considerações:’,

-   o tempo máximo da prova é de 70 minutos. Após esse tempo, a
    aplicação é interrompida

-   não é possível voltar para uma questão que já foi respondida

-   quando o sujeito responde mais de uma vez a mesma prova, algumas
    questões podem se repetir

Para instalar a aplicação em seu computador, use o seguinte comando:

``` r
devtools::install_github('alexandrejaloto/CATEnem')
```

Após instalar, para rodar a CATEnembasta usar o seguinte comando:

``` r
CATEnem::run_app()
```

A aplicação também está disponível em
<http://jalotoalexandre.shinyapps.io/CATEnem>. No entanto, não
garantimos que ela estará sempre acessível, pois há um limite de uso
nesse servidor. Por isso, recomendamos a instalação da aplicação em sua
máquina.

A CATEnem foi desenvolvida com os seguintes apoios:

<img src='https://raw.githubusercontent.com/alexandrejaloto/CATEnem/master/data-raw/usf.png' alt='' width='100'/>

Bolsa de estudo em 2019

<img src='https://raw.githubusercontent.com/alexandrejaloto/CATEnem/master/data-raw/capes.png' alt='' width='100'/>

Bolsa de estudo de 2019 a 2023

<img src='https://raw.githubusercontent.com/alexandrejaloto/CATEnem/master/data-raw/Catvante-07.png' alt='' width='200'/>

Preparo dos itens e suporte na elaboração da aplicação

<img src='https://raw.githubusercontent.com/alexandrejaloto/CATEnem/master/data-raw/Logo_INEP.PNG' alt='' width='250'/>

Afastamento do autor principal da CATEnem entre 2019 e 2023

Ainda que esta aplicação tenha sido elaborada com o apoio do Inep, ela
não configura uma aplicação oficial do instituto. Este trabalho não
representa necessariamente o ponto de vista do Inep. As opiniões
expressas nesta publicação são de inteira e exclusiva responsabilidade
dos autores, não expressando necessariamente o ponto de vista do Inep ou
do Ministério da Educação.
