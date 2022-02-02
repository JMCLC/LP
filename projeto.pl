:- [codigo_comum].

% Predicado auxiliar a extrai_ilhas_linha que atravessa recursivamente a linha do puzzle e cria uma ilha se o valor for diferente de 0
% Input - Linha (Lista de Inteiros), Index (Inteiro), N_L (Inteiro), Ilhas (Lista de Ilhas), Res (Variavel)
% Output - Res (Lista de Ilhas)
extrai_ilhas_linha_aux([], _, _, Ilhas, Res) :-
    Res = Ilhas.
extrai_ilhas_linha_aux([Valor | Resto], Index, N_L, Ilhas, Res) :-
    Novo_Index is Index + 1,
    (Valor =\= 0 -> Nova_Ilha = ilha(Valor,(N_L,Novo_Index)), append(Ilhas, [Nova_Ilha], Nova_Lista), extrai_ilhas_linha_aux(Resto, Novo_Index, N_L, Nova_Lista, Res); extrai_ilhas_linha_aux(Resto, Novo_Index, N_L, Ilhas, Res)).

% 2.1 - Predicado que calcula todas as ilhas existences numa linha do puzzle
% Input - N_L (Inteiro), Linha (Lista de Inteiros), Ilhas (Variavel)
% Output - Ilhas (Lista de Ilhas)
extrai_ilhas_linha(N_L, Linha, Ilhas) :-
    extrai_ilhas_linha_aux(Linha, 0, N_L, [], Ilhas).
    
% Predicado auxiliar a ilhas que atravessa o puzzle inteiro e chama extrai_ilhas_linha para cada linha do puzzle e guarda tudo numa lista
% Input - Puzzle (Lista de Listas de Inteiros), N_L (Inteiro), Ilhas (Lista de Ilhas), Res (Variavel)
% Output - Res (Lista de Ilhas)
ilhas_aux([], _, Ilhas, Res) :-
    Res = Ilhas.
ilhas_aux([Linha | Resto], N_L, Ilhas, Res) :-
    Novo_N_L is N_L + 1,
    extrai_ilhas_linha(Novo_N_L, Linha, Ilhas_Novas),
    append(Ilhas, Ilhas_Novas, Nova_Lista),
    ilhas_aux(Resto, Novo_N_L, Nova_Lista, Res).

% 2.2 - Predicado que calcula todas as ilhas existences num puzzle
% Input - Puz (Lista de Listas de Inteiros), Ilhas (Variavel)
% Output - Ilhas (Lista de Ilhas)
ilhas(Puz, Ilhas) :-
    ilhas_aux(Puz, 0, [], Ilhas).

% Predicado auxiliar que recebe o numero de uma coluna e uma lista de ilhas numa especifica linha e verifica se uma ilha existe nessa linha e coluna e retorna se existir
% Input - [Ilha|Resto] (Lista de Ilhas), Valor_Coluna (Inteiro), Res (Variavel)
% Output - Res (Ilha)
ilha_existe_linha([], _, Res) :-
    Res = [].
ilha_existe_linha([Ilha|Resto], Valor_Coluna, Res) :-
    Ilha = ilha(_,(_,Coluna)),
    (Coluna =:= Valor_Coluna -> Res = Ilha, !; ilha_existe_linha(Resto, Valor_Coluna, Res)).

% Predicado auxiliar que recebe o numero de uma linha e uma lista de ilhas numa especifica coluna e verifica se uma ilha existe nessa linha e coluna e retorna se existir
% Input - [Ilha|Resto] (Lista de Ilhas), Valor_Linha (Inteiro), Res (Variavel)
% Output - Res (Ilha)
ilha_existe_coluna([], _, Res) :-
    Res = [].
ilha_existe_coluna([Ilha|Resto], Valor_Linha, Res) :-
    Ilha = ilha(_,(Linha,_)),
    (Linha =:= Valor_Linha -> Res = Ilha, !; ilha_existe_coluna(Resto, Valor_Linha, Res)).

% Predicado auxiliar que recebe todas as ilhas a esquerda de uma ilha e encontra a ilha mais proxima dela
% Input - Vizinhas (Lista de Ilhas), Valor_Atual (Inteiro), Res (Variavel)
% Output - Res (Ilha)
ilha_mais_proxima_esquerda(Vizinhas, Valor_Atual, Res) :-
    Novo_Valor_Atual is Valor_Atual - 1,
    (Novo_Valor_Atual =:= 0 -> Res = [],!; ilha_existe_linha(Vizinhas, Novo_Valor_Atual, Ilha), (Ilha \== [] -> Res = [Ilha], !; ilha_mais_proxima_esquerda(Vizinhas, Novo_Valor_Atual, Res))).

% Predicado auxiliar que recebe todas as ilhas a direita de uma ilha e encontra a ilha mais proxima dela
% Input - Vizinhas (Lista de Ilhas), Valor_Atual (Inteiro), Res (Variavel)
% Output - Res (Ilha)
ilha_mais_proxima_direita(Vizinhas, Valor_Atual, Tamanho, Res) :-
    Novo_Valor_Atual is Valor_Atual + 1,
    (Novo_Valor_Atual =:= Tamanho + 1 -> Res = [],!; ilha_existe_linha(Vizinhas, Novo_Valor_Atual, Ilha), (Ilha \== [] -> Res = [Ilha], !; ilha_mais_proxima_direita(Vizinhas, Novo_Valor_Atual, Tamanho, Res))).

% Predicado auxiliar que recebe todas as ilhas acima de uma ilha e encontra a ilha mais proxima dela
% Input - Vizinhas (Lista de Ilhas), Valor_Atual (Inteiro), Res (Variavel)
% Output - Res (Ilha)
ilha_mais_proxima_cima(Vizinhas, Valor_Atual, Res) :-
    Novo_Valor_Atual is Valor_Atual - 1,
    (Novo_Valor_Atual =:= 0 -> Res = [], !; ilha_existe_coluna(Vizinhas, Novo_Valor_Atual, Ilha), (Ilha \== [] -> Res = [Ilha], !; ilha_mais_proxima_cima(Vizinhas, Novo_Valor_Atual, Res))).

% Predicado auxiliar que recebe todas as ilhas abaixo de uma ilha e encontra a ilha mais proxima dela
% Input - Vizinhas (Lista de Ilhas), Valor_Atual (Inteiro), Res (Variavel)
% Output - Res (Ilha ou [])
ilha_mais_proxima_baixo(Vizinhas, Valor_Atual, Tamanho, Res) :-
    Novo_Valor_Atual is Valor_Atual + 1,
    (Novo_Valor_Atual =:= Tamanho + 1 -> Res = [],!; ilha_existe_coluna(Vizinhas, Novo_Valor_Atual, Ilha), (Ilha \== [] -> Res = [Ilha], !; ilha_mais_proxima_baixo(Vizinhas, Novo_Valor_Atual, Tamanho, Res))).

% Predicado auxiliar percorre todas as ilhas e procura a ilha com o index de linha maior e retorna esse valor como o tamanho do puzzle
% Input - [ilha(_,(Linha,_))| Resto] (Lista de Ilhas), Maior_Valor (Inteiro), Tamanho (Variavel)
% Output - Tamanho (Inteiro)
obtem_tamanho_puzzle([], Maior_Valor, Tamanho) :-
    Tamanho = Maior_Valor.
obtem_tamanho_puzzle([ilha(_,(Linha,_))| Resto], Maior_Valor, Tamanho) :-
    (Linha > Maior_Valor -> Novo_Maior_Valor = Linha, obtem_tamanho_puzzle(Resto, Novo_Maior_Valor, Tamanho); obtem_tamanho_puzzle(Resto, Maior_Valor, Tamanho)).

% 2.3 - Predicado que recebe uma lista de ilhas e uma ilha e retorna uma lista com as vizinhas dessa ilha
% Input - Ilhas (Lista de Ilhas), Ilha (Ilha), Vizinhas (Variavel)
% Output - Vizinhas (Lista de Ilhas)
vizinhas(Ilhas, Ilha, Vizinhas) :-
    Ilha = ilha(_,(Linha,Coluna)),
    obtem_tamanho_puzzle(Ilhas, 0, Tamanho),
    % Encontra todas as ilhas a esquerda da ilha recebida e se a lista produzida pelo predicado sobre listas tiver mais que 1 elemento apenas mantem o elemento mais proximo da ilha original
    findall(Ilha_Atual, (member(Ilha_Atual, Ilhas), Ilha_Atual = ilha(_,(Linha_Atual,Coluna_Atual)), Linha =:= Linha_Atual, Coluna_Atual < Coluna), Vizinhas_Esquerda_Temp),
    length(Vizinhas_Esquerda_Temp, Tamanho_Esquerda),
    (Tamanho_Esquerda > 1 -> ilha_mais_proxima_esquerda(Vizinhas_Esquerda_Temp, Coluna, Vizinha_Esquerda); Vizinha_Esquerda = Vizinhas_Esquerda_Temp),
    % Encontra todas as ilhas a direita da ilha recebida e se a lista produzida pelo predicado sobre listas tiver mais que 1 elemento apenas mantem o elemento mais proximo da ilha original
    findall(Ilha_Atual, (member(Ilha_Atual, Ilhas), Ilha_Atual = ilha(_,(Linha_Atual,Coluna_Atual)), Linha =:= Linha_Atual, Coluna_Atual > Coluna), Vizinhas_Direita_Temp),
    length(Vizinhas_Direita_Temp, Tamanho_Direita),
    (Tamanho_Direita > 1 -> ilha_mais_proxima_direita(Vizinhas_Direita_Temp, Coluna, Tamanho, Vizinha_Direita); Vizinha_Direita = Vizinhas_Direita_Temp),
    append(Vizinha_Esquerda, Vizinha_Direita, Vizinhas_Linha),
    % Encontra todas as ilhas acima da ilha recebida e se a lista produzida pelo predicado sobre listas tiver mais que 1 elemento apenas mantem o elemento mais proximo da ilha original
    findall(Ilha_Atual, (member(Ilha_Atual, Ilhas), Ilha_Atual = ilha(_,(Linha_Atual,Coluna_Atual)), Coluna =:= Coluna_Atual, Linha_Atual < Linha), Vizinhas_Cima_Temp),
    length(Vizinhas_Cima_Temp, Tamanho_Cima),
    (Tamanho_Cima > 1 -> ilha_mais_proxima_cima(Vizinhas_Cima_Temp, Linha, Vizinha_Cima); Vizinha_Cima = Vizinhas_Cima_Temp), 
    % Encontra todas as ilhas abaixo da ilha recebida e se a lista produzida pelo predicado sobre listas tiver mais que 1 elemento apenas mantem o elemento mais proximo da ilha original
    findall(Ilha_Atual, (member(Ilha_Atual, Ilhas), Ilha_Atual = ilha(_,(Linha_Atual,Coluna_Atual)), Coluna =:= Coluna_Atual, Linha_Atual > Linha), Vizinhas_Baixo_Temp),
    length(Vizinhas_Baixo_Temp, Tamanho_Baixo),
    (Tamanho_Baixo > 1 -> ilha_mais_proxima_baixo(Vizinhas_Baixo_Temp, Linha, Tamanho, Vizinha_Baixo); Vizinha_Baixo = Vizinhas_Baixo_Temp),
    append(Vizinha_Cima, Vizinhas_Linha, Vizinhas_Temp),
    append(Vizinhas_Temp, Vizinha_Baixo, Vizinhas).

% 2.4 - Predicado que recebe todas as ilhas presentes num puzzle e constroi a entrada para cada ilha e guarda tudo numa variavel Estado
% Input - Ilhas (Lista de Ilhas), Estado (Variavel)
% Output - Estado (Lista de Entradas)
estado(Ilhas, Estado) :-
    bagof(Entrada, Ilha^Vizinhas^(member(Ilha, Ilhas), vizinhas(Ilhas, Ilha, Vizinhas), Entrada = [Ilha,Vizinhas,[]]), Estado).

% Predicado auxiliar que recebe duas posicoes e retorna uma lista com as posicoes em ordem
% Input - Pos1 (Posicao), Pos2 (Posicao), Posicoes_em_ordem (Variavel)
% Output - Posicoes_em_ordem (Lista de Posicoes)
posicoes_em_ordem(Pos1, Pos2, Posicoes_em_ordem) :-
    Pos1 = (Linha,Coluna),
    Pos2 = (Linha2,Coluna2),
    (Linha =:= Linha2 -> (Coluna > Coluna2 -> Posicoes_em_ordem = [Pos2,Pos1]; Posicoes_em_ordem = [Pos1,Pos2]); (Linha > Linha2 -> Posicoes_em_ordem = [Pos2,Pos1]; Posicoes_em_ordem = [Pos1,Pos2])).

% Predicado auxiliar que recebe dois inteiros e retorna uma lista com todos os inteiros existentes entre eles
% Input - Valor (Inteiro), Valor2 (Inteiro), Lista (Lista de Inteiros), Res (Variavel)
% Output - Res (Lista de Inteiros)
valores_entre(Valor, Valor2, [], Res) :-
    Primeiro_Valor is Valor + 1,
    valores_entre(Valor, Valor2, [Primeiro_Valor], Res).

valores_entre(Valor, Valor2, Lista, Res) :-
    last(Lista, Ultimo_Valor),
    Atual is Ultimo_Valor + 1,
    (Atual < Valor2 -> append(Lista, [Atual], Nova_Lista), valores_entre(Valor, Valor2, Nova_Lista, Res); Res = Lista, !).

% 2.5 - Predicado recebe duas posicoes, coloca-las em ordem e depois retorna todos as posicoes existentes entre as posicoes recebidas
% Input - Pos1 (Posicao), Pos2 (Posicao), Posicoes (Variavel)
% Output - Posicoes (Lista de Posicoes)
posicoes_entre(Pos1, Pos2, Posicoes) :-
    posicoes_em_ordem(Pos1, Pos2, [(Nova_Linha, Nova_Coluna),(Nova_Linha2, Nova_Coluna2)]),
    (Nova_Linha =:= Nova_Linha2 -> valores_entre(Nova_Coluna, Nova_Coluna2, [], Valores), bagof(Posicao, Valor^(member(Valor, Valores), Posicao = (Nova_Linha, Valor)), Posicoes); (Nova_Coluna =:= Nova_Coluna2 -> valores_entre(Nova_Linha, Nova_Linha2, [], Valores), bagof(Posicao, Valor^(member(Valor, Valores), Posicao = (Valor, Nova_Coluna)), Posicoes))).

% 2.6 - Predicado recebe duas posicoes e cria um ponte entre ambas
% Input - Pos1 (Posicao), Pos2 (Posicao), Ponte (Variavel)
% Output - Ponte (Ponte)
cria_ponte(Pos1, Pos2, Ponte) :-
    posicoes_em_ordem(Pos1, Pos2, Posicoes_em_ordem),
    Posicoes_em_ordem = [Nova_Pos1,Nova_Pos2],
    Ponte = ponte(Nova_Pos1,Nova_Pos2).

% 2.7 - Predicado recebe duas posicoes onde se vai criar uma ponte e as posicoes entre elas e uma ilha e sua vizinha e ve se apos a ponte ser criada o caminho entre a ilha e a sua vizinha mantem-se livre
% Input - Pos1 (Posicao), Pos2 (Posicao), Posicoes (Lista de Posicoes), I (Ilha), Vz (Ilha)
% Output - Booleano
caminho_livre(Pos1, Pos2, Posicoes, I, Vz) :-
    I = ilha(_,Pos_Ilha),
    Vz = ilha(_,Pos_Vizinha),
    % Calcula as posicoes entre a Ilha I e a ilha Vz
    posicoes_entre(Pos_Ilha, Pos_Vizinha, Posicoes_Vizinhas),
    posicoes_em_ordem(Pos_Ilha, Pos_Vizinha, [Nova_Pos_Ilha,Nova_Pos_Vizinha]),
    append([Nova_Pos_Ilha], Posicoes_Vizinhas, Posicoes_Vizinhas_Temp),
    append(Posicoes_Vizinhas_Temp, [Nova_Pos_Vizinha], Posicoes_Vizinhas_Final),
    % Calcula as posicoes em comum entre as posicoes entre Pos1 e Pos2 e as posicoes entre I e Vz
    findall(Posicao_Atual, (member(Posicao_Atual, Posicoes), member(Posicao_Atual_Vizinha, Posicoes_Vizinhas_Final), Posicao_Atual == Posicao_Atual_Vizinha), Posicoes_Comuns),
    length(Posicoes_Comuns, Tamanho),
    (Tamanho =:= 0; (Pos1 == Pos_Ilha -> (Pos2 == Pos_Vizinha); (Pos1 == Pos_Vizinha -> (Pos2 == Pos_Ilha)))).

% 2.8 - Predicado que recebe duas posicoes e as Posicoes e uma Entrada e atualiza a entrada apos o adicionamento da ponte entre Pos1 e Pos2
% Input - Pos1 (Posicao), Pos2 (Posicao), Posicoes (Lista de Posicoes), Entrada (Entrada), Nova_entrada (Variavel)
% Output - Nova_entrada (Entrada)
actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, Entrada, Nova_entrada) :-
    Entrada = [Ilha,Vizinhas,Pontes],
    findall(Vizinha, (member(Vizinha, Vizinhas), caminho_livre(Pos1, Pos2, Posicoes, Ilha, Vizinha)), Novas_Vizinhas),
    Nova_entrada = [Ilha,Novas_Vizinhas,Pontes].

% 2.9 - Predicado que recebe duas posicoes e as Posicoes e o Estado do puzzle e chama actualiza_vizinhas_entrada para cada entrada do estado
% Input - Estado (Estado), Pos1 (Posicao), Pos2 (Posicao), Novo_estado (Variavel)
% Output - Novo_estado (Estado)
actualiza_vizinhas_apos_pontes(Estado, Pos1, Pos2, Novo_estado) :-
    posicoes_entre(Pos1, Pos2, Posicoes),
    bagof(Nova_Entrada, Entrada_Atual^(member(Entrada_Atual, Estado), actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, Entrada_Atual, Nova_Entrada)), Novo_estado).

% 2.10 - Predicado que recebe um estado e retorna uma lista com as ilhas que ja estao acabadas, portanto as ilhas com o maximo numero de pontes atribuidas
% Input - Estado (Estado), Ilhas_term (Variavel)
% Output - Ilhas_term (Lista de Ilhas)
ilhas_terminadas(Estado, Ilhas_term) :-
    findall(IlhaTerminada, (member(Atual_Estado, Estado), Atual_Estado = [ilha(N_Pontes,Pos),_,Pontes], length(Pontes, Numero_De_Pontes), N_Pontes \== 'X', N_Pontes =:= Numero_De_Pontes, IlhaTerminada = ilha(N_Pontes,Pos)), Ilhas_term).

% 2.11 - Predicado que recebe uma lista de ilhas terminadas e uma entrada e remove as ilhas terminadas das vizinhas presentes na entrada recebida
% Input - Ilhas_term (Lista de Ilhas), Entrada (Entrada), Nova_entrada (Variavel)
% Output - Nova_entrada (Entrada)
tira_ilhas_terminadas_entrada(Ilhas_term, Entrada, Nova_entrada) :-
    Entrada = [Ilha,Vizinhas,Pontes],
    findall(Vizinha, (member(Vizinha, Vizinhas), \+member(Vizinha, Ilhas_term)), Novas_Vizinhas),
    Nova_entrada = [Ilha,Novas_Vizinhas,Pontes].

% 2.12 - Predicado que recebe o Estado do puzzle e uma lista com as ilhas terminadas e aplica o predicado tira_ilhas_terminadas_entrada a cada entrada do Estado
% Input - Estado (Lista de Entradas), Ilhas_term (Lista de Ilhas), Novo_estado (Variavel)
% Output - Novo_estado (Lista de Entradas)
tira_ilhas_terminadas(Estado, Ilhas_term, Novo_estado) :-
    bagof(Nova_entrada, Entrada^(member(Entrada, Estado), tira_ilhas_terminadas_entrada(Ilhas_term, Entrada, Nova_entrada)), Novo_estado).

% 2.13 - Predicado que recebe uma lista de ilhas terminadas e uma entrada e coloca um X no numero de pontes da ilha se a ilha da entrada estiver presente na lista de ilhas terminadas
% Input - Ilhas_term (Lista de Ilhas), Entrada (Entrada), Nova_entrada (Variavel)
% Output - Nova_entrada (Entrada)
marca_ilhas_terminadas_entrada(Ilhas_term, Entrada, Nova_entrada) :-
    Entrada = [Ilha,Vizinhas,Pontes],
    Ilha = ilha(_,(Linha,Coluna)),
    (member(Ilha, Ilhas_term) ->
        Nova_Ilha = ilha('X',(Linha,Coluna)),
        Nova_entrada = [Nova_Ilha,Vizinhas,Pontes]
    ;
        Nova_entrada = Entrada
    ).

% 2.14 - Predicado que recebe o Estado do puzzle e uma lista com as ilhas terminadas e aplica o predicado marca_ilhas_terminadas_entrada a cada entrada do Estado
% Input - Estado (Lista de Entradas), Ilhas_term (Lista de Ilhas), Novo_estado (Variavel)
% Output - Novo_estado (Lista de Entradas)
marca_ilhas_terminadas(Estado, Ilhas_term, Novo_estado) :-
    bagof(Nova_Entrada, Entrada^(member(Entrada, Estado), marca_ilhas_terminadas_entrada(Ilhas_term, Entrada, Nova_Entrada)), Novo_estado).

% 2.15 - Predicado que recebe o Estado do puzzle, descobre as ilhas que ja estao terminadas chamando o predicado ilhas_terminadas e depois retira as ilhas terminadas chamando o predicado tira_ilhas_terminadas e depois marca as entradas com ilhas terminadas chamando o predicado marca_ilhas_terminadas
% Input - Estado (Lista de Entradas), Ilhas_term (Lista de Ilhas), Novo_estado (Variavel)
% Output - Novo_estado (Lista de Entradas)
trata_ilhas_terminadas(Estado, Novo_estado) :-
    ilhas_terminadas(Estado, Ilhas_term),
    tira_ilhas_terminadas(Estado, Ilhas_term, Estado_Tratado),
    marca_ilhas_terminadas(Estado_Tratado, Ilhas_term, Novo_estado).

% Predicado que recebe uma ponte o numero de pontes a adicionar e uma entrada e adiciona a ponte a entrada recebida num_pontes vezes
% Input - Ponte (Ponte), Num_pontes (Inteiro), Entrada (Entrada), Nova_entrada (Variavel)
% Output - Nova_entrada (Entrada)
adiciona_pontes(Ponte, Num_pontes, Entrada, Nova_entrada) :-
    (Num_pontes >= 1 -> 
        Entrada = [Ilha,Vizinhas,Pontes], 
        append(Pontes, [Ponte], Novas_Pontes),
        Nova_Num_pontes is Num_pontes - 1,
        Entrada_Atualizado = [Ilha,Vizinhas,Novas_Pontes], 
        adiciona_pontes(Ponte, Nova_Num_pontes, Entrada_Atualizado, Nova_entrada)
    ;
        Nova_entrada = Entrada,!
    ).

% 2.16 - Predicado que recebe o Estado do puzzle, o numero de pontes a serem adicionadas e duas ilhas e adiciona essas ilhas ao estado chamando o predicado adiciona_pontes e depois actualiza_vizinhas_apos_pontes e trata_ilhas_terminadas
% Input - Estado (Lista de Entradas), Num_pontes (Inteiros), Ilha1 (Ilha), Ilha2 (Ilha), Novo_estado (Variavel)
% Output - Novo_estado (Lista de Entradas)
junta_pontes(Estado, Num_pontes, Ilha1, Ilha2, Novo_estado) :-
    Ilha1 = ilha(_,Pos1),
    Ilha2 = ilha(_,Pos2),
    cria_ponte(Pos1, Pos2, Ponte),
    % Encontra a Entrada da Ilha1
    findall(Entrada, (member(Entrada, Estado), Entrada = [Ilha_Atual,_,_], Ilha_Atual == Ilha1), Entrada1_Temp),
    Entrada1_Temp = [Entrada1],
    % Encontra a Entrada da Ilha2
    findall(Entrada, (member(Entrada, Estado), Entrada = [Ilha_Atual,_,_], Ilha_Atual == Ilha2), Entrada2_Temp),
    Entrada2_Temp = [Entrada2],
    adiciona_pontes(Ponte, Num_pontes, Entrada1, Nova_entrada_pontes1),
    adiciona_pontes(Ponte, Num_pontes, Entrada2, Nova_entrada_pontes2),
    findall(Entrada, (member(Entrada_Atual, Estado), Entrada_Atual = [Ilha_Atual,_,_], (Ilha_Atual == Ilha1 -> Entrada = Nova_entrada_pontes1; (Ilha_Atual == Ilha2 -> Entrada = Nova_entrada_pontes2; Entrada = Entrada_Atual))), Estado_Pontes),
    % Atualiza o estado apos adicao das ponte(s)
    actualiza_vizinhas_apos_pontes(Estado_Pontes, Pos1, Pos2, Estado_Atualizado),
    trata_ilhas_terminadas(Estado_Atualizado, Novo_estado).