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

     fwFldPut("Z09_AREA", u_areaCalc())
     fwFldPut("Z09_VOLUME",u_vbCalc())
     fwFldPut("Z09_PESO" ,u_pbCalc())
     nVb := fwFldGet("Z09_VOLUME")
     nPb := fwFldGet("Z09_PESO")
    if cTipo == "P"
        fwFldPut("Z09_PESO",nPb - nValor)
    else 
         fwFldPut("Z09_VOLUME",nVb - nValor)

    endIf  

return

user function Z09ReCalc()

    local oModel := FWModelActive()
    local oMdZ09 := oModel:getModel("M02Z09")
    local nI := 0
    local nPeso :=0
    local nVolume := 0
    local nVolTotal :=0
    local nPesoTotal := 0
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
