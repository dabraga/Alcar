#INCLUDE "PROTHEUS.CH"


/*
������������������������������������������������������������������������������������
������������������������������������������������������������������������������������
��������������������������������������������������������������������������������ͻ��
���Classe    �   ALFATA01      �Autor  �Alexandre Cosnelvan � Data �  16/09/13   ���
��������������������������������������������������������������������������������͹��
���Desc.     �Rotina que monta a descri��o do produto ( SB1->B1_DESC )           ���
��������������������������������������������������������������������������������͹��
���Uso       � A fun��o e disparada no campo de valida��o do usuario no SX3, dos ���
���          � campos descrito abaixo:                                    		 ���
���          � 	B1_ZZTIPO	-> ExecBlock("ALFATA01",.F.,.F.)                		 ���
���          � 	B1_ZZDIAM	-> ExecBlock("ALFATA01",.F.,.F.)                		 ���
���          � 	B1_ZZESP  	-> ExecBlock("ALFATA01",.F.,.F.)                		 ���
���          � 	B1_ZZFURO 	-> ExecBlock("ALFATA01",.F.,.F.)                		 ���
���          � 	B1_ZZGRAO 	-> ExecBlock("ALFATA01",.F.,.F.)                		 ���
���          � 	B1_ZZDUR  	-> ExecBlock("ALFATA01",.F.,.F.)                		 ���
���          � 	B1_ZZLIGA 	-> ExecBlock("ALFATA01",.F.,.F.)                		 ���
���          �   	B1_ZZMC   	-> ExecBlock("ALFATA01",.F.,.F.)                		 ���
���          � Caso o cliente deseje implementar novos campos dever� ter a chama-���
���          � da acima � no arry do programa o campo e sua regra.              	 ���
��������������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������������
������������������������������������������������������������������������������������
*/


User Function ALFATA01()			
/*
User Function ALFATA01()
              |  | |  |-> 2 Digitos ( Sequencia numerico da fun��o ( 01 ) ) 
              |  | |-> 1 Digito ( indicativo do tipo da Rotina ( A- Atualiza��o, R-Relatorio, Etc..) )
              |  |-> 3 Digitos ( indicativo do Modulo do protheus que a rotina e executada ( FAT - Faturamento ) ) 
              |-> 2 Digitos ( Indicativo do nome da Empresa ( AL - Alcar ) )
*/				         

&& VAriaveis Locais
Local _aCpoDes	:= {}
Local nk		:= 1   
Local _nLiga	:= 7
Local aAreaSx3	:= SX3->(GetArea())			// Salva a area do SX3

&& Verifica se os campos principais est�o preeenchidos:
&& Onde no Array temos as seguintes informa��es:
&& Posi��o 1 -> Nome do Campo a ser processado pela montagem da descri��o.
&& Posi��o 2 -> Qual a rega do espa�amento dda esquerda de cada campo.
&&   P.S. -> Quando temos o "Z", � indicativo que n�o temos espa�o em branco a esquerda, 
&&           com exe��o da liga que trabalha em conjunto com a Dureza , onde em algumas 
&&           Situa��es poderemos n�o ter a dureza ai deveremos tratar a regra da anterior.

dbSelectArea("SX3")
dbSetOrder(2)
If dbSeek("B1_ZZTIPO")
	If !Empty(Alltrim(GetSX3Cache("B1_ZZTIPO", "X3_VLDUSER")/*SX3->X3_VLDUSER*/))
		AADD(_aCpoDes,{M->B1_ZZTIPO	,"Z"})
	Endif
Endif
		
dbSelectArea("SX3")
dbSetOrder(2)
If dbSeek("B1_ZZDIAM")
	If !Empty(Alltrim(GetSX3Cache("B1_ZZDIAM", "X3_VLDUSER")/*SX3->X3_VLDUSER*/))
		AADD(_aCpoDes,{M->B1_ZZDIAM	," "})
	Endif
Endif

dbSelectArea("SX3")
dbSetOrder(2)
If dbSeek("B1_ZZESP")
	If !Empty(Alltrim(GetSX3Cache("B1_ZZESP", "X3_VLDUSER")/*SX3->X3_VLDUSER*/))
		AADD(_aCpoDes,{M->B1_ZZESP	,"x"})
	Endif
Endif

dbSelectArea("SX3")
dbSetOrder(2)
If dbSeek("B1_ZZFURO")
	If !Empty(Alltrim(GetSX3Cache("B1_ZZFURO", "X3_VLDUSER")/*SX3->X3_VLDUSER*/))
		AADD(_aCpoDes,{M->B1_ZZFURO	,"x"})
	Endif
Endif

dbSelectArea("SX3")
dbSetOrder(2)
If dbSeek("B1_ZZGRAO")
	If !Empty(Alltrim(GetSX3Cache("B1_ZZGRAO", "X3_VLDUSER")/*SX3->X3_VLDUSER*/))
		AADD(_aCpoDes,{M->B1_ZZGRAO	," "})
	Endif
Endif

dbSelectArea("SX3")
dbSetOrder(2)
If dbSeek("B1_ZZDUR")
	If !Empty(Alltrim(GetSX3Cache("B1_ZZDUR", "X3_VLDUSER")/*SX3->X3_VLDUSER*/))
		AADD(_aCpoDes,{M->B1_ZZDUR	," "})
	Endif
Endif

dbSelectArea("SX3")
dbSetOrder(2)
If dbSeek("B1_ZZLIGA")
	If !Empty(Alltrim(GetSX3Cache("B1_ZZLIGA", "X3_VLDUSER")/*SX3->X3_VLDUSER*/))
		AADD(_aCpoDes,{M->B1_ZZLIGA	,"Z"})
		_nLiga := Len(_aCpoDes)
	Endif
Endif

dbSelectArea("SX3")
dbSetOrder(2)
If dbSeek("B1_ZZMC")
	If !Empty(Alltrim(GetSX3Cache("B1_ZZMC", "X3_VLDUSER")/*SX3->X3_VLDUSER*/))
		AADD(_aCpoDes,{M->B1_ZZMC	," "})
	Endif
Endif

&& restaura a area da Tabela SX3
RestArea(aAreaSx3)

&& Limpa o campo de Descri��o.
M->B1_DESC := Space(Len(SB1->B1_DESC))

&& For que efetua a leitura de cada campo que esta no array emonta a descri��o do produto.
For nk := 1 To Len(_aCpoDes)
	&& VErifica se o campo esta vazio se sim n�o processa
	IF !Empty(Alltrim((_aCpoDes[nk][1])))
		&& Verifica se a rega � igual a "Z"
		If (_aCpoDes[nk][2]) = "Z"
			&& Verifica se estamos processando a Liga
			If nk = _nLiga
				&& Estamos processando a Liga , assim sendo , deveremos verificar a Dureza se a mesma 
				&& Esta preenchida.
				IF Empty(Alltrim((_aCpoDes[nk-1][1])))
					&& O campo de dureza esta vazio processamos a regra da dureza no item Liga
					M->B1_DESC += (_aCpoDes[nk-1][2]) + Alltrim((_aCpoDes[nk][1]))
				Else
					&& O Campo de dureza esta preenchido processamos a regra da Liga.
					M->B1_DESC += Alltrim((_aCpoDes[nk][1]))
				Endif
			Else
				&& Quando for diferente da pois��o de liga processamso a regra normal, sendo esta a 
				&& primeira posi��o do Array que � o Tipo ( Familia ).
				M->B1_DESC += Alltrim((_aCpoDes[nk][1]))
			Endif	
		Else
			&& Processamos a regra normal de montagem da descri��o
			M->B1_DESC += (_aCpoDes[nk][2]) + Alltrim((_aCpoDes[nk][1]))
		Endif	
	Endif
Next

&& Retiramos todos os espa�os em branco da descri��o.
If !Empty(Alltrim(M->B1_DESC)) 
	M->B1_DESC := Alltrim(M->B1_DESC)
Else
	M->B1_DESC := Space(Len(SB1->B1_DESC))
Endif	

&& Retorno sempre verdadeiro
Return(.T.)