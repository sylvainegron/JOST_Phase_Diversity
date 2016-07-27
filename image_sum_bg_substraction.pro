FUNCTION Image_Sum_bg_substraction,Nb_imagess,NPs, dirdatas, file_images, file_bgs


Nb_images=Nb_imagess
NP=NPs
dirdata=dirdatas
file_image=file_images
file_bg=file_bgs

  ; Nb number of images taken in total
  ;background image: average of N images N being bigger than 10
  im=fltarr(NP,NP,Nb_images+1)
  im=float(im)
  for i=1, Nb_images do im[*,*,i] = CCD_orientation_correction(float(readfits(dirdata+file_image+float2string(i)+'.fit')))-CCD_orientation_correction(float(readfits(dirdata+file_bg+float2string(i)+'.fit')))
  ;average image
  im_average = im[*,*,0]
  for i=1, Nb_images do im_average=im_average+im[*,*,i]
  im_average=im_average/Nb_images
  return, im_average


end