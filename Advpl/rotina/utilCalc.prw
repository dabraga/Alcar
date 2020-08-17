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
