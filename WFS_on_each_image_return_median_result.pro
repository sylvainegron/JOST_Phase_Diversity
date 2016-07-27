FUNCTION WFS_on_each_image_return_median_result, ConfigFiles,dirdatas, file_bg_Focuss,file_bg_Defocuss,file_image_Focuss,file_image_Defocuss,defoc_array_microns,Correction_myopes

  ;-Calculate Zernikes with phase diversity on each single image
  ;-Show zernikes depending on the frame number
  ;-Give the average
  ;show results with some plots
  ;-Returns the median

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

  defoc_array_a4 = -defoc_array_micron*!pi/N/N/wavelength_microns/8./sqrt(3.) + Correction_myope  ; en rad rms

  ;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ;Computing Backgroud average

  bg_average_Focus=Image_Sum(Nb_images,NP, dirdata, file_bg_Focus)
  bg_average_Defocus=Image_Sum(Nb_images,NP, dirdata, file_bg_Defocus)

  ai_tt = fltarr(NM,Nb_images)    ; avec le tip-tilt, on peut aussi aider l'algo en mettant des valeurs non nulles si on a une idee de la carte de phase.
  ;RECURENCE
  for i=0, Nb_images-1 do begin

    ;IMAGE FOCUS
    im =ccd_orientation_correction(float(readfits(dirdata+file_image_Focus+float2string(i+1)+'.fit')))-bg_average_Focus
    im=recenter(recenter(recenter(im)))

    ;IMAGE DEFOCUS
    im_defoc =ccd_orientation_correction(float(readfits(dirdata+file_image_Defocus+float2string(i+1)+'.fit')))-bg_average_Defocus
    im_defoc=recenter(recenter(recenter(im)))

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

    ai_tt[*,i] = [ ai_align , ai_rec ]
    ai_tt[*,i]=pupil_rotation_correction_by_pi(ai_tt[*,i],NM)
  endfor

  ;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ;Matrice finale et mise en forme des resultats
  ai_tt_nm = 1000.*wavelength_microns*ai_tt/2/!pi
  ;Moyenne sur les 99 mesures
  ai_tt_moyen=fltarr(NM)
  for i=0, NM-1 do ai_tt_moyen[i]=total(ai_tt[i,*])/Nb_images
  ai_tt_moyen_nm=1000.*wavelength_microns*ai_tt_moyen/2/!pi

  ai_tt_median=fltarr(NM)
  for i=0, NM-1 do ai_tt_median[i]=median(ai_tt[i,*])
  ai_tt_median_nm=1000.*wavelength_microns*ai_tt_median/2/!pi

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; Analyse des resultats de ComparaisonMoyenneDuResultatOuResultatDeLaMoyenne
  colorarr=['Blue', 'Red', 'Orange Red', 'Green',  'Blue Violet',  'Brown', 'Cadet Blue']
  colorind=INDGEN(7)

  plot1=PLOT(ai_tt_nm[0,*], xtitle='index of exposure',ytitle='nm rms',title='about 1sec between each images',color=colorarr[0],name='zernike Z'+float2string(2))
  plot2=PLOT(ai_tt_nm[1,*],  name='zernike Z'+float2string(3),color=colorarr[1],/overplot)
  plot3=PLOT(ai_tt_nm[2,*],  name='zernike Z'+float2string(4),color=colorarr[2],/overplot)
  plot4=PLOT(ai_tt_nm[3,*],  name='zernike Z'+float2string(5),color=colorarr[3],/overplot)
  plot5=PLOT(ai_tt_nm[4,*],  name='zernike Z'+float2string(6),color=colorarr[4],/overplot)
  plot6=PLOT(ai_tt_nm[5,*],  name='zernike Z'+float2string(7),color=colorarr[5],/overplot)
  plot7=PLOT(ai_tt_nm[6,*],  name='zernike Z'+float2string(8),color=colorarr[6],/overplot)
  leg=legend(target=[plot1,plot2,plot3,plot4,plot5,plot6,plot7],position=[1,1])

  plot1=PLOT(ai_tt_nm[7,*], xtitle='index of exposure',ytitle='nm rms',title='about 1sec between each images',color=colorarr[0],name='zernike Z'+float2string(9))
  plot2=PLOT(ai_tt_nm[8,*],  name='zernike Z'+float2string(10),color=colorarr[1],/overplot)
  plot3=PLOT(ai_tt_nm[9,*],  name='zernike Z'+float2string(11),color=colorarr[2],/overplot)
  plot4=PLOT(ai_tt_nm[10,*],  name='zernike Z'+float2string(12),color=colorarr[3],/overplot)
  plot5=PLOT(ai_tt_nm[11,*],  name='zernike Z'+float2string(13),color=colorarr[4],/overplot)
  plot6=PLOT(ai_tt_nm[12,*],  name='zernike Z'+float2string(14),color=colorarr[5],/overplot)
  plot7=PLOT(ai_tt_nm[13,*],  name='zernike Z'+float2string(15),color=colorarr[6],/overplot)
  leg=legend(target=[plot1,plot2,plot3,plot4,plot5,plot6,plot7],position=[1,1])


  print, ai_tt_moyen_nm
  print, ai_tt_median_nm

  return, ai_tt_median_nm
  
end