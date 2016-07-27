pro Z_alignment_Main1
; Main 1 
;Read the configfile
;Create the folder the right date
;Create the python config file

; Reading the Config File
readcol,'Z:\Testbeds\JOST\Alignment\data\ConfigFile.txt',Parameters_names,ConfigFile,FORMAT='A,D'

CALDAT, systime(/julian), Month, D, Y, H, M, S
Dates=float2string(Y)+'-'+float2string(Month)+'-'+float2string(D)+'-'+float2string(H)+'h-'+float2string(M)+'min'

spawn,'mkdir '+'Z:\Testbeds\JOST\Alignment\data\'+Dates+'\'
spawn,'mkdir '+'Z:\Testbeds\JOST\Alignment\data\'+Dates+'\InterMatrix\'
spawn,'mkdir '+'Z:\Testbeds\JOST\Alignment\data\'+Dates+'\Residual_Wavefront\'
spawn,'mkdir '+'Z:\Testbeds\JOST\Alignment\data\'+Dates+'\PhaseDiversity_Calculation\'
spawn,'mkdir '+'Z:\Testbeds\JOST\Alignment\data\'+Dates+'\LinearControl_Calculation\'

;Saving the date
OPENW, 1, 'Z:\Testbeds\JOST\Alignment\data\date_for_python.txt'
printf,1, float2string(Y)
printf,1, float2string(Month)
printf,1, float2string(D)
printf,1, float2string(H)
printf,1, float2string(M)
CLOSE,1

NewConfigFile=Create_Python_ConfigFile(ConfigFile)
fName= 'Z:\Testbeds\JOST\Alignment\data\'+Dates+'\python_config_file_'+Dates+'.txt'

ConfigFile_Size=size(ConfigFile)
nb_FoV=(ConfigFile_Size[1]-6)/2
OPENW, 1, fName
FOR i=0, 8*Nb_FoV+6-1 DO printf, 1, NewConfigFile[i]
CLOSE, 1

end