#include  "protheus.ch"

#define PI 0.7854


user function volume(nDiametro,nEspessura) 

    local nVolume := 0 

    nVolume  :=nDiametro * nEspessura

return nVolume


user function area(nDiametro , nFuro)

    local nRet := 0
    nRet := ((nDiametro + nFuro ) * (nDiametro - nFuro)) * PI
return nRet

user function volBruto(nArea,nEspessura)

    local nRet := 0
    nRet := (nArea * nEspessura) /1000
return nRet


user function pesoBruto(nVolume,nDensidade)

    local nRet := 0
    nRet := (nVolume * nDensidade)/1000
return nRet

user function z10CalcLine()
    local nVolPes:= 0
    nVolPes := (fwFldGet("Z10_QTD") * fwFldGet("Z10_VALOR" )) *(fwFldGet("Z10_DISTRI")/100) 
    calcLiquid(fwFldGet("Z10_UNID"),nVolPes)

return nVolPes

user function z11CalcLine()
    local nVolPes:= 0
    nVolPes := (fwFldGet("Z11_QUANT") * fwFldGet("Z11_VALOR" )) *(fwFldGet("Z11_DISTRI")/100) 
    calcLiquid(fwFldGet("Z11_UNID"),nVolPes)

return nVolPes

static function calcLiquid(cTipo,nValor)
     local nVb := 0 
     local nPb := 0 
     local nI,nX := 0 
     local oModel := FWModelActive()
     local oMdZ10 := oModel:getModel("M03Z10")
     local oMdZ11 := oModel:getModel("M04Z11")
     local nZ10PTotal := 0
     local nZ10VTotal := 0
     local aSaveLines := FWSaveRows()


    fwFldPut("Z09_AREA", u_areaCalc())
    fwFldPut("Z09_VOLUME",u_vbCalc())
    fwFldPut("Z09_PESO" ,u_pbCalc())  
    nPb := fwFldGet("Z09_PESO")
    nVb := fwFldGet("Z09_VOLUME")
    
    for nI:= 1 to oMdZ10:Length(.t.)
        oMdZ10:goLine(nI)
        cTipo := fwFldGet("Z10_UNID")
        if cTipo == "P"
            nZ10PTotal += fwFldGet("Z10_VOLPES")   
        else 
            nZ10VTotal += fwFldGet("Z10_VOLPES") 
        endIf  

    next nI

    for nX:= 1 to oMdZ11:Length(.t.)
        oMdZ11:goLine(nX)
        cTipo := fwFldGet("Z11_UNID")
        if cTipo == "P"
            nZ10PTotal += fwFldGet("Z11_VOLPES")   
        else 
            nZ10VTotal += fwFldGet("Z11_VOLPES") 
        endIf  

    next nX


    if nZ10VTotal > 0
         fwFldPut("Z09_VOLUME",nVb - nZ10VTotal)
         fwFldPut("Z09_PESO" ,u_pbCalc()) 
        nPb := fwFldGet("Z09_PESO")
        fwFldPut("Z09_PESO"  ,nPb - nZ10PTotal)
    else 
         fwFldPut("Z09_PESO"  ,nPb - nZ10PTotal)
    endIf

   
   
    
    
    FWRestRows( aSaveLines )
     
    
    

return

user function Z09ReCalc(oMdl)

    local oModel :=nil 
    local oMdZ09 := nil
    local nI := 0
    local nPeso :=0
    local nVolume := 0
    local nVolTotal :=0
    local nPesoTotal := 0
    local cMsg := ""
    if oMdl != nil
         oModel := oMdl
         oModel:SetOperation(4)
         oModel:Activate(.T.)
    else 
         oModel := FWModelActive()   
    endIf
     oMdZ09 := oModel:getModel("M02Z09")
    If oModel:isActive()
        for nI:= 1 to oMdZ09:Length(.t.)
                oMdZ09:goLine(nI)
                fwFldPut("Z09_AREA", u_areaCalc())
                fwFldPut("Z09_VOLUME",u_vbCalc())
                fwFldPut("Z09_PESO" ,u_pbCalc())
                nVolTotal := fwFldGet("Z09_VOLUME")
                nPesoTotal := fwFldGet("Z09_PESO")
                cMolde := oMdZ09:getValue("Z09_MOLDE")
                u_Z10ReCalc(oModel,cMolde,@nPeso,@nVolume)
                U_Z11ReCalc(oModel,cMolde,@nPeso,@nVolume)
                nVolTotal-=nVolume
                nPesoTotal-=nPeso
                fwFldPut("Z09_VOLUME",nVolTotal)
                fwFldPut("Z09_PESO" ,nPesoTotal)
                if oModel:VldData()
                    oModel:CommitData()
                    oModel:DeActivate()
                else 
                   cMsg := setMsgError(oModel)
                 endIf
        next nI        

    endIf


return

user function Z10ReCalc(oModel,cMolde,nPeso,nVolume)
    
    local oMdZ10 := oModel:getModel("M03Z10")
    local nI     := 0
   

     If oModel:isActive()
        for nI:= 1 to oMdZ10:Length(.t.)
            oMdZ10:goLine(nI)
            //if cMolde  == oMdZ10:getValue("Z10_MOLDE")
                if oMdZ10:getValue("Z10_UNID") == "P"
                    nPeso += oMdZ10:getValue("Z10_VOLPES")
                else 
                    nVolume += oMdZ10:getValue("Z10_VOLPES")
                endIf
            
           // endIf

        next nI
     endIf
return

user function Z11ReCalc(oModel,cMolde,nPeso,nVolume)
    
    local oMdZ11 := oModel:getModel("M04Z11")
    local nI     := 0
   

     If oModel:isActive()
        for nI:= 1 to oMdZ11:Length(.t.)
            oMdZ11:goLine(nI)
            //if cMolde  == oMdZ11:getValue("Z11_MOLDE")
                if oMdZ11:getValue("Z11_UNID") == "P"
                    nPeso += oMdZ11:getValue("Z11_VOLPES")
                else 
                    nVolume += oMdZ11:getValue("Z11_VOLPES")
                endIf
            
            //endIf

        next nI
     endIf
return


user function reCalcMD(oModelGD,cFldMolde,cFldUnid,cFldValor)

    local oModel := FWModelActive()
    local oMdZ09 :=oModel:getModel("M02Z09")
    local cMolde := "" 
    local oMdGd := nil
    local nPeso  := 0
    local nVolume := 0
    local nJ,nX,nI :=0 
    If oModel:isActive()    
        for nI:= 1 to oMdZ09:Length(.t.)
                oMdZ09:goLine(nI)
                cMolde := oMdZ09:getValue("Z09_MOLDE")
                oMdGd := oModelGD
                for nJ := 1 to oMdGd:Length(.t.)
                    oMdGd:goLine(nJ)
                    if cMolde == oMdGd:getValue(cFldMolde)
                        if oMdGd:getValue(cFldUnid) == "P"
                            nPeso += oMdGd:getValue(cFldValor)
                        else 
                            nVolume += oMdGd:getValue(cFldValor)
                        endIf
                    endIf
                next nJ
        next nI
        oMdZ09:setValue("Z09_VOLUME", oMdZ09:getValue("Z09_VOLUME")-nVolume )
        oMdZ09:setValue("Z09_PESO", oMdZ09:getValue("Z09_VOLUME")-nPeso )
    Endif
return


user function getRegCalcAlt(cMolde)
    local cQuery := ""
    local cAlias := getNextAlias()
    local nRecno := 0
    local oModel := nil

    cQuery := getSqlCalc(cMolde)

    MPSysOpenQuery(cQuery, @cAlias)

    if (cAlias)->(!EOF())
        while (cAlias)->(!EOF())
            nRecno:= (cAlias)->ID
            dbSelectArea("Z08")
            Z08->(dbGoTo(nRecno))
            oModel	:=FwLoadModel( 'cadCalculo' )
            u_Z09ReCalc(oModel)
        (cAlias)->(dbSkip())
        endDo

    endIf
    (cAlias)->(dbCloseArea())

return 

static function getSqlCalc(cMolde)

    local cQuery := "" 

   cQuery+=" SELECT distinct Z08.R_E_C_N_O_ as ID"
   cQuery+=" FROM "+retSqlName("Z08")+" Z08 "
   cQuery+=" INNER JOIN "+retSqlName("Z09")+" Z09 ON 1=1"
   cQuery+="     AND Z09.Z09_CODIGO =  Z08.Z08_CODIGO"
   cQuery+="     AND Z09.D_E_L_E_T_!= '*'"
   cQuery+="      AND Z09.Z09_MOLDE ='"+cMolde+"'"
   cQuery+=" INNER JOIN "+retSqlName("Z10")+" Z10 ON 1=1"
   cQuery+="     AND Z10.Z10_CODIGO = Z08.Z08_CODIGO"
   cQuery+="     AND Z10.D_E_L_E_T_!= '*' "
   cQuery+=" INNER JOIN "+retSqlName("Z11")+" Z11  ON 1=1"
   cQuery+="     AND Z11_CODIGO = Z08.Z08_CODIGO"
   cQuery+="     AND Z11.D_E_L_E_T_ !='*'"
   cQuery+=" WHERE Z08.D_E_L_E_T_!='*'"


return cQuery 



static function setMsgError(oModel)
	local aMsgErro  := {}
	local cResp		:= ""
	aMsgErro := oModel:GetErrorMessage()				
	cResp := "Mensagem do erro: " 			+ StrTran( StrTran( AllToChar(aMsgErro[6]), "<", "" ), "-", "" ) + (" ")
	cResp += "Mensagem da solucaoo: " 		+ StrTran( StrTran( AllToChar(aMsgErro[7]), "<", "" ), "-", "" ) + (" ")
	cResp += "Valor atribuido: " 			+ StrTran( StrTran( AllToChar(aMsgErro[8]), "<", "" ), "-", "" ) + (" ")
	cResp += "Valor anterior: " 			+ StrTran( StrTran( AllToChar(aMsgErro[9]), "<", "" ), "-", "" ) + (" ")
	cResp += "Id do formulario de origem: " + StrTran( StrTran( AllToChar(aMsgErro[1]), "<", "" ), "-", "" ) + (" ")
	cResp += "Id do campo de origem: " 		+ StrTran( StrTran( AllToChar(aMsgErro[2]), "<", "" ), "-", "" ) + (" ")
	cResp += "Id do formulario de erro: " 	+ StrTran( StrTran( AllToChar(aMsgErro[3]), "<", "" ), "-", "" ) + (" ")
	cResp += "Id do campo de erro: " 		+ StrTran( StrTran( AllToChar(aMsgErro[4]), "<", "" ), "-", "" ) + (" ")
	cResp += "Id do erro: " 				+ StrTran( StrTran( AllToChar(aMsgErro[5]), "<", "" ), "-", "" ) + (" ")
return  cResp

user function gatB1PSVL()

    dbSelectArea("SB1")
    SB1->(dbSetOrder(1))
    if SB1->(dbSeek(xFilial('SB1')+fwFldGet('Z10_CODMAT')))
        if SB1->(fieldPos("B1_ZZPSVL")) > 0 
            return SB1->B1_ZZPSVL
        endIf
    endIf

return 0
