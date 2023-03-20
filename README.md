# PCProject
This is the repository for a pratical project of my Concurrent Programming class. This is a Erlang project of a translator of CCS0 term to it's respectiv LTS graph.

Esse é o projeto de um tradutor de CCS0 para LTS com um server responsivo.
Esse projeto pertence a Luis Gustavo da Silva Xavier, nº202000638, L:CC.

Instruções:
A função que cria o LTS(a partir da AST) se chama "translateTo_LTS" recebendo apenas 1 argumento, a AST. 
E respondendo o correspondente LTS como um Tuplo da seguinte forma: {StatesList, Transitions, InitianState}.
O server recebe pedidos com a AST e responde com o respectivo LTS. A função comunicate se comunica com o server
de uma maneira mais simples, apenas sendo necessário dar start no server e chamar a função comunicate com o PID e com a AST.

Forma da AST:
    1 - Prefixo = {prefix, "action", NextNodeAST} Ex: a.b.0 = {prefix, "a", {prefix, "b", zero}}
    2 - Choice = {prefix, Left Node, Right Node} Ex: a.0 + b.0 = {choice,{prefix, "a", zero},{prefix, "b", zero}}

Existe um pequeno ficheiro de exemplos de AST's chamado examples.txt. Sinta-se livre para usa-lo.
