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
    nRet := nArea * nEspessura
return nRet
