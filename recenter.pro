Function recenter, images 

imagess=images
cdgg=llcdg(imagess)
recentered_image = fftshiftM(imagess,((size(imagess))[1]-1)/2.-cdgg[0],((size(imagess))[2]-1)/2.-cdgg[1])

return, recentered_image
end