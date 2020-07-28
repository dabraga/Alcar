#include "protheus.ch"

user  function impb5h4()


   MsgRun("Importando os moldes da tabela SB5 pasra SH4","Processando", {|| ImpB5ToH4() })

return

user function prodProc()

   MsgRun("Processando a atualizacao de produtos","Processando", {|| produtoProcess() })
return


user function estruProc()

   MsgRun("processando a atualizado da estrutura","Processando", {|| estruturaProcess() })
return

user function calcArea()
    local oRMolde := nil

    local nArea    := 0
    local nFuro    := fwFldGet("H4_ZZDININ")
    oRMolde := RMolde():RMolde()
   

    if oRMolde !=  nil  
       nArea :=  oRMolde:areaCircle(nFuro)
       fwFldput("H4_ZZAREA",nArea)
    endif 

return .t.

static function ImpB5ToH4()
    local oRMolde := nil


   oRMolde := RMolde():RMolde()
   oRMolde:processTool()
return 

static function produtoProcess()

   local oRMolde := RMolde():RMolde()

   oRMolde:processProduct()

return 

static function estruturaProcess()

   local oRMolde := RMolde():RMolde()

   oRMolde:processStrutura()
   
return 
