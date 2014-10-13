/* USBirths.do v0.00             damiancclarke             yyyy-mm-dd:2014-10-13
----|----1----|----2----|----3----|----4----|----5----|----6----|----7----|----8

Opens US birth data and counts by day*month (from 1968-2012)

contact: mailto:damian.clarke@economics.ox.ac.uk

*/

vers 11
clear all
set more off
cap log close

********************************************************************************
*** (1) globals and locals
********************************************************************************
global DAT "~/database/NVSS/Births/dta/clean"
global OUT "~/investigacion/2015/Graphs/USA"
global LOG "~/investigacion/2015/Log"

cap mkdir $OUT
cap mkdir $LOG

log using "$LOG/USBirths.txt", text replace


********************************************************************************
*** (2) Open births, collapse
********************************************************************************
local files

foreach yy of numlist 1968(1)2012 {
	dis "Working on year `yy' of 2012."
	use "$DAT/n`yy'"
	count
	gen Birth=1
	collapse (count) Birth, by(birthMonth year)
	tempfile f`yy'
	save `f`yy''
	local files `files' `f`yy''
}

********************************************************************************
*** (3) Append files, graph
********************************************************************************
clear
append using `files'

gen time=year+(birthMonth-1)/12
sort time
line Birth time, ytitle("Number of Births") xtitle("Month and Year")    ///
  title("All Births by Time: United States of America") scheme(s1color) ///
  note("Data from National Vital Statistics Service, USA.")
graph export "$OUT/BirthsMonth.eps", as(eps)
