#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºClasse    ³   ALFATA01      ºAutor  ³Alexandre Cosnelvan º Data ³  16/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina que monta a descrição do produto ( SB1->B1_DESC )           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ A função e disparada no campo de validação do usuario no SX3, dos º±±
±±º          ³ campos descrito abaixo:                                    		 º±±
±±º          ³ 	B1_ZZTIPO	-> ExecBlock("ALFATA01",.F.,.F.)                		 º±±
±±º          ³ 	B1_ZZDIAM	-> ExecBlock("ALFATA01",.F.,.F.)                		 º±±
±±º          ³ 	B1_ZZESP  	-> ExecBlock("ALFATA01",.F.,.F.)                		 º±±
±±º          ³ 	B1_ZZFURO 	-> ExecBlock("ALFATA01",.F.,.F.)                		 º±±
±±º          ³ 	B1_ZZGRAO 	-> ExecBlock("ALFATA01",.F.,.F.)                		 º±±
±±º          ³ 	B1_ZZDUR  	-> ExecBlock("ALFATA01",.F.,.F.)                		 º±±
±±º          ³ 	B1_ZZLIGA 	-> ExecBlock("ALFATA01",.F.,.F.)                		 º±±
±±º          ³   	B1_ZZMC   	-> ExecBlock("ALFATA01",.F.,.F.)                		 º±±
±±º          ³ Caso o cliente deseje implementar novos campos deverá ter a chama-º±±
±±º          ³ da acima é no arry do programa o campo e sua regra.              	 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function ALFATA01()			
/*
User Function ALFATA01()
              |  | |  |-> 2 Digitos ( Sequencia numerico da função ( 01 ) ) 
              |  | |-> 1 Digito ( indicativo do tipo da Rotina ( A- Atualização, R-Relatorio, Etc..) )
              |  |-> 3 Digitos ( indicativo do Modulo do protheus que a rotina e executada ( FAT - Faturamento ) ) 
              |-> 2 Digitos ( Indicativo do nome da Empresa ( AL - Alcar ) )
*/				         

&& VAriaveis Locais
Local _aCpoDes	:= {}
Local nk		:= 1   
Local _nLiga	:= 7
Local aAreaSx3	:= SX3->(GetArea())			// Salva a area do SX3

&& Verifica se os campos principais estão preeenchidos:
&& Onde no Array temos as seguintes informações:
&& Posição 1 -> Nome do Campo a ser processado pela montagem da descrição.
&& Posição 2 -> Qual a rega do espaçamento dda esquerda de cada campo.
&&   P.S. -> Quando temos o "Z", é indicativo que não temos espaço em branco a esquerda, 
&&           com exeção da liga que trabalha em conjunto com a Dureza , onde em algumas 
&&           Situações poderemos não ter a dureza ai deveremos tratar a regra da anterior.

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

&& Limpa o campo de Descrição.
M->B1_DESC := Space(Len(SB1->B1_DESC))

&& For que efetua a leitura de cada campo que esta no array emonta a descrição do produto.
For nk := 1 To Len(_aCpoDes)
	&& VErifica se o campo esta vazio se sim não processa
	IF !Empty(Alltrim((_aCpoDes[nk][1])))
		&& Verifica se a rega é igual a "Z"
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
				&& Quando for diferente da poisção de liga processamso a regra normal, sendo esta a 
				&& primeira posição do Array que é o Tipo ( Familia ).
				M->B1_DESC += Alltrim((_aCpoDes[nk][1]))
			Endif	
		Else
			&& Processamos a regra normal de montagem da descrição
			M->B1_DESC += (_aCpoDes[nk][2]) + Alltrim((_aCpoDes[nk][1]))
		Endif	
	Endif
Next

&& Retiramos todos os espaços em branco da descrição.
If !Empty(Alltrim(M->B1_DESC)) 
	M->B1_DESC := Alltrim(M->B1_DESC)
Else
	M->B1_DESC := Space(Len(SB1->B1_DESC))
Endif	

&& Retorno sempre verdadeiro
Return(.T.)