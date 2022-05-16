
*******//Creacion de Macros locales y globales\\*******

*Macros locales, son formas de guardar numeros, palabras, variables; en la memoria RAM

//DEFINICION DE LOCALES 

local ejemplo1 = 17

display `ejemplo1' 

local ejemplo2 "Clases de Econometria II"

display "`ejemplo2'" 

*Cuando más adelante necesite usar el numero 17 para hacer un calculo pues lo llamo con ejemplo1, y de igual forma el ejemplo2

//UTILIZACION DE LOCALES

*ALT + 96 `
*ALT + 39 '

*Para seguir mostrando ejemplos, utilizamos una base de datos nativa del STATA

clear
sysuse auto

summarize price //Nos daran muchos datos importantes de esa variable
*Necesito guardar uno de los resultados que obtuvimos al aplicar ese comando. Donde no se debe escribir manualmente

return list //muestra todos los datos guardados TEMPORALMENTE

local promedio = r(mean)
display `promedio'

gen promedio_por2 = 2 * `promedio' if make == "Subaru"

*Si intentas acceder a la macro local promedio luego de correr este do file con display, no te mostrara nada 

*Si creas una macro en la ventana de comandos, esa seguira "viva" hasta que cierres la ventana de STATA, ya que estas se mantienen en cualquier contexto EN EL QUE FUERON CREADAS.

//DEFINIENDO GLOBALES

global ejemplo3 = 107

display $ejemplo3

//UTILIZANDO GLOBALES

global ejemplo4 "Tengo sueño"
display "$ejemplo4"
display $ejemplo4

//UTILIZANDO MACROS CON VARIABLES

global lista_var price weight length

summ $lista_var
summ price weight length

*Podemos usar cualquier comando sobre esa lista de variables encajada en ese macro

//COMANDOS PARA MANEJAR LAS MACROS

macro dir //Nos permite ver el directorio de macros creados y otros adicionales del propio sistema

macro drop ejemplo3 //Borrando macro
macro list //Otra forma de ver lista de macros

//ABRIENDO BASE DE DATOS PARA SEGUIR CON LOS LOOPS

//FOR VALUES

import excel using "C:\Users\pc\Desktop\JP\ECONOMETRIA II\Clase 04\Base1.xlsx", clear firstrow

summ IPC if Año==2000 
summ IPC if Año==2001 
summ IPC if Año==2002 
summ IPC if Año==2003

forvalues i=2000/2003 {

	summ IPC if Año==`i'
	
}


forvalues k=2000(5)2020{

set scheme s2mono
line IPC Mes if Año==`k', name(Año_`k', replace) title(Periodo_`k') ytitle("IPC") ///
xlabel(1(1)12) lcolor(green) lpattern(longdash)

}

graph combine Año_2000 Año_2005 Año_2010 Año_2015 Año_2020, title("IPC (2009=100), 2000 - 2020")


//FOR EACH
use "C:\Users\pc\Desktop\JP\ECONOMETRIA II\Clase 04\Base2.dta", clear

foreach j of varlist ingreso_total ingreso_remesa ing_secundario{

codebook `j'
scatter ing_total_mensual `j', name(Pob_`j', replace) mcolor(green) msize(*0.8)

}

graph combine Pob_ingreso_total Pob_ingreso_remesa Pob_ing_secundario



foreach m of numlist 1 2 3{

summ ingreso_total if pobreza==`m'

}

//Macros locales y foreach

use "C:\Users\pc\Desktop\JP\ECONOMETRIA II\Clase 04\Base3.dta", clear

	local n1 "Enero"
	local n4 "Abril"
	local n7 "Julio"
	local n10 "Octubre"

foreach x of numlist 1 4 7 10{

	line mei`x' year , name(mei`x', replace) title("`n`x''") xtitle("") ytitle("MEI") ///
	xlabel(1950(5)2010 2011, grid labsize(*0.5) angle(60))
}
graph combine mei1 mei4 mei7 mei10, ycommon title("Variación de MEI para cada mes")

//NOTAR LA DIFERENCIA CON EL ANTERIOR EN EL TITLE DEL GRAFICO 

	local n1 "Enero"
	local n4 "Abril"
	local n7 "Julio"
	local n10 "Octubre"

foreach x of numlist 1 4 7 10{

	line mei`x' year , name(mei`x', replace) title(n`x') xtitle("") ytitle("MEI") ///
	xlabel(1950(5)2010 2011, grid labsize(*0.5) angle(60))
}
graph combine mei1 mei4 mei7 mei10, ycommon title("Variación de MEI para cada mes")




