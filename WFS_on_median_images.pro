FUNCTION WFS_on_median_images, ConfigFiles,dirdatas, file_bg_Focuss,file_bg_Defocuss,file_image_Focuss,file_image_Defocuss,defoc_array_microns,Correction_myopes

  ;-calculate the median image 
  ;-apply WFS on this image and return zernikes

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
  NP=ConfigFile[1]
  ;nombre de modes NM
  NM=ConfigFile[4]
  ;Surech
  surech = 1.47
  ;longueur d'onde en microns wavelength_microns
  wavelength_microns=ConfigFile[3]
  ;taille des pixels de la Camera en microns pixel_size_microns
  pixel_size_microns=ConfigFile[2]
  ;Nb of images
  Nb_images=ConfigFile[0]

  ; pupille ronde
  zern10 = calc_mode_zernike(NBMODES =NM,  PUPDIAM = NP/(2*surech), LARGEUR = NP, MASK = pupille)
  ;verifier que NP/(2*surech) est un entier ou proche, le code va arrondir la valeur a un pixel entier, donc selon les config, une variation de surech peut etre invisible sur les zernikes. On peut utiliser les rapports

  loadct,3
  ;definition ouverture
  N = 2*surech*pixel_size_microns/wavelength_microns
  ;defoc_array_a4 =-1.14
  defoc_array_a4 = -defoc_array_micron*!pi/N/N/wavelength_microns/8./sqrt(3.) + Correction_myope  ; en rad rms

  ;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ;Computing Backgroud average

  bg_average_Focus=Image_median(Nb_images,NP, dirdata, file_bg_Focus)
  bg_average_Defocus=Image_median(Nb_images,NP, dirdata, file_bg_Defocus)

  ai_tt = fltarr(NM)    ; avec le tip-tilt, on peut aussi aider l'algo en mettant des valeurs non nulles si on a une idee de la carte de phas
  

  ;IMAGE FOCUS
  im =Image_median(Nb_images,NP, dirdata, file_image_Focus)-bg_average_Focus
    
  ;IMAGE DEFOCUS
  im_defoc =Image_median(Nb_images,NP, dirdata, file_image_Defocus)-bg_average_Defocus
   
  writefits, dirdata+'im'+file_image_Focus+'.fit',im
  writefits, dirdata+'im_defoc'+file_image_Defocus+'.fit',im_defoc 
    
    images = [[[im]],[[im_defoc]]]
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

    ai_tt = [ ai_align , ai_rec ]
    ai_tt=CCD_orientation_correction(ai_tt,NM)
  

  ;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ;Matrice finale et mise en forme des resultats
  ai_tt_nm = 1000.*wavelength_microns*ai_tt/2/!pi

print, ai_tt_nm
  return, ai_tt_nm
end