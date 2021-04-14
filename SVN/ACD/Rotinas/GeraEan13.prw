#include "totvs.ch"

User Function GeraEan13

Local cCodBar	:= ""
Local cPais		:= "789"
Local cCodEmpr	:= "5788"
Local cSequen	:= Soma1(GetMV("ZZ_SQEAN13"))

cCodBar := cPais + cCodEmpr + cSequen

PutMV("ZZ_SQEAN13", cSequen)

Return cCodBar // O digito esta sendo adicionado pela validação padrao A010CodBar no campo B1_CODBAR