function calc_ftm_clean, psf, npfit = npfit, ech = ech

; PSF est la PSF expérimentale à partir de laquelle on veut calculer la ftm
; npfit est le nombre de points autour du point central sur lequel se fait le fit en 0)

if not keyword_set(npfit) then npfit = 3
if not keyword_set(ech) then ech = 1   ; ech = 1 -> Shannon

dim = size(psf)   

if dim[1] NE dim[2] then begin
    print, 'la PSF doit etre carre'
    retall
endif

if (dim[1] mod 2) NE 0 then begin
    print, 'NP doit etre un nombre pair'
    retall
endif


NP = dim[1]

ftm_raw = abs(fftshift(double(psf)))

; fit en 0
; -----------------------
ftm_1D = circmoy(ftm_raw, /milieu)
result = svdfit(indgen(npfit)+1, ftm_1D[1 : npfit], 2)
ftm_raw[NP/2,NP/2] = result[0]

;ftm = ftm_raw/result[0]


; soustraction du plateau
; ------------------------
plateau = mean(ftm_1D[NP/2./ech:*])

ftm = ftm_raw - plateau 

polaire2, rt=NP/2./ech, largeur = NP, masque = masque
ftm *= masque
ftm /= max(ftm)


return, ftm


end 

