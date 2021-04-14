#include 'Protheus.ch'
#include 'parmtype.ch'
#include "tbiconn.ch"

User Function SRVCALL()

local cRel := 'CLIENTES'
local bT := .T.
local cOptions := "1;0;1;CLIENTES"


Local cRootPath
Local cSystem  
Local cStartPath    
Local cLogPath
Local cPathCli  
local cInstallPath


PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

cRootPath := GetPvProfString( GetEnvServer(), "ROOTPATH", "", GetADV97() )
cSystem := GetPvProfString( GetEnvServer(), "STARTPATH", "", GetADV97() )  
cStartPath := cBIFixPath( cRootPath, "\") + cSystem  
cLogPath := cBIFixPath( cRootPath, "\") + SuperGetMV("MV_CRYSTAL") + "\LOG\
cPathCli   := GetClientDir()
cInstallPath := cBIFixPath( GetPvProfString( GetEnvServer(), "CRWINSTALLPATH", "" , GetADV97() ), "\" )



ConOut(cRootPath)
ConOut(cSystem)
ConOut(cStartPath)
ConOut(cLogPath)
ConOut(cPathCli)
ConOut(cInstallPath)

// TODO

CallCrys(cRel,'', cOptions, .t.,.t. ,.t.,.f.)

/*local cRel := 'RelP1225'
local cOptions := "1;0;1;RelP1225"

CallCrys(cRel,'', cOptions, .t.,.t.,.T.,.f.)


*/

Return .T.

