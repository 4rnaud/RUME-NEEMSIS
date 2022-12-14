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
global data = "NEEMSIS1-HH"
global loans = "NEEMSIS1-loans_mainloans"


********** Scheme
set scheme plotplain_v2
grstyle init
grstyle set plain, box nogrid

********** Deflate
*https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=IN
*(100/158) if year==2016
*(100/184) if year==2020









****************************************
* FINANCE
****************************************
use"$loans", clear
gen loan_database="FINANCE"
save "_temp\NEEMSIS1-loans_v2.dta", replace
****************************************
* END






****************************************
* GOLD
****************************************
use "$data", clear
keep HHID2016 INDID2016 egoid submissiondate goldamountpledge goldreasonpledge
gen loan_database="GOLD"

rename goldamountpledge loanamount
rename goldreasonpledge loanreasongiven
gen loanlender=6

keep if loanamount!=.

split loanreasongiven
destring loanreasongiven*, replace
tab loanreasongiven1 if loanreasongiven2==.

tab loanreasongiven if loanreasongiven2!=. & loanreasongiven3==.
tab loanreasongiven if loanreasongiven3!=. & loanreasongiven4==.


gen loanreasongivenOK=loanreasongiven1 if loanreasongiven2==.  // try to add loans 
replace loanreasongivenOK=loanreasongiven2 if loanreasongiven1==2 & loanreasongiven2==3 & loanreasongiven3==.  // 12
replace loanreasongivenOK=loanreasongiven2 if loanreasongiven1==2 & loanreasongiven2==4 & loanreasongiven3==.  // 9
replace loanreasongivenOK=loanreasongiven2 if loanreasongiven1==2 & loanreasongiven2==5 & loanreasongiven3==.  // 6
replace loanreasongivenOK=loanreasongiven2 if loanreasongiven1==2 & loanreasongiven2==7 & loanreasongiven3==.  // 11
replace loanreasongivenOK=loanreasongiven2 if loanreasongiven1==2 & loanreasongiven2==8 & loanreasongiven3==.  // 4
replace loanreasongivenOK=loanreasongiven2 if loanreasongiven1==2 & loanreasongiven2==9 & loanreasongiven3==.  // 10
replace loanreasongivenOK=loanreasongiven2 if loanreasongiven1==2 & loanreasongiven2==10 & loanreasongiven3==.  // 3
replace loanreasongivenOK=loanreasongiven2 if loanreasongiven1==2 & loanreasongiven2==11 & loanreasongiven3==.  // 2
replace loanreasongivenOK=loanreasongiven1 if loanreasongiven1==7 & loanreasongiven2==12 & loanreasongiven3==.  // 1
replace loanreasongivenOK=loanreasongiven1 if loanreasongiven1==1 & loanreasongiven2==2 & loanreasongiven3==.  // 4
replace loanreasongivenOK=loanreasongiven2 if loanreasongiven1==3 & loanreasongiven2==7 & loanreasongiven3==.  // 4
replace loanreasongivenOK=loanreasongiven3 if loanreasongiven1==2 & loanreasongiven2==3 & loanreasongiven3==4 & loanreasongiven4==.  // 4

tab loanreasongivenOK, m
tab loanreasongiven if loanreasongivenOK==.
replace loanreasongivenOK=1 if loanreasongiven=="1 2 3"
replace loanreasongivenOK=1 if loanreasongiven=="1 2 3 5"
replace loanreasongivenOK=2 if loanreasongiven=="1 2 3 7 10"
replace loanreasongivenOK=4 if loanreasongiven=="1 2 4"
replace loanreasongivenOK=4 if loanreasongiven=="1 2 4 10 11"
replace loanreasongivenOK=1 if loanreasongiven=="1 2 5"
replace loanreasongivenOK=8 if loanreasongiven=="1 2 5 8"
replace loanreasongivenOK=7 if loanreasongiven=="1 2 7"
replace loanreasongivenOK=9 if loanreasongiven=="1 2 9"
replace loanreasongivenOK=10 if loanreasongiven=="1 2 9 10 11"
replace loanreasongivenOK=1 if loanreasongiven=="1 3 5 7"
replace loanreasongivenOK=1 if loanreasongiven=="1 5"
replace loanreasongivenOK=1 if loanreasongiven=="1 5 9"
replace loanreasongivenOK=6 if loanreasongiven=="1 6"
replace loanreasongivenOK=8 if loanreasongiven=="1 8"
replace loanreasongivenOK=1 if loanreasongiven=="1 9"
replace loanreasongivenOK=2 if loanreasongiven1==2 & loanreasongivenOK==.
replace loanreasongivenOK=3 if loanreasongiven1==3 & loanreasongivenOK==.
replace loanreasongivenOK=4 if loanreasongiven1==4 & loanreasongivenOK==.
replace loanreasongivenOK=5 if loanreasongiven1==5 & loanreasongivenOK==.
replace loanreasongivenOK=6 if loanreasongiven1==6 & loanreasongivenOK==.
replace loanreasongivenOK=7 if loanreasongiven1==7 & loanreasongivenOK==.

drop loanreasongiven1 loanreasongiven2 loanreasongiven3 loanreasongiven4 loanreasongiven5 loanreasongiven6 loanreasongiven

rename loanreasongivenOK loanreasongiven


*String and effective
clonevar loaneffectivereason=loanreasongiven
tostring loaneffectivereason, replace

** Append
append using "_temp\NEEMSIS1-loans_v2.dta"
mdesc
save "_temp\NEEMSIS1-loans_v3.dta", replace
****************************************
* END









****************************************
* MARRIAGE
****************************************
use "$data", clear
keep HHID2016 INDID2016 submissiondate marriageloanamount_wellknown marriageloanamount_banks marriageloanamount_coopbanks marriageloanamount_relatives marriageloanamount_employer marriageloanamount_maistry marriageloanamount_colleagues marriageloanamount_pawnbroker marriageloanamount_monlender marriageloanamount_friends
gen loan_database="MARRIAGE"

gen loanamount1=marriageloanamount_wellknown
gen loanreasongiven1=8 if loanamount1!=.
gen loanlender1=1 if loanamount1!=.

gen loanamount2=marriageloanamount_relatives
gen loanreasongiven2=8 if loanamount2!=.
gen loanlender2=2 if loanamount2!=.

gen loanamount3=marriageloanamount_employer
gen loanreasongiven3=8 if loanamount3!=.
gen loanlender3=3 if loanamount3!=.

gen loanamount4=marriageloanamount_maistry
gen loanreasongiven4=8 if loanamount4!=.
gen loanlender4=4 if loanamount4!=.

gen loanamount5=marriageloanamount_colleagues
gen loanreasongiven5=8 if loanamount5!=.
gen loanlender5=5 if loanamount5!=.

gen loanamount6=marriageloanamount_pawnbroker
gen loanreasongiven6=8 if loanamount6!=.
gen loanlender6=6 if loanamount6!=.

gen loanamount7=marriageloanamount_monlender
gen loanreasongiven7=8 if loanamount7!=.
gen loanlender7=8 if loanamount7!=.

gen loanamount8=marriageloanamount_friends
gen loanreasongiven8=8 if loanamount8!=.
gen loanlender8=9 if loanamount8!=.

gen loanamount9=marriageloanamount_banks
gen loanreasongiven9=8 if loanamount9!=.
gen loanlender9=11 if loanamount9!=.

gen loanamount10=marriageloanamount_coopbanks
gen loanreasongiven10=8 if loanamount10!=.
gen loanlender10=12 if loanamount10!=.

gen modmar=1 if loanreasongiven1==8
foreach num of numlist 2(1)10{
replace modmar=1 if loanreasongiven`num'==8
}

drop marriageloanamount_wellknown marriageloanamount_banks marriageloanamount_coopbanks marriageloanamount_relatives marriageloanamount_employer marriageloanamount_maistry marriageloanamount_colleagues marriageloanamount_pawnbroker marriageloanamount_monlender marriageloanamount_friends


reshape long loanamount loanreasongiven loanlender, i(HHID2016 INDID2016)  j(num)
keep if loanamount!=.
drop modmar

clonevar loaneffectivereason=loanreasongiven
tostring loaneffectivereason, replace

append using "_temp\NEEMSIS1-loans_v3.dta"

gen year=2016


save "_temp\NEEMSIS1-loans_v4.dta", replace
****************************************
* END
















****************************************
* CAT VAR
****************************************
use"_temp\NEEMSIS1-loans_v4.dta", clear


*** Change date format of submissiondate
preserve
use "$data", clear
duplicates drop HHID2016, force
keep HHID2016 submissiondate
save"_temp\NEEMSIS1-HH_date.dta", replace
restore

drop submissiondate
merge m:1 HHID2016 using "_temp\NEEMSIS1-HH_date.dta", keepusing(submissiondate)
keep if _merge==3
drop _merge
rename submissiondate submissiondate_o
gen submissiondate=dofc(submissiondate_o)
format submissiondate %td



*** Loan duration
gen loanduration=submissiondate-loandate
replace loanduration=1 if loanduration<1




*** Type of loan
gen lender_cat=.
label define lender_cat 1"Informal" 2"Semi formal" 3"Formal"
label values lender_cat lender_cat

foreach i in 1 2 3 4 5 7 9 13{
replace lender_cat=1 if loanlender==`i'
}
foreach i in 6 10{
replace lender_cat=2 if loanlender==`i'
}
foreach i in 8 11 12 14{
replace lender_cat=3 if loanlender==`i'
}
fre lender_cat



*** Purpose of loan
label define loanreasongiven 1"Agriculture" 2"Family" 3"Health" 4"Repay previous loan" 5"House expenses" 6"Investment" 7"Ceremonies" 8"Marriage" 9"Education" 10"Relatives" 11"Death" 12"No reason" 77"Other", replace
label values loanreasongiven loanreasongiven
tab loanreasongiven

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

save"_temp\NEEMSIS1-loans_v5.dta", replace
****************************************
* END















****************************************
* NEW LENDER VAR
****************************************
use "_temp\NEEMSIS1-loans_v5.dta", clear
fre loanlender


***Recode loanlender pour que les intérêts soient plus justes
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
gen lender3=lender2
replace lender3=2 if lenderrelation=="2" | lenderrelation=="2 3" | lenderrelation=="2 5"  // Relatives
replace lender3=3 if lenderrelation=="1" |lenderrelation=="1 5"| lenderrelation=="1 7" |lenderrelation=="1 8" | lenderrelation=="1 8 10" | lenderrelation=="1 9"  // labour
replace lender3=7 if lenderrelation=="10" | lenderrelation=="3 10"  // Friends
replace lender3=8 if lenderrelation=="11" | lenderrelation=="6"  // SHG & group finance
replace lender3=10 if lenderrelation=="5" | lenderrelation=="5 8"  // New var: Neighbor
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

save "_temp\NEEMSIS1-loans_v6.dta", replace
****************************************
* END











****************************************
* Main loan consistency 1 --> principal / balance
****************************************
use "_temp\NEEMSIS1-loans_v6.dta", clear

********** Creation
gen corr=0
foreach x in loanamount loanbalance interestpaid totalrepaid principalpaid interestloan {
gen `x'2=`x'
}
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


********** Consistency loanamount
sort loanamount
br HHID2016 INDID2016 loanid loan_database loansettled lender4 loanreasongiven loanamount2 loanbalance2 totalrepaid2 principalpaid2 interestpaid2 interestfrequency interestloan2 termsofrepayment repayduration1 repayduration2 

replace loanamount2=20000 if HHID2016=="uuid:abefe76f-bf58-4b71-ab71-1d64a7a33c5e" & INDID2016==1 & loanid==1
replace loanbalance2=2000 if HHID2016=="uuid:abefe76f-bf58-4b71-ab71-1d64a7a33c5e" & INDID2016==1 & loanid==1
replace corr=1 if HHID2016=="uuid:abefe76f-bf58-4b71-ab71-1d64a7a33c5e" & INDID2016==1 & loanid==1


replace loanamount2=6800 if HHID2016=="uuid:d4ece943-b0c3-457c-8328-68333afaab41" & INDID2016==1 & loanid==1
replace loanbalance2=6800 if HHID2016=="uuid:d4ece943-b0c3-457c-8328-68333afaab41" & INDID2016==1 & loanid==1
replace corr=1 if HHID2016=="uuid:d4ece943-b0c3-457c-8328-68333afaab41" & INDID2016==1 & loanid==1


replace loanamount2=5500 if HHID2016=="uuid:9020eaf9-2e69-421d-8c8f-b5bbc44b310c" & INDID2016==3 & loanid==1
replace loanbalance2=5500 if HHID2016=="uuid:9020eaf9-2e69-421d-8c8f-b5bbc44b310c" & INDID2016==3 & loanid==1
replace corr=1 if HHID2016=="uuid:9020eaf9-2e69-421d-8c8f-b5bbc44b310c" & INDID2016==3 & loanid==1



********** Consistency 1 --> balance / principal
gen test1=loanamount2-loanbalance2-principalpaid2
ta test1
/*
87% des cas c'est ok

For those with pb check interest + principal as total
*/
gen test2=totalrepaid2-principalpaid2-interestpaid2
ta test2 if test1<0
/*
10 cas à corriger
*/
sort test2
br HHID2016 INDID2016 loanid loan_database loansettled lender4 loanreasongiven loanduration_month test1 test2 loanamount2 loanbalance2 principalpaid2 interestpaid2 totalrepaid2 interestfrequency interestloan2 termsofrepayment repayduration1 repayduration2 if test1<0 & test2==8 

replace principalpaid2=0 if HHID2016=="uuid:da893017-2541-42dc-9dab-d517d777b92b" & INDID2016==1 & loanid==3
replace corr=1 if HHID2016=="uuid:da893017-2541-42dc-9dab-d517d777b92b" & INDID2016==1 & loanid==3

replace principalpaid2=0 if HHID2016=="uuid:9f650881-8382-48ff-8757-9f012a0dfe8f" & INDID2016==1 & loanid==1
replace corr=1 if HHID2016=="uuid:9f650881-8382-48ff-8757-9f012a0dfe8f" & INDID2016==1 & loanid==1

replace principalpaid2=0 if HHID2016=="uuid:b6802956-c0b6-442e-b416-73d9acd4d137" & INDID2016==1 & loanid==1
replace corr=1 if HHID2016=="uuid:b6802956-c0b6-442e-b416-73d9acd4d137" & INDID2016==1 & loanid==1

replace principalpaid2=0 if HHID2016=="uuid:d92d4760-c143-430d-848d-ae199496a356" & INDID2016==1 & loanid==2
replace corr=1 if HHID2016=="uuid:d92d4760-c143-430d-848d-ae199496a356" & INDID2016==1 & loanid==2

replace principalpaid2=0 if HHID2016=="uuid:390905c9-ee49-4e1e-8a4a-80e4741b7140" & INDID2016==1 & loanid==2
replace corr=1 if HHID2016=="uuid:390905c9-ee49-4e1e-8a4a-80e4741b7140" & INDID2016==1 & loanid==2

replace principalpaid2=0 if HHID2016=="uuid:d35fd473-8f07-437a-b6d2-b51962ac7c94" & INDID2016==1 & loanid==2
replace corr=1 if HHID2016=="uuid:d35fd473-8f07-437a-b6d2-b51962ac7c94" & INDID2016==1 & loanid==2

replace principalpaid2=0 if HHID2016=="uuid:8e0b0fc2-c75d-4646-a949-4c7749d6b3cc" & INDID2016==1 & loanid==1
replace corr=1 if HHID2016=="uuid:8e0b0fc2-c75d-4646-a949-4c7749d6b3cc" & INDID2016==1 & loanid==1

replace totalrepaid2=totalrepaid2-test2 if HHID2016=="uuid:e73b9bd7-f7f3-4ac0-b360-ffcd09758ff4" & INDID2016==1 & loanid==2
replace corr=1 if HHID2016=="uuid:e73b9bd7-f7f3-4ac0-b360-ffcd09758ff4" & INDID2016==1 & loanid==2

replace totalrepaid2=totalrepaid2-test2 if HHID2016=="uuid:230d6cc6-be41-4fee-b970-682dd4f70c10" & INDID2016==2 & loanid==1
replace corr=1 if HHID2016=="uuid:230d6cc6-be41-4fee-b970-682dd4f70c10" & INDID2016==2 & loanid==1

replace principalpaid2=5000 if HHID2016=="uuid:e73b9bd7-f7f3-4ac0-b360-ffcd09758ff4" & INDID2016==1 & loanid==1
replace corr=1 if HHID2016=="uuid:e73b9bd7-f7f3-4ac0-b360-ffcd09758ff4" & INDID2016==1 & loanid==1

replace interestpaid2=10400 if HHID2016=="uuid:390905c9-ee49-4e1e-8a4a-80e4741b7140" & INDID2016==1 & loanid==2
replace corr=1 if HHID2016=="uuid:390905c9-ee49-4e1e-8a4a-80e4741b7140" & INDID2016==1 & loanid==2


br HHID2016 INDID2016 loanid loan_database loansettled lender4 loanreasongiven loanduration_month test1 test2 loanamount2 loanbalance2 principalpaid2 interestpaid2 totalrepaid2 interestfrequency interestloan2 termsofrepayment repayduration1 repayduration2


replace loanamount2=150000 if HHID2016=="uuid:a049567e-1188-4e9a-8875-4dce306cffdf" & INDID2016==1 & loanid==1
replace loanbalance2=150000 if HHID2016=="uuid:a049567e-1188-4e9a-8875-4dce306cffdf" & INDID2016==1 & loanid==1
replace corr=1 if HHID2016=="uuid:a049567e-1188-4e9a-8875-4dce306cffdf" & INDID2016==1 & loanid==1



/*
To check, see consistency between amount and 
*/







sort HHID2016 INDID2016 loanid
list loanamount loanbalance totalrepaid principalpaid interestpaid interestloan if test1!=0 & test1!=., clean noobs
gen pb1=0
replace pb1=1 if test1!=0 & test1!=.
ta pb1
/*
137 loans with pb
We accept 1000 rs of error in the calculation of balance principal
as principal depends on other variables, I correct loanbalance
*/
replace loanbalance=loanamount-principalpaid if test1<=1000 & test1>=-1000
drop test1 pb1
gen test1=loanamount-loanbalance-principalpaid
ta test1
/*
89% des cas c'est ok
*/
gen pb1=0
replace pb1=1 if test1!=0 & test1!=.
ta pb1
/*
114 cas à corriger: 
Est-ce qu'on corrige loanbalance ou est ce qu'on corrige principalpaid?
Il faut vérifier
Pour ca on vérifie la cohérence du repayment pour voir si on prioise principalpaid ou loanbalance
*/

*** Monthly duration of repayment: Repay duration2
gen repayduration2_month=.
replace repayduration2_month=repayduration2/4.3452 if repayduration1==1  // weekly
replace repayduration2_month=repayduration2 if repayduration1==2  // monthly
replace repayduration2_month=repayduration2*12 if repayduration1==3  // yearly
replace repayduration2_month=repayduration2*6 if repayduration1==4  // once in six month

*** PB DURATION 1: if nb month repay > loan duration
gen pb2=0  if repayduration1!=5 & repayduration1!=.
replace pb2=1 if repayduration2_month>loanduration_month & repayduration1!=5 & repayduration1!=.
ta pb2
/*
Dans 73% des cas, la durée de remboursement est plus ancienne que le prêt.
Ex:
un prêt de 75 mois (6 ans), déclaré rembourser tous les ans, depuis 36 ans.
*/
sort HHID2016 INDID2016 loanid
br HHID2016 INDID2016 loanid loansettled loanamount lender4 loanduration_month loanbalance totalrepaid principalpaid test1 termsofrepayment repayduration1 repayduration2 repayduration2_month pb2 if pb1==1
/*
repay duration2 ne correspond jamais (que dans 20% des cas), alors pour traiter tout le monde à la même enseigne, on priorise loanbalance
*/
replace principalpaid=loanamount-loanbalance if pb1==1
drop test1 pb1 pb2


/*
Last point: if missing for principalpaid --> loanbalance
*/
replace principalpaid=loanamount-loanbalance if principalpaid==.
br HHID2016 INDID2016 loanid loansettled loanamount lender4 loanduration_month loanbalance totalrepaid principalpaid termsofrepayment repayduration1 repayduration2 repayduration2_month if principalpaid==.



save "_temp\NEEMSIS1-loans_v7.dta", replace
****************************************
* END














****************************************
* Main loan consistency 2 --> interest loan / interest paid
****************************************
use "_temp\NEEMSIS1-loans_v7.dta", clear


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
br HHID2016 INDID2016 loanid loansettled loanamount lender4 loanduration_month principalpaid interestpaid test1 test2 interestfrequency interestloan interestloan_month if pb1==1
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
       N |      1091      1091       735      1061      1089
    mean |  68144.35  49512.39  23407.65  16624.52  34111.59
      sd |  91941.52  70582.44  39390.65  44161.29  67751.17
     p50 |     40000     30000      9000         0     11832
------------------------------------------------------------

   stats |  loanam~t  loanba~e  intere~d  princi~d  totalr~d
---------+--------------------------------------------------
       N |      1091      1091       766      1091       766
    mean |  68144.35  49505.33  22391.64  18639.02  40947.87
      sd |  91941.52  70586.97  38933.03  52963.04   74352.7
     p50 |     40000     30000      8000         0     15000
------------------------------------------------------------




ALL
   stats |  loanam~t  loanba~e  intere~d  princi~d  totalr~d
---------+--------------------------------------------------
       N |      2349      1697       735      1061      1089
    mean |  65900.36  44470.59  23407.65  16624.52  34111.59
      sd |  89472.79  66157.78  39390.65  44161.29  67751.17
     p50 |     35000     22000      9000         0     11832
------------------------------------------------------------


   stats |  loanam~t  loanba~e  intere~d  princi~d  totalr~d
---------+--------------------------------------------------
       N |      2349      1697       766      1697       766
    mean |  65900.36  44466.05  22391.64  15272.99  40947.87
      sd |  89472.79  66160.54  38933.03  45843.44   74352.7
     p50 |     35000     22000      8000         0     15000
------------------------------------------------------------


*/

save "_temp\NEEMSIS1-loans_v8.dta", replace
****************************************
* END










****************************************
* Annual
****************************************
use "_temp\NEEMSIS1-loans_v8.dta", clear

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


sort monthlyinterestrate
br HHID2016 INDID2016 loanid loansettled loanamount loanbalance lender4 loanduration_month principalpaid interestpaid interestfrequency interestloan interestloan_month yratepaid monthlyinterestrate



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



********** Add income
merge m:1 HHID2016 using "outcomes\NEEMSIS1-occup_HH.dta", keepusing(annualincome_HH)
drop if _merge==2
drop _merge
replace annualincome_HH=20000 if annualincome_HH<20000



*** Debt service pour ML
gen debt_service=.
replace debt_service=totalrepaid if loanduration<=365
replace debt_service=totalrepaid*365/loanduration if loanduration>365
replace debt_service=0 if loanduration==0 & totalrepaid==0 | loanduration==0 & totalrepaid==.


*** Interest service pour ML
gen interest_service=.
replace interest_service=interestpaid if loanduration<=365
replace interest_service=interestpaid*365/loanduration if loanduration>365
replace interest_service=0 if loanduration==0 & totalrepaid==0 | loanduration==0 & totalrepaid==.
replace interest_service=0 if dummyinterest==0 & interestpaid==0 | dummyinterest==0 & interestpaid==.


*** Imputation du principal
gen imp_principal=.
replace imp_principal=loanamount-loanbalance if loanduration<=365 & debt_service==.
replace imp_principal=(loanamount-loanbalance)*365/loanduration if loanduration>365 & debt_service==.



*** Imputation interest for moneylenders and microcredit
gen imp1_interest=.
replace imp1_interest=0.31*loanamount if lender4==6 & loanduration<=365 & debt_service==.
replace imp1_interest=0.31*loanamount*365/loanduration if lender4==6 & loanduration>365 & debt_service==.
replace imp1_interest=0.16*loanamount if lender4==8 & loanduration<=365 & debt_service==.
replace imp1_interest=0.16*loanamount*365/loanduration if lender4==8 & loanduration>365 & debt_service==.
replace imp1_interest=0 if lender4!=6 & lender4!=8 & debt_service==. & loandate!=.




*** Imputation total
gen imp1_totalrepaid_year=imp_principal+imp1_interest




*** Calcul service de la dette pour tout
gen imp1_debt_service=debt_service
replace imp1_debt_service=imp1_totalrepaid_year if debt_service==.

replace imp1_debt_service=. if loansettled==1
replace imp1_debt_service=. if loan_database=="MARRIAGE"



*** Calcul service des interets pour tout
gen imp1_interest_service=interest_service
replace imp1_interest_service=imp1_interest if interest_service==.

replace imp1_interest_service=. if loansettled==1
replace imp1_interest_service=. if loan_database=="MARRIAGE"



*** Services
bysort HHID2016: egen imp1_ds_tot_HH=sum(imp1_debt_service)
bysort HHID2016: egen imp1_is_tot_HH=sum(imp1_interest_service)


gen dsr=imp1_ds_tot_HH/annualincome_HH
gen isr=imp1_is_tot_HH/annualincome_HH


keep HHID2016 dsr isr
duplicates drop



tabstat dsr isr, stat(n mean sd q p90 p95 p99 max)
drop if isr>2.9















****************************************
* ANNUALIZED
****************************************
use"_temp\NEEMSIS1-loans_v8.dta", clear

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

*/

save"_temp\NEEMSIS1-loans_v9.dta", replace
*************************************
* END
*/











****************************************
* MARRIAGE LOANS
****************************************
use"_temp\NEEMSIS1-loans_v9.dta", clear

/*
tab loan_database
tab loanreasongiven if loan_database=="FINANCE"
/*
Essayer bricolage pour en tenir compte quand même
Sur 1697 prêts, il y en a eu que 15 de remboursés..
Pourquoi sur les 300, il y en aurait beaucoup ?

1. Je regarde les durée des prêts pour mariage les plus longues : je prends la durée minimale des 25 % des prêts avec la durée la plus longue (ou la durée max des 75 % des prêts avec la durée la plus courte) --> Q3  
2. Je l'impute aux autres (en utilisant p90, je prends volontairement une durée haute afin de réduire le plus possible le remboursement mensuel. Je ne veux pas surestimer le phénomène, je cherche juste à tenir "un peu" compte des prêts pour mariages)
3. Je divise le montant du prêt par la durée pour avoir une sorte de remboursement mensuel
*/

********** 1. vérif de la durée des prêts
tabstat loanduration if loanreasongiven==8, stat(n mean sd p50 p75 p90 p95 p99 max) 
*1400 jours

********** 3. vérif du % repayé sur le montant du prêts
gen ratiotest=totalrepaid/loanamount
tabstat ratiotest if loanreasongiven==8, stat(n mean sd min p1 p5 p10 q p90 p95 p99 max)
*Je prends la valeur de Q1 ici pour réduire le montant au max --> 0.21

********** vérif les intérêts
tab loanlender if loanreasongiven==8
*informel = pas d'intérêts


********** Proba settled
preserve
use"NEEMSIS1-loans_v4.dta", clear
tab loanreasongiven loansettled
*3 sur 298 
dis 1-(3/298)
*disons 0.95
restore


********** Imputation
clonevar loanduration_wm=loanduration
clonevar totalrepaid2_wm=totalrepaid2
clonevar loanamount_wm=loanamount
clonevar loanbalance_wm=loanbalance
clonevar interestpaid2_wm=interestpaid2

replace loanamount=. if loan_database=="MARRIAGE"
replace loanbalance=. if loan_database=="MARRIAGE"


replace loanduration_wm=1400 if loan_database=="MARRIAGE"
replace totalrepaid2_wm=loanamount_wm*0.21*0.95 if loan_database=="MARRIAGE"
replace interestpaid2_wm=loanamount_wm*0.233*0.95 if loan_database=="MARRIAGE" & lender4==6
replace interestpaid2_wm=loanamount_wm*0.139*0.95 if loan_database=="MARRIAGE" & lender4==8
*/

save"_temp\NEEMSIS1-loans_v9-bis.dta", replace
*************************************
* END












****************************************
* IMPUTATION
****************************************
use"_temp\NEEMSIS1-loans_v9-bis.dta", clear


********** Add income
*merge m:1 HHID2016 INDID2016 using "NEEMSIS1-HH_v7.dta", keepusing(annualincome_indiv annualincome_HH)
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
replace imp1_interest=0.233*loanamount if lender4==6 & loanduration<=365 & debt_service==.
replace imp1_interest=0.233*loanamount*365/loanduration if lender4==6 & loanduration>365 & debt_service==.
replace imp1_interest=0.139*loanamount if lender4==8 & loanduration<=365 & debt_service==.
replace imp1_interest=0.139*loanamount*365/loanduration if lender4==8 & loanduration>365 & debt_service==.
replace imp1_interest=0 if lender4!=6 & lender4!=8 & debt_service==. & loandate!=.




*** Imputation total
gen imp1_totalrepaid_year=imp_principal+imp1_interest




*** Calcul service de la dette pour tout
gen imp1_debt_service=debt_service
replace imp1_debt_service=imp1_totalrepaid_year if debt_service==.

replace imp1_debt_service=. if loansettled==1
replace imp1_debt_service=. if loan_database=="MARRIAGE"



*** Calcul service des interets pour tout
gen imp1_interest_service=interest_service
replace imp1_interest_service=imp1_interest if interest_service==.

replace imp1_interest_service=. if loansettled==1
replace imp1_interest_service=. if loan_database=="MARRIAGE"

drop totalrepaid2 interestpaid2 principalpaid2


save"_temp\NEEMSIS1-loans_v10.dta", replace
*************************************
* END










****************************************
* Other measures with dummies, share and amount
****************************************
use"_temp\NEEMSIS1-loans_v10.dta", clear



********** Loanlender
label define loanlender 1"WKP" 2"Relatives" 3"Employer" 4"Maistry" 5"Colleague" 6"Pawn broker" 7"Shop keeper" 8"Finance (moneylenders)" 9"Friends" 10"SHG" 11"Banks" 12"Coop bank" 13"Sugar mill loan" 14"Group finance"
label values loanlender loanlender
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
rename loanlender_14 lender_grou

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
foreach x in WKP rela empl mais coll pawn shop fina frie SHG bank coop suga grou {
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
rename loanreasongiven_12 given_nore
rename loanreasongiven_13 given_othe

*Amt
foreach x in agri fami heal repa hous inve cere marr educ rela deat nore othe {
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
rename loanreasoncat_6 givencat_nore
rename loanreasoncat_7 givencat_othe

*Amt
foreach x in econ curr huma soci hous nore othe {
gen givencatamt_`x'=loanamount if givencat_`x'==1
}



********** Effective
fre loaneffectivereason
gen effective_agri=0
gen effective_fami=0
gen effective_heal=0
gen effective_repa=0
gen effective_hous=0
gen effective_inve=0
gen effective_cere=0
gen effective_marr=0
gen effective_educ=0
gen effective_rela=0
gen effective_deat=0
gen effective_nore=0
gen effective_othe=0

replace effective_agri=1 if strpos(loaneffectivereason,"1")
replace effective_fami=1 if strpos(loaneffectivereason,"2")
replace effective_heal=1 if strpos(loaneffectivereason,"3")
replace effective_repa=1 if strpos(loaneffectivereason,"4")
replace effective_hous=1 if strpos(loaneffectivereason,"5")
replace effective_inve=1 if strpos(loaneffectivereason,"6")
replace effective_cere=1 if strpos(loaneffectivereason,"7")
replace effective_marr=1 if strpos(loaneffectivereason,"8")
replace effective_educ=1 if strpos(loaneffectivereason,"9")
replace effective_rela=1 if strpos(loaneffectivereason,"10")
replace effective_deat=1 if strpos(loaneffectivereason,"11")
replace effective_nore=1 if strpos(loaneffectivereason,"12")
replace effective_othe=1 if strpos(loaneffectivereason,"77")


*Amt
foreach x in agri fami heal repa hous inve cere marr educ rela deat nore othe {
gen effectiveamt_`x'=loanamount if effective_`x'==1
}

********** Lender service
tab otherlenderservices
gen othlendserv_poli=0
gen othlendserv_fina=0
gen othlendserv_guar=0
gen othlendserv_gene=0
gen othlendserv_none=0
gen othlendserv_othe=0
replace othlendserv_poli=1 if strpos(otherlenderservices,"1")
replace othlendserv_fina=1 if strpos(otherlenderservices,"2")
replace othlendserv_guar=1 if strpos(otherlenderservices,"3")
replace othlendserv_gene=1 if strpos(otherlenderservices,"4")
replace othlendserv_none=1 if strpos(otherlenderservices,"5")
replace othlendserv_othe=1 if strpos(otherlenderservices,"77")



********** Guarantee
ta guarantee
gen guarantee_doc=0
gen guarantee_chit=0
gen guarantee_shg=0
gen guarantee_pers=0
gen guarantee_jewe=0
gen guarantee_none=0
gen guarantee_othe=0

replace guarantee_doc=1 if strpos(guarantee,"1")
replace guarantee_chit=1 if strpos(guarantee,"2")
replace guarantee_shg=1 if strpos(guarantee,"3")
replace guarantee_pers=1 if strpos(guarantee,"4")
replace guarantee_jewe=1 if strpos(guarantee,"5")
replace guarantee_none=1 if strpos(guarantee,"6")
replace guarantee_othe=1 if strpos(guarantee,"77")





********** Borrower services
tab borrowerservices
gen borrservices_free=0
gen borrservices_work=0
gen borrservices_supp=0
gen borrservices_none=0
gen borrservices_othe=0
replace borrservices_free=1 if strpos(borrowerservices,"1")
replace borrservices_work=1 if strpos(borrowerservices,"2")
replace borrservices_supp=1 if strpos(borrowerservices,"3")
replace borrservices_none=1 if strpos(borrowerservices,"4")
replace borrservices_othe=1 if strpos(borrowerservices,"77")





********** Plan to repay
ta plantorepay
gen plantorep_chit=0
gen plantorep_work=0
gen plantorep_migr=0
gen plantorep_asse=0
gen plantorep_inco=0
gen plantorep_borr=0
gen plantorep_othe=0

replace plantorep_chit=1 if strpos(plantorepay,"1")
replace plantorep_work=1 if strpos(plantorepay,"2")
replace plantorep_migr=1 if strpos(plantorepay,"3")
replace plantorep_asse=1 if strpos(plantorepay,"4")
replace plantorep_inco=1 if strpos(plantorepay,"5")
replace plantorep_borr=1 if strpos(plantorepay,"6")
replace plantorep_othe=1 if strpos(plantorepay,"77")




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


*** Clean
drop egoid name jatis sex age villageid villageareaid householdid submissiondate_o

order HHID2016 INDID2016 year


save"outcomes\NEEMSIS1-loans_mainloans_new.dta", replace
*************************************
* END











****************************************
* Indiv and HH level
****************************************
use"outcomes\NEEMSIS1-loans_mainloans_new.dta", clear

*
drop if loansettled==1
drop if loan_database=="MARRIAGE"


*** Indiv + HH level
bysort HHID2016 INDID2016: egen nbloans_indiv=sum(1)
bysort HHID2016: egen nbloans_HH=sum(1)

bysort HHID2016 INDID2016: egen loanamount_indiv=sum(loanamount)
bysort HHID2016: egen loanamount_HH=sum(loanamount)




*** Services
bysort HHID2016 INDID2016: egen imp1_ds_tot_indiv=sum(imp1_debt_service)
bysort HHID2016 INDID2016: egen imp1_is_tot_indiv=sum(imp1_interest_service)

bysort HHID2016: egen imp1_ds_tot_HH=sum(imp1_debt_service)
bysort HHID2016: egen imp1_is_tot_HH=sum(imp1_interest_service)




********** Individual and HH level for dummies
foreach x in lender_WKP lender_rela lender_empl lender_mais lender_coll lender_pawn lender_shop lender_fina lender_frie lender_SHG lender_bank lender_coop lender_suga lender_grou lender4_WKP lender4_rela lender4_labo lender4_pawn lender4_shop lender4_mone lender4_frie lender4_micr lender4_bank lender4_neig given_agri given_fami given_heal given_repa given_hous given_inve given_cere given_marr given_educ given_rela given_deat given_nore given_othe givencat_econ givencat_curr givencat_huma givencat_soci givencat_hous givencat_nore givencat_othe effective_agri effective_fami effective_heal effective_repa effective_hous effective_inve effective_cere effective_marr effective_educ effective_rela effective_deat effective_nore effective_othe othlendserv_poli othlendserv_fina othlendserv_guar othlendserv_gene othlendserv_none othlendserv_othe guarantee_doc guarantee_chit guarantee_shg guarantee_pers guarantee_jewe guarantee_none guarantee_othe borrservices_free borrservices_work borrservices_supp borrservices_none borrservices_othe plantorep_chit plantorep_work plantorep_migr plantorep_asse plantorep_inco plantorep_borr plantorep_othe settlestrat_inco settlestrat_sche settlestrat_borr settlestrat_sell settlestrat_land settlestrat_cons settlestrat_addi settlestrat_work settlestrat_supp settlestrat_harv settlestrat_othe prodpledge_gold prodpledge_land prodpledge_car prodpledge_bike prodpledge_frid prodpledge_furn prodpledge_tail prodpledge_cell prodpledge_line prodpledge_dvd prodpledge_came prodpledge_gas prodpledge_comp prodpledge_dish prodpledge_none prodpledge_othe lendercat_semi lendercat_info lendercat_form  {

bysort HHID2016 INDID2016: egen nbindiv_`x'=sum(`x')
gen dumindiv_`x'=0
replace dumindiv_`x'=1 if nbindiv_`x'>0

bysort HHID2016: egen nbHH_`x'=sum(`x')
gen dumHH_`x'=0
replace dumHH_`x'=1 if nbHH_`x'>0
}



foreach x in lenderamt_WKP lenderamt_rela lenderamt_empl lenderamt_mais lenderamt_coll lenderamt_pawn lenderamt_shop lenderamt_fina lenderamt_frie lenderamt_SHG lenderamt_bank lenderamt_coop lenderamt_suga lenderamt_grou lender4amt_WKP lender4amt_rela lender4amt_labo lender4amt_pawn lender4amt_shop lender4amt_mone lender4amt_frie lender4amt_micr lender4amt_bank lender4amt_neig givenamt_agri givenamt_fami givenamt_heal givenamt_repa givenamt_hous givenamt_inve givenamt_cere givenamt_marr givenamt_educ givenamt_rela givenamt_deat givenamt_nore givenamt_othe givencatamt_econ givencatamt_curr givencatamt_huma givencatamt_soci givencatamt_hous givencatamt_nore givencatamt_othe lendercatamt_semi lendercatamt_info lendercatamt_form effectiveamt_agri effectiveamt_fami effectiveamt_heal effectiveamt_repa effectiveamt_hous effectiveamt_inve effectiveamt_cere effectiveamt_marr effectiveamt_educ effectiveamt_rela effectiveamt_deat effectiveamt_nore effectiveamt_othe {

bysort HHID2016 INDID2016: egen totindiv_`x'=sum(`x')

bysort HHID2016: egen totHH_`x'=sum(`x')
}



*Indiv
preserve
duplicates drop HHID2016 INDID2016, force
keep HHID2016 INDID2016 nbloans_indiv loanamount_indiv imp1_ds_tot_indiv imp1_is_tot_indiv nbindiv_lender_WKP dumindiv_lender_WKP nbindiv_lender_rela dumindiv_lender_rela nbindiv_lender_empl dumindiv_lender_empl nbindiv_lender_mais dumindiv_lender_mais nbindiv_lender_coll dumindiv_lender_coll nbindiv_lender_pawn dumindiv_lender_pawn nbindiv_lender_shop dumindiv_lender_shop nbindiv_lender_fina dumindiv_lender_fina nbindiv_lender_frie dumindiv_lender_frie nbindiv_lender_SHG dumindiv_lender_SHG nbindiv_lender_bank dumindiv_lender_bank nbindiv_lender_coop dumindiv_lender_coop nbindiv_lender_suga dumindiv_lender_suga nbindiv_lender_grou dumindiv_lender_grou nbindiv_lender4_WKP dumindiv_lender4_WKP nbindiv_lender4_rela dumindiv_lender4_rela nbindiv_lender4_labo dumindiv_lender4_labo nbindiv_lender4_pawn dumindiv_lender4_pawn nbindiv_lender4_shop dumindiv_lender4_shop nbindiv_lender4_mone dumindiv_lender4_mone nbindiv_lender4_frie dumindiv_lender4_frie nbindiv_lender4_micr dumindiv_lender4_micr nbindiv_lender4_bank dumindiv_lender4_bank nbindiv_lender4_neig dumindiv_lender4_neig nbindiv_given_agri dumindiv_given_agri nbindiv_given_fami dumindiv_given_fami nbindiv_given_heal dumindiv_given_heal nbindiv_given_repa dumindiv_given_repa nbindiv_given_hous dumindiv_given_hous nbindiv_given_inve dumindiv_given_inve nbindiv_given_cere dumindiv_given_cere nbindiv_given_marr dumindiv_given_marr nbindiv_given_educ dumindiv_given_educ nbindiv_given_rela dumindiv_given_rela nbindiv_given_deat dumindiv_given_deat nbindiv_given_nore dumindiv_given_nore nbindiv_given_othe dumindiv_given_othe nbindiv_givencat_econ dumindiv_givencat_econ nbindiv_givencat_curr dumindiv_givencat_curr nbindiv_givencat_huma dumindiv_givencat_huma nbindiv_givencat_soci dumindiv_givencat_soci nbindiv_givencat_hous dumindiv_givencat_hous nbindiv_givencat_nore dumindiv_givencat_nore nbindiv_givencat_othe dumindiv_givencat_othe nbindiv_effective_agri dumindiv_effective_agri nbindiv_effective_fami dumindiv_effective_fami nbindiv_effective_heal dumindiv_effective_heal nbindiv_effective_repa dumindiv_effective_repa nbindiv_effective_hous dumindiv_effective_hous nbindiv_effective_inve dumindiv_effective_inve nbindiv_effective_cere dumindiv_effective_cere nbindiv_effective_marr dumindiv_effective_marr nbindiv_effective_educ dumindiv_effective_educ nbindiv_effective_rela dumindiv_effective_rela nbindiv_effective_deat dumindiv_effective_deat nbindiv_effective_nore dumindiv_effective_nore nbindiv_effective_othe dumindiv_effective_othe nbindiv_othlendserv_poli dumindiv_othlendserv_poli nbindiv_othlendserv_fina dumindiv_othlendserv_fina nbindiv_othlendserv_guar dumindiv_othlendserv_guar nbindiv_othlendserv_gene dumindiv_othlendserv_gene nbindiv_othlendserv_none dumindiv_othlendserv_none nbindiv_othlendserv_othe dumindiv_othlendserv_othe nbindiv_guarantee_doc dumindiv_guarantee_doc nbindiv_guarantee_chit dumindiv_guarantee_chit nbindiv_guarantee_shg dumindiv_guarantee_shg nbindiv_guarantee_pers dumindiv_guarantee_pers nbindiv_guarantee_jewe dumindiv_guarantee_jewe nbindiv_guarantee_none dumindiv_guarantee_none nbindiv_guarantee_othe dumindiv_guarantee_othe nbindiv_borrservices_free dumindiv_borrservices_free nbindiv_borrservices_work dumindiv_borrservices_work nbindiv_borrservices_supp dumindiv_borrservices_supp nbindiv_borrservices_none dumindiv_borrservices_none nbindiv_borrservices_othe dumindiv_borrservices_othe nbindiv_plantorep_chit dumindiv_plantorep_chit nbindiv_plantorep_work dumindiv_plantorep_work nbindiv_plantorep_migr dumindiv_plantorep_migr nbindiv_plantorep_asse dumindiv_plantorep_asse nbindiv_plantorep_inco dumindiv_plantorep_inco nbindiv_plantorep_borr dumindiv_plantorep_borr nbindiv_plantorep_othe dumindiv_plantorep_othe nbindiv_settlestrat_inco dumindiv_settlestrat_inco nbindiv_settlestrat_sche dumindiv_settlestrat_sche nbindiv_settlestrat_borr dumindiv_settlestrat_borr nbindiv_settlestrat_sell dumindiv_settlestrat_sell nbindiv_settlestrat_land dumindiv_settlestrat_land nbindiv_settlestrat_cons dumindiv_settlestrat_cons nbindiv_settlestrat_addi dumindiv_settlestrat_addi nbindiv_settlestrat_work dumindiv_settlestrat_work nbindiv_settlestrat_supp dumindiv_settlestrat_supp nbindiv_settlestrat_harv dumindiv_settlestrat_harv nbindiv_settlestrat_othe dumindiv_settlestrat_othe nbindiv_prodpledge_gold dumindiv_prodpledge_gold nbindiv_prodpledge_land dumindiv_prodpledge_land nbindiv_prodpledge_car dumindiv_prodpledge_car nbindiv_prodpledge_bike dumindiv_prodpledge_bike nbindiv_prodpledge_frid dumindiv_prodpledge_frid nbindiv_prodpledge_furn dumindiv_prodpledge_furn nbindiv_prodpledge_tail dumindiv_prodpledge_tail nbindiv_prodpledge_cell dumindiv_prodpledge_cell nbindiv_prodpledge_line dumindiv_prodpledge_line nbindiv_prodpledge_dvd dumindiv_prodpledge_dvd nbindiv_prodpledge_came dumindiv_prodpledge_came nbindiv_prodpledge_gas dumindiv_prodpledge_gas nbindiv_prodpledge_comp dumindiv_prodpledge_comp nbindiv_prodpledge_dish dumindiv_prodpledge_dish nbindiv_prodpledge_none dumindiv_prodpledge_none nbindiv_prodpledge_othe dumindiv_prodpledge_othe nbindiv_lendercat_semi dumindiv_lendercat_semi nbindiv_lendercat_info dumindiv_lendercat_info nbindiv_lendercat_form dumindiv_lendercat_form totindiv_lenderamt_WKP totindiv_lenderamt_rela totindiv_lenderamt_empl totindiv_lenderamt_mais totindiv_lenderamt_coll totindiv_lenderamt_pawn totindiv_lenderamt_shop totindiv_lenderamt_fina totindiv_lenderamt_frie totindiv_lenderamt_SHG totindiv_lenderamt_bank totindiv_lenderamt_coop totindiv_lenderamt_suga totindiv_lenderamt_grou totindiv_lender4amt_WKP totindiv_lender4amt_rela totindiv_lender4amt_labo totindiv_lender4amt_pawn totindiv_lender4amt_shop totindiv_lender4amt_mone totindiv_lender4amt_frie totindiv_lender4amt_micr totindiv_lender4amt_bank totindiv_lender4amt_neig totindiv_givenamt_agri totindiv_givenamt_fami totindiv_givenamt_heal totindiv_givenamt_repa totindiv_givenamt_hous totindiv_givenamt_inve totindiv_givenamt_cere totindiv_givenamt_marr totindiv_givenamt_educ totindiv_givenamt_rela totindiv_givenamt_deat totindiv_givenamt_nore totindiv_givenamt_othe totindiv_givencatamt_econ totindiv_givencatamt_curr totindiv_givencatamt_huma totindiv_givencatamt_soci totindiv_givencatamt_hous totindiv_givencatamt_nore totindiv_givencatamt_othe totindiv_lendercatamt_semi totindiv_lendercatamt_info totindiv_lendercatamt_form totindiv_effectiveamt_agri totindiv_effectiveamt_fami totindiv_effectiveamt_heal totindiv_effectiveamt_repa totindiv_effectiveamt_hous totindiv_effectiveamt_inve totindiv_effectiveamt_cere totindiv_effectiveamt_marr totindiv_effectiveamt_educ totindiv_effectiveamt_rela totindiv_effectiveamt_deat totindiv_effectiveamt_nore totindiv_effectiveamt_othe
save"outcomes\NEEMSIS1-loans_indiv.dta", replace
restore

*HH
preserve
duplicates drop HHID2016, force
keep HHID2016 nbloans_HH loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH nbHH_lender_WKP dumHH_lender_WKP nbHH_lender_rela dumHH_lender_rela nbHH_lender_empl dumHH_lender_empl nbHH_lender_mais dumHH_lender_mais nbHH_lender_coll dumHH_lender_coll nbHH_lender_pawn dumHH_lender_pawn nbHH_lender_shop dumHH_lender_shop nbHH_lender_fina dumHH_lender_fina nbHH_lender_frie dumHH_lender_frie nbHH_lender_SHG dumHH_lender_SHG nbHH_lender_bank dumHH_lender_bank nbHH_lender_coop dumHH_lender_coop nbHH_lender_suga dumHH_lender_suga nbHH_lender_grou dumHH_lender_grou nbHH_lender4_WKP dumHH_lender4_WKP nbHH_lender4_rela dumHH_lender4_rela nbHH_lender4_labo dumHH_lender4_labo nbHH_lender4_pawn dumHH_lender4_pawn nbHH_lender4_shop dumHH_lender4_shop nbHH_lender4_mone dumHH_lender4_mone nbHH_lender4_frie dumHH_lender4_frie nbHH_lender4_micr dumHH_lender4_micr nbHH_lender4_bank dumHH_lender4_bank nbHH_lender4_neig dumHH_lender4_neig nbHH_given_agri dumHH_given_agri nbHH_given_fami dumHH_given_fami nbHH_given_heal dumHH_given_heal nbHH_given_repa dumHH_given_repa nbHH_given_hous dumHH_given_hous nbHH_given_inve dumHH_given_inve nbHH_given_cere dumHH_given_cere nbHH_given_marr dumHH_given_marr nbHH_given_educ dumHH_given_educ nbHH_given_rela dumHH_given_rela nbHH_given_deat dumHH_given_deat nbHH_given_nore dumHH_given_nore nbHH_given_othe dumHH_given_othe nbHH_givencat_econ dumHH_givencat_econ nbHH_givencat_curr dumHH_givencat_curr nbHH_givencat_huma dumHH_givencat_huma nbHH_givencat_soci dumHH_givencat_soci nbHH_givencat_hous dumHH_givencat_hous nbHH_givencat_nore dumHH_givencat_nore nbHH_givencat_othe dumHH_givencat_othe nbHH_effective_agri dumHH_effective_agri nbHH_effective_fami dumHH_effective_fami nbHH_effective_heal dumHH_effective_heal nbHH_effective_repa dumHH_effective_repa nbHH_effective_hous dumHH_effective_hous nbHH_effective_inve dumHH_effective_inve nbHH_effective_cere dumHH_effective_cere nbHH_effective_marr dumHH_effective_marr nbHH_effective_educ dumHH_effective_educ nbHH_effective_rela dumHH_effective_rela nbHH_effective_deat dumHH_effective_deat nbHH_effective_nore dumHH_effective_nore nbHH_effective_othe dumHH_effective_othe nbHH_othlendserv_poli dumHH_othlendserv_poli nbHH_othlendserv_fina dumHH_othlendserv_fina nbHH_othlendserv_guar dumHH_othlendserv_guar nbHH_othlendserv_gene dumHH_othlendserv_gene nbHH_othlendserv_none dumHH_othlendserv_none nbHH_othlendserv_othe dumHH_othlendserv_othe nbHH_guarantee_doc dumHH_guarantee_doc nbHH_guarantee_chit dumHH_guarantee_chit nbHH_guarantee_shg dumHH_guarantee_shg nbHH_guarantee_pers dumHH_guarantee_pers nbHH_guarantee_jewe dumHH_guarantee_jewe nbHH_guarantee_none dumHH_guarantee_none nbHH_guarantee_othe dumHH_guarantee_othe nbHH_borrservices_free dumHH_borrservices_free nbHH_borrservices_work dumHH_borrservices_work nbHH_borrservices_supp dumHH_borrservices_supp nbHH_borrservices_none dumHH_borrservices_none nbHH_borrservices_othe dumHH_borrservices_othe nbHH_plantorep_chit dumHH_plantorep_chit nbHH_plantorep_work dumHH_plantorep_work nbHH_plantorep_migr dumHH_plantorep_migr nbHH_plantorep_asse dumHH_plantorep_asse nbHH_plantorep_inco dumHH_plantorep_inco nbHH_plantorep_borr dumHH_plantorep_borr nbHH_plantorep_othe dumHH_plantorep_othe nbHH_settlestrat_inco dumHH_settlestrat_inco nbHH_settlestrat_sche dumHH_settlestrat_sche nbHH_settlestrat_borr dumHH_settlestrat_borr nbHH_settlestrat_sell dumHH_settlestrat_sell nbHH_settlestrat_land dumHH_settlestrat_land nbHH_settlestrat_cons dumHH_settlestrat_cons nbHH_settlestrat_addi dumHH_settlestrat_addi nbHH_settlestrat_work dumHH_settlestrat_work nbHH_settlestrat_supp dumHH_settlestrat_supp nbHH_settlestrat_harv dumHH_settlestrat_harv nbHH_settlestrat_othe dumHH_settlestrat_othe nbHH_prodpledge_gold dumHH_prodpledge_gold nbHH_prodpledge_land dumHH_prodpledge_land nbHH_prodpledge_car dumHH_prodpledge_car nbHH_prodpledge_bike dumHH_prodpledge_bike nbHH_prodpledge_frid dumHH_prodpledge_frid nbHH_prodpledge_furn dumHH_prodpledge_furn nbHH_prodpledge_tail dumHH_prodpledge_tail nbHH_prodpledge_cell dumHH_prodpledge_cell nbHH_prodpledge_line dumHH_prodpledge_line nbHH_prodpledge_dvd dumHH_prodpledge_dvd nbHH_prodpledge_came dumHH_prodpledge_came nbHH_prodpledge_gas dumHH_prodpledge_gas nbHH_prodpledge_comp dumHH_prodpledge_comp nbHH_prodpledge_dish dumHH_prodpledge_dish nbHH_prodpledge_none dumHH_prodpledge_none nbHH_prodpledge_othe dumHH_prodpledge_othe nbHH_lendercat_semi dumHH_lendercat_semi nbHH_lendercat_info dumHH_lendercat_info nbHH_lendercat_form dumHH_lendercat_form totHH_lenderamt_WKP totHH_lenderamt_rela totHH_lenderamt_empl totHH_lenderamt_mais totHH_lenderamt_coll totHH_lenderamt_pawn totHH_lenderamt_shop totHH_lenderamt_fina totHH_lenderamt_frie totHH_lenderamt_SHG totHH_lenderamt_bank totHH_lenderamt_coop totHH_lenderamt_suga totHH_lenderamt_grou totHH_lender4amt_WKP totHH_lender4amt_rela totHH_lender4amt_labo totHH_lender4amt_pawn totHH_lender4amt_shop totHH_lender4amt_mone totHH_lender4amt_frie totHH_lender4amt_micr totHH_lender4amt_bank totHH_lender4amt_neig totHH_givenamt_agri totHH_givenamt_fami totHH_givenamt_heal totHH_givenamt_repa totHH_givenamt_hous totHH_givenamt_inve totHH_givenamt_cere totHH_givenamt_marr totHH_givenamt_educ totHH_givenamt_rela totHH_givenamt_deat totHH_givenamt_nore totHH_givenamt_othe totHH_givencatamt_econ totHH_givencatamt_curr totHH_givencatamt_huma totHH_givencatamt_soci totHH_givencatamt_hous totHH_givencatamt_nore totHH_givencatamt_othe totHH_lendercatamt_semi totHH_lendercatamt_info totHH_lendercatamt_form totHH_effectiveamt_agri totHH_effectiveamt_fami totHH_effectiveamt_heal totHH_effectiveamt_repa totHH_effectiveamt_hous totHH_effectiveamt_inve totHH_effectiveamt_cere totHH_effectiveamt_marr totHH_effectiveamt_educ totHH_effectiveamt_rela totHH_effectiveamt_deat totHH_effectiveamt_nore totHH_effectiveamt_othe
save"outcomes\NEEMSIS1-loans_HH.dta", replace
restore

*************************************
* END
