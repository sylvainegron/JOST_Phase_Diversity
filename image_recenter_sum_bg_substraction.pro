FUNCTION Image_Recenter_Sum_bg_substraction,Nb_imagess,NPs, dirdatas, file_images, file_bgs

  Nb_images=Nb_imagess
  NP=NPs
  dirdata=dirdatas
  file_image=file_images
  file_bg=file_bgs

  IM_int=Image_Sum_bg_substraction(Nb_images,NP, dirdata, file_image, file_bg)
  recentered_im=recenter(recenter(recenter(IM_int)))
  
  writefits, dirdata+'im'+file_image+'.fit',recentered_im
  return, recentered_im

end

