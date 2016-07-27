pro jacobian_experimental
;Applies the WFS for each step of the motion of the elements
;returns all the zernikes
;Check that the values are the same as in the python "jacobian_experimental"
  Defoc_array_micron=[0. , 10571.]
  ;Correction_myope=[0.,0.12540482]
  Correction_myope=[0.,0.]
  dirdata='Z:\Testbeds\JOST\Alignment\data\jacobian_experimental\
  NP=200
  NM=20
  pixel_size=9
  lambdas=0.638
  nb_images=30
  nb_steps=11
  
 for i=0 , nb_steps-1 do begin
    
    file_bg_Focus='bg_Focus_step'+float2string(round(i+1))+'_frame_'
    file_bg_Defocus='bg_Defocus_step'+float2string(round(i+1))+'_frame_'
    file_image_Focus='Focus_step'+float2string(round(i+1))+'_frame_'
    file_image_Defocus='Defocus_step'+float2string(round(i+1))+'_frame_'
    
    fName_ai_rec='Z:\Testbeds\JOST\Alignment\data\jacobian_experimental\aberration_vs_L2_motion_step'+float2string(round(i+1))+'.txt'

    ai_tt_nm=WFS_on_average_image_sum_then_recentered_not_using_configfile(pixel_size,lambdas,nb_images,NP,NM,dirdata, file_bg_Focus,file_bg_Defocus,file_image_Focus,file_image_Defocus,Defoc_array_micron,Correction_myope)
    
    OPENW, 1, fName_ai_rec
    FOR j=0, NM-1 DO printf, 1, ai_tt_nm[j]
    CLOSE, 1

   endfor
end
