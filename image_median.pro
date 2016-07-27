FUNCTION Image_median,Nb_imagess,NPs, dirdatas, file_images


  Nb_images=Nb_imagess
  NP=NPs
  dirdata=dirdatas
  file_image=file_images


  ; Nb number of images taken in total
  ;background image: average of N images N being bigger than 10
  im=fltarr(NP,NP,Nb_images)
  im=float(im)
  for i=0, Nb_images-1 do im[*,*,i] = CCD_orientation_correction(float(readfits(dirdata+file_image+float2string(i+1)+'.fit')))
  
  im_median=float(fltarr(NP,NP)) 
 
  for i=0, NP-1 do begin
    for j=0,NP-1 do begin
    im_median[i,j]=median(im[i,j,*])
    endfor
  endfor
writefits, dirdata+file_images+'.fit',im_median
return, im_median

end