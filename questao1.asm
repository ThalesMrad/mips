.data 
 
 msg1: .asciiz "\nDigite quantas termos para calcular o PI deseja: " 
 msg2: .asciiz "\nO valor de PI é: "
 	.text
 	.globl main
 	
 main:
 	li $v0, 4		#imprime a mensagem 1
 	la $a0, msg1
 	syscall
 	
 	li $v0, 5		#le um inteiro
 	syscall
 	add $a0, $v0, $zero	#guarda valor lido no $a0 (parametro do procedimento)
	
	jal CalculaPi		#chama procedimento que calcula o pi
	
	li $v0, 4 
	la $a0, msg2		#imprime mensagem 2
	syscall
	li $v0, 2		#imprime valor aproximado de pi ($f12)
 	syscall	
 	j exit			#jump para o fim do programa
 	
 CalculaPi:

 	li $s1, 1		#contador de termos
 	li $s2, 1		#denominador das divisões 
 	li $s3, 4		#constante do numerador
 	li $s4, 2		#constante para descobrir se o s1 é par ou impar 	
 loop: 	
 	slt $t0, $a0, $s1	# quantidade de termos < contador ?
 	bne $t0, $zero, return	# se 1, desvia para o retorno da função
	rem $t0, $s1, $s4	# resto da divisão para verificar se o termo é par ou impar
 	mtc1 $s3,$f1		#converte inteiro para float e salva em f1
 	mtc1 $s2,$f2		#converte inteiro para float e salva em f2
 	div.s $f1, $f1, $f2	#divide a constante 4 por um numero impar
 	beq $t0, $zero, par	#se s1 for par, pula pra label par
 	add.s $f12,$f12,$f1	#soma ao valor de pi o resultado da divisão ($f12 é o argumento syscall para impressão de float) 
 	j incremento
 	
 par:
 	
 	sub.s $f12,$f12,$f1	#subtrai ao valor de pi o resultado da divisão

  incremento:
	add $s1, $s1, 1		#incrementa 1 ao contador
 	add $s2, $s2, 2		#incrementa 2 ao denominador das diviões (é sempre impar)
 	j loop

 return: 
 	jr $ra			#retorna o controle pra main
 	
 exit:
	li $v0, 10		#termino de execução
	syscall
