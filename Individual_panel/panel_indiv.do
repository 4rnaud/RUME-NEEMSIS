cls
/*
-------------------------
Arnaud Natal
arnaud.natal@u-bordeaux.fr
June 11, 2021
-----
Indiv panel
-----

-------------------------
*/






****************************************
* INITIALIZATION
****************************************
clear all
macro drop _all
********** Path to folder "data" folder.
*global directory = "D:\Documents\_Thesis\_DATA\NEEMSIS2\DATA\APPEND"
*cd "$directory\CLEAN"

********** SSC to install
*ssc install dropmiss, replace
*ssc install fre, replace

/*
Les bases indiv2010 & indiv2016 sont les plus importantes car panel entre les deux pour les individus avec INDID_panel

Le but est donc de compléter ça avec les données 2020 sachant qu'une bonne partie est preload donc INDID2016 et INDID2020 doivent coller

*/

****************************************
* END







****************************************
* Nettoyage précédents pour 2010
****************************************
/*
replace INDID_panel=1 if HHID_panel=="ELA52" & INDID=="F3" & year==2010
replace INDID_panel=5 if HHID_panel=="ELA52" & INDID=="F1" & year==2010
replace INDID_panel=-95 if HHID_panel=="GOV47" & INDID=="F2" & year==2010
replace INDID_panel=-96 if HHID_panel=="GOV47" & INDID=="F3" & year==2010
replace INDID_panel=2 if HHID_panel=="GOV47" & INDID=="F4" & year==2010
replace INDID_panel=-95 if HHID_panel=="GOV48" & INDID=="F2" & year==2010
replace INDID_panel=-95 if HHID_panel=="GOV5" & INDID=="F2" & year==2010
replace INDID_panel=-96 if HHID_panel=="GOV5" & INDID=="F3" & year==2010
replace INDID_panel=-97 if HHID_panel=="GOV5" & INDID=="F4" & year==2010
replace INDID_panel=-95 if HHID_panel=="GOV9" & INDID=="F2" & year==2010
replace INDID_panel=-95 if HHID_panel=="KAR15" & INDID=="F6" & year==2010
replace INDID_panel=-95 if HHID_panel=="ELA13" & INDID=="F3" & year==2010
replace INDID_panel=-99 if HHID_panel=="ELA7" & INDID=="F1" & year==2010
replace INDID_panel=-99 if HHID_panel=="KUV10" & INDID=="F2" & year==2010
replace INDID_panel=-98 if HHID_panel=="KUV10" & INDID=="F3" & year==2010
replace INDID_panel=-97 if HHID_panel=="KUV10" & INDID=="F4" & year==2010
replace INDID_panel=-96 if HHID_panel=="KUV10" & INDID=="F5" & year==2010
replace INDID_panel=-95 if HHID_panel=="KUV10" & INDID=="F6" & year==2010
replace INDID_panel=-99 if HHID_panel=="KUV25" & INDID=="F2" & year==2010
replace INDID_panel=-98 if HHID_panel=="KUV25" & INDID=="F3" & year==2010
replace INDID_panel=-97 if HHID_panel=="KUV25" & INDID=="F4" & year==2010
replace INDID_panel=-99 if HHID_panel=="MANAM34" & INDID=="F2" & year==2010
replace INDID_panel=-99 if HHID_panel=="MANAM40" & INDID=="F3" & year==2010
*/
****************************************
* END





****************************************
* Nettoyage 2020
****************************************
/*
Il faut ouvrir indiv2020_temp créer avec les .do.
*/
cd"D:\Documents\_Thesis\_DATA\NEEMSIS2\DATA\APPEND\CLEAN"
use"indiv2020_temp.dta", clear


**********Cleaning
rename ego egoid
recode livinghome (2=1) (3=0) (4=0)
rename livinghome dummylivinghome
ta dummylivinghome
label define yes 0"No" 1"Yes"
label values dummylivinghome yes
gen database=3
destring sex, replace
destring age, replace



********** Relationshiptohead2020
fre relationshiptohead
tab relationshiptoheadother 

replace relationshiptohead=20 if HHID_panel=="SEM2" & name=="Priya/Nithya?"  // daughter daughter = grandchild or grandchild in law ?
replace relationshiptohead=21 if HHID_panel=="SEM29" & name=="Valli"  // brother's wife --> sister in law
replace relationshiptohead=21 if HHID_panel=="SEM29" & name=="Sheela"  // brother's wife --> sister in law
replace relationshiptohead=22 if relationshiptoheadother=="Huband"  // husband
replace relationshiptohead=22 if relationshiptoheadother=="Husband"  // husband
replace relationshiptohead=21 if relationshiptoheadother=="Sivakandan's wife"  // sister in law
replace relationshiptohead=23 if relationshiptoheadother=="Sivakandan's daughter"  // nephew, niece
replace relationshiptohead=24 if relationshiptoheadother=="Husband's brother"  // --> brother-in-law
replace relationshiptohead=23 if relationshiptoheadother=="Mangalakshmi is sumathi's younger sister's daughter. Mangalakshmi's parents were died so sumathi taking care of her."  // niece
replace relationshiptohead=21 if relationshiptoheadother=="Anbarasan's wife"  // sister in law
replace relationshiptohead=23 if relationshiptoheadother=="Anbarasan's son"  // nephew, niece
replace relationshiptohead=21 if relationshiptoheadother=="Sister in law"  // sister in law
replace relationshiptohead=21 if relationshiptoheadother=="Murugan's wife"  // sister in law
replace relationshiptohead=23 if relationshiptoheadother=="Murugan's son"  // nephew, niece
tab relationshiptohead if relationshiptoheadother!=""

*
recode relationshiptohead (20=18) (21=19) (22=2) (23=20) (24=21)
label define relationshiptohead 1"Head" 2"Wife/Husband" 3"Mother" 4"Father" 5"Son" 6"Daughter" 7"Son-in-law" 8"Daughter-in-law" 9"Sister" 10"Brother" 11"Mother-in-law" 12"Father-in-law" 13"Grandchild" 15"Grandfather" 16"Grandmother" 17"Cousin" 18"Grandchild-in-law" 19"Sister-in-law" 20"Niece/nephew" 21"Brother-in-law" 77"Other", replace
label values relationshiptohead relationshiptohead
tab relationshiptohead
label define sex 1"Male" 2"Female"
label values sex sex
drop relationshiptoheadother



**********Panel2020
clonevar INDID2016=INDID2020
tostring INDID2016, replace
foreach x in name sex age relationshiptohead dummylivinghome maritalstatus egoid {
rename `x' `x'2020
}
format %10.0g dummylivinghome2020


merge 1:m HHID_panel INDID2016 using "C:\Users\Arnaud\Documents\GitHub\RUME-NEEMSIS\Individual_panel\panel_indiv_2010_2016_wide"

order HHID_panel INDID_panel INDID2010 INDID2016 INDID2020 name2010 name2016 name2020 version_HH
drop year
sort HHID_panel INDID_panel
tab name2010
tab name2016
tab name2020


********** Etape 1: verif les merge
preserve
keep if _merge==3
*Ok
*Donc premiere partie du panel ok
drop INDID2010 name2010 sex2010 age2010 relationshiptohead2010 dummylivinghome2010
drop INDID2016 name2016 sex2016 age2016 relationshiptohead2016 dummylivinghome2016 maritalstatus2016 egoid2016
save"indiv2020_temp2", replace
restore



********** Etape 2: verif les autres
drop if _merge==3
preserve
gen ok2010=1 if name2010!=""
gen ok2016=1 if name2016!=""
gen ok2020=1 if name2020!=""

bysort HHID_panel: egen sum_ok2010=sum(ok2010)
bysort HHID_panel: egen sum_ok2016=sum(ok2016)
bysort HHID_panel: egen sum_ok2020=sum(ok2020)

replace sum_ok2010=1 if sum_ok2010>1
replace sum_ok2016=1 if sum_ok2016>1
replace sum_ok2020=1 if sum_ok2020>1

egen todrop=rowtotal(sum_ok2010 sum_ok2016 sum_ok2020)
drop ok2010 ok2016 ok2020
drop if todrop==1
drop if sum_ok2020==0
br  // regarder qui changer
restore
tab _merge
drop if _merge==2


*Modif car panel avec 2010
replace INDID_panel="Ind_1" if HHID_panel=="GOV10" & INDID2020=="1"
replace INDID_panel="Ind_4" if HHID_panel=="GOV47" & INDID2020=="2"
replace INDID_panel="Ind_1" if HHID_panel=="GOV5" & INDID2020=="1"
replace INDID_panel="Ind_1" if HHID_panel=="GOV9" & INDID2020=="1"
replace INDID_panel="Ind_1" if HHID_panel=="KUV10" & INDID2020=="1"
replace INDID_panel="Ind_1" if HHID_panel=="KUV25" & INDID2020=="1"
replace INDID_panel="Ind_5" if HHID_panel=="MANAM19" & INDID2020=="4"
replace INDID_panel="Ind_1" if HHID_panel=="MANAM19" & INDID2020=="1"
replace INDID_panel="Ind_6" if HHID_panel=="MANAM19" & INDID2020=="5"
replace INDID_panel="Ind_2" if HHID_panel=="MANAM19" & INDID2020=="2"
replace INDID_panel="Ind_4" if HHID_panel=="MANAM19" & INDID2020=="3"
replace INDID_panel="Ind_3" if HHID_panel=="MANAM34" & INDID2020=="1"
replace INDID_panel="Ind_1" if HHID_panel=="MANAM40" & INDID2020=="1"
replace INDID_panel="Ind_2" if HHID_panel=="MANAM40" & INDID2020=="2"
replace INDID_panel="Ind_6" if HHID_panel=="ORA25" & INDID2020=="17"
replace INDID_panel="Ind_5" if HHID_panel=="ORA25" & INDID2020=="16"
replace INDID_panel="Ind_1" if HHID_panel=="ORA37" & INDID2020=="1"
replace INDID_panel="Ind_2" if HHID_panel=="ORA37" & INDID2020=="2"

drop INDID2010 name2010 sex2010 age2010 relationshiptohead2010 dummylivinghome2010
drop INDID2016 name2016 sex2016 age2016 relationshiptohead2016 dummylivinghome2016 maritalstatus2016 egoid2016

append using "indiv2020_temp2"
drop _merge
save"indiv2020", replace
*erase "indiv2020_temp.dta"
*erase "indiv2020_temp2.dta"

********** Cleaning
use"indiv2020", clear

drop HHINDID

tab INDID2020 if INDID_panel==""
*ok

foreach x in INDID name egoid dummylivinghome sex age relationshiptohead maritalstatus {
rename `x'2020 `x'
}
gen year=2020

order year HHID_panel INDID_panel INDID name sex age relationshiptohead dummylivinghome maritalstatus egoid
drop version_HH database
save"indiv2020_v2", replace

append using "C:\Users\Arnaud\Documents\GitHub\RUME-NEEMSIS\Individual_panel\panel_indiv_2010_2016"
drop HHINDID
sort HHID_panel INDID_panel
tab year


********** Creation of id for new member
sort HHID_panel INDID_panel
split INDID_panel, p(_)
drop INDID_panel1
rename INDID_panel2 codeid
destring codeid, replace
bysort HHID_panel: egen max_codeid=max(codeid)

gen INDID2020=INDID if year==2020
destring INDID2020, replace

sort HHID_panel INDID2020

*Lets go
clonevar codeid_save=codeid
bysort HHID_panel codeid (INDID2020): gen n=_n
replace n=. if codeid!=.

replace codeid=max_codeid+n if codeid==.
drop max_codeid INDID2020 n
gen temp="Ind_"
egen INDID_panel_temp=concat(temp codeid)
drop temp codeid codeid_save
order HHID_panel INDID_panel INDID_panel_temp year
tab year
drop INDID_panel
rename INDID_panel_temp INDID_panel

save"C:\Users\Arnaud\Documents\GitHub\RUME-NEEMSIS\Individual_panel\panel_indiv_2010_2016_2020", replace

egen HHINDID=concat(HHID_panel INDID_panel), p(/)
reshape wide INDID name sex age relationshiptohead dummylivinghome maritalstatus egoid, i(HHINDID) j(year)
drop HHINDID
order HHID_panel INDID_panel INDID2010 INDID2016 INDID2020

save"C:\Users\Arnaud\Documents\GitHub\RUME-NEEMSIS\Individual_panel\panel_indiv_2010_2016_2020_wide", replace
****************************************
* END
