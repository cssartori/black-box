;Work with the Intel 8086		-		INF01108 - Computers' Architecture and Organization I
;Black Box: Assembled (2012/1)


assume cs:codigo,ds:dados,es:dados,ss:pilha

CR       EQU    0DH ; constante - codigo ASCII do caractere "carriage return"
LF       EQU    0AH ; constante - codigo ASCII do caractere "line feed"
null     EQU    00H
BS	 EQU 	08H ; constante - codigo ASCII do caractere "Backspace"
EC	 EQU    01BH; constante - codigo ASCII do caractere 'escape'
cif      EQU    024H
;SEGMENTO DE DADOS:
	
dados	segment

Cenario_0  db	'Black Box: Assembled  |  by Carlo Sartori'                              , CR,LF,CR,LF ;'$'

Cenario_2  db   '         [  ] [  ] [  ] [  ] [  ] [  ] [  ] [  ]'                                           , CR,LF;'$'
Cenario_3  db   '           0    1    2    3    4    5    6    7           Tries:   [   ]'                , CR,LF;,'$'
Cenario_4  db	'        *----*----*----*----*----*----*----*----*'		                             , CR, LF;, '$'
Cenario_5  db   ' [  ] 0 |    |    |    |    |    |    |    |    | 0 [  ]  Command: [   ]'  ,CR, LF;,        '$'
Cenario_6  db   '        *----*----*----*----*----*----*----*----*           R: Shoot Ray'                    , CR,LF;,'$'
Cenario_7  db   ' [  ] 1 |    |    |    |    |    |    |    |    | 1 [  ]    P: Set Atom', CR,LF;,'$'
Cenario_8  db   '        *----*----*----*----*----*----*----*----*           D: Remove Atom', CR,LF;,'$'
Cenario_9  db   ' [  ] 2 |    |    |    |    |    |    |    |    | 2 [  ]    E: End Game', CR,LF;,'$'
Cenario_10 db   '        *----*----*----*----*----*----*----*----*            (show results)', CR,LF;,'$'
Cenario_11 db   ' [  ] 3 |    |    |    |    |    |    |    |    | 3 [  ]    N: New Game', CR,LF;,'$'
Cenario_12 db   '        *----*----*----*----*----*----*----*----*           F: Finish Program', CR,LF;,'$'
Cenario_13 db   ' [  ] 4 |    |    |    |    |    |    |    |    | 4 [  ]          ', CR,LF;,'$'
Cenario_14 db   '        *----*----*----*----*----*----*----*----*         Coordinates:', CR,LF;,'$'
Cenario_15 db   ' [  ] 5 |    |    |    |    |    |    |    |    | 5 [  ]    Row        [   ]', CR,LF;,'$'
Cenario_16 db   '        *----*----*----*----*----*----*----*----*           Column     [   ]', CR,LF;,'$'   		
Cenario_17 db   ' [  ] 6 |    |    |    |    |    |    |    |    | 6 [  ]    Direction  [   ]', CR,LF;,'$'
Cenario_18 db   '        *----*----*----*----*----*----*----*----*   '           , CR,LF;,'$'   
Cenario_19 db   ' [  ] 7 |    |    |    |    |    |    |    |    | 7 [  ]  Scenario File: ', CR,LF;,'$'
Cenario_20 db   '        *----*----*----*----*----*----*----*----*                          ' , CR,LF;,'$' 
Cenario_21 db   '           0    1    2    3    4    5    6    7 ', CR,LF;,'$'
Cenario_22 db   '         [  ] [  ] [  ] [  ] [  ] [  ] [  ] [  ] '  , CR,LF,CR,LF,'$'


erro_tec   db   'Comando invalido. Verifique os comandos e seus respectivos codigos.', '$'
erro_arq   db   'Erro ao abrir arquivo. Verifique se o nome foi digitado corretamente.', '$'
erro_lin   db   027H,'Linha',027h,' aceita somente numeros entre 0 e 7. Tente novamente.', '$'
erro_col   db   027H,'Coluna',027h,' aceita somente numeros entre 0 e 7. Tente novamente.', '$'
erro_col_1 db   'A linha escolhida permite apenas coluna 0, ou coluna 7.', '$'
erro_dir   db   027H,'Direcao',027h,' simboliza a direcao de entrada na caixa. Aceita E,B,C,D.', '$'
erro_dir_2 db   'A direcao informada nao e valida para a coordenada.', '$'
saiu_m	   db   'O raio saiu da caixa por ', '$'
refletido_m db  'O raio foi refletido. Ele entrou por ', '$'
absorvido_m db  'O raio foi absorvido. Ele entrou por ', '$'
marquivo   db   'Informe o nome do arquivo matriz: ','$' 
nome	   db    15 dup (?), '$'
erro_enc2  db   'O jogo ja foi encerrado. Finalize(F) ou comece um novo(N).', '$'
pont_certo db   'Acertou tudo! Parabens! Pontuacao final: ', '$'
pont_erro  db   'Erro no posicionamento de esferas! Pontuacao final: ', '$'
erro_enc   db   'Nenhuma tentativa efetuada, nao e possivel exibir resultados.', '$'
erro_escm  db   'Nao e possivel retornar deste campo. ','$'
var1       db    0
var2	   db    0
linha	   db    0
coluna     db    0
lim_col    db    0
handler    dw    (?)
matriz_o   db    80 dup (0), '$'
matriz_j   db    '00000000',CR,LF,'00000000',CR,LF,'00000000',CR,LF,'00000000',CR,LF,'00000000',CR,LF,'00000000',CR,LF,'00000000',CR,LF,'00000000',CR,LF,'$'
estado     dw    (?)
com	   db    (?)
coord_l    db    (?)
coord_c    db    (?)
lxc	   dw    (?)
contador   db    0
contador_2 db    0
pontos     db    0
direcao    db    (?)
dir_ent    db    (?)
encerrado  db    (0)


dados ends




; definicao do segmento de pilha do programa
pilha    segment stack ; permite inicializacao automatica de SS:SP
         dw     1024 dup(?)
pilha    ends
         
; definicao do segmento de codigo do programa
codigo   segment
inicio:  ; CS e IP sao inicializados com este endereco
         mov    ax,dados  ; inicializa DS
         mov    ds,ax     ; com endereco do segmento DADOS
         mov    es,ax     ; idem em ES
; fim da carga inicial dos registradores de segmento



;Parte inicial do programa, limpa a tela
;e imprime, linha por linha, o cenario na tela.


Comeca_o_jogo:
mov encerrado, 0
		;1ª parte: LIMPA TELA
mov ah, 6
mov al, 25
mov bh, 7h 		;fundo preto e letra branca
mov ch, 0
mov cl, 0
mov dh, 24
mov dl, 79
int 10h

		;2ª parte: IMPRIME
posiciona_cursor:
mov var1, 0
mov estado, 0
lea di, matriz_j

zera_matriz_j:		;Zera a matriz do jogador
mov ax, 48
mov [di], ax
inc var1
cmp var1, 8
jz pula_linha
inc di
jmp zera_matriz_j
pula_linha:
inc estado
cmp estado, 8
jz continua_S
mov var1, 0
ADD di, 3
jmp zera_matriz_j

continua_S:
mov var1, 0
mov estado, 0
mov ah,2		;defini a posição do cursor
mov dh, 0		;linha 0
mov dl, 0		;coluna 0
mov bh, 0		;página 0
int 10h
lea dx, Cenario_0
mov ah, 9
int 21h

Pega_nome_arquivo:
mov ah, 2		;defini a posição do cursor
mov dh, 24		;linha 24
mov dl, 1		;coluna 1
mov bh, 0		;página 0

lea dx, marquivo	;Imprime mensagem para pegar o nome do arquivo
mov ah, 9
int 21h
mov linha, 24
mov coluna, 34
mov lim_col, 34

lea di, nome
mov estado, di
add estado, 0CH       ;para impedir que passe de 12 caracteres (0..11=12)

ler_narquivo:
call espera_tecla   ;Chama a subrotina para verificar se uma tecla foi pressionada

cmp al, CR		;Verifica se a tecla é enter
jz ver_nome
cmp al, EC		;verifica se a tecla é ESC, se for, finaliza
jz fim_jmp
cmp al, BS		;Verifica se a tecla é backspace
jnz ver_lim
call backspace

jmp ler_narquivo

fim_jmp:
jmp fim

ver_lim:
cmp di, estado 		;Verifica se o 'di' não chegou ao limite de 12 caracteres
jnz dentro_limite	;se não, pula...
jmp ler_narquivo


dentro_limite:
ecoa_tecla:
mov dl, al		;Imprime o caracter na tela	    
mov ah, 2
int 21h

mov [di],al
inc di
inc coluna
jmp ler_narquivo


ver_nome_1:
jmp fim

ver_nome:
inc di
mov ah, 0ch
int 21h
mov al,0
mov ah, 6
mov al, 2
mov bh, 7h 		;fundo preto e letra branca
mov ch, 23
mov cl, 0
mov dh, 24
mov dl, 79
int 10h
mov ah, 2		;defini a posição do cursor
mov dh, 24		;linha 24
mov dl, 1		;coluna 1
mov bh, 0		;página 0
int 10h

lea dx, nome
mov byte ptr [di],0
mov ah, 3dh
mov al, 0
int 21h

jnc abriu_arq

lea dx, erro_arq
mov ah,9
int 21h
mov ah, 2		;defini a posição do cursor
mov dh, 24		;linha 24
mov dl, 1		;coluna 1
mov bh, 0		;página 0
int 10h

apaga_nome:
call espera_tecla
apaga_nome_22:
call limpa_ultima_linha
lea di, nome
mov dx, 15
cont_apagar_nome:
mov ax, null
mov [di], ax
inc di
dec dx
cmp dx, 1
jnz cont_apagar_nome
cmp var1, 1
jz posiciona_cursor_jmp
jmp pega_nome_arquivo

posiciona_cursor_jmp:
jmp posiciona_cursor

abriu_arq:
mov handler, ax
mov ah, 3fh
mov bx, handler
mov cx, 80
lea dx, matriz_o
int 21h
mov ah, 3eh	;fecha arquivo
int 21h

;Poe o nome do arquivo no layout
mov ah, 2		;defini a posição do cursor
mov dh, 20		;linha 24
mov dl, 58		;coluna 1
mov bh, 0		;página 0
int 10h
lea dx, nome	
mov ah, 9
int 21h





;INICIO DA INSERCAO DE COMANDOS
;----------------------------------------------------------------------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------------------------------------------------------------

Limpa_campos:
mov com, 0
mov estado, 0
mov var1, 0

;limpa campo do comando:
mov dh, 5		;linha
mov dl, 68		;coluna
call limpa_campo

;limpa campo da linha:
mov dh, 15		;linha
mov dl, 72		;coluna
call limpa_campo


;limpa campo da coluna:
mov dh, 16		;linha
mov dl, 72		;coluna
call limpa_campo

;limpa campo da direcao:
mov dh, 17		;linha
mov dl, 72		;coluna
call limpa_campo


Pede_comando:

mov linha, 5		;Envia para a área 'Comando'
mov lim_col, 68
mov coluna, 68
mov ah, 2		;defini a posição do cursor
mov dh, linha		;linha 
mov dl, coluna		;coluna
mov bh, 0		;página 0
int 10h
pede_comando_1:
call espera_tecla
cmp al, CR		;Verifica se a tecla é enter
jz ver_comando_jmp
cmp al, EC		;verifica se a tecla é ESC, se for, mensagem erro
jz erro_esc
cmp al, BS		;Verifica se a tecla é backspace
jnz ecoa_tecla_c
call backspace
mov estado, 0		;Se BS for utilizado significa que o único caracter será apagado
jmp Pede_comando_1

ver_comando_jmp:
jmp ver_comando

erro_esc:
call limpa_ultima_linha
mov ah, 2		;defini a posição do cursor
mov dh, 24		;linha 
mov dl, 1		;coluna
mov bh, 0		;página 0
int 10h
lea dx, erro_escm	
mov ah, 9
int 21h
jmp pede_comando

ecoa_tecla_c:
cmp estado, 1		;Verifica se já foi digitado um caracter, através da variável de estado (=1, já foi)
jz pede_comando_1
mov bl, al
mov dl, bl		;Imprime o caracter na tela
compara_caractere:
cmp dl, 'R'
jz ecoa_tecla_c_2
cmp dl, 'r'
jz ecoa_tecla_c_2
cmp dl, 'P'
jz ecoa_tecla_c_2
cmp dl, 'p'
jz ecoa_tecla_c_2
cmp dl, 'D'
jz ecoa_tecla_c_2
cmp dl, 'd'
jz ecoa_tecla_c_2
cmp dl, 'E'
jz ecoa_tecla_c_2
cmp dl, 'e'
jz ecoa_tecla_c_2
cmp dl, 'N'
jz ecoa_tecla_c_2
cmp dl, 'n'
jz ecoa_tecla_c_2
cmp dl, 'F'
jz ecoa_tecla_c_2
cmp dl, 'f'
jz ecoa_tecla_c_2
jmp erro_tecla_c
ecoa_tecla_c_2:
call limpa_ultima_linha
mov dl, bl	    
mov ah, 2
int 21h
mov com, al		;move o caracter para a variável comando
mov estado, 1		;move o valor um para estado, de modo a verificar se um caracter (máximo) já foi digitado na área
inc coluna
jmp pede_comando_1

jmp_fim:
jmp fim

erro_tecla_c:
call limpa_ultima_linha
mov ah, 2		;defini a posição do cursor
mov dh, 24		;linha 
mov dl, 1		;coluna
mov bh, 0		;página 0
int 10h
lea dx, erro_tec	
mov ah, 9
int 21h
jmp pede_comando


ver_comando:
cmp encerrado, 1
jz ja_foi_encerrado
cmp com, 'R'
jz linha_x_coluna_j
cmp com, 'r'
jz linha_x_coluna_j
cmp com, 'P'
jz linha_x_coluna_j
cmp com, 'p'
jz linha_x_coluna_j
cmp com, 'D'
jz linha_x_coluna_j
cmp com, 'd'
jz linha_x_coluna_j
cmp com, 'E'
jz encerrar_jmp
cmp com, 'e'
jz encerrar_jmp

ja_foi_encerrado:
cmp com, 'N'
jz novo_jogo
cmp com, 'n'
jz novo_jogo
cmp com, 'F'
jz fim_jmp_1
cmp com, 'f'
jz fim_jmp_1

mov ah, 2		;defini a posição do cursor
mov dh, 24		;linha 
mov dl, 1		;coluna
mov bh, 0		;página 0
int 10h
lea dx, erro_enc2
mov ah, 9
int 21h
jmp limpa_campos

linha_x_coluna_j:
jmp linha_x_coluna


encerrar_jmp:
cmp contador_2, 0
jnz jmp_encerrar_1
call limpa_ultima_linha
mov ah, 2		;defini a posição do cursor
mov dh, 24		;linha 
mov dl, 1		;coluna
mov bh, 0		;página 0
int 10h

lea dx, erro_enc	
mov ah, 9
int 21h
jmp limpa_campos
jmp_encerrar_1:
jmp encerrar

novo_jogo:
jmp novo
fim_jmp_1:
jmp fim


linha_x_coluna:
mov estado, 0

linha_coordenada:
mov linha, 15		;Envia para a área 'Linha'
mov lim_col, 72
mov coluna, 72
mov ah, 2		;defini a posição do cursor
mov dh, 15		;linha 
mov dl, 72		;coluna
mov bh, 0		;página 0
int 10h
linha_coordenada_1:
call espera_tecla
cmp al, CR		;Verifica se a tecla é enter
jnz linha_coordenada_2
cmp estado, 1
jz coluna_coordenada
jmp erro_linha
linha_coordenada_2:
cmp al, EC		;verifica se a tecla é ESC, se for, finaliza
jz volta_comando
cmp al, BS		;Verifica se a tecla é backspace
jnz ecoa_tecla_l
call backspace
mov estado, 0		;Se BS for utilizado significa que o único caracter será apagado
jmp linha_coordenada_1

volta_comando:
jmp limpa_campos


ecoa_tecla_l:
cmp estado, 1		;Verifica se já foi digitado um caracter, através da variável de estado (=1, já foi)
jz linha_coordenada_1
mov dl, al			    
cmp dl, 030H		;Verifica se o caracter é menor que 48D-30H(0 em ASCII)
JL erro_linha		;ou maior que 55D-37H (7 em ASCII).
cmp dl, 037H		;Se alguma for verdade, nem imprime o caracter, ele só é impresso se estiver dentro dos limites
JG erro_linha		
mov ah, 2		;Imprime o caracter na tela
int 21h
sub al, 48
mov coord_l, al
mov estado, 1		;move o valor um para estado, de modo a verificar se um caracter (máximo) já foi digitado na área
inc coluna
mov ah, 6
mov al, 1
mov bh, 7h 		;fundo preto e letra branca
mov ch, 24
mov cl, 0
mov dh, 24
mov dl, 79
int 10h
jmp linha_coordenada_1

erro_linha:		;Mensagem para caso o caracter digitado para linha não esteja
			;entre 0 e 7
call limpa_ultima_linha
mov ah, 2		;defini a posição do cursor
mov dh, 24		;linha 
mov dl, 1		;coluna
mov bh, 0		;página 0
int 10h
lea dx, erro_lin	
mov ah, 9
int 21h
jmp linha_x_coluna



coluna_coordenada:
mov estado, 0
coluna_coordenada_1:
mov linha, 16		;Envia para a área 'Coluna'
mov lim_col, 72
mov coluna, 72
mov ah, 2		;defini a posição do cursor
mov dh, linha		;linha 
mov dl, coluna		;coluna
mov bh, 0		;página 0
int 10h

coluna_coordenada_2:
call espera_tecla
cmp al, CR		;Verifica se a tecla é enter
jnz coluna_coordenada_3
cmp estado, 1
jz direcao_entrada_jmp
jmp erro_coluna
coluna_coordenada_3:
cmp al, EC		;verifica se a tecla é ESC, se for, finaliza
jz volta_linha
cmp al, BS		;Verifica se a tecla é backspace
jnz ecoa_tecla_cl
call backspace
mov estado, 0		;Se BS for utilizado significa que o único caracter será apagado
jmp coluna_coordenada_2

volta_linha:
mov estado, 0
mov var1, 0
mov coluna, 0
mov linha, 0
;limpa campo da linha:
mov dh, 15		;linha
mov dl, 72		;coluna
call limpa_campo
;limpa campo da coluna:
mov dh, 16		;linha
mov dl, 72		;coluna
call limpa_campo
jmp linha_coordenada


ecoa_tecla_cl:
mov dl, al
cmp estado, 1		;Verifica se já foi digitado um caracter, através da variável de estado (=1, já foi)
jz coluna_coordenada_2
cmp com, 'R'
jz tem_limite_col
cmp com, 'r'
jz tem_limite_col
jmp vale_qualquer_linha

tem_limite_col:
cmp coord_l, 0		;Compara a linha com 0 e 7, onde a coluna pode ter qualquer valor;
jz vale_qualquer_linha
cmp coord_l, 7
jz vale_qualquer_linha
cmp dl, 030H
jz coluna_coordenada_4
cmp dl, 037H
jz coluna_coordenada_4
jmp erro_coluna_1


direcao_entrada_jmp:
jmp ver_comando_1

vale_qualquer_linha:			    
cmp dl, 030H		;Verifica se o caracter é menor que 48D-30H(0 em ASCII)
JL erro_coluna		;ou maior que 55D-37H (7 em ASCII).
cmp dl, 037H		;Se alguma for verdade, nem imprime o caracter, ele só é impresso se estiver dentro dos limites
JG erro_coluna		
coluna_coordenada_4:
mov ah, 2		;Imprime o caracter na tela
int 21h
SUB al, 48		;Transforma de ASCII para o valor decimal do numero
mov coord_c, al	
mov estado, 1		;move o valor um para estado, de modo a verificar se um caracter (máximo) já foi digitado na área
inc coluna
call limpa_ultima_linha
jmp coluna_coordenada_2

erro_coluna:		;Mensagem para caso o caracter digitado para linha não esteja
call limpa_ultima_linha
mov ah, 2		;defini a posição do cursor
mov dh, 24		;linha 
mov dl, 1		;coluna
mov bh, 0		;página 0
int 10h
lea dx, erro_col	
mov ah, 9
int 21h
jmp coluna_coordenada

erro_coluna_1:		;Mensagem para caso o caracter digitado para linha não esteja
			;entre 0 e 7
call limpa_ultima_linha
mov ah, 2		;defini a posição do cursor
mov dh, 24		;linha 
mov dl, 1		;coluna
mov bh, 0		;página 0
int 10h
lea dx, erro_col_1	
mov ah, 9
int 21h
jmp coluna_coordenada



ver_comando_1:
cmp com, 'R'
jz direcao_entrada
cmp com, 'r'
jz direcao_entrada
jmp escolhe_o_que_faz



direcao_entrada:
mov estado, 0
mov linha, 17		;Envia para a área 'Coluna'
mov lim_col, 72
mov coluna, 72
mov ah, 2		;defini a posição do cursor
mov dh, linha		;linha 
mov dl, coluna		;coluna
mov bh, 0		;página 0
int 10h

direcao_coordenada_1:
call espera_tecla
cmp al, CR		;Verifica se a tecla é enter
jnz direcao_coordenada_2
cmp estado, 1
jz escolhe_o_que_faz_jmp
jmp erro_direcao
direcao_coordenada_2:
cmp al, EC
jz volta_coluna
cmp al, BS		;Verifica se a tecla é backspace
jnz ecoa_tecla_d
call backspace
mov estado, 0		;Se BS for utilizado significa que o único caracter será apagado
jmp direcao_coordenada_1

volta_coluna:
;limpa campo da coluna:
mov dh, 16		;linha
mov dl, 72		;coluna
call limpa_campo

;limpa campo da direcao:
mov dh, 17		;linha
mov dl, 72		;coluna
call limpa_campo
mov var1, 0
mov estado, 0
mov direcao, 0
mov coluna, 0
jmp coluna_coordenada

ecoa_tecla_d:
cmp estado, 1		;Verifica se já foi digitado um caracter, através da variável de estado (=1, já foi)
jz direcao_coordenada_1 

mov dl, al			    
cmp dl, 042H		;Verifica se o caracter é menor que 42H(B em ASCII), se for sinaliza 'erro' pois está fora do limite mínimo
JL erro_direcao_jmp	
cmp dl, 045H		;Verifica se é maior que 045H (E em ASCII) pois se for deve ser uma minuscula, ou está fora dos limites
JG  minuscula		

maiuscula:
cmp dl, 042H
jz por_baixo
cmp dl, 043H
jz por_cima
cmp dl, 044H
jz pela_direita
jmp pela_esquerda

escolhe_o_que_faz_jmp:
jmp escolhe_o_que_faz

erro_direcao_jmp:
jmp erro_direcao

por_baixo:
mov cl, coord_l
cmp cl, 7
jz dir_aceita
jmp erro_dir_2jmp
por_cima:
mov cl, coord_l
cmp cl, 0
jz dir_aceita
jmp erro_dir_2jmp
pela_direita:
mov cl, coord_c
cmp cl, 7
jz dir_aceita
jmp erro_dir_2jmp
pela_esquerda:
mov cl, coord_c
cmp cl, 0
jz dir_aceita
erro_dir_2jmp:
jmp erro_dir_2m

minuscula:
cmp dl, 062H
JL erro_direcao
cmp dl, 065H
JG erro_direcao
SUB dl, 32		;Passa de minuscula para maiuscula
mov al, dl
mov direcao, dl
jmp maiuscula

erro_dir_2m:
call limpa_ultima_linha		
mov ah, 2		;defini a posição do cursor
mov dh, 24		;linha 
mov dl, 1		;coluna
mov bh, 0		;página 0
int 10h
lea dx, erro_dir_2	
mov ah, 9
int 21h
jmp direcao_entrada



dir_aceita:
mov direcao, 0
mov ah, 2		;Imprime o caracter na tela
int 21h
mov direcao, al
mov dir_ent, al
mov estado, 1		;move o valor um para estado, de modo a verificar se um caracter (máximo) já foi digitado na área
inc coluna
call limpa_ultima_linha
jmp direcao_coordenada_1



erro_direcao:		;Mensagem para caso o caracter digitado para direcao não esteja
			;entre 'b' e 'e'
call limpa_ultima_linha
mov ah, 2		;defini a posição do cursor
mov dh, 24		;linha 
mov dl, 1		;coluna
mov bh, 0		;página 0
int 10h
lea dx, erro_dir	
mov ah, 9
int 21h
jmp direcao_entrada






;AH=mais significativo
;AL=menos significativo


;----------------------------------------------------------------------------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------------------------------------------------------------------
Escolhe_o_que_faz:
cmp com, 'R'
jz roda_jogo
cmp com, 'r'
jz roda_jogo
;Se não for para inserir, continua, pois será para remover ou posicionar atomo apenas
 
CALCULA_COORD_P_POSICIONA_E_REMOVE:
mov cl, coord_l
mov ch, coord_c
SHL cl, 1
ADD cl, 5 		;Linha atualizada para o prompt
mov ah, ch
ADD ch, ah
ADD ch, ah
ADD ch, ah
ADD ch, ah
ADD ch, 11


lea di, matriz_j
mov ah, 0
mov al, coord_c
ADD di, ax
mov al, coord_l
mov dl, 10
MUL dl
ADD di, ax

cmp com, 'D'
jz remove_atomo
cmp com, 'd'
jz remove_atomo

posiciona_atomo:
mov ah, 2		;defini a posição do cursor
mov dh, cl		;linha 
mov dl, ch		;coluna
mov bh, 0		;página 0
int 10h
mov dl, 'O'
mov ah, 2		;Imprime o caracter na tela
int 21h
mov dl, 49
mov [di], dl
jmp limpa_campos

remove_atomo:
mov ah, 2		;defini a posição do cursor
mov dh, cl		;linha 
mov dl, ch		;coluna
mov bh, 0		;página 0
int 10h
mov dl, null
mov ah, 2		;Imprime o caracter na tela
int 21h
mov dl, 48
mov [di], dl
jmp limpa_campos






jmp fim



Roda_jogo:
soma_e_mostra_contador:	;TENTATIVAS
mov ah, 0 		;Transforma a parte mais significativa de ax em 0, para que apenas o al valha
			;permitindo que o contador tenha seu valor real
ADD contador_2, 1
mov al, contador_2
mov dh, 10
DIV dh			;Divide o contador por dez, para poder imprimi-lo, sem confusão com código ASCII  -  AL = resultado inteiro / AH = resto
mov ch, ah
mov cl, al
mov ah, 2		;defini a posição do cursor
mov dh, 3		;linha 
mov dl, 71		;coluna
mov bh, 0		;página 0
int 10h
mov dl, cl
ADD dl, 48
mov ah, 2		;Imprime o caracter na tela
int 21h
mov ah, 2		;defini a posição do cursor
mov dh, 3		;linha 
mov dl, 72		;coluna
mov bh, 0		;página 0
int 10h
mov dl, ch
ADD dl, 48
mov ah, 2		;Imprime o caracter na tela
int 21h



mov var1, 0
mov estado, 0
mov al, coord_c
mov coluna, al
mov al, coord_l
mov linha, al


calcula_lxc:
lea di, matriz_o
mov al, coord_l
mov ch, 10
MUL ch
ADD di, ax
mov al, coord_c
ADD di, ax		;di guarda a posição de entrada na matriz. di = 10xlinha + coluna
mov lxc, di
mov cl, 49
mov ch, 48

rodando:
mov di, lxc
mov dl, [di]
cmp dl, ch
jnz absorvido_jmp_2
cmp direcao, 'B'
jz baixo_cima_jmp
cmp direcao, 'C'
jz cima_baixo
cmp direcao, 'D'
jz direita_esquerda_jmp
jmp esquerda_direita

absorvido_jmp_2:
jmp absorvido

baixo_cima_jmp:
jmp baixo_cima

direita_esquerda_jmp:
jmp direita_esquerda

saiu_jmp:
jmp saiu

cima_baixo:
	cmp var1, 1
	jz ta_dentro_cb	
	mov var1, 1
	cmp coluna, 0
	jz col_7_cb
	SUB di, 1
	mov dl, [di]
	cmp dl, cl
	jz refletido_jmp_2
	ADD di, 1
col_7_cb:
	cmp coluna, 7
	jz ta_dentro_cb
	ADD di, 1
	mov dl, [di]
	cmp dl, cl
	jz refletido_jmp_2
col_cb:
	SUB di, 1
ta_dentro_cb: 
	cmp linha, 7
	jz saiu_jmp
	ADD di, 10
	mov dl, [di]
	cmp dl, cl
	jz absorvido_jmp_2
	SUB di, 10
cima_baixo_diag_esquerda:
	ADD di, 9
	cmp coluna, 0
	jz cima_baixo_diag_direita
	mov dl, [di]
	cmp dl, ch		;compara com zero = ch
	jz cima_baixo_diag_direita
	mov direcao, 045H	;DIR = E --->
cima_baixo_diag_direita:
	SUB di, 9
	cmp coluna, 7
	jz segue_jmp_2	
	ADD di, 11
	mov dl, [di]
	cmp dl, ch
	jz segue_jmp_2
	cmp direcao, 045H
	jz muda_p_baixo_cima
	mov direcao, 044H
	jmp segue_jmp_2
muda_p_baixo_cima:
	mov direcao, 042H
	jmp segue_jmp

segue_jmp_2:
jmp segue

refletido_jmp_2:
jmp refletido

saiu_jmp_3:
jmp saiu

direita_esquerda:		;D = <----------
ta_entrando_de:			;Esta primeira parte (enquanto var1 = 0) testa as casas para a entrada do raio.
				;Ela testa três casas, a própria da entrada, e as adjacentes a essa.	
	cmp var1, 1
	jz ta_dentro_de	
	mov var1, 1
	cmp linha, 0		;Se a linha for 0, não se pode testar a casa de cima, pois ela "não existe"
	jz lin_7_de
	SUB di, 10
	mov dl, [di]
	cmp dl, cl
	jz refletido_jmp_2
	ADD di, 10
lin_7_de:
	cmp linha, 7		;Se a linha for 0, não se pode testar a casa de baixo, pois ela "não existe"
	jz ta_dentro_de
	ADD di, 10
	mov dl, [di]
	cmp dl, cl
	jz refletido_jmp_2
lin_de:
	SUB di, 10
ta_dentro_de: 
	cmp coluna, 0
	jz saiu_jmp_3
	SUB di, 1
	mov dl, [di]
	cmp dl, cl
	jz absorvido_jmp_3
	ADD di, 1
direita_esquerda_diag_cima:
	SUB di, 11
	cmp linha, 0
	jz direita_esquerda_diag_baixo
	mov dl, [di]
	cmp dl, ch		;compara com zero = ch
	jz direita_esquerda_diag_baixo
	mov direcao, 043H	;DIR = C
direita_esquerda_diag_baixo:
	ADD di, 11
	cmp linha, 7
	jz segue_jmp_2	
	ADD di, 9
	mov dl, [di]
	cmp dl, ch
	jz segue_jmp_2
	cmp direcao, 043H
	jz muda_p_esquerda_direita
	mov direcao, 042H
	jmp segue_jmp
muda_p_esquerda_direita:
	mov direcao, 045H
	jmp segue_jmp

absorvido_jmp_3:
jmp absorvido


esquerda_direita:		;E = ---------->
ta_entrando_ed:			;Esta primeira parte (enquanto var1 = 0) testa as casas para a entrada do raio.
				;Ela testa três casas, a própria da entrada, e as adjacentes a essa.	
	cmp var1, 1
	jz ta_dentro_ed	
	mov var1, 1
	cmp linha, 0		;Se a linha for 0, não se pode testar a casa de cima, pois ela "não existe"
	jz lin_7_ed
	SUB di, 10
	mov dl, [di]
	cmp dl, cl
	jz refletido_jmp
	ADD di, 10
lin_7_ed:
	cmp linha, 7		;Se a linha for 7, não se pode testar a casa de baixo, pois ela "não existe"
	jz ta_dentro_ed
	ADD di, 10
	mov dl, [di]
	cmp dl, cl
	jz refletido_jmp
lin_ed:
	SUB di, 10
ta_dentro_ed: 
	cmp coluna, 7
	jz saiu_jmp_2
	ADD di, 1
	mov dl, [di]
	cmp dl, cl
	jz absorvido_jmp
	SUB di, 1
esquerda_direita_diag_cima:
	SUB di, 9
	cmp linha, 0
	jz esquerda_direita_diag_baixo
	mov dl, [di]
	cmp dl, ch		;compara com zero = ch
	jz esquerda_direita_diag_baixo
	mov direcao, 043H	;DIR = C
esquerda_direita_diag_baixo:
	ADD di, 9
	cmp linha, 7
	jz segue_jmp	
	ADD di, 11
	mov dl, [di]
	cmp dl, ch
	jz segue_jmp
	cmp direcao, 043H
	jz muda_p_direita_esquerda
	mov direcao, 042H
	jmp segue_jmp
muda_p_direita_esquerda:
	mov direcao, 044H
	jmp segue_jmp



absorvido_jmp:
jmp absorvido
jmp fim
segue_jmp:
jmp segue
refletido_jmp:
jmp refletido

saiu_jmp_2:
jmp saiu


baixo_cima:		;B
ta_entrando_bc:			;Esta primeira parte (enquanto var1 = 0) testa as casas para a entrada do raio
				;ela testa três casas, a própria da entrada, e as adjacentes a essa.
	;mov cx, di
	cmp var1, 1
	jz ta_dentro_bc
	mov var1, 1
	cmp coluna, 0		;No caso da coluna ser 0, não se pode testar a casa da esquerda (pois logicamente ela não existe)
	jz col_7_bc
	SUB di, 1
	mov dl, [di]
	cmp dl, cl
	jz refletido_jmp
	ADD di, 1
col_7_bc:
	cmp coluna, 7		;E se a coluna for 7, também não podemos testar a casa da direita
	jz ta_dentro_bc
	ADD di, 1
	mov dl, [di]
	cmp dl, cl
	jz refletido_jmp
col_bc:
	SUB di, 1
ta_dentro_bc: 
	cmp linha, 0
	jz saiu_jmp_2
	SUB di, 10
	mov dl, [di]
	cmp dl, cl
	jz absorvido_jmp
	ADD di, 10
baixo_cima_diag_esquerda:
	SUB di, 11
	cmp coluna, 0
	jz baixo_cima_diag_direita
	mov dl, [di]
	cmp dl, ch
	jz baixo_cima_diag_direita	
	mov direcao, 045H
baixo_cima_diag_direita:
	ADD di, 11
	cmp coluna, 7
	jz segue
	SUB di, 9
	mov dl, [di]
	cmp dl, ch
	jz segue
	cmp direcao, 045H
	jz muda_p_cima_baixo
	mov direcao, 044H
	jmp segue
muda_p_cima_baixo:
	mov direcao, 043H
	jmp segue
	
	
	 	

saiu_jmp_1:
jmp saiu


segue:

segue_baixo_cima:
	cmp direcao, 042H
	jnz segue_cima_baixo
	cmp linha, 0 
	jz saiu_jmp_1
	SUB linha, 1
	SUB lxc, 10
	jmp rodando
segue_cima_baixo:
	cmp direcao, 043H
	jnz segue_direita_esquerda
	cmp linha, 7
	jz saiu_jmp_1
	ADD linha, 1
	ADD lxc, 10
	jmp rodando
segue_direita_esquerda:
	cmp direcao, 044H
	jnz segue_esquerda_direita
	cmp coluna, 0
	jz saiu_jmp_1
	SUB coluna, 1
	SUB lxc, 1
	jmp rodando
segue_esquerda_direita:
	cmp coluna, 7
	jz saiu_jmp_1
	ADD coluna, 1
	ADD lxc, 1
	jmp rodando



absorvido:
mov cl, coord_l
mov ch, coord_c
mov bh, dir_ent
call verifica_colchete_p_escrita
mov ah, 2		;defini a posição do cursor
mov dh, cl		;linha 
mov dl, ch		;coluna
mov bh, 0		;página 0
int 10h
mov dl, 65
mov ah, 2		;Imprime o caracter na tela
int 21h

call limpa_ultima_linha
mov ah, 2		;defini a posição do cursor
mov dh, 24		;linha 
mov dl, 1		;coluna
mov bh, 0		;página 0
int 10h
lea dx, absorvido_m	
mov ah, 9
int 21h
mov dl, coord_l
ADD dl, 48
mov ah, 2		;Imprime o caracter na tela
int 21h
mov dl, 120		; 'x'
mov ah, 2		;Imprime o caracter na tela
int 21h	
mov dl, coord_c
ADD dl, 48
mov ah, 2		;Imprime o caracter na tela
int 21h	
mov dl, 46
int 21h
call espera_tecla
jmp limpa_campos
	



refletido:
mov cl, coord_l
mov ch, coord_c
mov bh, dir_ent
call verifica_colchete_p_escrita
mov ah, 2		;defini a posição do cursor
mov dh, cl		;linha 
mov dl, ch		;coluna
mov bh, 0		;página 0
int 10h
mov dl, 82
mov ah, 2		;Imprime o caracter na tela
int 21h

call limpa_ultima_linha
mov ah, 2		;defini a posição do cursor
mov dh, 24		;linha 
mov dl, 1		;coluna
mov bh, 0		;página 0
int 10h
lea dx, refletido_m	
mov ah, 9
int 21h
mov dl, linha
ADD dl, 48
mov ah, 2		;Imprime o caracter na tela
int 21h
mov dl, 120		; 'x'
mov ah, 2		;Imprime o caracter na tela
int 21h	
mov dl, coluna
ADD dl, 48
mov ah, 2		;Imprime o caracter na tela
int 21h	
mov dl, 46
int 21h
call espera_tecla
jmp limpa_campos
	
	
saiu:
mov al, coord_c
cmp al, coluna
jnz saiu_mesmo
mov al, coord_l
cmp al, linha
jz refletido

saiu_mesmo:
inc contador	
call limpa_ultima_linha

mov cl, linha
mov ch, coluna
mov bh, direcao		;Por onde saiu
call verifica_colchete_p_escrita
		;cl = linha
		;ch = coluna	
	;numercação (i)
mov ah, 0 		;Transforma a parte mais significativa de ax em 0, para que apenas o al valha
			;permitindo que o contador tenha seu valor real
mov al, contador
mov dh, 10
DIV dh			;Divide o contador por dez, para poder imprimi-lo, sem confusão com código ASCII  -  AL = resultado inteiro / AH = resto

mov dh, cl
mov bl, ch
mov dl, ch
mov var2, ah
mov var1, al
mov ah, 2		;defini a posição do cursor
mov bh, 0		;página 0
int 10h
mov dl, var2		;imprime o resto
ADD dl, 48
mov ah, 2		;Imprime o caracter na tela
int 21h
cmp var1, 0
jz escreve_onde_entrou
dec bl
mov ah, 2		;defini a posição do cursor 
mov dl, bl		;coluna
mov bh, 0		;página 0
int 10h
mov dl, ch
ADD dl, 48
mov ah, 2		;Imprime o caracter na tela
int 21h


escreve_onde_entrou:
mov cl, coord_l
mov ch, coord_c
mov bh, dir_ent		;Por onde entrou
call verifica_colchete_p_escrita
	
	;numercação (i)
mov ah, 0 		;Transforma a parte mais significativa de ax em 0, para que apenas o al valha
			;permitindo que o contador tenha seu valor real
mov al, contador
mov dh, 10
DIV dh			;Divide o contador por dez, para poder imprimi-lo, sem confusão com código ASCII  -  AL = resultado inteiro / AH = resto

mov dh, cl
mov bl, ch
mov dl, ch
mov cl, ah
mov ch, al
mov ah, 2		;defini a posição do cursor
mov bh, 0		;página 0
int 10h
mov dl, cl		;imprime o resto
ADD dl, 48
mov ah, 2		;Imprime o caracter na tela
int 21h
cmp ch, 0
jz nao_tem_dezena_1
dec bl
mov ah, 2		;defini a posição do cursor 
mov dl, bl		;coluna
mov bh, 0		;página 0
int 10h
mov dl, ch
ADD dl, 48
mov ah, 2		;Imprime o caracter na tela
int 21h


nao_tem_dezena_1:
saiu_mesg:
mov ah, 2		;defini a posição do cursor
mov dh, 24		;linha 
mov dl, 1		;coluna
mov bh, 0		;página 0
int 10h
lea dx, saiu_m	
mov ah, 9
int 21h
mov dl, linha
ADD dl, 48
mov ah, 2		;Imprime o caracter na tela
int 21h
mov dl, 120		; 'x'
mov ah, 2		;Imprime o caracter na tela
int 21h	
mov dl, coluna
ADD dl, 48
mov ah, 2		;Imprime o caracter na tela
int 21h
mov dl, 46
int 21h
call espera_tecla
jmp limpa_campos




		;OO = acertou
		;OX = atomo nao posicionado
		;xO = atomo posicionado incorretamente

encerrar:
mov encerrado, 1	;Indica que o jogo já foi encerrado
mov var1, 0
mov cl, 0 	;linha
mov ch, 0	;coluna
mov linha, 0
mov coluna, 0
mov bl, 49
lea di, matriz_o
lea si, matriz_j

verifica_atomos_1:
mov cl, linha
mov ch, coluna
SHL cl, 1
ADD cl, 5 		;Linha atualizada para o prompt
mov ah, ch
ADD ch, ah
ADD ch, ah
ADD ch, ah
ADD ch, ah
ADD ch, 10
mov coord_l, cl
mov coord_c, ch

verifica_atomos:
	call limpa_ultima_linha

	mov al, [di]	
	cmp [si], al
	jz posicao_correta_1
posicao_incorreta:
	mov var1, 1		;Indica que houve ao menos um erro
	cmp [si], bl		;Caso o usuario (matriz_j) tenha colocado um atomo no local errado
	jnz atomo_nao_posto	
	mov ah, 2		;defini a posição do cursor
	mov dh, coord_l		;linha 
	mov dl, coord_c		;coluna
	mov bh, 0		;página 0
	int 10h
	mov dl, 'X'		; 'XO'
	mov ah, 2		;Imprime o caracter na tela
	int 21h	
	mov dl, 'O'
	int 21h
	ADD pontos, 5
	jmp continua_atomos
posicao_correta_1:
jmp posicao_correta

atomo_nao_posto:
	mov ah, 2		;defini a posição do cursor
	mov dh, coord_l		;linha 
	mov dl, coord_c		;coluna
	mov bh, 0		;página 0
	int 10h
	mov dl, 'O'
	mov ah, 2		;Imprime o caracter na tela
	int 21h	
	mov dl, 'X'
	int 21h
	jmp continua_atomos
posicao_correta:
	cmp [si], bl
	jnz continua_atomos	;Caso nao tenha atomo, apenas continua
	mov ah, 2		;defini a posição do cursor
	mov dh, coord_l		;linha 
	mov dl, coord_c		;coluna
	mov bh, 0		;página 0
	int 10h
	mov dl, 'O'
	mov ah, 2		;Imprime o caracter na tela
	int 21h	
	mov dl, 'O'
	int 21h
continua_atomos:
	ADD coluna, 1
	ADD di, 1
	ADD si, 1
	cmp coluna, 8
	jz continua_atomos_1
	jmp verifica_atomos_1
continua_atomos_1:
	mov coluna, 0
	ADD linha, 1
	cmp linha, 8
	jz terminou_matriz
	ADD di, 2
	ADD si, 2
	jmp verifica_atomos_1

terminou_matriz:
;Da os pontos...
	mov ah, contador_2
	ADD pontos, ah
	mov ah, 0 		;Transforma a parte mais significativa de ax em 0, para que apenas o al valha
			;permitindo que o contador tenha seu valor real
	mov al, pontos
	mov dh, 10
	DIV dh			;Divide o contador por dez, para poder imprimi-lo, sem confusão com código ASCII  -  AL = resultado inteiro / AH = resto
	mov ch, ah
	mov cl, al
	mov ah, 2		;defini a posição do cursor
	mov dh, 24		;linha 
	mov dl, 1		;coluna
	mov bh, 0		;página 0
	int 10h	
	cmp var1, 1
	jnz acertou_tudo
errou_algo:
	lea dx, pont_erro
	mov ah, 9
	int 21h
	jmp imprime_pontos
acertou_tudo:
	lea dx, pont_Certo
	mov ah, 9
	int 21h
imprime_pontos:
	mov dl, cl		;imprime a parte inteira
	ADD dl, 48
	mov ah, 2		;Imprime o caracter na tela
	int 21h	
	mov dl, ch		;imprime o resto
	ADD dl, 48
	mov ah, 2		;Imprime o caracter na tela
	int 21h	
	call espera_tecla
	jmp limpa_campos	
	
		

novo:			;novo jogo


Limpa_campos_1:
mov com, 0
mov estado, 0
mov var1, 0
mov contador_2, 0
mov contador, 0
mov pontos, 0
mov coord_c, 0
mov coord_l, 0
mov coluna, 0
mov linha, 0


apaga_nome_2:
lea di, nome
mov dx, 14
cont_apagar_nome_2:
mov ax, null
mov [di], ax
inc di
dec dx
cmp dx, 1
jnz cont_apagar_nome_2


jmp comeca_o_jogo


mov ah, 2		;defini a posição do cursor
mov dh, 3		;linha 
mov dl, 71		;coluna
mov bh, 0		;página 0
int 10h
mov dl, null
mov ah, 2		;Imprime o caracter na tela
int 21h
mov ah, 2		;defini a posição do cursor
mov dh, 3		;linha 
mov dl, 72		;coluna
mov bh, 0		;página 0
int 10h
mov dl, null
mov ah, 2		;Imprime o caracter na tela
int 21h

;limpa campo do comando:
mov dh, 5		;linha
mov dl, 68		;coluna
call limpa_campo

;limpa campo da linha:
mov dh, 15		;linha
mov dl, 72		;coluna
call limpa_campo


;limpa campo da coluna:
mov dh, 16		;linha
mov dl, 72		;coluna
call limpa_campo

;limpa campo da direcao:
mov dh, 17		;linha
mov dl, 72		;coluna
call limpa_campo	
	



fim:
	mov ah, 6
	mov al, 25
	mov bh, 7h 		;fundo preto e letra branca
	mov ch, 0
	mov cl, 0
	mov dh, 24
	mov dl, 79
	int 10h
	
	mov ah, 2		;defini a posição do cursor
	mov dh, 0		;linha 
	mov dl, 0		;coluna
	mov bh, 0		;página 0
	int 10h
	

	
         mov    ax,4c00h           ; funcao retornar ao DOS no AH
         int    21h                ; chamada do DOS















;SUBROTINAS:

verifica_colchete_p_escrita proc
cmp cl, 0
jnz para_entrada_1
cmp ch, 0
jnz para_entrada_2
cmp bh, 'D'
jz para_entrada_3
cmp bh, 'E'
jz para_entrada_3
mov cl, 2
mov ch, 11
ret
para_entrada_1:
cmp cl, 7
jnz para_entrada_6
cmp ch, 0
jnz para_entrada_7
cmp bh, 'C'
jz para_entrada_8
cmp bh, 'B'
jz para_entrada_8
mov cl, 19
mov ch, 3
ret
para_entrada_8:
mov cl, 22
mov ch, 11
ret
para_entrada_7:
cmp ch, 7
jnz para_entrada_9
cmp bh, 'C'
jz para_entrada_10
cmp bh, 'B'
jz para_entrada_10
mov cl, 19
mov ch, 54
ret
para_entrada_9:
mov cl, 22
mov ah, ch
ADD ch, ah
ADD ch, ah
ADD ch, ah
ADD ch, ah
ADD ch, 11
ret
para_entrada_10:
mov cl, 22
mov ch, 46
ret
para_entrada_6:
SHL cl, 1
ADD cl, 5
cmp ch, 0
jnz para_entrada_11
mov ch, 3
ret
para_entrada_11:
mov ch, 54
ret
para_entrada_2:
cmp ch, 7
jnz para_entrada_4
cmp bh, 'E'
jz para_entrada_5
cmp bh, 'D'
jz para_entrada_5
mov cl, 2
mov ch, 46
ret
para_entrada_3:
mov cl, 5
mov ch, 3
ret
para_entrada_4:
mov cl, 2
mov ah, ch
ADD ch, ah
ADD ch, ah
ADD ch, ah
ADD ch, ah
ADD ch, 11
ret
para_entrada_5:
mov cl, 5
mov ch, 54
ret
verifica_colchete_p_escrita endp






limpa_campo proc
mov ah, 2		;defini a posição do cursor sendo que dh e dl já estão inicializados
mov bh, 0		;página 0
int 10h
mov dl, null		;Imprime o caracter nulo na tela	    
mov ah, 2
int 21h
ret
limpa_campo endp


espera_tecla proc
mov ah,0
int 16h
mov ah, 1
int 16h
jnz espera_tecla	;se nada foi pressionado, volta
cmp al, CR		;Compara a tecla pressionada (al) com CR
jnz t_bspace
mov cx, CR		;Passa para o cx o valor de CR, ou seja, 'enter'
ret
t_bspace: 
cmp al, 08H		;Verifica se a telca pressionada é BS
jnz t_ret
mov cx, BS		;Passa para o cx o valor de BS, ou seja, 'backspace'
t_ret:
Ret			;Retorno da subrotina
espera_tecla endp


backspace proc 
mov dh, coluna
cmp lim_col, dh
jnz bs_cont
ret
bs_cont:
dec coluna

dec di

mov ah, 2		;defini a posição do cursor
mov dh, linha		;linha 24
mov dl, coluna		;coluna 1
mov bh, 0		;página 0
int 10h
mov dl, null
int 21h

mov ah, 2		;defini a posição do cursor
mov dh, linha		;linha 24
mov dl, coluna		;coluna 1
mov bh, 0		;página 0
int 10h

mov al, null
mov [di], al



ret

backspace endp


limpa_ultima_linha proc
mov ah, 6		;Limpar qualquer mensagem de erro que tenha sido colocada por tecla pressionada fora do limite (0 a 7)
mov al, 1
mov bh, 7h 		;fundo preto e letra branca
mov ch, 24
mov cl, 0
mov dh, 24
mov dl, 79
int 10h
ret
limpa_ultima_linha endp









codigo ends
	end inicio
