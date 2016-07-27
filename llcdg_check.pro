

file_path='Z:\Testbeds\JOST\Alignment\data\2016-6-16-16h-28min\imDefocus_X-1000_Y1000_.fit'
imagee=readfits(file_path)
A=llcdg(imagee)


file_path2='Z:\Testbeds\JOST\Alignment\data\2016-6-16-14h-18min\imFocus_X-1000_Y1000_.fit'
imagess=readfits(file_path2)
llcdg(imagess)

rec = shift(imagess,-0.2,0.2)