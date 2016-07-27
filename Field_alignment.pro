pro Field_alignment

  ;Check Nb_Images, NP, total_translation_of_the_Camera, and the path are the same as in the Python file "Last Field Alignment"


  Nb_images=5
  NP=1000
  pixel_size=0.009 ;in mm
  dirdata='Z:\Testbeds\JOST\Alignment\data\Field_alignment\'
  file_image='image_'
  file_bg='bg_'

  ;Sum of the images and background substraction
  im=Image_Sum_bg_substraction(Nb_images,NP, dirdata, file_image, file_bg)


  ;Calculation of the barycentre of the PSF
  position_psf=(llcdg(im)-(size(im))[1]/2)*pixel_size



  Current_Field=-position_psf/10.597  ;Check this value thanks to Zemax (Study the motion of the pupil with the misalignment)
  Current_Field[0]=-Current_Field[0]  ;Because the x Field goes for xpixels negative
  Field_to_apply=-Current_Field
  Motor_motion_to_correct_Field=-Field_to_apply*525./1000

  ; Saving the value in a text file
  OPENW, 1, 'Z:\Testbeds\JOST\Alignment\data\Field_Alignment\Field_Alignment.txt'
  printf,1, 'PSF position in mm'
  printf,1, position_psf
  printf,1, '' 
  printf,1, 'PSF position in pixels: ' 
  printf,1, position_psf/pixel_size
  printf,1, 'Field of the current Field if 0 degree field is the central pixel: Field X, Field Y'
  printf,1, current_Field
  printf,1, '' 
  printf,1, 'Motor motion to apply: SM x-tip, SM y-tip'
  printf,1, Motor_motion_to_correct_Field
  CLOSE,1

  OPENW, 1, 'Z:\Testbeds\JOST\Alignment\data\Field_Alignment\Field_Alignment_for_Python.txt'
  printf,1, Motor_motion_to_correct_Field
  CLOSE,1

end