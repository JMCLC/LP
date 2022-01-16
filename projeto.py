def extrai_ilhas_linha(N_L, Linha, Ilhas):
    res = []
    for i in range(len(Linha)):
        if Linha[i] != 0:
            res.append((Linha[i], (N_L, i + 1)))
    Ilhas = res
    return Ilhas

def ilhas(Puz, Ilhas):
    res = []
    for i in range(len(Puz)):
        currentIlhas = extrai_ilhas_linha(i+1, Puz[i], [])
        for j in range(len(currentIlhas)):
            res.append(currentIlhas[j])
    Ilhas = res
    return Ilhas
        
def vizinhas(Ilhas, Ilha, Vizinhas):
    res = []
    closestInLine = 0
    closestInColumn = 0
    for i in range(len(Ilhas)):
        currentColumn = Ilhas[i][1][0]
        currentLine = Ilhas[i][1][1]
        if currentColumn == Ilha[1][0] and (currentLine < closestInColumn or closestInColumn == 0):
            closestInColumn = currentLine
        elif currentLine == Ilha[1][1] and (currentColumn < closestInLine or closestInLine == 0):
            closestInLine = currentColumn
    for i in range(len(ilhas)):
        currentColumn = Ilhas[i][1][0]
        currentLine = Ilhas[i][1][1]
        if currentColumn == Ilha[1][0] and currentLine == closestInLine:
            res.append(Ilha[i])
        elif currentColumn == Ilha[1][1] and currentColumn == closestInColumn:
            res.append(Ilha[i]) 
    Vizinhas = res
    return Vizinhas

def estado(Ilhas, Estado):
    res = []
    [(), [], []]
    for i in range(len(Ilhas)):
        res.append([Ilhas[i], vizinhas(Ilhas, Ilhas[i], [])], [])
    Estado = res
    return Estado

def posicoes_entre(Pos1, Pos2, Posicoes): # Esta muito mal otimizado tem de ser melhorado
    if Pos1[0] != Pos2[0] and Pos1[1] != Pos2[1]:
        return False
    res = []
    if Pos1[0] == Pos2[0]:
        index = 1
    elif Pos2[1] == Pos2[1]:
        index = 0
    size = Pos1[index] - Pos2[index]
    if size < 0:
        size *= -1
    if Pos1[index] < Pos2[index]:
        start = Pos2[index]
    else:
        start = Pos1[index]
    for i in range(size):
        if index == 1:
            res.append((Pos1[0], start + i))
        else:
            res.append((start + i, Pos1[1]))
    Posicoes = res
    return Posicoes

def cria_ponte(Pos1, Pos2, Ponte):
    index = 0 
    if Pos1[0] == Pos2[0]:
        index = 1
    Ponte = [Pos1, Pos2]
    if Pos1[index] - Pos2[index] < 0:
        Ponte = [Pos2, Pos1]
    return Ponte

def caminho_livre(Pos1, Pos2, Posicoes, I, Vz):
    caminho = posicoes_entre(I, Vz, [])
    overlap = 0
    for i in range(len(Posicoes)):
        for j in range(len(caminho)):
            if Posicoes[i] == caminho[j]:
                overlap += 1
    if overlap == len(Posicoes):
        return True
    return False

def actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, Entrada, Nova_Entrada):
    for i in range(len(Entrada[1])):
        if not caminho_livre(Pos1, Pos2, Posicoes, Entrada[0], Entrada[1][i]):
            Entrada[1].remove(Entrada[1][i])
    Nova_Entrada = Entrada
    return Nova_Entrada

def actualiza_vizinhas_apos_pontes(Estado, Pos1, Pos2, Novo_Estado):
    res = []
    for i in range(len(Estado)):
        res.append(actualiza_vizinhas_entrada(Pos1, Pos2, posicoes_entre(Pos1, Pos2), Estado[i], []))
    Novo_Estado = res
    return Novo_Estado

def ilhas_terminadas(Estado, Ilhas_Term):

print(extrai_ilhas_linha(7, [4, 0, 0, 2, 0, 0, 0] , []))