FUNCTION pupil_rotation_correction_by_pi, ais,NM
;This function has to be apllied on a NM=36 elements maximmum vector. ai is the vector of zernikes, starting with tip tilts and finishing witg the pentafoils
;the code decoconj has a pi rotation between pupil plane and image plane, so the zernikes predicted are not correct. This function is correcting the rotation effect. 
;0 is the horizontal tilt, 1 is the vertical one
ai=ais
ai_corrected=fltarr(36)
for i=0, NM-1 do ai_corrected[i]=ai[i]


ai_corrected[0] = -ai_corrected[0]
ai_corrected[1]=-ai_corrected[1]
ai_corrected[5]=-ai_corrected[5]
ai_corrected[6]=-ai_corrected[6]
ai_corrected[7]=-ai_corrected[7]
ai_corrected[8]=-ai_corrected[8]
ai_corrected[14]=-ai_corrected[14]
ai_corrected[15]=-ai_corrected[15]
ai_corrected[16]=-ai_corrected[16]
ai_corrected[17]=-ai_corrected[17]
ai_corrected[18]=-ai_corrected[18]
ai_corrected[19]=-ai_corrected[19]
ai_corrected[27]=-ai_corrected[27]
ai_corrected[28]=-ai_corrected[28]
ai_corrected[29]=-ai_corrected[29]
ai_corrected[30]=-ai_corrected[30]
ai_corrected[31]=-ai_corrected[31]
ai_corrected[32]=-ai_corrected[32]
ai_corrected[33]=-ai_corrected[33]
ai_corrected[34]=-ai_corrected[34]
ai_corrected[35]=-ai_corrected[35]

ai_final=fltarr(NM)
for i=0, NM-1 do ai_final[i]=ai_corrected[i]
return, ai_final

end