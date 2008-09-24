<?php
function rd2ec($rx, $ry, &$eE, &$eN){
 
 // DESCRIPTION: converts geographic decimal degrees to the Dutch 
 // Rijksdriehoek-system, in meters, using the formulae published in
 // Strang van Hees, G., 1994. Globale en Geodetische Systemen. Nederlandse
 // Commissie voor Geodesie, Delft.
 // Met dank aan: Jasja Dekker.
 // Vertaald naar PHP door Jeroen Nienhuis & Gerard Troost SOVON Vogelonderzoek Nederland
   $rx *= 1000;
   $ry *= 1000;
 
   $finul = 52.15616056;
   $labdanul = 5.38763889;
 
   $xnul = 155000;
   $ynul = 463000;
 
   $A01 = 3236.0331637;
   $A20 = -32.5915821;
   $A02 = -0.2472814;
   $A21 = -0.8501341;
   $A03 = -0.065238;
   $A22 = -0.0171137;
   $A40 =  0.0052771;
   $A23 = -0.0003859;
   $A41 =  0.0003314;
   $A04 =  0.0000371;
   $A42 =  0.0000143;
   $A24 = -0.0000090;
  
   $B10 = 5261.3028966;
   $B11 =   105.9780241;
   $B12 =  2.4576469;
   $B30 = -0.8192156;
   $B31 = -0.0560092;
   $B13 =  0.0560089;
   $B32 = -0.0025614;
   $B14 =  0.0012770;
   $B50 =  0.0002574;
   $B33 = -0.0000973;
   $B51 =  0.0000293;
   $B15 =  0.0000291;
 
   $dx = (($rx - $xnul) * pow(10,-5));
   $dy = ($ry - $ynul) * pow(10,-5);
   $dfi = ($A01 * $dy) + ($A20 * (pow($dx,2))) + ($A02 * (pow($dy,2))) + ($A21 * (pow($dx,2)) * $dy) + ($A03 * (pow($dy,3))) + ($A40 * (pow($dx,4))) + ($A22 * (pow($dx,2)) * (pow($dy,2))) + ($A04 * (pow($dy,4))) + ($A41 * (pow($dx,4)) * $dy) + ($A23 * (pow($dx,2)) * (pow($dy,3))) + ($A42 * (pow($DX,4)) * (pow($DY,2))) + ($A24 * (pow($DX,2)) * (pow($DY,4)));
   $dlabda = ($B10 * $dx) + ($B11 * $dx * $dy) + ($B30 * (pow($dx,3))) + ($B12 * $dx * (pow($dy,2))) + ($B31 * (pow($dx,3)) * $dy) + ($B13 * $dx * (pow($dy,3))) + ($B50 * (pow($dx,5))) + ($B32 * (pow($dx,3)) * (pow($dy,2))) + ($B14 * $dx * (pow($dy,4))) + ($B51 * (pow($dx,5)) * $dy) + ($B33 * (pow($dx,3)) * (pow($dy,3))) + ($b15 * $dx * (pow($dy,5)));

 
   $eN = $finul + ($dfi / 3600);
   $eE = $labdanul +($dlabda / 3600);
}
 
function ec2rd($eE, $eN, &$rx, &$ry){
 
 // DESCRIPTION: converts geographic decimal degrees to the Dutch 
 // Rijksdriehoek-system, in meters, using the formulae published in
 // Strang van Hees, G., 1994. Globale en Geodetische Systemen. Nederlandse
 // Commissie voor Geodesie, Delft.
 // Met dank aan: Jasja Dekker.
 // Vertaald naar PHP door Jeroen Nienhuis & Gerard Troost SOVON Vogelonderzoek Nederland
 
 $long = $eN;
 $lat = $eE;
 
   $finul = 52.15616056;
   $labdanul = 5.38763889;
 
   $xnul = 155000;
   $ynul = 463000;
 
   $C1 = 190066.98903;
   $C11 = -11830.85831;
   $C21 = -114.19754;
   $C3 = -32.3836;
   $C31 = -2.34078;
   $C13 = -0.60639;
   $C23 =  0.15774;
   $C41 = -0.04158;
   $C5 =  -0.00661;
 
   $D10 = 309020.3181;
   $D2 = 3638.36193;
   $D12 = -157.95222;
   $D20 = 72.97141;
   $D30 = 59.79734;
   $D22 = -6.43481;
   $D4 =   0.09351;
   $D32 = -0.07379;
   $D14 = -0.05419;
   $D40 = -0.03444;
 
   $df = ($long - $finul) * 0.36;
   $dl = ($lat - $labdanul) * 0.36;
 
   $dx = ($C1 * $dl) + ($C11 * $df * $dl) + ($C21 * pow($df,2) * $dl) + ($C3 * pow($dl,3)) + ($C31 * pow($df,3) * $dl) + ($C13 * $df * pow($dl,3)) + ($C23 * pow($df,2) * pow($dl,3)) + ($C41 * pow($df,4) * $dl) + ($C5 * pow($dl,5));
   $dy = ($D10 * $df) + ($D20 * pow($df,2)) + ($D2 * pow($dl,2)) + ($D12 * $df * pow($dl,2)) + ($D30 * pow($df,3)) + ($D22 * pow($df,2) * pow($dl,2)) + ($D40 * pow($df,4)) + ($D4 * pow($dl,4)) + ($D32 * pow($df,3) * pow($dl,2)) + ($D14 * $df * pow($dl,4));

 
   $rx = ($xnul + $dx)/1000;
   $ry = ($ynul + $dy)/1000;
 
}
 
?> 
