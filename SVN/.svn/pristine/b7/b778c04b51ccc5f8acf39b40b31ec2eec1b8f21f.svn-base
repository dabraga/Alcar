#include "protheus.ch"
#include "totvs.ch"  
#include "topconn.ch"

User Function ReleaseOrder()
	Local aCposSX1 := FWSX1Util():GetGroup("RELEASEORD")
	local cGroupQuestions := Padr("RELEASEORD",Len(aCposSX1[1][1]/*SX1->X1_GRUPO*/))
	
	private oSql          := ipSqlObject():newIpSqlObject()
			
	SX1->(dbSetOrder(1))
	if !(SX1->(dbSeek(cGroupQuestions)))
		ValidQuestions(@cGroupQuestions)
	endif
	
	if !(Pergunte(cGroupQuestions,.T.))
		return
	endif
	
	processa({|lEnd| doRelease()},"Processando...","Aguarde, liberando pedidos",.F.)
	
return


/**
* Libera os Pedidos de Vendas
**/
static function doRelease()

	local nQtdLiberada := 0
	local nQtd2Liberad := 0
	local lCredito     := .T.
	local lEstoque     := .F.
	local lAvCred      := .F.
	local lAvEst       := .F.
	local lLibPar      := .T.
	local lTrfLocal    := .T.
	local aEmpenho     := nil
	local bBlock       := {||}
	local aEmpPronto   := nil
	local lTrocaLot    := .T.
	local lOkExpedicao := .T.
	local nVlrCred     := 0
	local oUpdSql      := ipSqlObject():newIpSqlObject()

	runQueryData()
	
	if oSql:count() > 0

		ProcRegua(oSql:count())
		
		while oSql:notIsEof()
		
			incProc("Liberando o Pedido de Venda " + oSql:getValue("C6_NUM") + " Item " + oSql:getValue("C6_ITEM"))
			
			nQtdLiberada := (oSql:getValue("C6_QTDVEN") - oSql:getValue("C6_QTDENT"))
						
			nQtd2Liberad := ConvUm(oSql:getValue("C6_PRODUTO"),nQtdLiberada,0,2)

			MaLibDoFat(oSql:getValue("C6_RECNO"),nQtdLiberada,lCredito,lEstoque,lAvCred,lAvEst,lLibPar,lTrfLocal,aEmpenho,bBlock,aEmpPronto,lTrocaLot,lOkExpedicao,nVlrCred)
			
			oUpdSql:update("SC5","C5_LIBEROK = 'S'","C5_FILIAL = '%SC5.FILIAL%' AND C5_NUM = '" + oSql:getValue("C6_NUM") + "'")
			
			oSql:skip()
		enddo
	else
		MsgAlert("Não foram encontrados Pedidos de Venda. Verifique os parâmetros informados.")
	endif
	
	oSql:close()
	
return


/**
* Retorna os Pedidos de Venda a serem Liberados
**/
static function runQueryData()

	local cQuery := getQuery()
	
	oSql:newAlias(cQuery)
	 
return


/**
 * Monta a Query para retornar os Pedidos
 **/
static function getQuery()

	local cQuery := ""
	
	cQuery += "SELECT C6_FILIAL,C6_NUM,C6_ITEM,C6_PRODUTO,R_E_C_N_O_ C6_RECNO,"    +  CRLF
	cQuery += "       C6_QTDLIB,C6_QTDVEN,C6_QTDENT"                               +  CRLF
	cQuery += "FROM %SC6.SQLNAME%"                                                 +  CRLF
	cQuery += "WHERE C6_FILIAL  = '%SC6.FILIAL%' AND"                              +  CRLF
	cQuery += "      C6_NUM BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' AND" +  CRLF
	cQuery += "      C6_BLQ     <> 'R' AND"                                        +  CRLF
	cQuery += "	     C6_QTDVEN  > C6_QTDENT AND"                                   +  CRLF
	cQuery += "	   %SC6.NOTDEL%"                                                   +  CRLF
	
return cQuery


/**
* Cria o Grupo de perguntas
*/
static function ValidQuestions(cGroupQuestions)

	local aRegs := {}   // Registros do Grupo de Pergunta
	local a     := .F.  // Variavel de controle
	local i     := 0
	local j     := 0

	SX1->(dbSetOrder(1))
	
	aAdd(aRegs,{cGroupQuestions,"01","Pedidos de ","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cGroupQuestions,"02","Pedidos Até","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	
	for i:=1 to Len(aRegs)
		a := SX1->(dbSeek(cGroupQuestions+aRegs[i,2]))
		RecLock("SX1",!a)
		for j:=1 to FCount()
			if j <= Len(aRegs[i]) .AND. !(a .AND. j>=15)
				FieldPut(j,aRegs[i][j])
			endif
		next
		MsUnlock()
	next i

return