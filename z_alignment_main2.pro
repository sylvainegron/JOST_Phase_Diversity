pro z_alignment_main2
;Main 2
;read python config file 
;run WFS and save result in the folder "Phase Diversity calculation"

  readcol,'Z:\Testbeds\JOST\Alignment\data\date_for_python.txt',dates_,FORMAT='D'

  Dates=float2string(round(dates_[0]))+'-'+float2string(round(dates_[1]))+'-'+float2string(round(dates_[2]))+'-'+float2string(round(dates_[3]))+'h-'+float2string(round(dates_[4]))+'min'

  readcol,'Z:\Testbeds\JOST\Alignment\data\'+Dates+'\python_config_file_'+Dates+'.txt',ConfigFile_python,FORMAT='D'


  ConfigFile_Size=size(ConfigFile_python)
  nb_FoV=fix((ConfigFile_Size[1]-6)/8.)
  NM=fix(ConfigFile_python[4])
  Defoc_array_micron=[0. , 10571.]
  ;Correction_myope=[0.,0.12540482]
  Correction_myope=[0.,0.]
  for i=0 , nb_FoV-1 do begin

    dirdata='Z:\Testbeds\JOST\Alignment\data\'+Dates+'\'
    file_bg_Focus='bg_Focus_X'+float2string(round(ConfigFile_python[6+8*i]))+'_Y'+float2string(round(ConfigFile_python[7+8*i]))+'_'
    file_bg_Defocus='bg_Defocus_X'+float2string(round(ConfigFile_python[6+8*i]))+'_Y'+float2string(round(ConfigFile_python[7+8*i]))+'_'
    file_image_Focus='Focus_X'+float2string(round(ConfigFile_python[6+8*i]))+'_Y'+float2string(round(ConfigFile_python[7+8*i]))+'_'
    file_image_Defocus='Defocus_X'+float2string(round(ConfigFile_python[6+8*i]))+'_Y'+float2string(round(ConfigFile_python[7+8*i]))+'_'


    fName_ai_rec='Z:\Testbeds\JOST\Alignment\data\'+Dates+'\PhaseDiversity_Calculation\FieldX'+float2string(round(ConfigFile_python[6+8*i]))+'_FieldY'+float2string(round(ConfigFile_python[7+8*i]))+'.txt'
   
    ai_tt_nm=WFS_on_average_image_sum_then_recentered(ConfigFile_python,dirdata, file_bg_Focus,file_bg_Defocus,file_image_Focus,file_image_Defocus,Defoc_array_micron,Correction_myope)

    OPENW, 1, fName_ai_rec
    FOR j=0, NM-1 DO printf, 1, ai_tt_nm[j]
    CLOSE, 1

  endfor

PSF_position

end
