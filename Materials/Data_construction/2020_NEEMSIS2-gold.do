*-------------------------
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*-----
*Assets construction
*-----
*-------------------------

********** Clear
clear all
macro drop _all

********** Path to working directory directory
global directory = "C:\Users\Arnaud\Documents\Dropbox\RUME-NEEMSIS\Data\Construction"
cd"$directory"

********** Database names
global data = "NEEMSIS2-HH"

********** Scheme
set scheme plotplain_v2
grstyle init
grstyle set plain, box nogrid

********** Deflate
*https://data.worldbank.org/indicator/FP.CPI.TOTL?locations=IN
*(100/158) if year==2016
*(100/184) if year==2020



****************************************
* Gold 2020-21
***************************************
use"$data", clear

keep HHID2020 INDID2020 dummygold covsoldgold covsoldgoldquantity covlostgold dummygoldownerlist goldnumber goldquantity dummygoldpledged goldquantitypledge goldamountpledge covgoldpledged goldreasonpledge goldreasonpledgemain loanamountgold loandategold loanlendergold lenderscastegold lenderfromgold loansettledgold loanbalancegold


***** Save
gen goldquantity2=goldquantity
gen goldquantitypledge2=goldquantitypledge
gen goldamountpledge2=goldamountpledge
gen loanamountgold2=loanamountgold

ta HHID2020 if goldquantitypledge==140000



***** Cleaning Elena
g	unpledged_goldquantity=goldquantity - goldquantitypledge
ta unpledged
ta goldquantity goldquantitypledge if unpledged_g<0 
ta goldamountpledge if goldquantitypledge==140000
* 1 cas ou quantité et montant gagés ont été inversés (l inversion est cohérente avec loanamountgold)
replace goldquantitypledge2=48 if HHID2020=="uuid:3936b5d3-2709-4669-9986-9f427fac869a" & INDID2020==2
replace goldamountpledge2=140000 if HHID2020=="uuid:3936b5d3-2709-4669-9986-9f427fac869a" & INDID2020==2

g gold_rate=goldamountpledge2/goldquantitypledge2
ta gold_rate
su gold_rate, d

list HHID2020 INDID2020 goldquantity  goldquantitypledge2 goldamountpledge2  loanamountgold loanbalance gold_rate if unpledged_g<0, clean noobs
*la solution la plus "conservative" consiste à considérer que le goldquantity declaré correspond à unpledged gold au lieu de totalgold (sinon il faut soit multiplier par 8 en considérant que c'est des sovereign, bof)
recode goldquantity goldquantitypledge2 (.=0)
replace goldquantity2=goldquantity+goldquantitypledge2


*** check loanamountgold 
ta loanamountgold if goldamountpledge!=., mis
//66 peut etre soit une quantité,  soit une NR => vote pour le NR
replace loanamountgold2=goldamountpledge2 if HHID2020=="uuid:9bc0d4be-96cd-4d5e-aa71-98313b21905f" & INDID2020==2 //celui la est marqué missing dans le fichier all loans
//le 8 ici correspond probablement à la quantité
replace loanamountgold2=goldamountpledge2 if HHID2020=="uuid:435ed027-bac6-423b-ad03-8abc0e9aecf7" & INDID2020==1
//99 n est probablement pas une quantité;  on remplace par goldamountpledged
replace loanamountgold2=goldamountpledge2 if loanamountgold==99

// 24 loanamount ?
*br if HHID_panel=="ELA23" & INDID_panel=="Ind_2"
replace loanamountgold=goldamountpledge if HHID2020=="uuid:fb3e15f2-aede-49d5-8eee-514affc34b1a" & INDID2020==1
replace loanamountgold2=loanamountgold if HHID2020=="uuid:fb3e15f2-aede-49d5-8eee-514affc34b1a" & INDID2020==1

// 48
*br if HHID_panel=="SEM23" & INDID_panel=="Ind_2"
replace loanamountgold=goldamountpledge if HHID2020=="uuid:f93966cd-7487-4ab9-992a-a61437b648ff" & INDID2020==2
replace loanamountgold2=loanamountgold if HHID2020=="uuid:f93966cd-7487-4ab9-992a-a61437b648ff" & INDID2020==2


*** check consistency goldamountpledge goldquantitypled
ta goldamountpledge2
ta goldamountpledge2 goldquantitypledge2 if goldamountpledge2<2000
*on considere que répondu en lakh (on a bien des loanamountgold en milliers)
replace goldamountpledge2=8000 if goldamountpledge==8
replace goldamountpledge2=16000 if goldamountpledge==16
replace goldamountpledge2=40000 if goldamountpledge==40
* pour ceux qui ne renseignent pas goldamountpledge: soit on impute sur la base d'une valeur pour l or (difficile vu la variabilité), soit on attribue la value du loanamountgold => c est ce qu on fait ici
replace goldamountpledge2=loanamountgold if goldamountpledge==0 & loanamountgold!=.


*** check problems of 0
g temp=goldamountpledge2/loanamountgold
g test=0
replace test=1 if loanamountgold!=. & goldamountpledge2!=. & (goldamountpledge2==10*loanamountgold | loanamountgold==10*goldamountpledge2)

list HHID2020 INDID2020 goldquantity  goldquantitypledge2 goldamountpledge2  loanamountgold gold_rate temp if test==1
*vu le goldrate, on peut considérer que goldamountpl a un 0 en trop
replace goldamountpledge2=goldamountpledge2/10 if HHID2020=="uuid:4df12d9e-63a9-48e2-a962-517cc3ec8a65"  & INDID2020==2 | HHID2020=="uuid:7b70f238-d8fa-471b-8cd7-f89a30c1f9f4" & INDID2020==2 | HHID2020=="uuid:a2e54cd3-e9ca-4dba-945c-acb552cf74bf" & INDID2020==2
* et vice versa, 0 en trop pour loanamount
replace loanamountgold2=loanamountgold2/10 if HHID2020=="uuid:83d1f6fc-59e8-4afe-b725-2b5eee50cce8"  & INDID2020==4 | HHID2020=="uuid:17e456bc-0327-461c-9782-de911c716e4f"  & INDID2020==2
 
drop temp test unpledged_goldquantity gold_rate





***** Realistic quantity?
ta goldquantity2
preserve
bysort HHID2020: egen goldHH=sum(goldquantity2)
keep HHID2020 goldHH
duplicates drop
ta goldHH
restore
/*
Outliers, but less than 2016-17!
Need to correct after
*/

ta goldquantitypledge2
/*
Same
*/


***** Manually recode outliers
/*
To check outliers, i use quantity of 2016 also
*/
merge m:m HHID2020 using "ODRIIS-HH_wide", keepusing(HHID2016)
keep if _merge==3
drop _merge
merge m:m HHID2016 using "outcomes/NEEMSIS1-gold_HH", keepusing(goldquantity_HH)
drop if _merge==2
drop _merge
rename goldquantity_HH goldquantity_HH2016
order goldquantity_HH2016, after(goldquantity)
sort goldquantity2 HHID2020 INDID2020
gen n=_n

cls
list n HHID2020 INDID2020 goldquantity_HH2016 goldquantity2 goldquantitypledge2 goldamountpledge2 loanamountgold2 if goldquantity2!=., clean noobs 
/*
Above 100 grams it is strange, so check one by one
*/


* 880 280 700000 40000
replace goldquantity2=88 if HHID2020=="uuid:4e9a4381-81ea-4e38-86f2-c7a3184b0d7e" & INDID2020==2
replace goldquantitypledge2=28 if HHID2020=="uuid:4e9a4381-81ea-4e38-86f2-c7a3184b0d7e" & INDID2020==2
replace goldamountpledge2=70000 if HHID2020=="uuid:4e9a4381-81ea-4e38-86f2-c7a3184b0d7e" & INDID2020==2

* 720 320
replace goldquantity2=72 if HHID2020=="uuid:3fe02e46-180b-4f5c-864b-ecda49e97656" & INDID2020==2
replace goldquantitypledge2=32 if HHID2020=="uuid:3fe02e46-180b-4f5c-864b-ecda49e97656" & INDID2020==2

*560 160 500000 100000
replace goldquantity2=56 if HHID2020=="uuid:619e7076-c7e3-47d1-931b-24039121aa55" & INDID2020==2
replace goldquantitypledge2=16 if HHID2020=="uuid:619e7076-c7e3-47d1-931b-24039121aa55" & INDID2020==2
replace goldamountpledge2=50000 if HHID2020=="uuid:619e7076-c7e3-47d1-931b-24039121aa55" & INDID2020==2
replace loanamountgold2=10000 if HHID2020=="uuid:619e7076-c7e3-47d1-931b-24039121aa55" & INDID2020==2

* 480
replace goldquantity2=48 if HHID2020=="uuid:3fe02e46-180b-4f5c-864b-ecda49e97656" & INDID2020==4

*428 214
replace goldquantity2=43 if HHID2020=="uuid:be3a1fd7-1d0c-43aa-a9ff-b917f9130a7f" & INDID2020==1
replace goldquantitypledge2=21 if HHID2020=="uuid:be3a1fd7-1d0c-43aa-a9ff-b917f9130a7f" & INDID2020==1
replace goldamountpledge2=41500 if HHID2020=="uuid:be3a1fd7-1d0c-43aa-a9ff-b917f9130a7f" & INDID2020==1

* 400 200
replace goldquantity2=40 if HHID2020=="uuid:d4b98efb-0cc6-4e82-996a-040ced0cbd52" & INDID2020==1
replace goldquantitypledge2=20 if HHID2020=="uuid:d4b98efb-0cc6-4e82-996a-040ced0cbd52" & INDID2020==1
replace goldamountpledge2=30000 if HHID2020=="uuid:d4b98efb-0cc6-4e82-996a-040ced0cbd52" & INDID2020==1
replace loanamountgold2=30000 if HHID2020=="uuid:d4b98efb-0cc6-4e82-996a-040ced0cbd52" & INDID2020==1

* 400
replace goldquantity2=40 if HHID2020=="uuid:4e9a4381-81ea-4e38-86f2-c7a3184b0d7e" & INDID2020==6

*200 200 500000
replace goldquantity2=40 if HHID2020=="uuid:496a8ebe-1d87-4dd8-886a-24ec26514474" & INDID2020==1
replace goldquantitypledge2=20 if HHID2020=="uuid:496a8ebe-1d87-4dd8-886a-24ec26514474" & INDID2020==1
replace goldamountpledge2=50000 if HHID2020=="uuid:496a8ebe-1d87-4dd8-886a-24ec26514474" & INDID2020==1
replace loanamountgold2=50000 if HHID2020=="uuid:496a8ebe-1d87-4dd8-886a-24ec26514474" & INDID2020==1

* 320 160 300000
replace goldquantity2=32 if HHID2020=="uuid:bd716ce9-7b96-4eae-a972-88c46dadc45b" & INDID2020==3
replace goldquantitypledge2=16 if HHID2020=="uuid:bd716ce9-7b96-4eae-a972-88c46dadc45b" & INDID2020==3
replace goldamountpledge2=30000 if HHID2020=="uuid:bd716ce9-7b96-4eae-a972-88c46dadc45b" & INDID2020==3
replace loanamountgold2=30000 if HHID2020=="uuid:bd716ce9-7b96-4eae-a972-88c46dadc45b" & INDID2020==3

* 160 120 282000 200000
replace goldquantity2=28 if HHID2020=="uuid:05dbf9ff-89b9-418d-adc6-20705195200a" & INDID2020==2
replace goldquantitypledge2=12 if HHID2020=="uuid:05dbf9ff-89b9-418d-adc6-20705195200a" & INDID2020==2
replace goldamountpledge2=28200 if HHID2020=="uuid:05dbf9ff-89b9-418d-adc6-20705195200a" & INDID2020==2
replace loanamountgold2=20000 if HHID2020=="uuid:05dbf9ff-89b9-418d-adc6-20705195200a" & INDID2020==2

* 240 120 250000
replace goldquantity2=24 if HHID2020=="uuid:89f0eed8-03fb-4e07-8773-90bd6e4c7530" & INDID2020==3
replace goldquantitypledge2=12 if HHID2020=="uuid:89f0eed8-03fb-4e07-8773-90bd6e4c7530" & INDID2020==3
replace goldamountpledge2=25000 if HHID2020=="uuid:89f0eed8-03fb-4e07-8773-90bd6e4c7530" & INDID2020==3
replace loanamountgold2=5000 if HHID2020=="uuid:89f0eed8-03fb-4e07-8773-90bd6e4c7530" & INDID2020==3

* 240 
replace goldquantity2=24 if HHID2020=="uuid:03eae81d-b4be-4200-b6f1-bcae0b8e2aa3" & INDID2020==2

* 900000
replace goldamountpledge2=90000 if HHID2020=="uuid:f43c3bf6-4ffd-4093-860d-8efc06aa29b8" & INDID2020==2
replace loanamountgold2=90000 if HHID2020=="uuid:f43c3bf6-4ffd-4093-860d-8efc06aa29b8" & INDID2020==2


sort goldquantity2 HHID2020 INDID2020
list HHID2020 INDID2020 goldquantity_HH2016 goldquantity2 goldquantitypledge2 goldamountpledge2 loanamountgold2 if goldquantity2!=., clean noobs 

sort goldamountpledge2 HHID2020 INDID2020
list HHID2020 INDID2020 goldquantity_HH2016 goldquantity2 goldquantitypledge2 goldamountpledge2 loanamountgold2 if goldamountpledge2!=., clean noobs 





* 400 320 100000 10000
replace goldquantity2=40 if HHID2020=="uuid:3fe02e46-180b-4f5c-864b-ecda49e97656" & INDID2020==2
replace goldquantitypledge2=32 if HHID2020=="uuid:3fe02e46-180b-4f5c-864b-ecda49e97656" & INDID2020==2
replace goldamountpledge2=87000 if HHID2020=="uuid:3fe02e46-180b-4f5c-864b-ecda49e97656" & INDID2020==2
replace loanamountgold2=87000 if HHID2020=="uuid:3fe02e46-180b-4f5c-864b-ecda49e97656" & INDID2020==2

*300
replace goldquantity2=30 if HHID2020=="uuid:4e9a4381-81ea-4e38-86f2-c7a3184b0d7e" & INDID2020==7

* 1000000
replace goldamountpledge2=100000 if HHID2020=="uuid:4df12d9e-63a9-48e2-a962-517cc3ec8a65" & INDID2020==2


*750000
replace goldamountpledge2=75000 if HHID2020=="uuid:a2e54cd3-e9ca-4dba-945c-acb552cf74bf" & INDID2020==2

*176 144 660000
replace goldquantity2=17 if HHID2020=="uuid:de6be2df-87c0-4f22-aaa2-43bb1b6ac4c0" & INDID2020==2
replace goldquantitypledge2=14 if HHID2020=="uuid:de6be2df-87c0-4f22-aaa2-43bb1b6ac4c0" & INDID2020==2
replace goldamountpledge2=40000 if HHID2020=="uuid:de6be2df-87c0-4f22-aaa2-43bb1b6ac4c0" & INDID2020==2
replace loanamountgold2=40000 if HHID2020=="uuid:de6be2df-87c0-4f22-aaa2-43bb1b6ac4c0" & INDID2020==2

*500000
replace goldamountpledge2=50000 if HHID2020=="uuid:d69cba0a-b431-4f15-8e58-87b998d259e3" & INDID2020==2
replace loanamountgold2=50000 if HHID2020=="uuid:d69cba0a-b431-4f15-8e58-87b998d259e3" & INDID2020==2

*400 160 500000 100000
replace goldquantity2=40 if HHID2020=="uuid:619e7076-c7e3-47d1-931b-24039121aa55" & INDID2020==2
replace goldquantitypledge2=16 if HHID2020=="uuid:619e7076-c7e3-47d1-931b-24039121aa55" & INDID2020==2
replace goldamountpledge2=50000 if HHID2020=="uuid:619e7076-c7e3-47d1-931b-24039121aa55" & INDID2020==2
replace loanamountgold2=10000 if HHID2020=="uuid:619e7076-c7e3-47d1-931b-24039121aa55" & INDID2020==2


*80 56     450000     450000 
replace goldamountpledge2=45000 if HHID2020=="uuid:a7632ff4-729b-4892-b701-44b74165d41a" & INDID2020==2
replace loanamountgold2=45000 if HHID2020=="uuid:a7632ff4-729b-4892-b701-44b74165d41a" & INDID2020==2

* 420000 30000
replace goldamountpledge2=42000 if HHID2020=="uuid:831ac2d3-8b2f-4936-9c96-515eb3940233" & INDID2020==2

* 214 214 415000 5000
replace goldquantity2=21 if HHID2020=="uuid:be3a1fd7-1d0c-43aa-a9ff-b917f9130a7f" & INDID2020==1
replace goldquantitypledge2=21 if HHID2020=="uuid:be3a1fd7-1d0c-43aa-a9ff-b917f9130a7f" & INDID2020==1
replace goldamountpledge2=15000 if HHID2020=="uuid:be3a1fd7-1d0c-43aa-a9ff-b917f9130a7f" & INDID2020==1

*400000 /10
replace goldamountpledge2=40000 if HHID2020=="uuid:e6dee14b-0cdd-4c95-ab31-837aa7651b74" & INDID2020==18
replace loanamountgold2=40000 if HHID2020=="uuid:e6dee14b-0cdd-4c95-ab31-837aa7651b74" & INDID2020==18
replace goldamountpledge2=40000 if HHID2020=="uuid:65057613-d2d1-4b3c-a9d6-e7e1f3bbf9e7" & INDID2020==4
replace loanamountgold2=40000 if HHID2020=="uuid:65057613-d2d1-4b3c-a9d6-e7e1f3bbf9e7" & INDID2020==4

* 120 40 350000 500000
replace goldquantity2=40 if HHID2020=="uuid:cb748595-aa39-4b85-9782-4d10e0e8117f" & INDID2020==2
replace goldquantitypledge2=12 if HHID2020=="uuid:cb748595-aa39-4b85-9782-4d10e0e8117f" & INDID2020==2
replace goldamountpledge2=35000 if HHID2020=="uuid:cb748595-aa39-4b85-9782-4d10e0e8117f" & INDID2020==2
replace loanamountgold2=35000 if HHID2020=="uuid:cb748595-aa39-4b85-9782-4d10e0e8117f" & INDID2020==2

* 350000
replace goldamountpledge2=35000 if HHID2020=="uuid:1e92b7e8-0055-44a9-a77a-674c65efb544" & INDID2020==2

* 192 192 330000 80000
replace goldquantity2=19 if HHID2020=="uuid:12659065-bcc2-4803-92ae-b81b8897ee3d" & INDID2020==1
replace goldquantitypledge2=19 if HHID2020=="uuid:12659065-bcc2-4803-92ae-b81b8897ee3d" & INDID2020==1
replace goldamountpledge2=33000 if HHID2020=="uuid:12659065-bcc2-4803-92ae-b81b8897ee3d" & INDID2020==1
replace loanamountgold2=8000 if HHID2020=="uuid:12659065-bcc2-4803-92ae-b81b8897ee3d" & INDID2020==1

* 200 200 300000 300000
replace goldquantity2=20 if HHID2020=="uuid:d4b98efb-0cc6-4e82-996a-040ced0cbd52" & INDID2020==1
replace goldquantitypledge2=20 if HHID2020=="uuid:d4b98efb-0cc6-4e82-996a-040ced0cbd52" & INDID2020==1
replace goldamountpledge2=30000 if HHID2020=="uuid:d4b98efb-0cc6-4e82-996a-040ced0cbd52" & INDID2020==1
replace loanamountgold2=30000 if HHID2020=="uuid:d4b98efb-0cc6-4e82-996a-040ced0cbd52" & INDID2020==1

*120
replace goldquantity2=12 if HHID2020=="uuid:6d60ca9d-572f-4e01-91d6-b34fedf0179b" & INDID2020==17
replace goldquantity2=12 if HHID2020=="uuid:f435ac6b-11a5-4273-a5a0-d7f2bb74b5f6" & INDID2020==16

*160
replace goldquantity2=16 if HHID2020=="uuid:f612acf8-feb5-4d29-824f-6ec5448323e0" & INDID2020==6
replace goldquantity2=16 if HHID2020=="uuid:f612acf8-feb5-4d29-824f-6ec5448323e0" & INDID2020==10


*128 128 300000 300000
replace goldquantity2=13 if HHID2020=="uuid:496a8ebe-1d87-4dd8-886a-24ec26514474" & INDID2020==2
replace goldquantitypledge2=13 if HHID2020=="uuid:496a8ebe-1d87-4dd8-886a-24ec26514474" & INDID2020==2
replace goldamountpledge2=30000 if HHID2020=="uuid:496a8ebe-1d87-4dd8-886a-24ec26514474" & INDID2020==2
replace loanamountgold2=30000 if HHID2020=="uuid:496a8ebe-1d87-4dd8-886a-24ec26514474" & INDID2020==2

* 300000
replace goldamountpledge2=30000 if HHID2020=="uuid:3f46b232-e813-49da-870e-6427391b3429" & INDID2020==2
replace loanamountgold2=30000 if HHID2020=="uuid:3f46b232-e813-49da-870e-6427391b3429" & INDID2020==2

*500000
replace goldamountpledge2=50000 if HHID2020=="uuid:2bc1e724-7bd9-4f62-9f6f-911d5a747957" & INDID2020==2
replace loanamountgold2=30000 if HHID2020=="uuid:2bc1e724-7bd9-4f62-9f6f-911d5a747957" & INDID2020==2

* 176 128 290000
replace goldquantity2=18 if HHID2020=="uuid:93a732f9-77e1-4da7-88f6-352721852510" & INDID2020==16
replace goldquantitypledge2=13 if HHID2020=="uuid:93a732f9-77e1-4da7-88f6-352721852510" & INDID2020==16
replace goldamountpledge2=29000 if HHID2020=="uuid:93a732f9-77e1-4da7-88f6-352721852510" & INDID2020==16
replace loanamountgold2=29000 if HHID2020=="uuid:93a732f9-77e1-4da7-88f6-352721852510" & INDID2020==16



*208 128
replace goldquantity2=21 if HHID2020=="uuid:2a15b403-dea9-48e6-a1b8-57b067830add" & INDID2020==2
replace goldquantitypledge2=13 if HHID2020=="uuid:2a15b403-dea9-48e6-a1b8-57b067830add" & INDID2020==2
replace goldamountpledge2=25000 if HHID2020=="uuid:2a15b403-dea9-48e6-a1b8-57b067830add" & INDID2020==2
replace loanamountgold2=20000 if HHID2020=="uuid:2a15b403-dea9-48e6-a1b8-57b067830add" & INDID2020==2

*245000
replace goldamountpledge2=24500 if HHID2020=="uuid:b6f2cdf0-36d8-4106-905b-13b7d993c193" & INDID2020==16
replace loanamountgold2=24500 if HHID2020=="uuid:b6f2cdf0-36d8-4106-905b-13b7d993c193" & INDID2020==16

* 120 80
replace goldquantity2=12 if HHID2020=="uuid:1f6677b5-5a9d-4892-b5ab-b70f32d53615" & INDID2020==2
replace goldquantitypledge2=8 if HHID2020=="uuid:1f6677b5-5a9d-4892-b5ab-b70f32d53615" & INDID2020==2
replace goldamountpledge2=23000 if HHID2020=="uuid:1f6677b5-5a9d-4892-b5ab-b70f32d53615" & INDID2020==2
replace loanamountgold2=23000 if HHID2020=="uuid:1f6677b5-5a9d-4892-b5ab-b70f32d53615" & INDID2020==2

* 120 80
replace goldquantity2=12 if HHID2020=="uuid:d4a5192d-74e4-4cb8-8b48-1d971f68cb54" & INDID2020==2
replace goldquantitypledge2=8 if HHID2020=="uuid:d4a5192d-74e4-4cb8-8b48-1d971f68cb54" & INDID2020==2
replace goldamountpledge2=30000 if HHID2020=="uuid:d4a5192d-74e4-4cb8-8b48-1d971f68cb54" & INDID2020==2
replace loanamountgold2=20000 if HHID2020=="uuid:d4a5192d-74e4-4cb8-8b48-1d971f68cb54" & INDID2020==2

* 80 80 320000 50000
replace goldamountpledge2=100000 if HHID2020=="uuid:7c99c8dc-8da1-4dda-8b93-236f99cc98d2" & INDID2020==2


*300000
replace goldamountpledge2=30000 if HHID2020=="uuid:fbe7c190-7c95-40f4-ad97-69b66a5ceb72" & INDID2020==2
replace loanamountgold2=30000 if HHID2020=="uuid:fbe7c190-7c95-40f4-ad97-69b66a5ceb72" & INDID2020==2

*30000
replace goldamountpledge2=30000 if HHID2020=="uuid:79cefad2-b1d6-44ea-9d5d-12734c0dffd7" & INDID2020==1

* 80 80 210000
replace goldquantity2=8 if HHID2020=="uuid:ea20a948-0e03-4bf5-ad8c-abe731ee2fe0" & INDID2020==1
replace goldquantitypledge2=8 if HHID2020=="uuid:ea20a948-0e03-4bf5-ad8c-abe731ee2fe0" & INDID2020==1
replace goldamountpledge2=21000 if HHID2020=="uuid:ea20a948-0e03-4bf5-ad8c-abe731ee2fe0" & INDID2020==1
replace loanamountgold2=21000 if HHID2020=="uuid:ea20a948-0e03-4bf5-ad8c-abe731ee2fe0" & INDID2020==1

* 20000 26000
replace goldamountpledge2=26000 if HHID2020=="uuid:d18158ec-d0a2-4dfb-80bd-d4109f6b0430" & INDID2020==2
replace loanamountgold2=20000 if HHID2020=="uuid:d18158ec-d0a2-4dfb-80bd-d4109f6b0430" & INDID2020==2

* 80 80 200000 200000
replace goldquantity2=8 if HHID2020=="uuid:c68d90f2-d76b-41bb-a58e-b82fd2bde6af" & INDID2020==16
replace goldquantitypledge2=8 if HHID2020=="uuid:c68d90f2-d76b-41bb-a58e-b82fd2bde6af" & INDID2020==16
replace goldamountpledge2=20000 if HHID2020=="uuid:c68d90f2-d76b-41bb-a58e-b82fd2bde6af" & INDID2020==16
replace loanamountgold2=20000 if HHID2020=="uuid:c68d90f2-d76b-41bb-a58e-b82fd2bde6af" & INDID2020==16

* 60 40 200000
replace goldquantity2=6 if HHID2020=="uuid:c14788bc-235f-4690-b9bf-15bfde3788ef" & INDID2020==2
replace goldquantitypledge2=4 if HHID2020=="uuid:c14788bc-235f-4690-b9bf-15bfde3788ef" & INDID2020==2
replace goldamountpledge2=20000 if HHID2020=="uuid:c14788bc-235f-4690-b9bf-15bfde3788ef" & INDID2020==2
replace loanamountgold2=20000 if HHID2020=="uuid:c14788bc-235f-4690-b9bf-15bfde3788ef" & INDID2020==2




/*
sort goldquantity2 goldquantity_HH HHID2020 INDID2020
list n HHID2020 INDID2020 goldquantity_HH2010 goldquantity_HH goldquantity2 goldquantitypledge2 goldamountpledge2 if goldquantity2!=., clean noobs 
drop goldquantity_HH goldamount_HH



***** Pledge vs Owned quantity:
gen test=goldquantity2-goldquantitypledge2
ta test
/*
Neg means that pledge>total, suppose they reversed, so need to recoded:
*/
replace goldquantity2=goldquantitypledge2 if test<0
drop test


***** Quantity and amount pledge
gen test=goldamountpledge2/goldquantitypledge2
ta test
/*
Higher than 2700 strange as 2700 is the gold price
So, need to check the quantity and the price to observe outliers
*/
ta goldquantitypledge2 if test>2700
ta goldamountpledge2 if test>2700
/*
It seems that the quantity is good, so replace the price
*/
replace goldamountpledge2=goldquantitypledge2*2700 if test>2700
drop test



***** Loan balance consistency




***** Save
drop goldquantity_HH2010 n HHID2016
gen goldamount=goldquantity2*2700

tabstat goldquantity goldquantity2, stat(n mean cv q)

save"outcomes\NEEMSIS1-gold", replace


***** HH level
bysort HHID2020: egen goldquantity_HH=sum(goldquantity2)
bysort HHID2020: egen goldquantitypledge_HH=sum(goldquantitypledge2)
bysort HHID2020: egen goldamountpledge_HH=sum(goldamountpledge2)
bysort HHID2020: egen goldamount_HH=sum(goldamount)

keep HHID2020 goldquantity_HH goldquantitypledge_HH goldamountpledge_HH goldamount_HH
duplicates drop
save"outcomes\NEEMSIS1-gold_HH", replace
****************************************
* END
