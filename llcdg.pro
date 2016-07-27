Function LLcdg, ims

  im=ims
  xs = (size(im))[1]

  maxx = max(im,posmax)  &  ye = posmax/xs  &  xe = posmax mod xs
  mask = im*0.+1  &   mask[xe-20:xe+20, ye-20:ye+20] = 0
  offset_brut = total(im*mask)/float(total(mask))
  im -= offset_brut
  seuil = max(im)/10  ; 2*sqrt(total(im))
  pospsf = cdg((im>seuil)-seuil) ;cdg((im>seuil)-seuil)

  Return, pospsf

end