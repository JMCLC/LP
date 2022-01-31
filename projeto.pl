:- [codigo_comum].

extrai_ilhas_linha_aux([], _, _, Ilhas, Res) :-
    Res = Ilhas.
extrai_ilhas_linha_aux([Valor | Resto], Index, N_L, Ilhas, Res) :-
    Novo_Index is Index + 1,
    (Valor =\= 0 -> Nova_Ilha = ilha(Valor,(N_L,Novo_Index)), append(Ilhas, [Nova_Ilha], Nova_Lista), extrai_ilhas_linha_aux(Resto, Novo_Index, N_L, Nova_Lista, Res); extrai_ilhas_linha_aux(Resto, Novo_Index, N_L, Ilhas, Res)).

extrai_ilhas_linha(N_L, Linha, Ilhas) :-
    extrai_ilhas_linha_aux(Linha, 0, N_L, [], Ilhas).
    
ilhas_aux([], _, Ilhas, Res) :-
    Res = Ilhas.
ilhas_aux([Linha | Resto], N_L, Ilhas, Res) :-
    Novo_N_L is N_L + 1,
    extrai_ilhas_linha(Novo_N_L, Linha, Ilhas_Novas),
    append(Ilhas, Ilhas_Novas, Nova_Lista),
    ilhas_aux(Resto, Novo_N_L, Nova_Lista, Res).

ilhas(Puz, Ilhas) :-
    ilhas_aux(Puz, 0, [], Ilhas).

ilha_existe_linha([], _, Res) :-
    Res = [].
ilha_existe_linha([Ilha|Resto], Valor_Coluna, Res) :-
    Ilha = ilha(_,(_,Coluna)),
    (Coluna =:= Valor_Coluna -> Res = Ilha, !; ilha_existe_linha(Resto, Valor_Coluna, Res)).

ilha_existe_coluna([], _, Res) :-
    Res = [].
ilha_existe_coluna([Ilha|Resto], Valor_Linha, Res) :-
    Ilha = ilha(_,(Linha,_)),
    (Linha =:= Valor_Linha -> Res = Ilha, !; ilha_existe_coluna(Resto, Valor_Linha, Res)).

ilha_mais_proxima_esquerda(Vizinhas, Valor_Atual, Res) :-
    Novo_Valor_Atual is Valor_Atual - 1,
    (Novo_Valor_Atual =:= 0 -> Res = [],!; ilha_existe_linha(Vizinhas, Novo_Valor_Atual, Ilha), (Ilha \== [] -> Res = [Ilha], !; ilha_mais_proxima_esquerda(Vizinhas, Novo_Valor_Atual, Res))).

ilha_mais_proxima_direita(Vizinhas, Valor_Atual, Tamanho, Res) :-
    Novo_Valor_Atual is Valor_Atual + 1,
    (Novo_Valor_Atual =:= Tamanho + 1 -> Res = [],!; ilha_existe_linha(Vizinhas, Novo_Valor_Atual, Ilha), (Ilha \== [] -> Res = [Ilha], !; ilha_mais_proxima_direita(Vizinhas, Novo_Valor_Atual, Tamanho, Res))).

ilha_mais_proxima_cima(Vizinhas, Valor_Atual, Res) :-
    Novo_Valor_Atual is Valor_Atual - 1,
    (Novo_Valor_Atual =:= 0 -> Res = [], !; ilha_existe_coluna(Vizinhas, Novo_Valor_Atual, Ilha), (Ilha \== [] -> Res = [Ilha], !; ilha_mais_proxima_cima(Vizinhas, Novo_Valor_Atual, Res))).

ilha_mais_proxima_baixo(Vizinhas, Valor_Atual, Tamanho, Res) :-
    Novo_Valor_Atual is Valor_Atual + 1,
    (Novo_Valor_Atual =:= Tamanho + 1 -> Res = [],!; ilha_existe_coluna(Vizinhas, Novo_Valor_Atual, Ilha), (Ilha \== [] -> Res = [Ilha], !; ilha_mais_proxima_baixo(Vizinhas, Novo_Valor_Atual, Tamanho, Res))).

obtem_tamanho_puzzle([], Maior_Valor, Tamanho) :-
    Tamanho = Maior_Valor.
obtem_tamanho_puzzle([ilha(_,(Linha,_))| Resto], Maior_Valor, Tamanho) :-
    (Linha > Maior_Valor -> Novo_Maior_Valor = Linha, obtem_tamanho_puzzle(Resto, Novo_Maior_Valor, Tamanho); obtem_tamanho_puzzle(Resto, Maior_Valor, Tamanho)).

vizinhas(Ilhas, Ilha, Vizinhas) :-
    Ilha = ilha(_,(Linha,Coluna)),
    obtem_tamanho_puzzle(Ilhas, 0, Tamanho),
    findall(Ilha_Atual, (member(Ilha_Atual, Ilhas), Ilha_Atual = ilha(_,(Linha_Atual,Coluna_Atual)), Linha =:= Linha_Atual, Coluna_Atual < Coluna), Vizinhas_Esquerda_Temp),
    length(Vizinhas_Esquerda_Temp, Tamanho_Esquerda),
    (Tamanho_Esquerda > 1 -> ilha_mais_proxima_esquerda(Vizinhas_Esquerda_Temp, Coluna, Vizinha_Esquerda); Vizinha_Esquerda = Vizinhas_Esquerda_Temp),
    findall(Ilha_Atual, (member(Ilha_Atual, Ilhas), Ilha_Atual = ilha(_,(Linha_Atual,Coluna_Atual)), Linha =:= Linha_Atual, Coluna_Atual > Coluna), Vizinhas_Direita_Temp),
    length(Vizinhas_Direita_Temp, Tamanho_Direita),
    (Tamanho_Direita > 1 -> ilha_mais_proxima_direita(Vizinhas_Direita_Temp, Coluna, Tamanho, Vizinha_Direita); Vizinha_Direita = Vizinhas_Direita_Temp),
    append(Vizinha_Esquerda, Vizinha_Direita, Vizinhas_Linha),
    findall(Ilha_Atual, (member(Ilha_Atual, Ilhas), Ilha_Atual = ilha(_,(Linha_Atual,Coluna_Atual)), Coluna =:= Coluna_Atual, Linha_Atual < Linha), Vizinhas_Cima_Temp),
    length(Vizinhas_Cima_Temp, Tamanho_Cima),
    (Tamanho_Cima > 1 -> ilha_mais_proxima_cima(Vizinhas_Cima_Temp, Linha, Vizinha_Cima); Vizinha_Cima = Vizinhas_Cima_Temp), 
    findall(Ilha_Atual, (member(Ilha_Atual, Ilhas), Ilha_Atual = ilha(_,(Linha_Atual,Coluna_Atual)), Coluna =:= Coluna_Atual, Linha_Atual > Linha), Vizinhas_Baixo_Temp),
    length(Vizinhas_Baixo_Temp, Tamanho_Baixo),
    (Tamanho_Baixo > 1 -> ilha_mais_proxima_baixo(Vizinhas_Baixo_Temp, Linha, Tamanho, Vizinha_Baixo); Vizinha_Baixo = Vizinhas_Baixo_Temp),
    append(Vizinha_Cima, Vizinhas_Linha, Vizinhas_Temp),
    append(Vizinhas_Temp, Vizinha_Baixo, Vizinhas).

estado(Ilhas, Estado) :-
    bagof(Entrada, Ilha^Vizinhas^(member(Ilha, Ilhas), vizinhas(Ilhas, Ilha, Vizinhas), Entrada = [Ilha,Vizinhas,[]]), Estado).

posicoes_em_ordem(Pos1, Pos2, Posicoes_em_ordem) :-
    Pos1 = (Linha,Coluna),
    Pos2 = (Linha2,Coluna2),
    (Linha =:= Linha2 -> (Coluna > Coluna2 -> Posicoes_em_ordem = [Pos2,Pos1]; Posicoes_em_ordem = [Pos1,Pos2]); (Linha > Linha2 -> Posicoes_em_ordem = [Pos2,Pos1]; Posicoes_em_ordem = [Pos1,Pos2])).

valores_entre(Valor, Valor2, [], Res) :-
    Primeiro_Valor is Valor + 1,
    valores_entre(Valor, Valor2, [Primeiro_Valor], Res).

valores_entre(Valor, Valor2, Lista, Res) :-
    last(Lista, Ultimo_Valor),
    Atual is Ultimo_Valor + 1,
    (Atual < Valor2 -> append(Lista, [Atual], Nova_Lista), valores_entre(Valor, Valor2, Nova_Lista, Res); Res = Lista, !).

posicoes_entre(Pos1, Pos2, Posicoes) :-
    posicoes_em_ordem(Pos1, Pos2, [(Nova_Linha, Nova_Coluna),(Nova_Linha2, Nova_Coluna2)]),
    (Nova_Linha =:= Nova_Linha2 -> valores_entre(Nova_Coluna, Nova_Coluna2, [], Valores), bagof(Posicao, Valor^(member(Valor, Valores), Posicao = (Nova_Linha, Valor)), Posicoes); (Nova_Coluna =:= Nova_Coluna2 -> valores_entre(Nova_Linha, Nova_Linha2, [], Valores), bagof(Posicao, Valor^(member(Valor, Valores), Posicao = (Valor, Nova_Coluna)), Posicoes))).

cria_ponte(Pos1, Pos2, Ponte) :-
    posicoes_em_ordem(Pos1, Pos2, Posicoes_em_ordem),
    Posicoes_em_ordem = [Nova_Pos1,Nova_Pos2],
    Ponte = ponte(Nova_Pos1,Nova_Pos2).

listas_iguais([], []).
listas_iguais([Pos1 | Resto], [Pos2 | Resto2]) :-
    (Pos1 == Pos2 -> listas_iguais(Resto, Resto2); false).

caminho_livre(Pos1, Pos2, Posicoes, I, Vz) :-
    I = ilha(_,Pos_Ilha),
    Vz = ilha(_,Pos_Vizinha),
    posicoes_entre(Pos_Ilha, Pos_Vizinha, Posicoes_Vizinhas),
    posicoes_em_ordem(Pos_Ilha, Pos_Vizinha, [Nova_Pos_Ilha,Nova_Pos_Vizinha]),
    append([Nova_Pos_Ilha], Posicoes_Vizinhas, Posicoes_Vizinhas_Temp),
    append(Posicoes_Vizinhas_Temp, [Nova_Pos_Vizinha], Posicoes_Vizinhas_Final),
    findall(Posicao_Atual, (member(Posicao_Atual, Posicoes), member(Posicao_Atual_Vizinha, Posicoes_Vizinhas_Final), Posicao_Atual == Posicao_Atual_Vizinha), Posicoes_Comuns),
    length(Posicoes_Comuns, Tamanho),
    (Tamanho =:= 0; (Pos1 == Pos_Ilha -> (Pos2 == Pos_Vizinha); (Pos1 == Pos_Vizinha -> (Pos2 == Pos_Ilha)))).

actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, Entrada, Nova_entrada) :-
    Entrada = [Ilha,Vizinhas,Pontes],
    findall(Vizinha, (member(Vizinha, Vizinhas), caminho_livre(Pos1, Pos2, Posicoes, Ilha, Vizinha)), Novas_Vizinhas),
    Nova_entrada = [Ilha,Novas_Vizinhas,Pontes].

actualiza_vizinhas_apos_pontes(Estado, Pos1, Pos2, Novo_estado) :-
    posicoes_entre(Pos1, Pos2, Posicoes),
    bagof(Nova_Entrada, Entrada_Atual^(member(Entrada_Atual, Estado), actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, Entrada_Atual, Nova_Entrada)), Novo_estado).

ilhas_terminadas(Estado, Ilhas_term) :-
    findall(IlhaTerminada, (member(Atual_Estado, Estado), Atual_Estado = [ilha(N_Pontes,Pos),_,Pontes], length(Pontes, Numero_De_Pontes), N_Pontes \== 'X', N_Pontes =:= Numero_De_Pontes, IlhaTerminada = ilha(N_Pontes,Pos)), Ilhas_term).

tira_ilhas_terminadas_entrada(Ilhas_term, Entrada, Nova_entrada) :-
    Entrada = [Ilha,Vizinhas,Pontes],
    findall(Vizinha, (member(Vizinha, Vizinhas), \+member(Vizinha, Ilhas_term)), Novas_Vizinhas),
    Nova_entrada = [Ilha,Novas_Vizinhas,Pontes].

tira_ilhas_terminadas(Estado, Ilhas_term, Novo_estado) :-
    bagof(Nova_entrada, Entrada^(member(Entrada, Estado), tira_ilhas_terminadas_entrada(Ilhas_term, Entrada, Nova_entrada)), Novo_estado).

marca_ilhas_terminadas_entrada(Ilhas_term, Entrada, Nova_entrada) :-
    Entrada = [Ilha,Vizinhas,Pontes],
    Ilha = ilha(_,(Linha,Coluna)),
    (member(Ilha, Ilhas_term) ->
        Nova_Ilha = ilha('X',(Linha,Coluna)),
        Nova_entrada = [Nova_Ilha,Vizinhas,Pontes]
    ;
        Nova_entrada = Entrada
    ).

marca_ilhas_terminadas(Estado, Ilhas_term, Novo_estado) :-
    bagof(Nova_Entrada, Entrada^(member(Entrada, Estado), marca_ilhas_terminadas_entrada(Ilhas_term, Entrada, Nova_Entrada)), Novo_estado).

trata_ilhas_terminadas(Estado, Novo_estado) :-
    ilhas_terminadas(Estado, Ilhas_term),
    tira_ilhas_terminadas(Estado, Ilhas_term, Estado_Tratado),
    marca_ilhas_terminadas(Estado_Tratado, Ilhas_term, Novo_estado).

adiciona_pontes(Ponte, Num_pontes, Estado, Novo_estado) :-
    (Num_pontes >= 1 -> 
        Estado = [Ilha,Vizinhas,Pontes], 
        append(Pontes, [Ponte], Novas_Pontes),
        Nova_Num_pontes is Num_pontes - 1,
        Estado_Atualizado = [Ilha,Vizinhas,Novas_Pontes], 
        adiciona_pontes(Ponte, Nova_Num_pontes, Estado_Atualizado, Novo_estado)
    ;
        Novo_estado = Estado,!
    ).


junta_pontes(Estado, Num_pontes, Ilha1, Ilha2, Novo_estado) :-
    Ilha1 = ilha(_,Pos1),
    Ilha2 = ilha(_,Pos2),
    cria_ponte(Pos1, Pos2, Ponte),
    findall(Entrada, (member(Entrada, Estado), Entrada = [Ilha_Atual,_,_], Ilha_Atual == Ilha1), Entrada1_Temp),
    Entrada1_Temp = [Entrada1],
    findall(Entrada, (member(Entrada, Estado), Entrada = [Ilha_Atual,_,_], Ilha_Atual == Ilha2), Entrada2_Temp),
    Entrada2_Temp = [Entrada2],
    adiciona_pontes(Ponte, Num_pontes, Entrada1, Nova_entrada_pontes1),
    adiciona_pontes(Ponte, Num_pontes, Entrada2, Nova_entrada_pontes2),
    findall(Entrada, (member(Entrada_Atual, Estado), Entrada_Atual = [Ilha_Atual,_,_], (Ilha_Atual == Ilha1 -> Entrada = Nova_entrada_pontes1; (Ilha_Atual == Ilha2 -> Entrada = Nova_entrada_pontes2; Entrada = Entrada_Atual))), Estado_Pontes),
    actualiza_vizinhas_apos_pontes(Estado_Pontes, Pos1, Pos2, Estado_Atualizado),
    trata_ilhas_terminadas(Estado_Atualizado, Novo_estado).