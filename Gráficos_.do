*Informacion sobre eventos geologicos a nivel de pais entre 1979 y 2010  
use "C:\Users\pc\Desktop\JP\ECONOMETRIA II\Clase 03\Base1.dta", clear 
describe

//*Primero grafico*\\

twoway ///
(scatter mag combi if year==1990, mcolor(blue) msize(*0.4) mlabel(iso) mlabcolor(blue) mlabsize(*0.5)) ///
(scatter mag combi if year==2000, mcolor(green) msize(*0.4) mlabel(iso) mlabcolor(green) mlabsize(*0.5)) ///
(scatter mag combi if year==2010, mcolor(red) msize(*0.4) mlabel(iso) mlabcolor(red) mlabsize(*0.5)) ///
, legend (order(1 "1990" 2 "2000" 3 "2010") cols(3)) xlabel(0(20)150) ylabel(2(1)8) ///
xtitle("Velocidad maxima del viento en nodos para tormentas y huracanes") ///
ytitle("Maxima escala richet por terremoto") ///
title("Terremotos y velocidad de tormentas" "1990-2000-2010")

//*Segundo grafico*\\

*Ahora vamos a combinar dos graficos, agregaremos la instruccion lfit que es una especie de regresion lineal sobre ambas variables y nos muestra la mejor recta que se ajusta a los datos en cuestion
*Fijate en las opciones de la linea, ahora son opciones lcolor en lugar mcolor q hacia referencia a los marcadores 
twoway ///
 (scatter mag combi if year==2000, mcolor(green) msize(*0.4) mlabel(iso) mlabcolor (blue)) ///
 (lfit mag combi if year==2000, lcolor(red) lpattern(dash)) ///
 , legend(off) ///
 xlabel (0(20)140) ylabel (2(1)8) ////
 xtitle("Velocidad maxima del viento en nodos para tormentas y huracanes", size(*0.8)) ///
 ytitle("Maxima escala richertt por terremoto", size(*0.8)) ///
 title("Terremotos y velocidad de tormentas" "2000")

*Haremos la siguiente gráfica utilizando los comandos preserve y restore, los cuales nos ayudaran a usar una muestra de los datos y no vamos a alterar la base luego de ejecutar el codigo


//*Tercer grafico*\\

//Antes vemos un poco de Collapse

collapse (sum) damage_cor quake (mean) difmonth // Modificara la base de datos por eso deben utilizarlo con preserve y restore
*Lo interesante surge cuando utilizamos la opcion by del comando collapse
collapse (sum) damage_cor quake (max) difmonth, by(year)
collapse (sum) damage_cor quake (max) difmonth, by(year country)

*No esta en las diapos, los comandos preserve y restore


*El grafico de linea

preserve 
*Recuerdan que esto elimina los datos que no estan señalados en la siguiente lista
keep if iso == "PER" | iso == "CHL" | iso == "MEX" | iso == "USA" | ///
		iso == "COL" | iso == "GTM" | iso == "PAN" | iso == "ECU" | ///
		iso == "CRI" | iso == "HND" | iso == "SLV" | iso == "CAN"
*De esta lista, queremos la suma de terremotos por año, usamos los comandos collapse para cada año
collapse (sum) quake, by (year)
line quake year, lcolor(blue) lpattern(longdash) ///
xtitle("Años") ytitle("Total de terremotos") ///
title("Numero de terremoto por año" "Paises con costa al Pacifico, 1979 - 2010") ///

restore 

//*Cuarto grafico*\\

preserve 

generate sample = 1 if iso == "PER" | iso == "CHL" | iso == "MEX" | iso == "USA" | ///
				       iso == "COL" | iso == "GTM" | iso == "PAN" | iso == "ECU" | ///
		               iso == "CRI" | iso == "HND" | iso == "SLV" | iso == "CAN"

replace sample = 2 if  iso == "JPN" | iso == "CHN" | iso == "KOR" | iso == "TWN" | ///
					   iso == "PHL" | iso == "VNM" | iso == "MYS" | iso == "IDN" | ///
					   iso == "BRN" | iso == "PNG"
					   
replace sample = 3 if sample ==. 

collapse (sum) quake, by (sample year)

label define sample_label 1 "América" 2 "Asia" 3 "Resto"
label values sample sample_label

line quake year, by(sample, cols(1)) ///
title("Numero de terremotos por año") ///

restore

*Se pudo hacere esto en un solo grafico utilizando el comando twoway, pero el by nos ayuda a verlo en graficos separados 

//*Quinto grafico*\\
*Ahora veremos un box

preserve

generate sample = 1 if iso == "PER" | iso == "CHL" | iso == "MEX" | iso == "USA" | ///
				       iso == "COL" | iso == "GTM" | iso == "PAN" | iso == "ECU" | ///
		               iso == "CRI" | iso == "HND" | iso == "SLV" | iso == "CAN"

replace sample = 2 if  iso == "JPN" | iso == "CHN" | iso == "KOR" | iso == "TWN" | ///
					   iso == "PHL" | iso == "VNM" | iso == "MYS" | iso == "IDN" | ///
					   iso == "BRN" | iso == "PNG"
					   
replace sample = 3 if sample ==. 

label define sample_label 1 "America" 2 "Asia" 3 "Resto"
label values sample sample_label

gen log_d = log(damage_cor*1000000)
graph box log_d if damage_cor != 0 | damage_cor !=., by(sample, rows(1)) ///
ytitle("Log de Daño Material en dolares")

restore

*Row(1) implica que queremos ver los graficos en una fila, tmbien puedes colocar cols(1) y  verq  tal

//*Sexto grafico*\\


*Un grafico más simple (pie)

use "C:\Users\pc\Desktop\JP\ECONOMETRIA II\Clase 03\Base2.dta", clear 


generate añoc = 1 if Año == 2010 
replace añoc = 2 if Año == 2020
replace añoc = 3  if Año == 2030 

graph pie Puntaje, over(añoc) plabel(_all percent)
graph hbar (max) Puntaje, over(añoc)


labe define añoc_label 1 "2010" 2 "2020" 3 "2030"
label value añoc añoc_label

*Pie

use "C:\Users\pc\Desktop\JP\ECONOMETRIA II\Clase 03\Base1.dta", clear 

preserve

gen decadas = 1 if year >= 1979 & year < 1989
replace decadas = 2 if year >= 1989 & year < 1999
replace decadas = 3 if year >= 1999 & year <= 2010

label define decadas_label 1 "[1979-1989]" 2 "[1989-1999]" 3 "[1999-2010]"
label value decadas decadas_label

graph pie quake, over(decadas) plabel(_all percent) ///
pie(1, color (red) explode) pie(2, color(blue) explode) pie(3, color(green) explode) ///
legen(order(1 "[1979-1989]" 2 "[1989-1999]" 3 "1999-2010") row(1)) ///
title("Porcentaje de terremotos por decadas")

restore

*Cada pie es editado de manera separada

//*Septimo grafico*\\
*Barras 

preserve

generate sample = 1 if iso == "PER" | iso == "CHL" | iso == "MEX" | iso == "USA" | ///
				       iso == "COL" | iso == "GTM" | iso == "PAN" | iso == "ECU" | ///
		               iso == "CRI" | iso == "HND" | iso == "SLV" | iso == "CAN"

replace sample = 2 if  iso == "JPN" | iso == "CHN" | iso == "KOR" | iso == "TWN" | ///
					   iso == "PHL" | iso == "VNM" | iso == "MYS" | iso == "IDN" | ///
					   iso == "BRN" | iso == "PNG"
					   
replace sample = 3 if sample ==. 

label define sample_label 1 "America" 2 "Asia" 3 "Resto"
label values sample sample_label

graph hbar (max) mag maxvei, over(sample) ///
bar(1, color(blue)) bar(2, color(red))
legend (order(1 "Magnitud Richter de terremotos" 2 "Indice de explosividad volcanica"))


restore


//*Revisando Set Scheme*\\
*Cambiar el esquema significa cambiar la paleta de colores por ejemplo, fondo azul, orden de las variables, etc
*Diferentes esquemas de graficos

set scheme s2color
hist mag, name(A1, replace)

set scheme s2mono
hist mag, name(A2, replace)

set scheme s2gcolor
hist mag, name(A3, replace)

set scheme s2manual
hist mag, name(A4, replace)

set scheme s2gmanual
hist mag, name(A5, replace)

set scheme s1rcolor
hist mag, name(A6, replace)

graph combine A1 A2 A3 A4 A5 A6, title("Diferentes esquemas de gráfico")


set scheme s1color
hist mag, name(A1, replace)

set scheme s1mono
hist mag, name(A2, replace)

set scheme s1manual
hist mag, name(A3, replace)

set scheme economist
hist mag, name(A4, replace)

set scheme sj
hist mag, name(A5, replace)

graph combine A1 A2 A3 A4 A5, title("Diferentes esquemas de gráfico")
 


 
 
 
 

