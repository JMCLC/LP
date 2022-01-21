:- [codigo_comum].
:- [puzzles_publicos].

extrai_ilhas_linha(N_L, Linha, Ilhas) :-
    findall(NewIlha, (member(CurrentValue, Linha), nth1(Index, Linha, CurrentValue), CurrentValue =\= 0, NewIlha = ilha(CurrentValue,(N_L, Index))), New_Ilhas),
    list_to_set(New_Ilhas, Ilhas).
    
ilhas(Puz, Ilhas) :-
    bagof(Ilha, CurrentLinha^CurrentIndex^CurrentIlhas^(member(CurrentLinha, Puz), nth1(CurrentIndex, Puz, CurrentLinha), extrai_ilhas_linha(CurrentIndex, CurrentLinha, CurrentIlhas), member(Ilha, CurrentIlhas)), Ilhas).

vizinhas(Ilhas, Ilha, Vizinhas) :- % Esta funcao pode n funcionar muito bem se ouver dois do mesmo lado
    Ilha = ilha(_,(Linha, Coluna)),
    bagof(CurrentIlha, (member(CurrentIlha, Ilhas), CurrentIlha = ilha(_, (CurrentLinha, _)), Linha =:= CurrentLinha, CurrentIlha \== Ilha), VizinhosLinha),
    bagof(CurrentIlha, (member(CurrentIlha, Ilhas), CurrentIlha = ilha(_, (_, CurrentColuna)), Coluna =:= CurrentColuna, CurrentIlha \== Ilha), VizinhosColuna),
    append(VizinhosLinha, VizinhosColuna, VizinhasTemp),
    sort(VizinhasTemp, Vizinhas),
    writeln([Vizinhas, VizinhosLinha, VizinhosColuna]).