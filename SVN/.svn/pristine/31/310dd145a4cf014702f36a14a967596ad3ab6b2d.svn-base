#Include 'Protheus.ch'

/*/{Protheus.doc} ALRPCP06

Etiqueta de OP para apontamento
 
@author Ectore Cecato - Totvs IP (Jundiaí)
@since 13/01/2015
@version Protheus 11 - PCP

/*/

User Function ALRPCP06()

Local aSays	:= {}
Local aButtons:= {}
Local lImprime:= .F.
Local cPerg	:= "ALRPCP06"

AjustaSX1(cPerg)

Aadd(aSays, "Rotina responsável por imprimir etiquetas de ordem de produção ")
Aadd(aSays, "para apontamento")
Aadd(aSays, "Clique no botão Imprimir para continuar")

Aadd(aButtons, {5, 	.T., {|| Pergunte(cPerg, .T.)}})
Aadd(aButtons, {6, 	.T., {|o| lImprime := .T., o:oWnd:End()}})
Aadd(aButtons, {2, 	.T., {|o| o:oWnd:End()}})

FormBatch("Impressão de Etiquetas", aSays, aButtons,, 200, 400)

If lImprime
	Processa({|| ImpEtq()}, "Aguarde", "Imprimindo etiquetas", .F.)
Endif

Return

/*/{Protheus.doc} ImpEtq

Função responsável pela impressão da etiqueta
 
@author Ectore Cecato - Totvs IP (Jundiaí)
@since 13/01/2015
@version Protheus 11 - PCP

/*/

Static Function ImpEtq()

Local cQuery 		:= ""
Local cDirEtq		:= "C:\Protheus"
Local cArqEtq		:= cDirEtq + "\Etiqueta.txt"
Local cArqBatEtq	:= cDirEtq + "\ImprimirEtiqueta.bat"
Local cAliasSC2	:= GetNextAlias()
Local cOp 			:= MV_PAR01
Local nQtdEtq 	:= MV_PAR02
Local nArq			:= 0
Local nX 			:= 0

cQuery := "SELECT "
cQuery += "	C2_NUM+C2_ITEM+C2_SEQUEN AS OP, C2_PRODUTO, B1_ZZDIAM, B1_ZZESP, B1_ZZFURO, B1_ZZGRAO "
cQuery += "FROM "+ RetSqlName("SC2") +" SC2 "
cQuery += "	INNER JOIN "+ RetSqlName("SB1") +" SB1 "
cQuery += "		ON 	SB1.D_E_L_E_T_ = ' ' "
cQuery += "			AND B1_FILIAL = '"+ FWFilial("SB1") +"' "
cQuery += "			AND B1_COD = C2_PRODUTO "
cQuery += "WHERE "
cQuery += "	SC2.D_E_L_E_T_ = ' ' "
cQuery += "	AND C2_FILIAL = '"+ FWFilial("SC2") +"' "
cQuery += "	AND C2_NUM+C2_ITEM+C2_SEQUEN = '"+ cOp +"' "

DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasSC2, .F., .T.)

(cAliasSC2)->(DbGoTop())

If !(cAliasSC2)->(Eof())

	ProcRegua(nQtdEtq)

	If !File(cDirEtq)
	
		If MakeDir(cDirEtq) <> 0
			Aviso("Atenção", "Não foi possível criar o diretório de impressão", {"Ok"})
			Return 		
		EndIf
	
	EndIf

	nArq := FCreate(cArqEtq)	
	
	If nArq >= 0
		
		For nX := 1 To nQtdEtq

			cEtiq := "^XA"+ CRLF
			cEtiq += "^MMT"+ CRLF
			cEtiq += "^PW440"+ CRLF
			cEtiq += "^LL0280"+ CRLF
			cEtiq += "^LS0"+ CRLF
			cEtiq += "^FT80,340^A0B,50,50^FH\^FD"+ AllTrim((cAliasSC2)->C2_PRODUTO) +"^FS"+ CRLF
			cEtiq += "^FT160,350^A0B,50,50^FH\^FD"+ AllTrim((cAliasSC2)->OP) +"^FS"+ CRLF
			cEtiq += "^FT240,420^A0B,50,50^FH\^FD"+ AllTrim((cAliasSC2)->B1_ZZDIAM) +"X"+ AllTrim((cAliasSC2)->B1_ZZESP) +"X"+ ; 
						AllTrim((cAliasSC2)->B1_ZZFURO) + AllTrim((cAliasSC2)->B1_ZZGRAO) +"^FS"+ CRLF
			cEtiq += "^PQ1,0,1,Y^XZ"+ CRLF
					
			IncProc()
	
			FWrite(nArq, cEtiq)
			
		Next nX
		
	Else		
		Aviso("Atenção", "Não foi possível imprimir etiqueta de produto", {"Ok"})
	Endif
	
	FClose(nArq)
	
Else
	Aviso("Atenção", "Nenhuma informação localizada", {"Ok"})
Endif

(cAliasSC2)->(DbCloseArea())

Return

/*/{Protheus.doc} AjustaSX1

Função responsável pela gravação dos parâmetros do relatório
 
@author Ectore Cecato - Totvs IP (Jundiaí)
@since 13/01/2015
@version Protheus 11 - PCP

@param [cPerg], caracter, Nome do grupo de perguntas
 
/*/
Static Function AjustaSX1(cPerg)

/*PutSX1(cPerg, "01", "OP:",			"OP:",			 "OP:",		  "MV_PAR01", "C", 11, 0, 0, "G",, "SC2",,, 	"MV_PAR02",,,,,,,,,,,,,,,,, {"Informe a OP"},							{"Informe a OP"}, 						{"Informe a OP"})
PutSX1(cPerg, "02", "Quantidade:",	"Quantidade:", "Quantidade:", "MV_PAR02", "N", 03, 0, 0, "G",,,,, 			"MV_PAR06",,,,,,,,,,,,,,,,, {"Informe a quantidade de etiquetas"},	{"Informe a quantidade de etiqutas"}, 	{"Informe a quantidade de etiquetas"})*/


	Local aParBox := {}
	
	aAdd(aParBox, {1, "OP:", Space(11), "@!","","","",70, .T. })
	aAdd(aParBox, {1, "Quantidade:", Space(17), "@E 9999.999999999999","","","",70, .T. })


Return ParamBox(aParBox, "Etiqueta de Produto",,,,,,,,cPerg, .T., .T.)