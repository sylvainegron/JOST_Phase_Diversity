FUNCTION CCD_orientation_correction, Fit_image

Fit_images=Fit_image

image_plane_image=REVERSE(Fit_images,2)

return, image_plane_image
end