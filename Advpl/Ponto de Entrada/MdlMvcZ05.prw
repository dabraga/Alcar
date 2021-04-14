#include  "protheus.ch"




/*/{Protheus.doc} User Function MdlMvcZ05
    (long_description)
    @type  Function
    @author user
    @since 23/09/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function MdlMvcZ05()
    Local aParam := PARAMIXB
    Local xRet   := .T.
    Local oObj   :=  nil
    Local cIdPonto  := ""
    Local cMolde    := ""

    If aParam <> NIL 
        oObj      := aParam[1]
        cIdPonto  := aParam[2]
        cIdModel  := aParam[3]

        if cIdPonto =="FORMPOS"
               cMolde:= oObj:getValue("Z05_CODIGO")
               MsgRun("Processamento","Aguardade o processamento do recalculo",{|| u_getRegCalcAlt(cMolde) })
               

        endIf
    endIf    




 
    
Return xRet
