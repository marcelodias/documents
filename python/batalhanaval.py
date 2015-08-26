from random import randint	#Importar random de randint
#Variavel responsavel pelo tabuleiro
board = []			
#Laco para criar uma grade 5x5, inicializado com 'O's em todas as posicoes do tabuleiro
for x in range(5):		
    board.append(["O"] * 5)
#Mostra se o tabuleiro foi criado
#print board

#Funcao identificada para personalisar a exibicao do tabuleiro esteticamente
def print_board(board):
    for row in board:
        print " ".join(row)

print "Vamos jogar Batalha Naval!"
print_board(board)

# Agora vamos ocultar as informacoes de onde esta o navio de forma randomizada, auxiliada pelo import da linha 3
def random_row(board):
    return randint(0, len(board) - 1)

def random_col(board):
    return randint(0, len(board[0]) - 1)

#Adicionar quatro novas variaveis, 2 primeiras para colocar o navio
ship_row = random_row(board)
ship_col = random_col(board)

#Depurando o local real nesse momento do navio, comentar as duas linhas que refere-se a resultado do jogo
print ship_row
print ship_col

#Laco para fazer a contagem e limite de quatro tentativas
for turn in range(4):
    #Adicionar duas variaveis para fazer a procura do navio, fazendo com que o usuario   digite o local do navio
    guess_row = int(raw_input("Adivinhe a Linha:"))
    guess_col = int(raw_input("Adivinhe a Coluna:"))

	# Fazendo o teste se o usuarios acertar e exibir mensagem de acerto
    if guess_row == ship_row and guess_col == ship_col:
        print "Parabens, voce afundou meu couracado!"
        
        # Parar a funcao de tentativas caso usuario acerte o navio
        break
    # Quando usuario errar o navio
    else:
    	# Se os valores inseridos pelo usuario estam fora do alcance da batalha
        if (guess_row < 0 or guess_row > 4) or (guess_col < 0 or guess_col > 4):
            print "Oops, isso nao e nem mesmo no oceano."
        # Verificando se o usuario ja tentou o mesmo lugar
        elif(board[guess_row][guess_col] == "X"):
            print "Voce ja tentou esse."
        else:
            print "Voce errou meu couracado!"
            # Marcar todos os locais digitados com "X"
            board[guess_row][guess_col] = "X"
            # Se ele completar o ciclo de 4x e errando 4x eh Game Over
            if turn == 3:
                print "Game Over"
    # Mostra qual eh a volta do "for"
    print "Turn", turn + 1
    print turn
    print_board(board)
