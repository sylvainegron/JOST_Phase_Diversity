FUNCTION PSF_position
;to get the psf position on the ccd detector in mm


readcol,'Z:\Testbeds\JOST\Alignment\data\date_for_python.txt',dates_,FORMAT='D'

Dates=float2string(round(dates_[0]))+'-'+float2string(round(dates_[1]))+'-'+float2string(round(dates_[2]))+'-'+float2string(round(dates_[3]))+'h-'+float2string(round(dates_[4]))+'min'

readcol,'Z:\Testbeds\JOST\Alignment\data\'+Dates+'\python_config_file_'+Dates+'.txt',ConfigFile_python,FORMAT='D'
ConfigFile_Size=size(ConfigFile_python)
nb_FoV=fix((ConfigFile_Size[1]-6)/8.)
fName='Z:\Testbeds\JOST\Alignment\data\'+Dates+'\psf_position.txt'
crop_position=fltarr(2*nb_FoV)
positions=fltarr(2*nb_FoV)
pixel_size=0.009 ;in mm
for i=0, nb_FoV - 1 do begin
crop_position[2*i]=ConfigFile_python[10+i*8]
crop_position[2*i+1]=ConfigFile_python[11+i*8]
dirdata='Z:\Testbeds\JOST\Alignment\data\'+Dates+'\'
file_image_Focus='Focus_X'+float2string(round(ConfigFile_python[6+8*i]))+'_Y'+float2string(round(ConfigFile_python[7+8*i]))+'_'
im=CCD_orientation_correction(float(readfits(dirdata+file_image_Focus+'1.fit')))
psf_position_in_the_crop=llcdg(im)
positions[2*i]=(crop_position[2*i]+psf_position_in_the_crop[0])*0.009
positions[2*i+1]=(crop_position[2*i+1]+psf_position_in_the_crop[1])*0.009

OPENW, 1, fName
FOR j=0, 1 DO printf, 1, positions[j]
CLOSE, 1
endfor

end