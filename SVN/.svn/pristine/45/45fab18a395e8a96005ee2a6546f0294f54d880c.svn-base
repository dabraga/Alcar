#Include 'Protheus.ch'

#DEFINE CRLF CHR(13)+CHR(10) // FINAL DE LINHA

/**
* Rotina		:	Pe01NfeSefaz
* Autor		:	Ectore Cecato - Totvs Jundiaí
* Data		    :	06/11/2013
* Descrição	:	Ponto de Entrada responsável por adicionar inoformações complementares para as notas fiscais 
* Módulo		:  	Faturamento
**/
User Function Pe01NfeSefaz()

	Local aArea		:= GetArea()
	Local aAreaSF2	:= SF2->(GetArea())
	Local aAreaSD2	:= SD2->(GetArea())
	Local aAreaSC5	:= SC5->(GetArea())
	Local aAreaSC6	:= SC6->(GetArea())
	Local aAreaSB1	:= SB1->(GetArea())
	Local aAreaSA1	:= SA1->(GetArea())
	Local aAreaSA2	:= SA2->(GetArea())
	Local aProd		:= ParamIxb[1]
	Local cMensCli	:= ParamIxb[2]
	Local cNota  	:= ParamIxb[5, 4]
	Local cDescProd	:= ""
	Local cInfAlcar	:= ""
	Local cPedido	:= ""
	Local nI		:= 0
	Local nPosProd	:= 0

	//nota fiscal de saída
	If cNota == "1"

		//Acrescenta informações adicionais na descrição do produto
		SD2->(DbSetOrder(13)) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_ITEM+D2_COD

		If SD2->(DbSeek(xFilial("SD2")+ SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
			
			While !SD2->(Eof()) .And. SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)
				
				cPedido  := SD2->D2_PEDIDO
				nPosProd := aScan(aProd, {|x| AllTrim(x[2])+cValToChar(x[1]) == AllTrim(SD2->D2_COD)+cValToChar(Val(SD2->D2_ITEM))})

				If nPosProd > 0

					//Caso seja nota de exportação, considera o campo B1_ZZDCEXP			
					If SF2->F2_EST == "EX"	
						cDescProd := AllTrim(Posicione("SB1", 1, xFilial("SB1")+SD2->D2_COD, "SB1->B1_ZZDCEXP"))
					Else
						cDescProd := AllTrim(Posicione("SB1", 1, xFilial("SB1")+SD2->D2_COD, "SB1->B1_ZZDESNF"))
					EndIf

					cInfAlcar := IIF(!Empty(SD2->D2_ZZPEDCL), " OC: "+ AllTrim(SD2->D2_ZZPEDCL), "")				//Pedido do cliente
					cInfAlcar += IIF(!Empty(SD2->D2_ZZREQ),   " REQ.: "+ AllTrim(SD2->D2_ZZREQ), "")				//Requisição
					cInfAlcar += IIF(!Empty(SD2->D2_ZZDES),   " DES.: "+ AllTrim(SD2->D2_ZZDES), "")				//Desenho
					cInfAlcar += IIF(!Empty(SD2->D2_ZZPRDCL), " COD.: "+ AllTrim(SD2->D2_ZZPRDCL), "")			//Código do Produto do Cliente
					cInfAlcar += IIF(!Empty(SD2->D2_PEDIDO),  " PV.: "+ AllTrim(SD2->D2_PEDIDO), "")				//Número Pedido da Alcar

					aProd[nPosProd, 4] := IIF(!Empty(cDescProd), cDescProd, aProd[nPosProd, 4])+cInfAlcar

				EndIf

				SD2->(DbSkip())

			EndDo

		EndIf
		
		SC5->(DbSetOrder(1))
		SC5->(DbSeek(FWxFilial("SC5")+cPedido))
		
		//Endereço de Entrega
		If SC5->C5_TIPO $ "B|D|" //Utiliza fornecedor

			SA2->(DbSetOrder(1))
			SA2->(DbSeek(xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))

			If !Empty(SA2->A2_END)
				cMensCli += ">>Local de Entrega: "+ AllTrim(SA2->A2_END) + IIF(Empty(SA2->A2_COMPLEM), "", " - "+ AllTrim(SA2->A2_COMPLEM)) + ;
				" - "+ AllTrim(SA2->A2_BAIRRO) + " -  "+ AllTrim(SA2->A2_MUN)  +" "+ AllTrim(SA2->A2_EST) +"."
			Endif

		Else

			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))

			If !Empty(SA1->A1_ENDENT)
				cMensCli += ">>Local de Entrega: "+ AllTrim(SA1->A1_ENDENT) + IIF(Empty(SA1->A1_ZZCOMEN), "", " - "+ AllTrim(SA1->A1_ZZCOMEN)) + ;
				" - "+ AllTrim(SA1->A1_BAIRROE) + " -  "+ AllTrim(SA1->A1_MUNE)  +" "+ AllTrim(SA1->A1_ESTE) +"."
			Endif

		EndIf

		If !Empty(SF2->F2_VEND1)
			cMensCli += CRLF + " Vendedor: "+ AllTrim(SF2->F2_VEND1) +" - "+ Posicione("SA3", 1, xFilial("SA3")+SF2->F2_VEND1, "A3_NREDUZ")
		EndIf

		For nI := 1 To Len(aProd)

			If "*" $ aProd[nI][4] 

				cMensCli += CRLF +" PRODUTO COM O SÍMBOLO (*) NÃO PERTENCEM AO SISTEMA DA QUALIDADE CERTIFICADO ALCAR."
				Exit

			Endif

		Next nI

		cMensCli += CRLF +" SÓ SERÃO ACEITAS RECLAMAÇÕES/DEVOLUÇÕES DENTRO DE 60 DIAS A PARTIR DA DATA DE EMISSÃO NA NOTA FISCAL."

		//Template Mensagem da NF - Ectore Cecato em 29/11/13
		DbSelectArea("SZZ")

		If DbSeek(xFilial("SZZ")+"S"+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)

			cMensCli  += CRLF

			While !SZZ->(Eof()) .And. SZZ->ZZ_TIPODOC == "S" .And. SZZ->ZZ_DOC == SF2->F2_DOC .And. SZZ->ZZ_SERIE == SF2->F2_SERIE .And. ;
			SZZ->ZZ_CLIFOR == SF2->F2_CLIENTE .And. SZZ->ZZ_LOJA 	== SF2->F2_LOJA

				cMensCli  += AllTrim(SZZ->ZZ_TXTMENS)+ " - "

				SZZ->(DbSkip())

			Enddo

		Endif		

	Else //Nota de saída

		//Template Mensagem da NF - Ectore Cecato em 29/11/13
		DbSelectArea("SZZ")

		If dbSeek(xFilial("SZZ")+"E"+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)

			cMensCli  += CRLF

			While !SZZ->(Eof()) .And. SZZ->ZZ_TIPODOC == "E" .And. SZZ->ZZ_DOC == SF1->F1_DOC .And. SZZ->ZZ_SERIE == SF1->F1_SERIE .And. ;
			SZZ->ZZ_CLIFOR == SF1->F1_FORNECE .And. SZZ->ZZ_LOJA 	== SF1->F1_LOJA

				cMensCli  += AllTrim(SZZ->ZZ_TXTMENS)+ " - "

				SZZ->(DbSkip())

			Enddo
		Endif

	Endif

	ParamIxb[1] := aProd
	ParamIxb[2] := cMensCli

	RestArea(aAreaSA2)
	RestArea(aAreaSA1)
	RestArea(aAreaSB1)
	RestArea(aAreaSC6)
	RestArea(aAreaSC5)
	RestArea(aAreaSD2)
	RestArea(aAreaSF2)
	RestArea(aArea)

Return ParamIxb

