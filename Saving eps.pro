saving eps files 
file_path='Z:\Testbeds\JOST\Alignment\data\2016-6-15-12h-35min\imFocus_X0_Y0_.fit'
imagee=readfits(file_path)
WINDOW, 0, XSIZE=128, YSIZE=128
tvscl,imagee
write_png, 'Desktop\est.png',tvrd(/TRUE)

set_plot,"ps"
aff,imagee
device,filename='Z:\Testbeds\JOST\Alignment\data\2016-6-15-12h-35min\imFocus_X0_Y0_.eps', /encaps, xsize=1, ysize=1, BITS_PER_PIXEL=16, /color


file_path='Z:\Testbeds\JOST\Alignment\data\2016-6-15-12h-35min\imFocus_X0_Y0_.fit'
imagee=readfits(file_path)
 cgPS_Open, 'Z:\Testbeds\JOST\Alignment\data\2016-6-15-12h-35min\imFocus_X0_Y0_.eps'
 cgImage,  imagee
 cgPS_Close
 

 
set_plot, 'win'


cgPS_Open, 'Z:\Testbeds\JOST\Alignment\data\2016-6-15-12h-35min\PhaseDiversity_Calculation\AAA.eps'
cgPlot, B, COLOR='navy', XTITLE='Time', YTITLE='Signal'
cgPS_Close


;readcol,'Z:\Testbeds\JOST\Alignment\data\2016-6-15-12h-35min\PhaseDiversity_Calculation\FieldX-1000_FieldY1000.txt',A2,FORMAT='D'

readcol,'Z:\Testbeds\JOST\Alignment\data\2016-6-15-12h-35min\Zemax simu for SPIE\FieldX-1000_FieldY-1000.txt',A1,FORMAT='D'
readcol,'Z:\Testbeds\JOST\Alignment\data\2016-6-15-12h-35min\Zemax simu for SPIE\FieldX-1000_FieldY1000.txt',A2,FORMAT='D'
readcol,'Z:\Testbeds\JOST\Alignment\data\2016-6-15-12h-35min\Zemax simu for SPIE\FieldX0_FieldY0.txt',A3,FORMAT='D'
readcol,'Z:\Testbeds\JOST\Alignment\data\2016-6-15-12h-35min\Zemax simu for SPIE\FieldX1000_FieldY1000.txt',A4,FORMAT='D'
readcol,'Z:\Testbeds\JOST\Alignment\data\2016-6-15-12h-35min\Zemax simu for SPIE\FieldX1000_FieldY-1000.txt',A5,FORMAT='D'

;B1=A1[2:*]
B1=A1
B2=A2
B3=A3
B4=A4
B5=A5

NM=18
nz = indgen(NM-2)+4
;myplot=plot( nz, B, xtitle='Zernike polynom i (Noll Convention)', ytitle='Wavefront Peak to Valley (nm)',xstyle=1, ystyle=1, yrange=[-10,100])
;myplot.save

cgPlot, nz,B1, PSym=-15, Color='red', ytitle='Wavefront Peak to Valley (nm)',xtitle='i Zernike (Noll convention)',YRange=[-50,120], $
  LineStyle=0, YStyle=1, xstyle=1,/Window, thick=2
  cgPlot, nz,B2, PSym=-16, Color='dodger blue', thick=3, /Overplot, $
    LineStyle=1, /AddCmd
    cgPlot, nz,B3, PSym=-17, Color='green', thick=2, /Overplot, $
    LineStyle=2, /AddCmd
    cgPlot, nz,B4, PSym=-18, Color='purple', thick=2, /Overplot, $
    LineStyle=3, /AddCmd
    cgPlot, nz,B5, PSym=-19, Color='black', thick=2, /Overplot, $
    LineStyle=4, /AddCmd
  cgLegend, Title=['Top-left corner','Bottom-left corner','Center','Bottom-right corner','Top-right corner'], PSym=[-15,-16,-17,-18,-19], $
    LineStyle=[0,1,2,3,4], Color=['red','dodger blue','green','purple','black'], Location=[5,115], $
    /Data, /AddCmd
    
    
    
    