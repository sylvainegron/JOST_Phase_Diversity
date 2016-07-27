FUNCTION WFS_on_average_image_sum_then_recentered_not_using_configfile, pixel_size,lambdas,nb_imagess,NPs,NMs,dirdatas, file_bg_Focuss,file_bg_Defocuss,file_image_Focuss,file_image_Defocuss,Defoc_array_microns,Correction_myopes
  ;does the same thing as WFS_on_average_image_sum_then_recentered, but the info written in the config file is directly put as argument of the function. 
  ;Calculate focus and defocus images by summing the images then recnetering them
  ;Apply WFS on it
  ;return zernikes

  ConfigFile=ConfigFiles
  dirdata=dirdatas
  file_bg_Focus=file_bg_Focuss
  file_bg_Defocus=file_bg_Defocuss
  file_image_Focus=file_image_Focuss
  file_image_Defocus=file_image_Defocuss
  defoc_array_micron=defoc_array_microns
  Correction_myope=Correction_myopes

  ;Calculate Zernikes with phase diversity on the average of 99 images

  iii=complex(0,1)

  ;nombre de pixels NP
  NP=NPs
  ;nombre de modes NM
  NM=NMs
  ;Surech
  surech = 1.47
  ;longueur d'onde en microns wavelength_microns
  wavelength_microns=lambdas
  ;taille des pixels de la Camera en microns pixel_size_microns
  pixel_size_microns=pixel_size
  ;Nb of images
  Nb_images=nb_imagess

  ; pupille ronde
  zern10 = calc_mode_zernike(NBMODES =NM,  PUPDIAM = NP/(2*surech), LARGEUR = NP, MASK = pupille)
  ;verifier que NP/(2*surech) est un entier ou proche, le code va arrondir la valeur a un pixel entier, donc selon les config, une variation de surech peut etre invisible sur les zernikes. On peut utiliser les rapports

  loadct,3
  ;definition ouverture
  N = 2*surech*pixel_size_microns/wavelength_microns

  ;DIVERSITE
  ; definition diversite
  ;conversion de la defoc de mm en rad rms

  ;defoc_array_micron = [0. , 10571.] ; en microns                   ; toujours bien recompiler defoc_array_a4
  defoc_array_a4 = -defoc_array_micron*!pi/N/N/wavelength_microns/8./sqrt(3.) + Correction_myope  ; en rad rms
  ;correction de la defoc grace au mode myope
  ;Correction_myope=[0.,0.12540482]
  ;defoc_array_a4 = defoc_array_a4 + Correction_myope


  ;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ;Getting the images
  im_focus_average=image_recenter_sum_bg_substraction( Nb_images,NP, dirdata, file_image_Focus,file_bg_Focus)
  im_defocus_average=image_recenter_sum_bg_substraction( Nb_images,NP, dirdata, file_image_Defocus,file_bg_Defocus)


  images = [[[im_focus_average]],[[im_defocus_average]]]

  writefits, dirdata+'im'+file_image_Focus+'.fit',im_focus_average
  writefits, dirdata+'im_defoc'+file_image_Defocus+'.fit',im_defocus_average

  sigma2 = 1D
  ai_init = fltarr(NM-2)    ; sans le tip-tilt, on peut aussi aider l'algo en mettant des valeurs non nulles si on a une idee de la carte de phase.
  ai_align = [0.,0.]        ; tip tilt

  ;MODE OEIL SAIN
  deco_conjmarg, objet_rec, ai_rec,  $
    IMAGES = images, $ ; _nb
    SIGMA2 = sigma2, NOISE_TYPE = 'ls', $
    OBJ_REGUL_TYPE =  'none', PSF_TYPE = 'ai', $
    PARAMPSF_GUESS = ai_init, $ ; OBJ_GUESS = obj_guess, $
    LARGEUR = NP,   $
    PUP_DIAM = NP/2./surech,  $
    DEFOC_ARRAY_A4 = defoc_array_a4, $ ;ITMAX = itmax, $
    VISU = 0, METHODE = 'conj', AI_ALIGN = ai_align, $
    PUP_MASQ = pupille, $ ; doit etre de taille LARGEUR
    GUARD_BAND_APO = 0, $;pas d'apodisation en point source?
    ALTERNE = 0, $
    DOUBLE = 1B, INFO = 1, leq = 0, $
    /VMLM, fseuil = 1e-6 ;/erreurdiv




  ;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ;Matrice finale et mise en forme des resultats
  ai_tt = [ ai_align , ai_rec ]
  ai_tt=pupil_rotation_correction_by_pi(ai_tt,NM)
  ai_tt_nm = 1000.*wavelength_microns*ai_tt/2/!pi
  print, ai_tt_nm

  return, ai_tt_nm

end