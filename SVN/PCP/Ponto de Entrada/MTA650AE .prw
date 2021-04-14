#Include 'Protheus.ch'

/**
 * Rotina		:	MTA650AE
 * Autor		:	Ectore Cecato - Totvs Jundiaí
 * Data		:	04/10/2013
 * Descrição	:	Ponto de entrada responável por excluir registro na tabela de histórico de OP de aglutinação (Misturas)
 * Modulo		:  	PCP
**/
 
User Function MTA650AE()

	Local aArea		:= GetArea()
	Local aAreaSC2	:= SC2->(GetArea())
	Local cOp		:= SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
	Local cOpAglut	:= SC2->C2_AGLUT  
	Local cQuery 	:= ""
	 
	cQuery := "UPDATE "+ RetSqlName("Z01") +" "
	cQuery += "SET "
	cQuery += "	D_E_L_E_T_ = '*' "
	cQuery += "WHERE "
	cQuery += "	D_E_L_E_T_ = ' ' AND "
	cQuery += "	Z01_FILIAL = '"+ FWFilial("SC2") +"' AND "
		
	If cOpAglut == "S" 	// OP Aglutinada
		cQuery += "Z01_OPAGLU = '"+ cOp +"' "
	Else
		cQuery += "Z01_OPPAI = '"+ cOp +"' "
	Endif
	 
	If TcSqlExec(cQuery) <> 0
		UserException(TCSQLError())
	Endif
	
	RestArea(aAreaSC2)
	RestArea(aArea)
		
Return Nil