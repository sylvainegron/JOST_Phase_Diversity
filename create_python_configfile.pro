FUNCTION Create_Python_ConfigFile , ConfigFiles

ConfigFile=ConfigFiles
ConfigFile_Size=size(ConfigFile)
nb_FoV=(ConfigFile_Size[1]-6)/2

from_field_angle_in_degree_to_motor_translation_in_mm=525./1000.
from_field_angle_in_degree_to_focus_psf_position_in_pixel=1.1925  ;(from the CCD center)
from_field_angle_in_degree_to_defocus_psf_position_in_pixel=1.254   ;(from CCD center)
;Making the Config file for labview
NewConfigFile=dblarr(8*nb_FoV+6,1)


NewConfigFile[0]=ConfigFile[0]
NewConfigFile[1]=ConfigFile[1]
NewConfigFile[2]=ConfigFile[2]
NewConfigFile[3]=ConfigFile[3]
NewConfigFile[4]=ConfigFile[4]
NewConfigFile[5]=ConfigFile[5]


for i=0, nb_FoV - 1 do begin
  NewConfigFile[6+i*8]=ConfigFile[6+2*i]/1000.    ;X Field in degrees
  NewConfigFile[7+i*8]=ConfigFile[7+2*i]/1000.    ;Y Field in degrees
  NewConfigFile[8+i*8]=-(ConfigFile[6+2*i]/1000)*from_field_angle_in_degree_to_motor_translation_in_mm    ;SM x-tip position of the motor
  NewConfigFile[9+i*8]=-(ConfigFile[7+2*i]/1000)*from_field_angle_in_degree_to_motor_translation_in_mm   ;SM y-tip position of the motor
  NewConfigFile[10+i*8]=fix(round(2048.-ConfigFile[1]/2.  +  ConfigFile[6+2*i]*from_field_angle_in_degree_to_focus_psf_position_in_pixel))       ;x-position of the bottom left hand corner pixel for focus
  NewConfigFile[11+i*8]=fix(round(2048.-ConfigFile[1]/2.  +  ConfigFile[7+2*i]*from_field_angle_in_degree_to_focus_psf_position_in_pixel))        ;y-position of the bottom left hand corner pixel for focus
  NewConfigFile[12+i*8]=fix(round(2048.-ConfigFile[1]/2.  +  ConfigFile[6+2*i]*from_field_angle_in_degree_to_defocus_psf_position_in_pixel))      ;x-position of the bottom left hand corner pixel for defocus
  NewConfigFile[13+i*8]=fix(round(2048.-ConfigFile[1]/2.  +  ConfigFile[7+2*i]*from_field_angle_in_degree_to_defocus_psf_position_in_pixel))     ;y-position of the bottom left hand corner pixel for defocus
 
endfor

return, NewConfigFile

end
