
*1) Cargamos la base de datos

import excel using "C:\Users\pc\Desktop\JP\ECONOMETRIA II\Clase 11\Mensuales-20220212-110341.xlsx", firstrow

*2) Manejamos la variable temporal

gen Año = substr(Periodo,4,2)
destring Año, replace
replace Año = Año+1900 if Año>90 
replace Año = Año+2000 if Año>=0 & Año<90

gen Mes = substr(Periodo,1,3)

/*Notar además de las locales creadas, que fueron usadas para iterar los
valores de la variable mes en el forvalues, revisar ppt04, ya que para llamar
una local en Mes=="`mes`i''" se hizo un doble llamado, y el segundo fue 
un llamando de una local string a partir de locales creadas tipo string. 
Revisar ppt*/

local 1 "Ene"
local 2 "Feb"
local 3 "Mar"
local 4 "Abr"
local 5 "May"
local 6 "Jun"
local 7 "Jul"
local 8 "Ago"
local 9 "Sep"
local 10 "Oct"
local 11 "Nov"
local 12 "Dic"

forvalues i = 1(1)12 {
replace Mes = "`i'" if Mes=="``i''" 
}

destring Mes, replace 
gen t = ym(Año,Mes)
format t %tm
tsset t
drop Año Mes Periodo 

*3) Algunas modificiones adicionales

rename Tipodecambiofindeperiodo TC
order t, before(TC)

*4) Metodologia Box Jenkings

//************* Fase de identificación*************\\ 

tsline TC 

sum TC
tsline TC, tline(2000m1 2010m1 2020m1) ///
title("Evolución del tipo de cambio S/. por $/.") ///
subtitle("PERU, 1994 - 2022") ///
note("Nota: Datos obtenidos de la base de estadísticas del BCRP") ///
ytitle("Tipo de cambio") ///
xtitle("Tiempo") ///
tlabel(1994m1(47)2022m1) lcolor(blue) lpattern(dash) ///
yline(`r(mean)')

//Evidentemente no sigue un proceso estacionario
//La literatura sugiere una diferenciación 

gen dif1 = d1.TC 
sum dif1 //Recordar que guarda en memoria los ultimos datos y los podemos llamar como locales
tsline dif1, yline(`r(mean)') 

//Verificacion de estacionariedad con el estadistico de DickeyFuller

dfuller dif1

//Funcion de autocorrelacion y autocorrelacion parcial 
corrgram TC //Muestra estacionariedad 
ac TC
pac TC 

//Ahora de la diferenciada
ac dif1
pac dif1

//************* Fase de estimacion*************\\ 

*MA
ac dif1
*AR
cap dif1
*ARIMA
arima dif1, ar(1) ma(1)
arima dif1, ar(1) ma(1) noconstant //Los valores deben ser menores a 0.05 para que el coeficiente sea significativo

*Verificacion del modelo mediante los errores (tienen que seguir ruido blanco)
predict error, residual
wntestq error //Hipotesis nula es que la variable sigue un proceso de ruido blanco > 0.05
wntestb error //Periodograma, si se encuentra fuera de la banda serian errores de ruido blanco

//************* Fase de prediccion*************\\ 

tsappend, add(10) //Aumentamos los periodos 
arima dif1, ar(1) ma(1) noconstant //Corremos de nuevo el modelo
arima TC, arima(1,1,1) noconstant
predict TCf, y dynamic(m(2022m2)) 

tsline TC TCf, lcolor(blue red) lpattern(dash solid)





