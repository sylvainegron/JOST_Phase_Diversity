pro savee


  readcol,'Z:\Testbeds\JOST\Alignment\data\2016-6-15-12h-35min\PhaseDiversity_Calculation\FieldX0_FieldY0.txt',A,FORMAT='D'
  B=A[2:17]
  cgPS_Open, 'Z:\Testbeds\JOST\Alignment\data\2016-6-15-12h-35min\PhaseDiversity_Calculation\AAA.ps'
  cgPlot, B, COLOR='navy', XTITLE='Time', YTITLE='Signal'
  cgPS_Close

end