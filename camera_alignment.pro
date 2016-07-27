pro camera_alignment

;Check Nb_Images, NP, total_translation_of_the_Camera, and the path are the same as in the Python file "Last Camera Alignment"


Nb_images=5
NP=400
pixel_size=0.009 ;in mm
total_translation_of_the_Camera=40 ; distance between the position of the Camera for the two exposures.
dirdata='Z:\Testbeds\JOST\Alignment\data\Camera_alignment\'
file_image_close_to_L3='close_to_L3_'
file_image_far_from_L3='far_from_L3_'
file_bg_close_to_L3='bg_close_to_L3_'
file_bg_far_from_L3='bg_far_from_L3_'
 
Distance_between_the_nuggers=10 ; mm

;Sum of the images and background substraction
im_close_to_L3=Image_Sum(Nb_images,NP, dirdata, file_image_close_to_L3, file_bg_close_to_L3)
im_far_from_L3=Image_Sum(Nb_images,NP, dirdata, file_image_far_from_L3, file_bg_far_from_L3)

;Calculation of the barycentre of the PSF
position_close_to_L3=llcdg(im_close_to_L3)*pixel_size
position_far_from_L3=llcdg(im_far_from_L3)*pixel_size

Angle_of_the_Camera=[0.,0.]
Angle_of_the_Camera[0]=180/!PI*ATAN((position_far_from_L3[0]-position_close_to_L3[0])/total_translation_of_the_Camera) ; degrees
Angle_of_the_Camera[1]=180/!PI*ATAN((position_far_from_L3[1]-position_close_to_L3[1])/total_translation_of_the_Camera) ; degrees
Shims_thickness_to_put=-(position_far_from_L3[0]-position_close_to_L3[0])*Distance_between_the_nuggers/total_translation_of_the_Camera
Shims_thickness_to_put=Shims_thickness_to_put

; Saving the value in a text file
OPENW, 1, 'Z:\Testbeds\JOST\Alignment\data\Camera_alignment\Camera_correcting_angle.txt'
printf,1, 'shift of the psf in pixels when the Camera moves in direction of the light, repere is the one define by the image in 2D (x increases to the right, and y up)'
printf,1, (position_far_from_L3-position_close_to_L3)/pixel_size
printf,1, ''
printf,1, 'Angle of the Camera (direct repere of the testbed,direct angles, reference being the chief ray)'
printf,1, Angle_of_the_Camera
printf,1, ''
printf,1, 'thickness of the shim:'
printf,1, Shims_thickness_to_put


end