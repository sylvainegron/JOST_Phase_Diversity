pro Determination_Surech
;Dans ce code, le but est de determiner surech qui sera utilise pour decoconjMarg
;+dirdata='Z:\Testbeds\JOST\Alignment\data\2016-5-31-13h-44min\'
;file_image_Focus='Focus_X1000_Y1000_'
;file_bg_Focus='bg_Focus_X1000_Y1000_'


;NP=100
;Nb_images=40

;bg_average_Focus=LLast_Image_Sum_only(Nb_images,NP, dirdata, file_bg_Focus)

;im=fltarr(NP,NP,Nb_images+1)
;im=float(im)


;for i=1, Nb_images do  im[*,*,i] = llrecenter(Last_from_fit_to_image_plane(float(readfits(dirdata+file_image_Focus+float2string(i)+'.fit')))-bg_average_Focus)

;average image
;im_average = im[*,*,0]
;for i=1, Nb_images do im_average=im_average+im[*,*,i]
;im_average=im_average/Nb_images
;im_average=im_average-min(im_average)
;im_average=im_average/total(im_average)
;writefits, 'Z:\Testbeds\JOST\Alignment\data\AAA.fit', im_average

im_average=readfits('Z:\Testbeds\JOST\Alignment\data\2016-6-10-13h-3min\imFocus_X0_Y0_.fit')


;I Methode classique de calcul de FTM
fto = fftshift(im_average)  &  fto /= max(fto)
window,1
tvwin,fto,z=4

ftm=abs(fto)
H=alog(ftm)
Write_png, FILENAME='Z:\Testbeds\JOST\Alignment\data\ftm1.png', H
Write_png, 'Z:\Testbeds\JOST\Alignment\data\ftm1.png',  TVRD(/TRUE)

profil_ftm = circmoy(ftm,/milieu)

window,2
loadct,0
tek_color
plot, ftm[50,50:*]
oplot, ftm[50:*,50],color=2
oplot, profil_ftm,color=3

x = FINDGEN(50)
p = PLOT ( x, profil_ftm,YRANGE=[0,1.],xtitle='Spatial Frequencies')

p.Save, 'Z:\Testbeds\JOST\Alignment\data\ftm2.png', BORDER=10,  RESOLUTION=300, /TRANSPARENT


;II Alternative pour bien traiter la valeur de la FTM en 0
;ftm theorique
surech = 50./34.
ftm = calc_ftm_clean(im_average , ech = surech)


psf_theo = airypattern(NP=100,oversampling=surech)
ftm_det = ftccd(NP=100)
ftm_theo = abs(fftshift(psf_theo))*ftm_det
ftm_theo /= max(ftm_theo)


loadct,0
tek_color
plot, ftm[50,50:*],/ylog, yr=[1.e-3,1], xtitle='Spatial Frequencies'
oplot, ftm[50:*,50],color=2
oplot, ftm_theo[50:*,50],color=1

print, 'Strehl = ', total(ftm)/total(ftm_theo)
print, 'surech = ', surech

end
