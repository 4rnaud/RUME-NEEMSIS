*-------------------------
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*-----
*Debt construction
*-----
*-------------------------

********** Clear
clear all
macro drop _all

********** Path to working directory directory
global directory = "C:\Users\Arnaud\Documents\Dropbox\RUME-NEEMSIS\Data\Construction"
cd"$directory"

********** Database names
global data = "RUME-HH"
global loans = "RUME-loans_mainloans"

********** Scheme
set scheme plotplain_v2
grstyle init
grstyle set plain, box nogrid

********** Deflate
*https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=IN
*(100/158) if year==2016
*(100/184) if year==2020






****************************************
* CLEANING 2
****************************************
use "$loans", clear


*Settled
*drop if loansettled==1

********** Submission darte
gen submissiondate=mdy(03,01,2010)
tab submissiondate
format submissiondate %d

*Loan date
fre loandatemonth
replace loandatemonth="1" if loandatemonth=="JAN"
replace loandatemonth="2" if loandatemonth=="FEB"
replace loandatemonth="3" if loandatemonth=="MAR"
replace loandatemonth="4" if loandatemonth=="APR"
replace loandatemonth="5" if loandatemonth=="MAY"
replace loandatemonth="6" if loandatemonth=="JUN"
replace loandatemonth="7" if loandatemonth=="JUL"
replace loandatemonth="8" if loandatemonth=="AUG"
replace loandatemonth="8" if loandatemonth=="aug"
replace loandatemonth="9" if loandatemonth=="SEP"
replace loandatemonth="10" if loandatemonth=="OCT"
replace loandatemonth="11" if loandatemonth=="NOV"
replace loandatemonth="12" if loandatemonth=="DEC"

replace loandatemonth="6" if loandatemonth=="88"
replace loandatemonth="6" if loandatemonth=="99"

destring loandatemonth, replace
gen loandate2=mdy(loandatemonth,01,loandateyear)
format loandate2 %d
order loandate2, after(loandate)
drop loandate loandatemonth loandateyear
rename loandate2 loandate

*Loan duration
gen loanduration=submissiondate-loandate
replace loanduration=1 if loanduration<1

*** Type of loan
fre loanlender
gen lender_cat=.
label define lender_cat 1"Informal" 2"Semi formal" 3"Formal"
label values lender_cat lender_cat

foreach i in 1 2 3 4 5 7 9 13{
replace lender_cat=1 if loanlender==`i'
}
foreach i in 6 10 15{
replace lender_cat=2 if loanlender==`i'
}
foreach i in 8 11 12{
replace lender_cat=3 if loanlender==`i'
}
fre lender_cat



*** Purpose of loan
fre loanreasongiven
gen reason_cat=.
label define reason_cat 1"Economic" 2"Current" 3"Human capital" 4"Social" 5"Housing" 6"No reason" 77"Other"
label values reason_cat reason_cat
foreach i in 1 6{
replace reason_cat=1 if loanreasongiven==`i'
}
foreach i in 2 4 10{
replace reason_cat=2 if loanreasongiven==`i'
}
foreach i in 3 9{
replace reason_cat=3 if loanreasongiven==`i'
}
foreach i in 7 8 11{
replace reason_cat=4 if loanreasongiven==`i'
}
replace reason_cat=5 if loanreasongiven==5
replace reason_cat=6 if loanreasongiven==12
replace reason_cat=77 if loanreasongiven==77

fre reason_cat

save"_temp\RUME-loans_v4.dta", replace
****************************************
* END














****************************************
* NEW LENDER VAR
****************************************
use "_temp\RUME-loans_v4.dta", clear
fre loanlender
*Recode loanlender pour que les intérêts soient plus justes
gen lender2=.
replace lender2=1 if loanlender==1
replace lender2=2 if loanlender==2
replace lender2=3 if loanlender==3 | loanlender==4 | loanlender==5  // labour relation 
replace lender2=4 if loanlender==6
replace lender2=5 if loanlender==7
replace lender2=6 if loanlender==8
replace lender2=7 if loanlender==9
replace lender2=8 if loanlender==10 | loanlender==14  // SHG & group finance
replace lender2=9 if loanlender==11 | loanlender==12 | loanlender==13  // bank & coop & sugar mill loan
label define lender2 1 "WKP" 2 "Relatives" 3 "Labour" 4 "Pawn broker" 5 "Shop keeper" 6 "Moneylenders" 7 "Friends" 8"SHG & grp fin" 9 "Banks", replace
label values lender2 lender2
fre lender2

*Including relationship to the lender
fre lenderrelation
destring lenderrelation, replace
fre lenderrelation
label define lenderrelation 1"Colleague" 2"Relative" 3"Labour" 4"Political" 5"Religious" 6"Neighbour" 7"SHG member" 8"Businessman" 9"Therinjavanga" 10"Financial" 11"Bank" 12"DK him/her" 13"Traditional" 66"Irrelevant" 77"Other" 88"DK" 99"NR", replace
label values lenderrelation lenderrelation
fre lenderrelation
gen lender3=lender2
replace lender3=2 if lenderrelation==2  // Relatives
replace lender3=3 if lenderrelation==1 | lenderrelation==3  // Labour
replace lender3=8 if lenderrelation==7 | lenderrelation==10  // SHG & group finance
replace lender3=10 if lenderrelation==6  // New var: Neighbor
label define lender3 1 "WKP" 2 "Relatives" 3 "Labour" 4 "Pawn broker" 5 "Shop keeper" 6 "Moneylenders" 7 "Friends" 8 "Microcredit" 9 "Bank" 10 "Neighbor"
label values lender3 lender3
tab lender3
*In tamil, microcredit = kuzukanam

*correction of the moneylenders category with info from the main loan variable "lendername" 
tab lendername
tab lendername if strpos(lendername, "finance")
tab lendername if strpos(lendername, "finence")
tab lendername if strpos(lendername, "Equidos")
tab lendername if strpos(lendername, "Equitos")
tab lendername if strpos(lendername, "Hdfc")
tab lendername if strpos(lendername, "HDFC")
tab lendername if strpos(lendername, "Ekvidas")
tab lendername if strpos(lendername, "Eqvidas")
tab lendername if strpos(lendername, "Bwda")
tab lendername if strpos(lendername, "Ujji")
gen lender4=lender3
replace lender4=8 if  lendername=="Ujjivan" | lendername=="Ujjivan finence" | lendername=="Ujjivan5" | lendername=="Baroda bank" | lendername=="Bwda finance" | lendername=="Bwda" | lendername=="Danalakshmi finance" | lendername=="Equitos finance" | lendername=="Equitos" | lendername=="Equidos" | lendername=="Ekvidas" | lendername=="Eqvidas"
replace lender4=8 if lendername=="Fin care" | lendername=="HDFC" | lendername=="Hdfc" | lendername=="Logu finance" | lendername=="Loki management" | lendername=="Muthood fincorp" | lendername=="Muthoot finance" | lendername=="Muthu  Finance" | lendername=="Pin care" | lendername=="Rbl (finance)" | lendername=="Sriram finance" | lendername=="Sriram fainance" 
replace lender4=8 if lendername=="Mahendra finance" | lendername=="Mahi ndra finance" 
replace lender4=1 if lendername=="Therinjavanga" 
replace lender4=8 if lendername=="Sundaram finance" |  lendername=="Mahi ndra financeQ" | lendername=="Maglir Mandram"
replace lender4=8 if lendername=="Muthu  Finance" |  lendername=="Logu finance" |  lendername=="Rbl (finance)" |  lendername=="Sriram finance" |  lendername=="Sundaram finance" 
label values lender4 lender3
label var lender4 "version def (lendername)"
tab lender4



*** Effective reason
gen loaneffectivereason=.
replace loaneffectivereason=1 if loaneffectivereasondetails=="ADVANCE FOR SUGARCANE CUTTING"
replace loaneffectivereason=1 if loaneffectivereasondetails=="AGRI"
replace loaneffectivereason=1 if loaneffectivereasondetails=="AGRI CULTURE"
replace loaneffectivereason=1 if loaneffectivereasondetails=="AGRI."
replace loaneffectivereason=1 if loaneffectivereasondetails=="AGRICULTRE"
replace loaneffectivereason=1 if loaneffectivereasondetails=="Agriculture"
replace loaneffectivereason=1 if loaneffectivereasondetails=="agriculture"
replace loaneffectivereason=1 if loaneffectivereasondetails=="AGRICULTURE"
replace loaneffectivereason=1 if loaneffectivereasondetails=="AGRICULTURE AND FAMILY EXPS"
replace loaneffectivereason=1 if loaneffectivereasondetails=="AGRICULTURE AND HEALTH"
replace loaneffectivereason=1 if loaneffectivereasondetails=="AGRICULTURE EXP"
replace loaneffectivereason=1 if loaneffectivereasondetails=="AGRICULTURE EXP & FAMILY EXP"
replace loaneffectivereason=1 if loaneffectivereasondetails=="AGRICUTURAL EXP"
replace loaneffectivereason=1 if loaneffectivereasondetails=="AGRICUTURE"
replace loaneffectivereason=5 if loaneffectivereasondetails=="BATHROOM CONSTRUCTION"
replace loaneffectivereason=2 if loaneffectivereasondetails=="BIKE REPAIR"
replace loaneffectivereason=1 if loaneffectivereasondetails=="bore well"
replace loaneffectivereason=1 if loaneffectivereasondetails=="Borewell"
replace loaneffectivereason=8 if loaneffectivereasondetails=="brother marriage"
replace loaneffectivereason=8 if loaneffectivereasondetails=="BROTHER MARRIAGE"
replace loaneffectivereason=8 if loaneffectivereasondetails=="BROTHERS MARRIAGE"
replace loaneffectivereason=8 if loaneffectivereasondetails=="BROTHES MARRIAGE"
replace loaneffectivereason=1 if loaneffectivereasondetails=="BROUGHT THE PLOT"
replace loaneffectivereason=6 if loaneffectivereasondetails=="BUISINESS"
replace loaneffectivereason=6 if loaneffectivereasondetails=="BUISINESS EXP"
replace loaneffectivereason=6 if loaneffectivereasondetails=="BUISINESS INVESTMENT"
replace loaneffectivereason=6 if loaneffectivereasondetails=="BUSINESS"
replace loaneffectivereason=6 if loaneffectivereasondetails=="BUSINESS EXP"
replace loaneffectivereason=6 if loaneffectivereasondetails=="BUSINESS INPUTS"
replace loaneffectivereason=1 if loaneffectivereasondetails=="BUY COW"
replace loaneffectivereason=6 if loaneffectivereasondetails=="BUY JEWEL"
replace loaneffectivereason=1 if loaneffectivereasondetails=="BUY LAND"
replace loaneffectivereason=7 if loaneffectivereasondetails=="CEREMONIES"
replace loaneffectivereason=6 if loaneffectivereasondetails=="CHAMBER WORK"
replace loaneffectivereason=8 if loaneffectivereasondetails=="COUSIN MARRIAGE"
replace loaneffectivereason=1 if loaneffectivereasondetails=="cow purchasing"
replace loaneffectivereason=4 if loaneffectivereasondetails=="CREDIT SETTILE"
replace loaneffectivereason=4 if loaneffectivereasondetails=="CREDIT SETTLE"
replace loaneffectivereason=4 if loaneffectivereasondetails=="CREDIT SETTLED"
replace loaneffectivereason=2 if loaneffectivereasondetails=="DAUGHTER DELIVERY"
replace loaneffectivereason=2 if loaneffectivereasondetails=="DAUGHTER FUNCTION"
replace loaneffectivereason=8 if loaneffectivereasondetails=="DAUGHTER MARRIAGE"
replace loaneffectivereason=8 if loaneffectivereasondetails=="daughter marriage"
replace loaneffectivereason=8 if loaneffectivereasondetails=="DAUGHTER MARRIGE"
replace loaneffectivereason=7 if loaneffectivereasondetails=="DAUGHTER PUBERTY"
replace loaneffectivereason=7 if loaneffectivereasondetails=="daughter puberyt ceremony"
replace loaneffectivereason=8 if loaneffectivereasondetails=="DAUGHTERMARRIAGE"
replace loaneffectivereason=9 if loaneffectivereasondetails=="daughters education"
replace loaneffectivereason=8 if loaneffectivereasondetails=="DAUGHTERS MARRIAGE"
replace loaneffectivereason=8 if loaneffectivereasondetails=="DAUGHTERS MARRIAGE EXP"
replace loaneffectivereason=11 if loaneffectivereasondetails=="DEATH"
replace loaneffectivereason=11 if loaneffectivereasondetails=="DEATH EXP"
replace loaneffectivereason=2 if loaneffectivereasondetails=="DELIVERY EXP"
replace loaneffectivereason=2 if loaneffectivereasondetails=="DOUGHTER FUNCTION"
replace loaneffectivereason=8 if loaneffectivereasondetails=="DOUGHTER MARRIAGE"
replace loaneffectivereason=7 if loaneffectivereasondetails=="EAR BOREING CEREMONY"
replace loaneffectivereason=7 if loaneffectivereasondetails=="EAR BORING CEREMONY EXP"
replace loaneffectivereason=9 if loaneffectivereasondetails=="education"
replace loaneffectivereason=9 if loaneffectivereasondetails=="EDUCATION"
replace loaneffectivereason=9 if loaneffectivereasondetails=="EDUCATION EXP"
replace loaneffectivereason=9 if loaneffectivereasondetails=="EDUCATION EXPENS"
replace loaneffectivereason=6 if loaneffectivereasondetails=="ELECTION"
replace loaneffectivereason=2 if loaneffectivereasondetails=="FAMILY AND MEDICAL EXP"
replace loaneffectivereason=2 if loaneffectivereasondetails=="FAMILY EXP"
replace loaneffectivereason=2 if loaneffectivereasondetails=="family exp"
replace loaneffectivereason=2 if loaneffectivereasondetails=="FAMILY EXPENS"
replace loaneffectivereason=2 if loaneffectivereasondetails=="FAMILY EXPENSES"
replace loaneffectivereason=2 if loaneffectivereasondetails=="FAMILY EXPS"
replace loaneffectivereason=2 if loaneffectivereasondetails=="FAMILY EXPS AND HOUSE REPAIR"
replace loaneffectivereason=2 if loaneffectivereasondetails=="FAMILY EXPS AND INVESTMENT"
replace loaneffectivereason=2 if loaneffectivereasondetails=="FAMILY EXPS."
replace loaneffectivereason=2 if loaneffectivereasondetails=="FAMILY EXSP"
replace loaneffectivereason=2 if loaneffectivereasondetails=="FAMILY FUNCTION"
replace loaneffectivereason=3 if loaneffectivereasondetails=="FATHER MEDICAL EXPS"
replace loaneffectivereason=7 if loaneffectivereasondetails=="FESTIVAL"
replace loaneffectivereason=7 if loaneffectivereasondetails=="FESTIVAL EXPS"
replace loaneffectivereason=7 if loaneffectivereasondetails=="FESTIVEL"
replace loaneffectivereason=7 if loaneffectivereasondetails=="FESTIVEL EXPENS"
replace loaneffectivereason=7 if loaneffectivereasondetails=="FESTIVELS"
replace loaneffectivereason=6 if loaneffectivereasondetails=="FOR BUSINESS"
replace loaneffectivereason=6 if loaneffectivereasondetails=="FRUTI BUSINESS"
replace loaneffectivereason=11 if loaneffectivereasondetails=="FUNERAL"
replace loaneffectivereason=11 if loaneffectivereasondetails=="FUNERAL EXPENS"
replace loaneffectivereason=6 if loaneffectivereasondetails=="HANDLOOM"
replace loaneffectivereason=6 if loaneffectivereasondetails=="HANDLOOM WORK"
replace loaneffectivereason=3 if loaneffectivereasondetails=="HEALTH"
replace loaneffectivereason=3 if loaneffectivereasondetails=="HEALTH AND FAMILY EXPENS"
replace loaneffectivereason=3 if loaneffectivereasondetails=="HEALTH EXPEN"
replace loaneffectivereason=3 if loaneffectivereasondetails=="HEALTH EXPENS"
replace loaneffectivereason=3 if loaneffectivereasondetails=="HELATH EXPENS"
replace loaneffectivereason=5 if loaneffectivereasondetails=="HOUSE CONSRTUCTION"
replace loaneffectivereason=5 if loaneffectivereasondetails=="HOUSE CONSTRUCTION"
replace loaneffectivereason=5 if loaneffectivereasondetails=="HOUSE CONSTRUCTION EXP"
replace loaneffectivereason=5 if loaneffectivereasondetails=="House repair"
replace loaneffectivereason=5 if loaneffectivereasondetails=="house repair"
replace loaneffectivereason=5 if loaneffectivereasondetails=="HOUSE REPAIR"
replace loaneffectivereason=5 if loaneffectivereasondetails=="HOUSE REPAIRE"
replace loaneffectivereason=5 if loaneffectivereasondetails=="HOUSE REPAIRING"
replace loaneffectivereason=11 if loaneffectivereasondetails=="HUSBAND DEATH EXP"
replace loaneffectivereason=11 if loaneffectivereasondetails=="HUSBAND DEATH EXPENS"
replace loaneffectivereason=4 if loaneffectivereasondetails=="INTEREST SETTLE"
replace loaneffectivereason=6 if loaneffectivereasondetails=="INVESTMEN"
replace loaneffectivereason=6 if loaneffectivereasondetails=="INVESTMENT"
replace loaneffectivereason=6 if loaneffectivereasondetails=="INVESTMENT FOR BUSINESS"
replace loaneffectivereason=6 if loaneffectivereasondetails=="JOB EXP"
replace loaneffectivereason=2 if loaneffectivereasondetails=="KADHU KUTHAL"
replace loaneffectivereason=6 if loaneffectivereasondetails=="LABOUR ADVANCE"
replace loaneffectivereason=1 if loaneffectivereasondetails=="LAND LEASE EXP"
replace loaneffectivereason=3 if loaneffectivereasondetails=="madicla exp"
replace loaneffectivereason=8 if loaneffectivereasondetails=="marriage"
replace loaneffectivereason=8 if loaneffectivereasondetails=="MARRIAGE"
replace loaneffectivereason=8 if loaneffectivereasondetails=="MARRIAGE AND AGRICULTURE"
replace loaneffectivereason=8 if loaneffectivereasondetails=="MARRIAGE EXP"
replace loaneffectivereason=8 if loaneffectivereasondetails=="MARRIAGE EXPENS"
replace loaneffectivereason=8 if loaneffectivereasondetails=="MEDICAL EXP"
replace loaneffectivereason=8 if loaneffectivereasondetails=="MEDICAL EXPENS"
replace loaneffectivereason=8 if loaneffectivereasondetails=="MEDICAL EXPS"
replace loaneffectivereason=3 if loaneffectivereasondetails=="MOTHER HEALTH"
replace loaneffectivereason=11 if loaneffectivereasondetails=="MOTHER IN LAW DEATH EXP"
replace loaneffectivereason=6 if loaneffectivereasondetails=="PAY ADVANCE TO THE LABOUR"
replace loaneffectivereason=6 if loaneffectivereasondetails=="PETTI SHOP"
replace loaneffectivereason=6 if loaneffectivereasondetails=="PLACEMENT"
replace loaneffectivereason=7 if loaneffectivereasondetails=="PUBERTY"
replace loaneffectivereason=7 if loaneffectivereasondetails=="PUBERTY CEREMONIE"
replace loaneffectivereason=7 if loaneffectivereasondetails=="PUBERTY CEREMONIES EXP"
replace loaneffectivereason=7 if loaneffectivereasondetails=="puberty ceremony"
replace loaneffectivereason=7 if loaneffectivereasondetails=="PUBERTY CEREMONY"
replace loaneffectivereason=7 if loaneffectivereasondetails=="PUBERTY CEREMONY EXP"
replace loaneffectivereason=7 if loaneffectivereasondetails=="PUBERTY FUNCTION"
replace loaneffectivereason=7 if loaneffectivereasondetails=="PUBRTY CEREMONY"
replace loaneffectivereason=7 if loaneffectivereasondetails=="PUBRTY CEREMONY EXP"
replace loaneffectivereason=5 if loaneffectivereasondetails=="RECONSTRUCT HOUSE"
replace loaneffectivereason=10 if loaneffectivereasondetails=="RELATIEVES FUNCTION"
replace loaneffectivereason=10 if loaneffectivereasondetails=="RELATIEVES MARRIAGE EXP"
replace loaneffectivereason=10 if loaneffectivereasondetails=="RELATION DEATH"
replace loaneffectivereason=10 if loaneffectivereasondetails=="RELATION FUNCTION"
replace loaneffectivereason=10 if loaneffectivereasondetails=="RELATION FUNERAL"
replace loaneffectivereason=10 if loaneffectivereasondetails=="RELATION MARRIAGE"
replace loaneffectivereason=10 if loaneffectivereasondetails=="RELATIONS FUNERAL"
replace loaneffectivereason=10 if loaneffectivereasondetails=="RELATIVE DEATH"
replace loaneffectivereason=10 if loaneffectivereasondetails=="RELATIVE FUNCTION"
replace loaneffectivereason=10 if loaneffectivereasondetails=="RELATIVE FUNTION"
replace loaneffectivereason=10 if loaneffectivereasondetails=="RELATIVE MARRIAGE"
replace loaneffectivereason=10 if loaneffectivereasondetails=="relatives ceremonies"
replace loaneffectivereason=10 if loaneffectivereasondetails=="RELATIVES DEATH EXP"
replace loaneffectivereason=10 if loaneffectivereasondetails=="RELATIVES FESTIVALS"
replace loaneffectivereason=10 if loaneffectivereasondetails=="RELATIVES FESTIVALS EXP"
replace loaneffectivereason=10 if loaneffectivereasondetails=="RELATIVES FUNCTION"
replace loaneffectivereason=10 if loaneffectivereasondetails=="RELATIVES FUNCTION EXP"
replace loaneffectivereason=10 if loaneffectivereasondetails=="RELATIVES MARRIAGE EXP"
replace loaneffectivereason=5 if loaneffectivereasondetails=="RENT FOR HOUSE"
replace loaneffectivereason=4 if loaneffectivereasondetails=="REPAYMENT FOR PREVIOUS LOAN"
replace loaneffectivereason=4 if loaneffectivereasondetails=="REPAYMENT FOR PREVIOUS LOAN INTERESTS"
replace loaneffectivereason=4 if loaneffectivereasondetails=="REPAYMENT PREVIOUS LOAN"
replace loaneffectivereason=4 if loaneffectivereasondetails=="REPAYMENTFOR PREVIOUS LOAN"
replace loaneffectivereason=4 if loaneffectivereasondetails=="SETTLED LOAN"
replace loaneffectivereason=6 if loaneffectivereasondetails=="SHOP CONSTRUCTION EXP"
replace loaneffectivereason=8 if loaneffectivereasondetails=="SISTER MARRIAGE"
replace loaneffectivereason=11 if loaneffectivereasondetails=="SISTER PREGNANCY"
replace loaneffectivereason=8 if loaneffectivereasondetails=="SISTERS MARRIAGE"
replace loaneffectivereason=8 if loaneffectivereasondetails=="SISTERS MARRIAGE EXP"
replace loaneffectivereason=3 if loaneffectivereasondetails=="SON ACCIDENT TREATMENT EXPENS"
replace loaneffectivereason=9 if loaneffectivereasondetails=="SON EDUCATION"
replace loaneffectivereason=8 if loaneffectivereasondetails=="SON MARRIAGE"
replace loaneffectivereason=8 if loaneffectivereasondetails=="SON MARRIAGE EXP"
replace loaneffectivereason=2 if loaneffectivereasondetails=="SON PLACEMENT"
replace loaneffectivereason=8 if loaneffectivereasondetails=="SONS MARRIAGE EXP"
replace loaneffectivereason=3 if loaneffectivereasondetails=="SONS MEDICAL EXP"
replace loaneffectivereason=1 if loaneffectivereasondetails=="SUGARCANE EXP"
replace loaneffectivereason=6 if loaneffectivereasondetails=="SULAI PODA"
replace loaneffectivereason=7 if loaneffectivereasondetails=="TEMPLE FESTIVAL"
replace loaneffectivereason=5 if loaneffectivereasondetails=="TO BUILD HOUSE"
replace loaneffectivereason=1 if loaneffectivereasondetails=="TO BUY AGRI LAND"
replace loaneffectivereason=2 if loaneffectivereasondetails=="TO BUY BIKE"
replace loaneffectivereason=1 if loaneffectivereasondetails=="TO BUY BULLOCART VEHICLE"
replace loaneffectivereason=1 if loaneffectivereasondetails=="TO BUY BULLOCK"
replace loaneffectivereason=1 if loaneffectivereasondetails=="TO BUY COW"
replace loaneffectivereason=2 if loaneffectivereasondetails=="TO BUY FUNITURE"
replace loaneffectivereason=5 if loaneffectivereasondetails=="TO BUY HOUSE"
replace loaneffectivereason=1 if loaneffectivereasondetails=="TO BUY LAND"
replace loaneffectivereason=6 if loaneffectivereasondetails=="TO BUY LOAD CARRIER VEHICLE"
replace loaneffectivereason=1 if loaneffectivereasondetails=="TO BUY PLOT"
replace loaneffectivereason=2 if loaneffectivereasondetails=="TO BUY TATA VEHICLE"
replace loaneffectivereason=1 if loaneffectivereasondetails=="TO BUY TRACTOR"
replace loaneffectivereason=6 if loaneffectivereasondetails=="TO EXTEND OUR BUSINESS"
replace loaneffectivereason=10 if loaneffectivereasondetails=="TO GIVE GIFT NEIBHOUR MARRIAGE FUNCTION"
replace loaneffectivereason=2 if loaneffectivereasondetails=="TO GO ABROAD"
replace loaneffectivereason=6 if loaneffectivereasondetails=="TO GO GULF"
replace loaneffectivereason=1 if loaneffectivereasondetails=="TO MAKE BORE"
replace loaneffectivereason=5 if loaneffectivereasondetails=="TO REAIRING HOUSE"
replace loaneffectivereason=5 if loaneffectivereasondetails=="TO REBUILD HOUSE"
replace loaneffectivereason=5 if loaneffectivereasondetails=="TO REPAIR HOUSE"
replace loaneffectivereason=5 if loaneffectivereasondetails=="TO REPAIRE HOUSE"
replace loaneffectivereason=5 if loaneffectivereasondetails=="TO REPAIRING HOUSE"
replace loaneffectivereason=4 if loaneffectivereasondetails=="TO REPAYMENT FOR PREVIOUS LOAN"
replace loaneffectivereason=4 if loaneffectivereasondetails=="TO REPAYMENT PREVIOUS LOAN"
replace loaneffectivereason=4 if loaneffectivereasondetails=="TO SETTLE PREVIOUS LOAN"
replace loaneffectivereason=4 if loaneffectivereasondetails=="TO SETTLE PREVIUOS LOAN"
replace loaneffectivereason=4 if loaneffectivereasondetails=="TO SETTLE THE PREVIOUS LOAN"
replace loaneffectivereason=1 if loaneffectivereasondetails=="TRACTOR"
replace loaneffectivereason=1 if loaneffectivereasondetails=="TRACTOR LOAN"
replace loaneffectivereason=3 if loaneffectivereasondetails=="TREATMENT"
replace loaneffectivereason=3 if loaneffectivereasondetails=="TREATMENT FOR DAUGHTER"
replace loaneffectivereason=7 if loaneffectivereasondetails=="VALAIKAPPU"
replace loaneffectivereason=2 if loaneffectivereasondetails=="VEHICLE MAINTANANCE"
replace loaneffectivereason=8 if loaneffectivereasondetails=="WEEDING"
replace loaneffectivereason=3 if loaneffectivereasondetails=="WIFE HEALTH EXPS"
replace loaneffectivereason=8 if loaneffectivereasondetails=="WIFE SISSTERS MARRIAGE EXP"

*** Effective reason2
gen loaneffectivereason2=.
replace loaneffectivereason2=. if loaneffectivereasondetails=="ADVANCE FOR SUGARCANE CUTTING"
replace loaneffectivereason2=. if loaneffectivereasondetails=="AGRI"
replace loaneffectivereason2=. if loaneffectivereasondetails=="AGRI CULTURE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="AGRI."
replace loaneffectivereason2=. if loaneffectivereasondetails=="AGRICULTRE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="Agriculture"
replace loaneffectivereason2=. if loaneffectivereasondetails=="agriculture"
replace loaneffectivereason2=. if loaneffectivereasondetails=="AGRICULTURE"
replace loaneffectivereason2=2 if loaneffectivereasondetails=="AGRICULTURE AND FAMILY EXPS"
replace loaneffectivereason2=3 if loaneffectivereasondetails=="AGRICULTURE AND HEALTH"
replace loaneffectivereason2=. if loaneffectivereasondetails=="AGRICULTURE EXP"
replace loaneffectivereason2=2 if loaneffectivereasondetails=="AGRICULTURE EXP & FAMILY EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="AGRICUTURAL EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="AGRICUTURE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="BATHROOM CONSTRUCTION"
replace loaneffectivereason2=. if loaneffectivereasondetails=="BIKE REPAIR"
replace loaneffectivereason2=. if loaneffectivereasondetails=="bore well"
replace loaneffectivereason2=. if loaneffectivereasondetails=="Borewell"
replace loaneffectivereason2=. if loaneffectivereasondetails=="brother marriage"
replace loaneffectivereason2=. if loaneffectivereasondetails=="BROTHER MARRIAGE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="BROTHERS MARRIAGE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="BROTHES MARRIAGE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="BROUGHT THE PLOT"
replace loaneffectivereason2=. if loaneffectivereasondetails=="BUISINESS"
replace loaneffectivereason2=. if loaneffectivereasondetails=="BUISINESS EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="BUISINESS INVESTMENT"
replace loaneffectivereason2=. if loaneffectivereasondetails=="BUSINESS"
replace loaneffectivereason2=. if loaneffectivereasondetails=="BUSINESS EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="BUSINESS INPUTS"
replace loaneffectivereason2=. if loaneffectivereasondetails=="BUY COW"
replace loaneffectivereason2=2 if loaneffectivereasondetails=="BUY JEWEL"
replace loaneffectivereason2=. if loaneffectivereasondetails=="BUY LAND"
replace loaneffectivereason2=. if loaneffectivereasondetails=="CEREMONIES"
replace loaneffectivereason2=. if loaneffectivereasondetails=="CHAMBER WORK"
replace loaneffectivereason2=. if loaneffectivereasondetails=="COUSIN MARRIAGE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="cow purchasing"
replace loaneffectivereason2=. if loaneffectivereasondetails=="CREDIT SETTILE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="CREDIT SETTLE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="CREDIT SETTLED"
replace loaneffectivereason2=. if loaneffectivereasondetails=="DAUGHTER DELIVERY"
replace loaneffectivereason2=. if loaneffectivereasondetails=="DAUGHTER FUNCTION"
replace loaneffectivereason2=. if loaneffectivereasondetails=="DAUGHTER MARRIAGE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="daughter marriage"
replace loaneffectivereason2=. if loaneffectivereasondetails=="DAUGHTER MARRIGE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="DAUGHTER PUBERTY"
replace loaneffectivereason2=. if loaneffectivereasondetails=="daughter puberyt ceremony"
replace loaneffectivereason2=. if loaneffectivereasondetails=="DAUGHTERMARRIAGE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="daughters education"
replace loaneffectivereason2=. if loaneffectivereasondetails=="DAUGHTERS MARRIAGE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="DAUGHTERS MARRIAGE EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="DEATH"
replace loaneffectivereason2=. if loaneffectivereasondetails=="DEATH EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="DELIVERY EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="DOUGHTER FUNCTION"
replace loaneffectivereason2=. if loaneffectivereasondetails=="DOUGHTER MARRIAGE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="EAR BOREING CEREMONY"
replace loaneffectivereason2=. if loaneffectivereasondetails=="EAR BORING CEREMONY EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="education"
replace loaneffectivereason2=. if loaneffectivereasondetails=="EDUCATION"
replace loaneffectivereason2=. if loaneffectivereasondetails=="EDUCATION EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="EDUCATION EXPENS"
replace loaneffectivereason2=. if loaneffectivereasondetails=="ELECTION"
replace loaneffectivereason2=3 if loaneffectivereasondetails=="FAMILY AND MEDICAL EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="FAMILY EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="family exp"
replace loaneffectivereason2=. if loaneffectivereasondetails=="FAMILY EXPENS"
replace loaneffectivereason2=. if loaneffectivereasondetails=="FAMILY EXPENSES"
replace loaneffectivereason2=. if loaneffectivereasondetails=="FAMILY EXPS"
replace loaneffectivereason2=5 if loaneffectivereasondetails=="FAMILY EXPS AND HOUSE REPAIR"
replace loaneffectivereason2=6 if loaneffectivereasondetails=="FAMILY EXPS AND INVESTMENT"
replace loaneffectivereason2=. if loaneffectivereasondetails=="FAMILY EXPS."
replace loaneffectivereason2=. if loaneffectivereasondetails=="FAMILY EXSP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="FAMILY FUNCTION"
replace loaneffectivereason2=. if loaneffectivereasondetails=="FATHER MEDICAL EXPS"
replace loaneffectivereason2=. if loaneffectivereasondetails=="FESTIVAL"
replace loaneffectivereason2=. if loaneffectivereasondetails=="FESTIVAL EXPS"
replace loaneffectivereason2=. if loaneffectivereasondetails=="FESTIVEL"
replace loaneffectivereason2=. if loaneffectivereasondetails=="FESTIVEL EXPENS"
replace loaneffectivereason2=. if loaneffectivereasondetails=="FESTIVELS"
replace loaneffectivereason2=. if loaneffectivereasondetails=="FOR BUSINESS"
replace loaneffectivereason2=. if loaneffectivereasondetails=="FRUTI BUSINESS"
replace loaneffectivereason2=. if loaneffectivereasondetails=="FUNERAL"
replace loaneffectivereason2=. if loaneffectivereasondetails=="FUNERAL EXPENS"
replace loaneffectivereason2=. if loaneffectivereasondetails=="HANDLOOM"
replace loaneffectivereason2=. if loaneffectivereasondetails=="HANDLOOM WORK"
replace loaneffectivereason2=. if loaneffectivereasondetails=="HEALTH"
replace loaneffectivereason2=2 if loaneffectivereasondetails=="HEALTH AND FAMILY EXPENS"
replace loaneffectivereason2=. if loaneffectivereasondetails=="HEALTH EXPEN"
replace loaneffectivereason2=. if loaneffectivereasondetails=="HEALTH EXPENS"
replace loaneffectivereason2=. if loaneffectivereasondetails=="HELATH EXPENS"
replace loaneffectivereason2=. if loaneffectivereasondetails=="HOUSE CONSRTUCTION"
replace loaneffectivereason2=. if loaneffectivereasondetails=="HOUSE CONSTRUCTION"
replace loaneffectivereason2=. if loaneffectivereasondetails=="HOUSE CONSTRUCTION EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="House repair"
replace loaneffectivereason2=. if loaneffectivereasondetails=="house repair"
replace loaneffectivereason2=. if loaneffectivereasondetails=="HOUSE REPAIR"
replace loaneffectivereason2=. if loaneffectivereasondetails=="HOUSE REPAIRE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="HOUSE REPAIRING"
replace loaneffectivereason2=. if loaneffectivereasondetails=="HUSBAND DEATH EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="HUSBAND DEATH EXPENS"
replace loaneffectivereason2=. if loaneffectivereasondetails=="INTEREST SETTLE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="INVESTMEN"
replace loaneffectivereason2=. if loaneffectivereasondetails=="INVESTMENT"
replace loaneffectivereason2=. if loaneffectivereasondetails=="INVESTMENT FOR BUSINESS"
replace loaneffectivereason2=. if loaneffectivereasondetails=="JOB EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="KADHU KUTHAL"
replace loaneffectivereason2=. if loaneffectivereasondetails=="LABOUR ADVANCE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="LAND LEASE EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="madicla exp"
replace loaneffectivereason2=. if loaneffectivereasondetails=="marriage"
replace loaneffectivereason2=. if loaneffectivereasondetails=="MARRIAGE"
replace loaneffectivereason2=1 if loaneffectivereasondetails=="MARRIAGE AND AGRICULTURE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="MARRIAGE EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="MARRIAGE EXPENS"
replace loaneffectivereason2=. if loaneffectivereasondetails=="MEDICAL EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="MEDICAL EXPENS"
replace loaneffectivereason2=. if loaneffectivereasondetails=="MEDICAL EXPS"
replace loaneffectivereason2=. if loaneffectivereasondetails=="MOTHER HEALTH"
replace loaneffectivereason2=. if loaneffectivereasondetails=="MOTHER IN LAW DEATH EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="PAY ADVANCE TO THE LABOUR"
replace loaneffectivereason2=. if loaneffectivereasondetails=="PETTI SHOP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="PLACEMENT"
replace loaneffectivereason2=. if loaneffectivereasondetails=="PUBERTY"
replace loaneffectivereason2=. if loaneffectivereasondetails=="PUBERTY CEREMONIE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="PUBERTY CEREMONIES EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="puberty ceremony"
replace loaneffectivereason2=. if loaneffectivereasondetails=="PUBERTY CEREMONY"
replace loaneffectivereason2=. if loaneffectivereasondetails=="PUBERTY CEREMONY EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="PUBERTY FUNCTION"
replace loaneffectivereason2=. if loaneffectivereasondetails=="PUBRTY CEREMONY"
replace loaneffectivereason2=. if loaneffectivereasondetails=="PUBRTY CEREMONY EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="RECONSTRUCT HOUSE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="RELATIEVES FUNCTION"
replace loaneffectivereason2=. if loaneffectivereasondetails=="RELATIEVES MARRIAGE EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="RELATION DEATH"
replace loaneffectivereason2=. if loaneffectivereasondetails=="RELATION FUNCTION"
replace loaneffectivereason2=. if loaneffectivereasondetails=="RELATION FUNERAL"
replace loaneffectivereason2=. if loaneffectivereasondetails=="RELATION MARRIAGE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="RELATIONS FUNERAL"
replace loaneffectivereason2=. if loaneffectivereasondetails=="RELATIVE DEATH"
replace loaneffectivereason2=. if loaneffectivereasondetails=="RELATIVE FUNCTION"
replace loaneffectivereason2=. if loaneffectivereasondetails=="RELATIVE FUNTION"
replace loaneffectivereason2=. if loaneffectivereasondetails=="RELATIVE MARRIAGE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="relatives ceremonies"
replace loaneffectivereason2=. if loaneffectivereasondetails=="RELATIVES DEATH EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="RELATIVES FESTIVALS"
replace loaneffectivereason2=. if loaneffectivereasondetails=="RELATIVES FESTIVALS EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="RELATIVES FUNCTION"
replace loaneffectivereason2=. if loaneffectivereasondetails=="RELATIVES FUNCTION EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="RELATIVES MARRIAGE EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="RENT FOR HOUSE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="REPAYMENT FOR PREVIOUS LOAN"
replace loaneffectivereason2=. if loaneffectivereasondetails=="REPAYMENT FOR PREVIOUS LOAN INTERESTS"
replace loaneffectivereason2=. if loaneffectivereasondetails=="REPAYMENT PREVIOUS LOAN"
replace loaneffectivereason2=. if loaneffectivereasondetails=="REPAYMENTFOR PREVIOUS LOAN"
replace loaneffectivereason2=. if loaneffectivereasondetails=="SETTLED LOAN"
replace loaneffectivereason2=. if loaneffectivereasondetails=="SHOP CONSTRUCTION EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="SISTER MARRIAGE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="SISTER PREGNANCY"
replace loaneffectivereason2=. if loaneffectivereasondetails=="SISTERS MARRIAGE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="SISTERS MARRIAGE EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="SON ACCIDENT TREATMENT EXPENS"
replace loaneffectivereason2=. if loaneffectivereasondetails=="SON EDUCATION"
replace loaneffectivereason2=. if loaneffectivereasondetails=="SON MARRIAGE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="SON MARRIAGE EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="SON PLACEMENT"
replace loaneffectivereason2=. if loaneffectivereasondetails=="SONS MARRIAGE EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="SONS MEDICAL EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="SUGARCANE EXP"
replace loaneffectivereason2=. if loaneffectivereasondetails=="SULAI PODA"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TEMPLE FESTIVAL"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TO BUILD HOUSE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TO BUY AGRI LAND"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TO BUY BIKE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TO BUY BULLOCART VEHICLE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TO BUY BULLOCK"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TO BUY COW"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TO BUY FUNITURE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TO BUY HOUSE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TO BUY LAND"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TO BUY LOAD CARRIER VEHICLE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TO BUY PLOT"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TO BUY TATA VEHICLE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TO BUY TRACTOR"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TO EXTEND OUR BUSINESS"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TO GIVE GIFT NEIBHOUR MARRIAGE FUNCTION"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TO GO ABROAD"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TO GO GULF"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TO MAKE BORE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TO REAIRING HOUSE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TO REBUILD HOUSE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TO REPAIR HOUSE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TO REPAIRE HOUSE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TO REPAIRING HOUSE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TO REPAYMENT FOR PREVIOUS LOAN"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TO REPAYMENT PREVIOUS LOAN"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TO SETTLE PREVIOUS LOAN"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TO SETTLE PREVIUOS LOAN"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TO SETTLE THE PREVIOUS LOAN"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TRACTOR"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TRACTOR LOAN"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TREATMENT"
replace loaneffectivereason2=. if loaneffectivereasondetails=="TREATMENT FOR DAUGHTER"
replace loaneffectivereason2=. if loaneffectivereasondetails=="VALAIKAPPU"
replace loaneffectivereason2=. if loaneffectivereasondetails=="VEHICLE MAINTANANCE"
replace loaneffectivereason2=. if loaneffectivereasondetails=="WEEDING"
replace loaneffectivereason2=. if loaneffectivereasondetails=="WIFE HEALTH EXPS"
replace loaneffectivereason2=. if loaneffectivereasondetails=="WIFE SISSTERS MARRIAGE EXP"

order loaneffectivereason loaneffectivereason2, before(loaneffectivereasondetails)
label values loaneffectivereason loanreasongiven
label values loaneffectivereason2 loanreasongiven


save "_temp\RUME-loans_v5.dta", replace
****************************************
* END






****************************************
* Main loan consistency 1 --> principal / balance
****************************************
use "_temp\RUME-loans_v5.dta", clear

gen totalrepaid=interestpaid+principalpaid
*keep if lendername!=""

tabstat loanamount loanbalance interestpaid principalpaid totalrepaid, stat(n mean sd p50)
/*
ML
   stats |  loanam~t  loanba~e  intere~d  princi~d  totalr~d
---------+--------------------------------------------------
       N |      1215      1215      1215      1215      1215
    mean |  24580.41  15755.73  3799.128  8824.685  12623.81
      sd |  44719.18  35216.43  7468.788  19808.96  25235.02
     p50 |     12000      8000      1215      2000      4500
------------------------------------------------------------



ALL
   stats |  loanam~t  loanba~e  intere~d  princi~d  totalr~d
---------+--------------------------------------------------
       N |      2396      2396      1215      1215      1215
    mean |  19555.52  12965.96  3799.128  8824.685  12623.81
      sd |  40804.95  34670.94  7468.788  19808.96  25235.02
     p50 |     10000      5000      1215      2000      4500
------------------------------------------------------------


*/

*1091 ML
*** Loan duration
gen loanduration_month=loanduration/30.4167

/*
Pb majeur:
Il manque des informations pour en vérifier d'autres
C-à-d. qu'on ne peut pas recalculer des informations à la 
main à partir d'autres
D'un côté - total des intérêts payés
D'un autre - montant des intérêt par semaine, mois jours
MAIS on n'a pas la fréquence
--> We cannot calculte interest paid..

Same with the amount:
We have the total repaid
We also have the frequency of the monthly/yearly repayment
BUT not the amount
--> We cannot calculate total repaid

We always need to mix diferent informations
We can only check 2 things:
- the duration
- consistency between total repaid, principal paid and interest paid

However, the duration also depends on total repaid principal paid...
The only double check is loanamount/loanbalance/totalrepaid/principalpaid/interestpaid

Lets first check the consistency between total repaid, principal paid, interest paid as the rest depends on these values.

However, loanamount - loanbalance, suppose to be principal paid, so lets begin with that


En fait non, 2 choses à faire:
Vérifier cohérence entre:
loanamount/loanbalance/principalpaid
Une fois OK, OK.

Vérifier cohérence entre:
interestloan/loanduration/interestpaid
Une fois OK, OK.

mettre en commun pour calculer totalrepaid
*/



********** Consistency 1 --> balance / principal
gen test1=loanamount-loanbalance-principalpaid
ta test1
/*
100% des cas c'est ok
*/
drop test1

save "_temp\RUME-loans_v6.dta", replace
****************************************
* END














****************************************
* Main loan consistency 2 --> interest loan / interest paid
****************************************
use "_temp\RUME-loans_v6.dta", clear

********** Consistency of interest loan / interestpaid
*** Gen interest loan per month
gen interestloan_month=.
replace interestloan_month=interestloan*4.3452 if interestfrequency==1  // weekly
replace interestloan_month=interestloan if interestfrequency==2  // monthly
replace interestloan_month=interestloan/12 if interestfrequency==3  // yearly
replace interestloan_month=interestloan/6 if interestfrequency==4  // once in six month

** PB AMOUNT: if interest loan * loan duration trop != de interestpaid
gen test1=.
replace test1=interestloan_month*loanduration_month if interestloan_month!=.
gen test2=.
replace test2=interestpaid-test1 if interestpaid!=.
gen pb1=0 if dummyinterest==1
replace pb1=1 if test1!=interestpaid & dummyinterest==1
ta pb1
/*
On calcul la borne max qu'ils ont payé: en étant super régulier et payant tel montant
on atteint pas ce qu'ils déclarent avoir payer en tout...

On accepte une erreur de 1000 roupies dans le calcul
*/
replace interestloan_month=interestpaid/loanduration_month if test2<1000 & test2!=. & test2>-1000
drop test1 test2 pb1
gen test1=.
replace test1=interestloan_month*loanduration_month if interestloan_month!=.
gen test2=.
replace test2=interestpaid-test1 if interestpaid!=.
gen pb1=0 if dummyinterest==1
replace pb1=1 if test1!=interestpaid & dummyinterest==1
ta pb1


sort test2
br HHID2010 loanid loansettled loanamount lender4 loanduration_month principalpaid interestpaid test1 test2 interestfrequency interestloan interestloan_month if pb1==1
/*
Le moins risqué c'est de garder le plus petit des deux
*/
replace interestpaid=interestloan_month*loanduration_month if test2>0 & (interestfrequency==1 | interestfrequency==2 | interestfrequency==3 | interestfrequency==4)
replace interestloan=interestpaid/loanduration_month if test2<=0 & (interestfrequency==1 | interestfrequency==2 | interestfrequency==3 | interestfrequency==4)
drop test2 test1 pb1

/*
Si on garde le plus grand
*/
*replace interestpaid=interestloan_month*loanduration_month if test2<=0 & (interestfrequency==1 | interestfrequency==2 | interestfrequency==3 | interestfrequency==4)
*replace interestloan=interestpaid/loanduration_month if test2>0 & (interestfrequency==1 | interestfrequency==2 | interestfrequency==3 | interestfrequency==4)
*drop test2 test1 pb1


********** Total repaid to gen
replace totalrepaid=principalpaid+interestpaid




tabstat loanamount loanbalance interestpaid principalpaid totalrepaid, stat(n mean sd p50)
/*
ML
   stats |  loanam~t  loanba~e  intere~d  princi~d  totalr~d
---------+--------------------------------------------------
       N |      1215      1215      1215      1215      1215
    mean |  24580.41  15755.73  3799.128  8824.685  12623.81
      sd |  44719.18  35216.43  7468.788  19808.96  25235.02
     p50 |     12000      8000      1215      2000      4500
------------------------------------------------------------


   stats |  loanam~t  loanba~e  intere~d  princi~d  totalr~d
---------+--------------------------------------------------
       N |      1215      1215      1211      1215      1211
    mean |  24580.41  15755.73  3691.221  8824.685  12545.05
      sd |  44719.18  35216.43   7461.42  19808.96  25256.77
     p50 |     12000      8000      1200      2000      4500
------------------------------------------------------------




ALL
   stats |  loanam~t  loanba~e  intere~d  princi~d  totalr~d
---------+--------------------------------------------------
       N |      2396      2396      1215      1215      1215
    mean |  19555.52  12965.96  3799.128  8824.685  12623.81
      sd |  40804.95  34670.94  7468.788  19808.96  25235.02
     p50 |     10000      5000      1215      2000      4500
------------------------------------------------------------

   stats |  loanam~t  loanba~e  intere~d  princi~d  totalr~d
---------+--------------------------------------------------
       N |      2396      2396      1211      1215      1211
    mean |  19555.52  12965.96  3691.221  8824.685  12545.05
      sd |  40804.95  34670.94   7461.42  19808.96  25256.77
     p50 |     10000      5000      1200      2000      4500
------------------------------------------------------------

*/

save "_temp\RUME-loans_v7.dta", replace
****************************************
* END
















****************************************
* Annual
****************************************
use "_temp\RUME-loans_v7.dta", clear

*****
*Arnaud test yrate
gen yratepaid=interestpaid*100/loanamount if loanduration<=365

gen _yratepaid=interestpaid*365/loanduration if loanduration>365
gen _loanamount=loanamount*365/loanduration if loanduration>365

replace yratepaid=_yratepaid*100/_loanamount if loanduration>365
drop _loanamount _yratepaid



tab yratepaid
sort yratepaid
*tab loanamount if loanamount<1000
*drop if loanamount<1000

tabstat yratepaid if interestpaid>0 & interestpaid!=., by(lender4) stat(n mean p50 min max)
gen monthlyinterestrate=.
replace monthlyinterestrate=yratepaid if loanduration<=30.4167
replace monthlyinterestrate=(yratepaid/loanduration)*30.4167 if loanduration>30.4167

tabstat monthlyinterestrate if interestpaid>0 & interestpaid!=., by(lender4) stat(n mean p50 min max)


*****
/*
ARNAUD BASE:
     lender4 |         N      mean       p50       min       max
-------------+--------------------------------------------------
         WKP |       316  45.53768        30  1.499985       720
   Relatives |       128  35.01362        25  .0033333       180
      Labour |        31  21.08602  21.66667         4        48
 Pawn broker |         1       100       100       100       100
 Shop keeper |         2        37        37        24        50
Moneylenders |        57  23.30901  11.57895        .5       300
     Friends |        13  29.46154        18         4        90
 Microcredit |       101  13.95773     9.152  .3073846        81
        Bank |        32  66.22486      11.5        .6  1676.471
    Neighbor |        30  41.88889        28       1.5       144
-------------+--------------------------------------------------
       Total |       711  36.84462        21  .0033333  1676.471
----------------------------------------------------------------


ARNAUD AFTER CLEAN:
     lender4 |         N      mean       p50       min       max
-------------+--------------------------------------------------
         WKP |       340  42.27391  27.14382  1.499985  657.8623
   Relatives |       134  32.78675      21.5  .0033333       180
      Labour |        31  21.08602  21.66667         4        48
 Pawn broker |         1       100       100       100       100
 Shop keeper |         2        37        37        24        50
Moneylenders |        58  24.22504  11.78947        .5       300
     Friends |        14      27.7        18         4        90
 Microcredit |       104  13.59651     9.125  .3073846        81
        Bank |        34  61.35638       9.5  .5170122  1676.471
    Neighbor |        30  40.76588        28  .1647121  128.4163
-------------+--------------------------------------------------
       Total |       748  34.90669        20  .0033333  1676.471
----------------------------------------------------------------


ELENA AFTER CLEAN:
     lender4 |         N      mean       p50       min       max
-------------+--------------------------------------------------
  Well known |       324  24.28248      21.6  1.463415     115.2
   Relatives |       129  18.83321  16.27119         2        60
      Labour |        31  18.42413  16.36364         5  41.14286
 Pawn broker |         1  23.07692  23.07692  23.07692  23.07692
 Shop keeper |         2  17.32692  17.32692      12.5  22.15385
Moneylenders |        58  27.50972        24  2.907692     79.68
     Friends |        14   20.2881  19.04895   .742268      43.2
 Microcredit |        98  15.63684    13.392     .4992        54
        Bank |        31  10.61372  10.28571        .9        32
    Neighbor |        32  22.23268  22.28572  2.727273  41.14286
-------------+--------------------------------------------------
       Total |       720  21.35884        18     .4992     115.2
----------------------------------------------------------------
*/









































****************************************
* ANNUALIZED
****************************************
use"_temp\RUME-loans_v7.dta", clear

*****
*Arnaud test yrate
gen yratepaid=interestpaid2*100/loanamount if loanduration<=365

gen _yratepaid=interestpaid2*365/loanduration if loanduration>365
gen _loanamount=loanamount*365/loanduration if loanduration>365

replace yratepaid=_yratepaid*100/_loanamount if loanduration>365
drop _loanamount _yratepaid

tab yratepaid
sort yratepaid
*tab loanamount if loanamount<1000
*drop if loanamount<1000

tabstat yratepaid if interestpaid2>0 & interestpaid2!=., by(lender4) stat(n mean p50 min max)
gen monthlyinterestrate=.
replace monthlyinterestrate=yratepaid if loanduration<=30.4167
replace monthlyinterestrate=(yratepaid/loanduration)*30.4167 if loanduration>30.4167

*****
/*
2010
     lender4 |         N      mean       p50       min       max
-------------+--------------------------------------------------
         WKP |       162   20.1878  15.19231       1.5  116.6667
   Relatives |       131   19.3611  15.55556  .2933333       108
      Labour |       120  18.50312        15         3        72
 Pawn broker |         2  94.48529  94.48529      12.5  176.4706
 Shop keeper |         1        18        18        18        18
Moneylenders |        37  29.88986        21         3       150
     Friends |        15  14.89524        15         3        35
 Microcredit |        51  14.28715  10.55556       1.2        60
        Bank |        13  11.25972  6.993007       1.8        30
    Neighbor |       260  21.72951        18      1.75        96
-------------+--------------------------------------------------
       Total |       792  20.31328      17.5  .2933333  176.4706
----------------------------------------------------------------

*/

save"_temp\RUME-loans_v8.dta", replace
*************************************
* END















****************************************
* IMPUTATION
****************************************
use"_temp\RUME-loans_v8.dta", clear

*** Add income
*preserve
*use"RUME-HH_v7.dta", clear
*duplicates drop HHID2010, force
*keep HHID2010 annualincome_HH
*save"RUME-HH_annualincome.dta", replace
*restore
*merge m:1 HHID using "RUME-HH_annualincome.dta", keepusing(annualincome_HH)
*drop if _merge==2
*drop _merge

*** Debt service pour ML
gen debt_service=.
replace debt_service=totalrepaid2 if loanduration<=365
replace debt_service=totalrepaid2*365/loanduration if loanduration>365
replace debt_service=0 if loanduration==0 & totalrepaid2==0 | loanduration==0 & totalrepaid2==.



*** Interest service pour ML
gen interest_service=.
replace interest_service=interestpaid2 if loanduration<=365
replace interest_service=interestpaid2*365/loanduration if loanduration>365
replace interest_service=0 if loanduration==0 & totalrepaid2==0 | loanduration==0 & totalrepaid2==.
replace interest_service=0 if dummyinterest==0 & interestpaid2==0 | dummyinterest==0 & interestpaid2==.



*** Imputation du principal
gen imp_principal=.
replace imp_principal=loanamount-loanbalance if loanduration<=365 & debt_service==.
replace imp_principal=(loanamount-loanbalance)*365/loanduration if loanduration>365 & debt_service==.




*** Imputation interest for moneylenders and microcredit
gen imp1_interest=.
replace imp1_interest=0.299*loanamount if lender4==6 & loanduration<=365 & debt_service==.
replace imp1_interest=0.299*loanamount*365/loanduration if lender4==6 & loanduration>365 & debt_service==.
replace imp1_interest=0.149*loanamount if lender4==8 & loanduration<=365 & debt_service==.
replace imp1_interest=0.149*loanamount*365/loanduration if lender4==8 & loanduration>365 & debt_service==.
replace imp1_interest=0 if lender4!=6 & lender4!=8 & debt_service==. & loandate!=.




*** Imputation total
gen imp1_totalrepaid_year=imp_principal+imp1_interest



*** Calcul service de la dette pour tout
gen imp1_debt_service=debt_service
replace imp1_debt_service=imp1_totalrepaid_year if debt_service==.
replace imp1_debt_service=. if loansettled==1


*** Calcul service des interets pour tout
gen imp1_interest_service=interest_service
replace imp1_interest_service=imp1_interest if interest_service==.
replace imp1_interest_service=. if loansettled==1


save"_temp\RUME-loans_v9.dta", replace
*************************************
* END













****************************************
* Other measure
****************************************
use"_temp\RUME-loans_v9.dta", clear


********** Loanlender
fre loanlender lender4

ta loanlender, gen(loanlender_)
rename loanlender_1 lender_WKP
rename loanlender_2 lender_rela
rename loanlender_3 lender_empl
rename loanlender_4 lender_mais
rename loanlender_5 lender_coll
rename loanlender_6 lender_pawn
rename loanlender_7 lender_shop
rename loanlender_8 lender_fina
rename loanlender_9 lender_frie
rename loanlender_10 lender_SHG
rename loanlender_11 lender_bank
rename loanlender_12 lender_coop
rename loanlender_13 lender_suga

ta lender4, gen(lender_)
rename lender_1 lender4_WKP
rename lender_2 lender4_rela
rename lender_3 lender4_labo
rename lender_4 lender4_pawn
rename lender_5 lender4_shop
rename lender_6 lender4_mone
rename lender_7 lender4_frie
rename lender_8 lender4_micr
rename lender_9 lender4_bank
rename lender_10 lender4_neig

ta lender_cat, gen(lendercat_)
rename lendercat_1 lendercat_info
rename lendercat_2 lendercat_semi
rename lendercat_3 lendercat_form



* Amount
foreach x in WKP rela empl mais coll pawn shop fina frie SHG bank coop suga {
gen lenderamt_`x'=loanamount if lender_`x'==1
}
foreach x in WKP rela labo pawn shop mone frie micr bank neig {
gen lender4amt_`x'=loanamount if lender4_`x'==1
}
foreach x in info semi form {
gen lendercatamt_`x'=loanamount if lendercat_`x'==1
}


********** Reason given
fre loanreasongiven
ta loanreasongiven, gen(loanreasongiven_)
rename loanreasongiven_1 given_agri
rename loanreasongiven_2 given_fami
rename loanreasongiven_3 given_heal
rename loanreasongiven_4 given_repa
rename loanreasongiven_5 given_hous
rename loanreasongiven_6 given_inve
rename loanreasongiven_7 given_cere
rename loanreasongiven_8 given_marr
rename loanreasongiven_9 given_educ
rename loanreasongiven_10 given_rela
rename loanreasongiven_11 given_deat

*Amt
foreach x in agri fami heal repa hous inve cere marr educ rela deat {
gen givenamt_`x'=loanamount if given_`x'==1
}



********** Reason given 2
fre reason_cat
ta reason_cat, gen(loanreasoncat_)
rename loanreasoncat_1 givencat_econ
rename loanreasoncat_2 givencat_curr
rename loanreasoncat_3 givencat_huma
rename loanreasoncat_4 givencat_soci
rename loanreasoncat_5 givencat_hous

*Amt
foreach x in econ curr huma soci hous {
gen givencatamt_`x'=loanamount if givencat_`x'==1
}




********** Effective
fre loaneffectivereason
ta loaneffectivereason, gen(effective_)
rename effective_1 effective_agri
rename effective_2 effective_fami
rename effective_3 effective_heal
rename effective_4 effective_repa
rename effective_5 effective_hous
rename effective_6 effective_inve
rename effective_7 effective_cere
rename effective_8 effective_marr
rename effective_9 effective_educ
rename effective_10 effective_rela
rename effective_11 effective_deat


*Amt
foreach x in agri fami heal repa hous inve cere marr educ rela deat {
gen effectiveamt_`x'=loanamount if effective_`x'==1
}


********** Lender service
fre otherlenderservices

ta otherlenderservices, gen(othlendserv_)

rename othlendserv_1 othlendserv_poli
rename othlendserv_2 othlendserv_fina
rename othlendserv_3 othlendserv_guar
rename othlendserv_4 othlendserv_gene
rename othlendserv_5 othlendserv_othe
rename othlendserv_7 othlendserv_nrep

replace othlendserv_othe=1 if othlendserv_6==1


********** Guarantee
fre guarantee

ta guarantee, gen(guarantee_)

rename guarantee_1 guarantee_chit
rename guarantee_2 guarantee_shg
rename guarantee_3 guarantee_both
rename guarantee_4 guarantee_none






********** Borrower services
fre borrowerservices

ta borrowerservices, gen(borrservices_)

rename borrservices_1 borrservices_free
rename borrservices_2 borrservices_work
rename borrservices_3 borrservices_supp
*rename borrservices_4 borrservices_none
rename borrservices_4 borrservices_othe
rename borrservices_5 borrservices_nrep




********** Plan to repay
fre plantorepay1 plantorepay2 plantorepay3
gen plantorep_chit=0
gen plantorep_work=0
gen plantorep_migr=0
gen plantorep_asse=0
gen plantorep_inco=0
gen plantorep_borr=0
gen plantorep_noth=0
gen plantorep_othe=0
gen plantorep_nrep=0

replace plantorep_chit=1 if plantorepay1==1
replace plantorep_work=1 if plantorepay1==2
replace plantorep_migr=1 if plantorepay1==3
replace plantorep_asse=1 if plantorepay1==4
replace plantorep_inco=1 if plantorepay1==5
replace plantorep_borr=1 if plantorepay1==6
replace plantorep_noth=1 if plantorepay1==7
replace plantorep_othe=1 if plantorepay1==77
replace plantorep_nrep=1 if plantorepay1==99

replace plantorep_chit=1 if plantorepay2==1
replace plantorep_work=1 if plantorepay2==2
replace plantorep_migr=1 if plantorepay2==3
replace plantorep_asse=1 if plantorepay2==4
replace plantorep_inco=1 if plantorepay2==5
replace plantorep_borr=1 if plantorepay2==6
replace plantorep_noth=1 if plantorepay2==7
replace plantorep_othe=1 if plantorepay2==77
replace plantorep_nrep=1 if plantorepay2==99

replace plantorep_chit=1 if plantorepay3==1
replace plantorep_work=1 if plantorepay3==2
replace plantorep_migr=1 if plantorepay3==3
replace plantorep_asse=1 if plantorepay3==4
replace plantorep_inco=1 if plantorepay3==5
replace plantorep_borr=1 if plantorepay3==6
replace plantorep_noth=1 if plantorepay3==7
replace plantorep_othe=1 if plantorepay3==77
replace plantorep_nrep=1 if plantorepay3==99



/*
********** Settle loan strategy
ta settleloanstrategy
gen settlestrat_inco=0
gen settlestrat_sche=0
gen settlestrat_borr=0
gen settlestrat_sell=0
gen settlestrat_land=0
gen settlestrat_cons=0
gen settlestrat_addi=0
gen settlestrat_work=0
gen settlestrat_supp=0
gen settlestrat_harv=0
gen settlestrat_othe=0

replace settlestrat_inco=1 if strpos(settleloanstrategy,"1")
replace settlestrat_sche=1 if strpos(settleloanstrategy,"2")
replace settlestrat_borr=1 if strpos(settleloanstrategy,"3")
replace settlestrat_sell=1 if strpos(settleloanstrategy,"4")
replace settlestrat_land=1 if strpos(settleloanstrategy,"5")
replace settlestrat_cons=1 if strpos(settleloanstrategy,"6")
replace settlestrat_addi=1 if strpos(settleloanstrategy,"7")
replace settlestrat_work=1 if strpos(settleloanstrategy,"8")
replace settlestrat_supp=1 if strpos(settleloanstrategy,"9")
replace settlestrat_harv=1 if strpos(settleloanstrategy,"10")
replace settlestrat_othe=1 if strpos(settleloanstrategy,"77")
*/



/*
********** Loan product pledge
ta loanproductpledge
gen prodpledge_gold=0
gen prodpledge_land=0
gen prodpledge_car=0
gen prodpledge_bike=0
gen prodpledge_frid=0
gen prodpledge_furn=0
gen prodpledge_tail=0
gen prodpledge_cell=0
gen prodpledge_line=0
gen prodpledge_dvd=0
gen prodpledge_came=0
gen prodpledge_gas=0
gen prodpledge_comp=0
gen prodpledge_dish=0
gen prodpledge_none=0
gen prodpledge_othe=0

replace prodpledge_gold=1 if strpos(loanproductpledge,"1")
replace prodpledge_land=1 if strpos(loanproductpledge,"2")
replace prodpledge_car=1 if strpos(loanproductpledge,"3")
replace prodpledge_bike=1 if strpos(loanproductpledge,"4")
replace prodpledge_frid=1 if strpos(loanproductpledge,"5")
replace prodpledge_furn=1 if strpos(loanproductpledge,"6") 
replace prodpledge_tail=1 if strpos(loanproductpledge,"7") 
replace prodpledge_cell=1 if strpos(loanproductpledge,"8") 
replace prodpledge_line=1 if strpos(loanproductpledge,"9")
replace prodpledge_dvd=1 if strpos(loanproductpledge,"10")
replace prodpledge_came=1 if strpos(loanproductpledge,"11")
replace prodpledge_gas=1 if strpos(loanproductpledge,"12")
replace prodpledge_comp=1 if strpos(loanproductpledge,"13")
replace prodpledge_dish=1 if strpos(loanproductpledge,"14")
replace prodpledge_none=1 if strpos(loanproductpledge,"15")
replace prodpledge_othe=1 if strpos(loanproductpledge,"77")
*/



*** Clean
gen year=2010
order HHID2010 year


save"outcomes\RUME-loans_mainloans_new.dta", replace
*************************************
* END










****************************************
* HH level
****************************************
use"outcomes\RUME-loans_mainloans_new.dta", clear



*
drop if loansettled==1



*** Indiv + HH level
bysort HHID2010: egen nbloans_HH=sum(1)
bysort HHID2010: egen loanamount_HH=sum(loanamount)




*** Services
bysort HHID2010: egen imp1_ds_tot_HH=sum(imp1_debt_service)
bysort HHID2010: egen imp1_is_tot_HH=sum(imp1_interest_service)




********** Individual and HH level for dummies
foreach x in lender_WKP lender_rela lender_empl lender_mais lender_coll lender_pawn lender_shop lender_fina lender_frie lender_SHG lender_bank lender_coop lender_suga lender4_WKP lender4_rela lender4_labo lender4_pawn lender4_shop lender4_mone lender4_frie lender4_micr lender4_bank lender4_neig lendercat_info lendercat_semi lendercat_form given_agri given_fami given_heal given_repa given_hous given_inve given_cere given_marr given_educ given_rela given_deat givencat_econ givencat_curr givencat_huma givencat_soci givencat_hous othlendserv_poli othlendserv_fina othlendserv_guar othlendserv_gene othlendserv_othe othlendserv_6 othlendserv_nrep guarantee_chit guarantee_shg guarantee_both guarantee_none borrservices_free borrservices_work borrservices_supp borrservices_othe borrservices_nrep plantorep_chit plantorep_work plantorep_migr plantorep_asse plantorep_inco plantorep_borr plantorep_noth plantorep_othe plantorep_nrep effective_agri effective_fami effective_heal effective_repa effective_hous effective_inve effective_cere effective_marr effective_educ effective_rela effective_deat {

bysort HHID2010: egen nbHH_`x'=sum(`x')
gen dumHH_`x'=0
replace dumHH_`x'=1 if nbHH_`x'>0
}


foreach x in lenderamt_WKP lenderamt_rela lenderamt_empl lenderamt_mais lenderamt_coll lenderamt_pawn lenderamt_shop lenderamt_fina lenderamt_frie lenderamt_SHG lenderamt_bank lenderamt_coop lenderamt_suga lender4amt_WKP lender4amt_rela lender4amt_labo lender4amt_pawn lender4amt_shop lender4amt_mone lender4amt_frie lender4amt_micr lender4amt_bank lender4amt_neig lendercatamt_info lendercatamt_semi lendercatamt_form givenamt_agri givenamt_fami givenamt_heal givenamt_repa givenamt_hous givenamt_inve givenamt_cere givenamt_marr givenamt_educ givenamt_rela givenamt_deat givencatamt_econ givencatamt_curr givencatamt_huma givencatamt_soci givencatamt_hous effectiveamt_agri effectiveamt_fami effectiveamt_heal effectiveamt_repa effectiveamt_hous effectiveamt_inve effectiveamt_cere effectiveamt_marr effectiveamt_educ effectiveamt_rela effectiveamt_deat {

bysort HHID2010: egen totHH_`x'=sum(`x')
}




*HH
preserve
duplicates drop HHID2010, force
keep HHID2010 nbloans_HH loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH nbHH_lender_WKP dumHH_lender_WKP nbHH_lender_rela dumHH_lender_rela nbHH_lender_empl dumHH_lender_empl nbHH_lender_mais dumHH_lender_mais nbHH_lender_coll dumHH_lender_coll nbHH_lender_pawn dumHH_lender_pawn nbHH_lender_shop dumHH_lender_shop nbHH_lender_fina dumHH_lender_fina nbHH_lender_frie dumHH_lender_frie nbHH_lender_SHG dumHH_lender_SHG nbHH_lender_bank dumHH_lender_bank nbHH_lender_coop dumHH_lender_coop nbHH_lender_suga dumHH_lender_suga nbHH_lender4_WKP dumHH_lender4_WKP nbHH_lender4_rela dumHH_lender4_rela nbHH_lender4_labo dumHH_lender4_labo nbHH_lender4_pawn dumHH_lender4_pawn nbHH_lender4_shop dumHH_lender4_shop nbHH_lender4_mone dumHH_lender4_mone nbHH_lender4_frie dumHH_lender4_frie nbHH_lender4_micr dumHH_lender4_micr nbHH_lender4_bank dumHH_lender4_bank nbHH_lender4_neig dumHH_lender4_neig nbHH_lendercat_info dumHH_lendercat_info nbHH_lendercat_semi dumHH_lendercat_semi nbHH_lendercat_form dumHH_lendercat_form nbHH_given_agri dumHH_given_agri nbHH_given_fami dumHH_given_fami nbHH_given_heal dumHH_given_heal nbHH_given_repa dumHH_given_repa nbHH_given_hous dumHH_given_hous nbHH_given_inve dumHH_given_inve nbHH_given_cere dumHH_given_cere nbHH_given_marr dumHH_given_marr nbHH_given_educ dumHH_given_educ nbHH_given_rela dumHH_given_rela nbHH_given_deat dumHH_given_deat nbHH_givencat_econ dumHH_givencat_econ nbHH_givencat_curr dumHH_givencat_curr nbHH_givencat_huma dumHH_givencat_huma nbHH_givencat_soci dumHH_givencat_soci nbHH_givencat_hous dumHH_givencat_hous nbHH_othlendserv_poli dumHH_othlendserv_poli nbHH_othlendserv_fina dumHH_othlendserv_fina nbHH_othlendserv_guar dumHH_othlendserv_guar nbHH_othlendserv_gene dumHH_othlendserv_gene nbHH_othlendserv_othe dumHH_othlendserv_othe nbHH_othlendserv_6 dumHH_othlendserv_6 nbHH_othlendserv_nrep dumHH_othlendserv_nrep nbHH_guarantee_chit dumHH_guarantee_chit nbHH_guarantee_shg dumHH_guarantee_shg nbHH_guarantee_both dumHH_guarantee_both nbHH_guarantee_none dumHH_guarantee_none nbHH_borrservices_free dumHH_borrservices_free nbHH_borrservices_work dumHH_borrservices_work nbHH_borrservices_supp dumHH_borrservices_supp nbHH_borrservices_othe dumHH_borrservices_othe nbHH_borrservices_nrep dumHH_borrservices_nrep nbHH_plantorep_chit dumHH_plantorep_chit nbHH_plantorep_work dumHH_plantorep_work nbHH_plantorep_migr dumHH_plantorep_migr nbHH_plantorep_asse dumHH_plantorep_asse nbHH_plantorep_inco dumHH_plantorep_inco nbHH_plantorep_borr dumHH_plantorep_borr nbHH_plantorep_noth dumHH_plantorep_noth nbHH_plantorep_othe dumHH_plantorep_othe nbHH_plantorep_nrep dumHH_plantorep_nrep totHH_lenderamt_WKP totHH_lenderamt_rela totHH_lenderamt_empl totHH_lenderamt_mais totHH_lenderamt_coll totHH_lenderamt_pawn totHH_lenderamt_shop totHH_lenderamt_fina totHH_lenderamt_frie totHH_lenderamt_SHG totHH_lenderamt_bank totHH_lenderamt_coop totHH_lenderamt_suga totHH_lender4amt_WKP totHH_lender4amt_rela totHH_lender4amt_labo totHH_lender4amt_pawn totHH_lender4amt_shop totHH_lender4amt_mone totHH_lender4amt_frie totHH_lender4amt_micr totHH_lender4amt_bank totHH_lender4amt_neig totHH_lendercatamt_info totHH_lendercatamt_semi totHH_lendercatamt_form totHH_givenamt_agri totHH_givenamt_fami totHH_givenamt_heal totHH_givenamt_repa totHH_givenamt_hous totHH_givenamt_inve totHH_givenamt_cere totHH_givenamt_marr totHH_givenamt_educ totHH_givenamt_rela totHH_givenamt_deat totHH_givencatamt_econ totHH_givencatamt_curr totHH_givencatamt_huma totHH_givencatamt_soci totHH_givencatamt_hous nbHH_effective_agri dumHH_effective_agri nbHH_effective_fami dumHH_effective_fami nbHH_effective_heal dumHH_effective_heal nbHH_effective_repa dumHH_effective_repa nbHH_effective_hous dumHH_effective_hous nbHH_effective_inve dumHH_effective_inve nbHH_effective_cere dumHH_effective_cere nbHH_effective_marr dumHH_effective_marr nbHH_effective_educ dumHH_effective_educ nbHH_effective_rela dumHH_effective_rela nbHH_effective_deat dumHH_effective_deat totHH_effectiveamt_agri totHH_effectiveamt_fami totHH_effectiveamt_heal totHH_effectiveamt_repa totHH_effectiveamt_hous totHH_effectiveamt_inve totHH_effectiveamt_cere totHH_effectiveamt_marr totHH_effectiveamt_educ totHH_effectiveamt_rela totHH_effectiveamt_deat
save"outcomes\RUME-loans_HH.dta", replace
restore

*************************************
* END
