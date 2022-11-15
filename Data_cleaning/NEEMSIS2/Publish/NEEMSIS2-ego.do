*-------------------------
*Arnaud NATAL
*arnaud.natal@u-bordeaux.fr
*-----
*XLSform to XLSquest
*-----
*-------------------------

********** Clear
clear all
macro drop _all

********** Path to do
global dofile = "C:\Users\Arnaud\Documents\MEGA\Data\Publish\NEEMSIS-2"

********** Path to working directory directory
global directory = "C:\Users\Arnaud\Documents\MEGA\Data\Publish\NEEMSIS-2"
cd"$directory"








****************************************
* Ego
****************************************

use"NEEMSIS2-HH.dta", clear

drop if egoid==0
*dropmiss, force


drop version_agri goldquantityamount amountownlanddry amountownlandwet amountownland edulevel s_goldquantity goodtotalamount2 assets assets_noland ra1 rab1 rb1 ra2 rab2 rb2 ra3 rab3 rb3 ra4 rab4 rb4 ra5 rab5 rb5 ra6 rab6 rb6 ra7 rab7 rb7 ra8 rab8 rb8 ra9 rab9 rb9 ra10 rab10 rb10 ra11 rab11 rb11 ra12 rab12 rb12 set_a set_ab set_b raven_tt refuse num_tt lit_tt ars ars2 ars3 cr_curious cr_interestedbyart cr_repetitivetasks cr_inventive cr_liketothink cr_newideas cr_activeimagination cr_organized cr_makeplans cr_workhard cr_appointmentontime cr_putoffduties cr_easilydistracted cr_completeduties cr_enjoypeople cr_sharefeelings cr_shywithpeople cr_enthusiastic cr_talktomanypeople cr_talkative cr_expressingthoughts cr_workwithother cr_understandotherfeeling cr_trustingofother cr_rudetoother cr_toleratefaults cr_forgiveother cr_helpfulwithothers cr_managestress cr_nervous cr_changemood cr_feeldepressed cr_easilyupset cr_worryalot cr_staycalm cr_tryhard cr_stickwithgoals cr_goaftergoal cr_finishwhatbegin cr_finishtasks cr_keepworking cr_OP cr_CO cr_EX cr_AG cr_ES cr_Grit OP CO EX AG ES Grit mainocc_kindofwork_indiv mainocc_profession_indiv mainocc_occupation_indiv mainocc_sector_indiv mainocc_hoursayear_indiv mainocc_annualincome_indiv mainocc_jobdistance_indiv mainocc_occupationname_indiv annualincome_indiv nboccupation_indiv occinc_indiv_agri occinc_indiv_agricasual occinc_indiv_nonagricasual occinc_indiv_nonagriregnonqual occinc_indiv_nonagriregqual occinc_indiv_selfemp occinc_indiv_nrega worker mainocc_kindofwork_HH mainocc_occupation_HH annualincome_HH nboccupation_HH occinc_HH_agri occinc_HH_agricasual occinc_HH_nonagricasual occinc_HH_nonagriregnonqual occinc_HH_nonagriregqual occinc_HH_selfemp occinc_HH_nrega working_pop remreceivedtotalamount_indiv remreceivedtotalamount_HH incomeassets_HH incomeassets_indiv otherhouserent_HH otherhouserent_indiv pension_indiv pension_HH totalincome_indiv totalincome_HH loans_indiv loanamount_indiv imp1_ds_tot_indiv imp1_is_tot_indiv loans_HH loanamount_HH imp1_ds_tot_HH imp1_is_tot_HH caste2010 caste2010_str caste2016 caste2016_str


foreach x in INDID2020 start_HH_quest start_agri_quest end_HH_quest end_agri_quest submissiondate version_HH version_agri panelHH dummynewHH panelindiv geopointlatitude geopointlongitude geopointaltitude geopointaccuracy username compensation compensationamount villagename villageid villagearea villageareaid householdid2020 newfrompanel villagenameparent villageareaparent householdidparent householdidparent_key interviewplace address dummylefthousehold reasonlefthome reasonlefthomeother othermember newmembernb dummynewmember dummyformermember name interviewer livinghome lefthomedurationlessoneyear lefthomedurationmoreoneyear lefthomedestination lefthomereason religion comefrom otherorigin numfamily sex age jatis caste relationshiptohead relationshiptoheadother maritalstatus maritalstatusdate dummycastespouse comefromspouse dummyreligionspouse religionspouse castespouse otheroriginspouse canread everattendedschool classcompleted after10thstandard durationafter10th typeofhigheredu subjectsafter10th othersubjectsafter10th newtraining reservation reservationgrade reservationkind reservationother currentlyatschool educationexpenses amountschoolfees bookscost transportcost reasonneverattendedschool reasondropping otherreasondroppingschool covgoingbackschool decisiondropping decisiondroppingother dummyscholarship scholarshipamount scholarshipduration converseinenglish dummyworkedpastyear reservationemployment reasonnotworkpastyear stoppedworking workpastsixmonth everworksalaried kindofworkinactive dummymigration dummymigrantlist migrationjoblist dummyremreceived dummyremrecipientlist remrecipientsourcename1 remrecipientsourcenametwo1 remreceivedsourcerelation1 remreceivedsourceoccup1 remreceivedsourceplace1 remreceivedmoney1 remgift1 remreceivedservices1 remreceivedfrequency1 remreceivedamount1 remreceivedtotalamount1 remreceivedmean1 remgiftnb1 remgiftamount1 remreceivedsourceoccupother1 remreceivedservicesother1 covremreceived1 remrecipientsourcename2 remrecipientsourcenametwo2 remreceivedsourcerelation2 remreceivedsourceoccup2 remreceivedsourceplace2 remreceivedmoney2 remgift2 remreceivedservices2 remreceivedfrequency2 remreceivedamount2 remreceivedtotalamount2 remreceivedmean2 remgiftnb2 remgiftamount2 remreceivedsourceoccupother2 remreceivedservicesother2 covremreceived2 remrecipientsourcename3 remrecipientsourcenametwo3 remreceivedsourcerelation3 remreceivedsourceoccup3 remreceivedsourceplace3 remreceivedmoney3 remgift3 remreceivedservices3 remreceivedfrequency3 remreceivedamount3 remreceivedtotalamount3 remreceivedmean3 remgiftnb3 remgiftamount3 remreceivedsourceoccupother3 remreceivedservicesother3 covremreceived3 remrecipientsourcename4 remrecipientsourcenametwo4 remreceivedsourcerelation4 remreceivedsourceoccup4 remreceivedsourceplace4 remreceivedmoney4 remgift4 remreceivedservices4 remreceivedfrequency4 remreceivedamount4 remreceivedtotalamount4 remreceivedmean4 remgiftnb4 remgiftamount4 remreceivedsourceoccupother4 remreceivedservicesother4 covremreceived4 dummyremsent dummyremsenderlist remsentname1 remsentnametwo1 remsentdummyvillage1 remsentrelation1 remsentoccup1 remsentplace1 remsentmoney1 remsentgift1 remsentservices1 remsentsourceoccupother1 remsentservicesother1 remsentfrequency1 remsentamount1 remsenttotalamount1 remsentmean1 remsentgiftnb1 remsentgiftamount1 covremsent1 remsentname2 remsentnametwo2 remsentdummyvillage2 remsentrelation2 remsentoccup2 remsentplace2 remsentmoney2 remsentgift2 remsentservices2 remsentsourceoccupother2 remsentservicesother2 remsentfrequency2 remsentamount2 remsenttotalamount2 remsentmean2 remsentgiftnb2 remsentgiftamount2 covremsent2 remsentname3 remsentnametwo3 remsentdummyvillage3 remsentrelation3 remsentoccup3 remsentplace3 remsentmoney3 remsentgift3 remsentservices3 remsentsourceoccupother3 remsentservicesother3 remsentfrequency3 remsentamount3 remsenttotalamount3 remsentmean3 remsentgiftnb3 remsentgiftamount3 covremsent3 remsentname4 remsentnametwo4 remsentdummyvillage4 remsentrelation4 remsentoccup4 remsentplace4 remsentmoney4 remsentgift4 remsentservices4 remsentsourceoccupother4 remsentservicesother4 remsentfrequency4 remsentamount4 remsenttotalamount4 remsentmean4 remsentgiftnb4 remsentgiftamount4 covremsent4 remsentname5 remsentnametwo5 remsentdummyvillage5 remsentrelation5 remsentoccup5 remsentplace5 remsentmoney5 remsentgift5 remsentservices5 remsentsourceoccupother5 remsentservicesother5 remsentfrequency5 remsentamount5 remsenttotalamount5 remsentmean5 remsentgiftnb5 remsentgiftamount5 covremsent5 dummyloans covrefusalloan dummyborrowerlist sumhhloans threemainloans nbloansbyborrower loandetails1 loandetails2 loandetails3 loandetails4 loandetails5 loandetails6 loandetails7 loandetails8 loandetails9 loandetails10 loandetails11 loandetails12 loandetails13 loandetails14 loandetails15 loandetails16 loandetails17 loandetails18 loandetails19 loandetails20 loandetails21 loandetails22 loandetails23 loandetails24 loandetails25 loandetails26 loandetails27 loandetails28 loandetails29 loandetails30 loandetails31 loandetails32 loandetails33 loandetails34 loandetails35 loandetails36 loandetails37 loandetails41 loandetails42 loandetails43 loandetails44 loandetails49 loandetails50 loandetails51 loandetails52 loandetails53 loandetails54 loandetails55 loandetails56 loandetails65 loandetails66 loandetails67 loandetails68 loandetails69 loandetails70 loandetails71 loandetails72 loandetails73 loandetails74 loandetails75 loandetails76 loandetails77 loandetails78 loandetails79 dummyincomeassets incomeassets dummylendingmoney dummyhhlenderlist borrowerscaste borrowerssex relationwithborrower amoutlent interestlending purposeloanborrower problemrepayment dummyloanfromborrower covlendrepayment covlending datelendingmoney dummyrecommendgiven dummyrecommendgivenlist dummyrecommendrefuse reasonrefuserecommend dummychitfund dummychitfundbelongerlist chitfundbelongernumber nbchitfunds chitfundtype1 durationchit1 nbermemberchit1 chitfundpayment1 chitfundpaymentamount1 chitfundamount1 covchitfundstop1 covchitfundreturn1 chitfundtype2 durationchit2 nbermemberchit2 chitfundpayment2 chitfundpaymentamount2 chitfundamount2 covchitfundstop2 covchitfundreturn2 chitfundtype3 durationchit3 nbermemberchit3 chitfundpayment3 chitfundpaymentamount3 chitfundamount3 covchitfundstop3 dummysavingaccount dummysavingsownerlist savingsownernumber nbsavingaccounts savingsaccounttype1 savingsjointaccount1 banktype1 savingsbankname1 savingsbankplace1 savingsamount1 savingspurpose1 covsavinguse1 dummydebitcard1 dummycreditcard1 covsavinguseamount1 usedebitcard1 reasonnotusedebitcard1 usecreditcard1 savingsaccountdate1 datedebitcard1 datecreditcard1 savingsaccounttype2 savingsjointaccount2 banktype2 savingsbankname2 savingsbankplace2 savingsamount2 savingspurpose2 covsavinguse2 dummydebitcard2 dummycreditcard2 covsavinguseamount2 usedebitcard2 savingsaccountdate2 datedebitcard2 savingsaccounttype3 banktype3 savingsbankname3 savingsbankplace3 savingsamount3 savingspurpose3 covsavinguse3 dummydebitcard3 dummycreditcard3 covsavinguseamount3 usedebitcard3 savingsaccountdate3 datedebitcard3 savingsaccounttype4 banktype4 savingsbankname4 savingsbankplace4 savingsamount4 savingspurpose4 covsavinguse4 dummydebitcard4 dummycreditcard4 usedebitcard4 savingsaccountdate4 datedebitcard4 dummygold covsoldgold covsoldgoldquantity covlostgold dummygoldownerlist goldnumber goldquantity dummygoldpledged goldquantitypledge goldamountpledge covgoldpledged goldreasonpledge goldreasonpledgemain loanamountgold loandategold loanlendergold lenderscastegold lenderfromgold loansettledgold loanbalancegold dummyinsurance reasonnoinsurance dummyinsuranceownerlist insuranceownernumber nbinsurance insurancepublic1 insurancename1 insurancejoineddate1 insurancetype1 insurancepaymentfrequency1 insuranceamount1 insurancebenefit1 insurancebenefitamount1 insurancepublic2 insurancename2 insurancejoineddate2 insurancetype2 insurancepaymentfrequency2 insuranceamount2 insurancebenefit2 insurancebenefitamount2 insurancepublic3 insurancename3 insurancejoineddate3 insurancetype3 insurancepaymentfrequency3 insuranceamount3 insurancebenefit3 insurancebenefitamount3 insurancepublic4 insurancename4 insurancejoineddate4 insurancetype4 insurancepaymentfrequency4 insuranceamount4 insurancebenefit4 insurancepublic5 insurancename5 insurancejoineddate5 insurancetype5 insurancepaymentfrequency5 insuranceamount5 insurancebenefit5 insurancepublic6 insurancename6 insurancejoineddate6 insurancetype6 insurancepaymentfrequency6 insuranceamount6 insurancebenefit6 usemobilefinance usemobilefinancetype usemobilefinanceother dummyeverland2010 covsellland dummyeverhadland reasonnoland reasonnolandother ownland sizeownland drywetownland sizedryownland sizewetownland waterfromownland leaseland sizeleaseland drywetleaseland waterfromleaseland landpurchased landpurchasedacres landpurchasedamount landpurchasedhowbuy landlost landlostreason dummyleasedland landleasername landleaserrelation landleasercaste dummyleasingland landleasingname landleasingrelation landleasingcaste productlist productacre_paddy productypeland_paddy productunit_paddy productnbchoice_paddy productselfconsumption_paddy productnbchoicesold_paddy productpricesold_paddy productexpenses_paddy productpaidworkers_paddy productnbpaidworkers_paddy productlabourcost_paddy productunpaidworkers_paddy productnbunpaidworkers_paddy productnbhhmembers_paddy productoriginlabourers_paddy productcastelabourers_paddy productacre_cotton productypeland_cotton productunit_cotton productnbchoice_cotton productselfconsumption_cotton productnbchoicesold_cotton productpricesold_cotton productexpenses_cotton productpaidworkers_cotton productnbpaidworkers_cotton productlabourcost_cotton productunpaidworkers_cotton productnbunpaidworkers_cotton productnbhhmembers_cotton productoriginlabourers_cotton productcastelabourers_cotton productacre_sugarcane productypeland_sugarcane productunit_sugarcane productnbchoice_sugarcane productselfconsumption_sugarcane productnbchoicesold_sugarcane productpricesold_sugarcane productexpenses_sugarcane productpaidworkers_sugarcane productnbpaidworkers_sugarcane productlabourcost_sugarcane productunpaidworkers_sugarcane productnbunpaidworkers_sugarcane productnbhhmembers_sugarcane productoriginlabourers_sugarcane productcastelabourers_sugarcane productacre_savukku productypeland_savukku productunit_savukku productnbchoice_savukku productselfconsumption_savukku productnbchoicesold_savukku productpricesold_savukku productexpenses_savukku productpaidworkers_savukku productnbpaidworkers_savukku productlabourcost_savukku productunpaidworkers_savukku productnbunpaidworkers_savukku productnbhhmembers_savukku productoriginlabourers_savukku productcastelabourers_savukku productacre_guava productypeland_guava productunit_guava productnbchoice_guava productselfconsumption_guava productnbchoicesold_guava productpricesold_guava productexpenses_guava productpaidworkers_guava productnbpaidworkers_guava productlabourcost_guava productunpaidworkers_guava productnbunpaidworkers_guava productnbhhmembers_guava productoriginlabourers_guava productcastelabourers_guava productacre_groundnut productypeland_groundnut productunit_groundnut productnbchoice_groundnut productselfconsumption_groundnut productnbchoicesold_groundnut productpricesold_groundnut productexpenses_groundnut productpaidworkers_groundnut productnbpaidworkers_groundnut productlabourcost_groundnut productunpaidworkers_groundnut productnbunpaidworkers_groundnut productnbhhmembers_groundnut productoriginlabourers_groundnut productcastelabourers_groundnut productacre_millets productypeland_millets productunit_millets productnbchoice_millets productselfconsumption_millets productnbchoicesold_millets productpricesold_millets productexpenses_millets productpaidworkers_millets productnbpaidworkers_millets productlabourcost_millets productunpaidworkers_millets productnbunpaidworkers_millets productnbhhmembers_millets productoriginlabourers_millets productcastelabourers_millets productacre_cashew productypeland_cashew productunit_cashew productnbchoice_cashew productselfconsumption_cashew productnbchoicesold_cashew productpricesold_cashew productexpenses_cashew productpaidworkers_cashew productnbpaidworkers_cashew productlabourcost_cashew productunpaidworkers_cashew productnbunpaidworkers_cashew productnbhhmembers_cashew productoriginlabourers_cashew productcastelabourers_cashew productother productacre_other productypeland_other productunit_other productnbchoice_other productselfconsumption_other productnbchoicesold_other productpricesold_other productexpenses_other productpaidworkers_other productnbpaidworkers_other productlabourcost_other productunpaidworkers_other productnbunpaidworkers_other productnbhhmembers_other productoriginlabourers_other productcastelabourers_other covsubsistence covsubsistencereason covsubsistencesize covsubsistencenext covsubsistencereasonother covharvest covselfconsumption covharvestquantity covharvestprices livestocklist livestocknb_cow livestockprice_cow livestockamount_cow livestockuse_cow livestocknb_goat livestockprice_goat livestockamount_goat livestockuse_goat livestocknb_chicken livestockprice_chicken livestockamount_chicken livestockuse_chicken livestocknb_bullock livestockprice_bullock livestockamount_bullock livestockuse_bullock livestocknb_bullforploughing livestockprice_bullforploughing livestockamount_bullforploughing livestockuse_bullforploughing covselllivestock covselllivestock_cow covselllivestock_goat covselllivestock_chicken covselllivestock_bullock covselllivestock_bullforploughin covselllivestock_none dummycattleloss dummycattlesold cattlesoldreason equipmentlist equipmentnb_tractor equipmentyear_tractor equipmentcost_tractor equipmentpledged_tractor equipmentnb_bullockcart equipmentyear_bullockcart equipmentcost_bullockcart equipmentpledged_bullockcart equipmentnb_plowingmach equipmentyear_plowingmach equipmentcost_plowingmach equipmentpledged_plowingmach equipmentborrowedlist covsellequipment covsellequipment_tractor covsellequipment_bullockcar covsellequipment_harvester covsellequipment_plowingmac covsellequipment_none decisionconsumption foodexpenses decisionhealth healthexpenses ceremoniesexpenses ceremoniesrelativesexpenses deathexpenses covfoodenough covfoodquality covgenexpenses covexpensesdecrease covexpensesincrease covexpensesstable covplacepurchase covsick listgoods othergood numbergoods_car goodyearpurchased_car goodtotalamount_car goodbuying_car numbergoods_bike goodyearpurchased_bike goodtotalamount_bike goodbuying_bike goodsourcecredit_bike goodcreditsettled_bike numbergoods_fridge goodyearpurchased_fridge goodtotalamount_fridge goodbuying_fridge goodsourcecredit_fridge goodcreditsettled_fridge numbergoods_furniture goodyearpurchased_furniture goodtotalamount_furniture goodbuying_furniture numbergoods_tailormach goodyearpurchased_tailormach goodtotalamount_tailormach goodbuying_tailormach numbergoods_phone goodyearpurchased_phone goodtotalamount_phone goodbuying_phone goodsourcecredit_phone goodcreditsettled_phone numbergoods_landline goodyearpurchased_landline goodtotalamount_landline goodbuying_landline numbergoods_camera goodyearpurchased_camera goodtotalamount_camera goodbuying_camera numbergoods_cookgas goodyearpurchased_cookgas goodtotalamount_cookgas goodbuying_cookgas goodsourcecredit_cookgas goodcreditsettled_cookgas numbergoods_computer goodyearpurchased_computer goodtotalamount_computer goodbuying_computer numbergoods_antenna goodyearpurchased_antenna goodtotalamount_antenna goodbuying_antenna covsellgoods covsellgoods_car covsellgoods_bike covsellgoods_fridge covsellgoods_furniture covsellgoods_tailormach covsellgoods_phone covsellgoods_landline covsellgoods_DVD covsellgoods_camera covsellgoods_cookgas covsellgoods_computer covsellgoods_antenna covsellgoods_other covsellgoods_none covsellgoodsother dummymarriage marriedlist dummy_marriedlist marriedname marriedid marriagesomeoneelse marriagedate peoplewedding husbandwifecaste marriagetype marriageblood marriagearranged marriagedecision marriagespousefamily marriagedowry engagementtotalcost engagementhusbandcost engagementwifecost marriagetotalcost marriagehusbandcost marriagewifecost howpaymarriage marriageloannb marriageexpenses dummymarriagegift marriagegiftsource marriagegiftsourcename1 marriagegiftsourcenb1 marriagegifttype1 marriagegiftamount1 marriagegoldquantityasgift1 marriagegiftsourcename2 marriagegiftsourcenb2 marriagegifttype2 marriagegiftamount2 marriagegoldquantityasgift2 marriagegiftsourcename3 marriagegiftsourcenb3 marriagegifttype3 marriagegiftamount3 marriagegoldquantityasgift3 marriagegiftsourcename4 marriagegiftsourcenb4 marriagegifttype4 marriagegiftamount4 marriagegoldquantityasgift4 marriagegiftsourcename5 marriagegiftsourcenb5 marriagegifttype5 marriagegiftamount5 marriagegoldquantityasgift5 marriagegiftsourcename9 marriagegiftsourcenb9 marriagegifttype9 marriagegiftamount9 marriagegoldquantityasgift9 marriagegiftsourcename10 marriagegiftsourcenb10 marriagegifttype10 marriagegiftamount10 marriagegoldquantityasgift10 house howbuyhouse covsellhouse rentalhouse housevalue housetype housesize houseroom housetitle ownotherhouse covsellplot otherhouserent otherhousevalue dummysaleproperty incomesaleproperty useincomesaleproperty electricity water toiletfacility notoiletreason noowntoilet schemeslist rationcardnber rationcardmembers rationcarduse covrationcarduse covproductavailability rationcardreasonnouse scheme_freehouse schemedate_freehouse schemetype_freehouse schemeamount_freehouse schemedate_cashfuneral schemeamount_cashfuneral schemedate_freepatta schemeamount_freepatta schemedate_girlprotection schemeamount_girlprotection schemedate_shgloan schemeamount_shgloan schemedate_freecows schemeamount_freecows schemedate_freelpg schemeamount_freelpg schemedate_educfees schemeamount_educfees schemedate_farmequip schemeamount_farmequip schemedate_land schemesize_land nreganberdaysworked nregaincome schemedate_cashmarriage schemeamount_cashmarriage schemedate_goldmarriage schemeamount_goldmarriage schemeamount_oldage schemedate_oldage schemeamount_widows schemedate_widows schemeamount_maternity schemedate_maternity schemeamount_disability schemedate_disability schemeonamount_retirement schemedate_retirement schemedate_laptop schemeamount_laptop {
capture confirm v `x'
if _rc==0 {
drop `x'
}
}

drop INDID_total INDID_former INDID_new householdid_int numformerfamily numleftfamily instancename formdef_version Suganya_and_Malarvizhi Raichal Rajalakschmi Chithra_and_Radhika Mayan Pazani Vivek_Radja parent_key_BaseAgri address_BaseAgri submissiondate_BaseAgri geopointlatitude_BaseAgri geopointlongitude_BaseAgri geopointaltitude_BaseAgri geopointaccuracy_BaseAgri villagename_BaseAgri villagearea_BaseAgri value_householdid_2020 namenewhead householdidparent_backup sondaughter sondaughtername issue_new childname_modif lefthousehold migrantlist dummy_migrantlist migrantid migrantname remrecipientlist dummy_remrecipientlist remrecipientid remrecipientname remsenderlist dummy_remsenderlist remsenderid remsendername borrowerlist dummy_borrowerlist borrowerid borrowername hhlenderlist dummy_hhlenderlist hhlenderid hhlendername recommendgivenlist dummy_recommendgivenlist recommendgivenid recommendgivenname chitfundbelongerid dummy_chitfundbelongerid chitfundbelongername savingsownerid dummy_savingsownerid savingsownername goldownerid dummy_goldownerid goldownername insuranceownerid dummy_insuranceownerid insuranceownername landpurchasedhowbuy_6 landleasingrelation_5 productname1 productacre1 productypeland1 productunit1 productunitchoice1 productnbchoice1 productselfconsumption1 productnbchoicesold1 productpricesold1 productexpenses1 productpaidworkers1 productnbpaidworkers1 productlabourcost1 productunpaidworkers1 productnbunpaidworkers1 productnbhhmembers1 productoriginlabourers1 productcastelabourers1 productname2 productacre2 productypeland2 productunit2 productunitchoice2 productnbchoice2 productselfconsumption2 productnbchoicesold2 productpricesold2 productexpenses2 productpaidworkers2 productnbpaidworkers2 productlabourcost2 productunpaidworkers2 productnbunpaidworkers2 productnbhhmembers2 productoriginlabourers2 productcastelabourers2 productname3 productacre3 productypeland3 productunit3 productunitchoice3 productnbchoice3 productselfconsumption3 productnbchoicesold3 productpricesold3 productexpenses3 productpaidworkers3 productnbpaidworkers3 productlabourcost3 productunpaidworkers3 productnbunpaidworkers3 productnbhhmembers3 productoriginlabourers3 productcastelabourers3 productname4 productacre4 productypeland4 productunit4 productunitchoice4 productnbchoice4 productselfconsumption4 productnbchoicesold4 productpricesold4 productexpenses4 productpaidworkers4 productnbpaidworkers4 productlabourcost4 productunpaidworkers4 productnbunpaidworkers4 productnbhhmembers4 productoriginlabourers4 productcastelabourers4 productname5 productacre5 productypeland5 productunit5 productunitchoice5 productnbchoice5 productselfconsumption5 productnbchoicesold5 productpricesold5 productexpenses5 productpaidworkers5 productnbpaidworkers5 productlabourcost5 productunpaidworkers5 productnbunpaidworkers5 productnbhhmembers5 productoriginlabourers5 productcastelabourers5 productname9 productacre9 productypeland9 productunit9 productunitchoice9 productnbchoice9 productselfconsumption9 productnbchoicesold9 productpricesold9 productexpenses9 productpaidworkers9 productnbpaidworkers9 productlabourcost9 productunpaidworkers9 productnbunpaidworkers9 productnbhhmembers9 productoriginlabourers9 productcastelabourers9 productname11 productacre11 productypeland11 productunit11 productunitchoice11 productnbchoice11 productselfconsumption11 productnbchoicesold11 productpricesold11 productexpenses11 productpaidworkers11 productnbpaidworkers11 productlabourcost11 productunpaidworkers11 productnbunpaidworkers11 productnbhhmembers11 productoriginlabourers11 productcastelabourers11 productname12 productacre12 productypeland12 productunit12 productunitchoice12 productnbchoice12 productselfconsumption12 productnbchoicesold12 productpricesold12 productexpenses12 productpaidworkers12 productnbpaidworkers12 productlabourcost12 productunpaidworkers12 productnbunpaidworkers12 productnbhhmembers12 productoriginlabourers12 productcastelabourers12 productname14 productacre14 productypeland14 productunit14 productunitchoice14 productnbchoice14 productselfconsumption14 productnbchoicesold14 productpricesold14 productexpenses14 productpaidworkers14 productnbpaidworkers14 productlabourcost14 productunpaidworkers14 productnbunpaidworkers14 productnbhhmembers14 productoriginlabourers14 productcastelabourers14 productcastelabourers_15 productcastelabourers_11 equipmentlist_tractor equipmentlist_bullockcar equipmentlist_harvester equipmentlist_plowingmac equipmentlist_none equipmentborrowedlist_tractor equipmentborrowedlist_bullockcar equipmentborrowedlist_harvester equipmentborrowedlist_plowingmac equipmentborrowedlist_none equipmentname_tractor equipementyear1 equipmentname_bullockcart equipementyear2 equipmentname_plowingmach equipementyear4 goodname_car goodname_bike goodname_fridge goodname_furniture goodname_tailormach goodname_phone goodname_landline goodname_camera goodname_cookgas goodname_computer goodname_antenna goodtotalamount_DVD old_marriedid marriagepb dummy_schemeslist dummy_nregarecipientlist dummy_schemerecipientlist3 dummy_schemerecipientlist4 dummy_schemerecipientlist5 dummy_schemerecipientlist6 dummy_schemerecipientlist7 dummy_schemerecipientlist8 dummy_schemerecipientlist9 dummy_schemerecipientlist10 nregarecipientlist nregarecipientid nregarecipientname freehousescheme freehousebenefittype schemeamount0 schemeyearbenefited1 schemeamount1 schemeyearfreepatta schemeamountfreepatta schemeyeargirlprotection schemeamountgirlprotection schemeyearshgloan schemeamountshgloan schemeyearbenefited2 schemeamount2 schemeyearbenefited3 schemeamount3 schemeyearbenefited4 schemeamount4 schemeyearbenefited5 schemeamount5 schemelandyearbenefited schemelandsize schemerecipientlist3 schemerecipientid3 schemerecipientname3 schemeyearbenefited7 schemeamount7 schemerecipientlist4 schemerecipientid4 schemerecipientname4 schemeyearbenefited8 schemeamount8 schemerecipientlist5 schemerecipientid5 schemerecipientname5 schemepensionamount1 schemepensionsdate1 schemerecipientlist6 schemerecipientid6 schemerecipientname6 schemepensionamount2 schemepensiondate2 schemerecipientlist7 schemerecipientid7 schemerecipientname7 schemepensionamount3 schemepensiondate3 schemerecipientlist8 schemerecipientid8 schemerecipientname8 schemepensionamount4 schemepensiondate4 schemerecipientlist9 schemerecipientid9 schemerecipientname9 schemepensionamount5 schemepensiondate5 schemerecipientlist10 schemerecipientid10 schemerecipientname10 schemepensiondate6 schemepensionamount6 housingschemesdate

drop year setofemployment setofmarriagegroup setofremreceivedsourceidgroup setofremsentidgroup_old setofdetailsloanbyborrower setofremreceivedgroup setofremsentgroup jatis2010_str jatis2016_str INDID dummyego dummy_respondent2020 name2016 setofmigrationidgroup pb


*Backup
foreach x in curious_backup interestedbyart_backup repetitivetasks_backup inventive_backup liketothink_backup newideas_backup activeimagination_backup organized_backup makeplans_backup workhard_backup appointmentontime_backup putoffduties_backup easilydistracted_backup completeduties_backup enjoypeople_backup sharefeelings_backup shywithpeople_backup enthusiastic_backup talktomanypeople_backup talkative_backup expressingthoughts_backup workwithother_backup understandotherfeeling_backup trustingofother_backup rudetoother_backup toleratefaults_backup forgiveother_backup helpfulwithothers_backup managestress_backup nervous_backup changemood_backup feeldepressed_backup easilyupset_backup worryalot_backup staycalm_backup tryhard_backup stickwithgoals_backup goaftergoal_backup finishwhatbegin_backup finishtasks_backup keepworking_backup {
local new=substr("`x'",1,strlen("`x'")-7)
drop `new'
rename `x' `new'
label var `new' "`new'"
}



********** Reshape covoccupation questions
preserve
use"NEEMSIS2-covoccupation", clear
destring covoccupationnumber, replace
reshape wide covoccupationname covkindofwork covmonthsayear covdaysamonth covhoursaday annnualincome covworkeffort covlossincome, i(parent_key egoid) j(covoccupationnumber)
save"NEEMSIS2-covoccupation_wide", replace
restore


********** Add cov occupation
merge 1:1 parent_key egoid using "NEEMSIS2-covoccupation_wide"
sort _merge
drop if _merge==2
drop _merge






********** Order
drop selected_occupposition

fre businesspaymentinkindvalue_clot businesspaymentinkindvalue_food businesspaymentinkindvalue_trsp businesspaymentinkindvalue_acco businesspaymentinkindvalue_labo

fre businesspaymentinkindlist


order covoccupationname1 covkindofwork1 covmonthsayear1 covdaysamonth1 covhoursaday1 annnualincome1 covworkeffort1 covlossincome1 covoccupationname2 covkindofwork2 covmonthsayear2 covdaysamonth2 covhoursaday2 annnualincome2 covworkeffort2 covlossincome2 covoccupationname3 covkindofwork3 covmonthsayear3 covdaysamonth3 covhoursaday3 annnualincome3 covworkeffort3 covlossincome3 covoccupationname4 covkindofwork4 covmonthsayear4 covdaysamonth4 covhoursaday4 annnualincome4 covworkeffort4 covlossincome4, after(sumwagejobpaymentinkindvalue)

forvalues i=1/4 {
rename annnualincome`i' covannualincome`i'
}




********* PTCS last
order a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 ab1 ab2 ab3 ab4 ab5 ab6 ab7 ab8 ab9 ab10 ab11 ab12 canreadcard1a canreadcard1b canreadcard1c canreadcard2 numeracy1 numeracy2 numeracy3 numeracy4 numeracy5 numeracy6 enjoypeople curious organized managestress interestedbyart tryhard workwithother makeplans sharefeelings nervous stickwithgoals repetitivetasks shywithpeople workhard changemood understandotherfeeling inventive enthusiastic feeldepressed appointmentontime trustingofother goaftergoal easilyupset talktomanypeople liketothink finishwhatbegin putoffduties rudetoother finishtasks toleratefaults worryalot easilydistracted keepworking completeduties talkative newideas staycalm forgiveother activeimagination expressingthoughts helpfulwithothers locuscontrol1 locuscontrol2 locuscontrol3 locuscontrol4 locuscontrol5 locuscontrol6, last




********** Asso
order associationtype1 associationname1 assodegreeparticip1 assosize1 dummyassorecommendation1 snrecommendasso1 dummyassohelpjob1 assohelpjob1 assohelpjob_hiredyou1 assohelpjob_referredyou1 assohelpjob_sharedjob1 assohelpjob_helpwithappli1 assohelpjob_other1 assocotherhelpjob1 dummyassohelpbusiness1 assohelpbusiness1 assootherhelpbusiness1 associationtype2 associationname2 assodegreeparticip2 assosize2 dummyassorecommendation2 snrecommendasso2 dummyassohelpjob2 assohelpjob2 assohelpjob_hiredyou2 assohelpjob_referredyou2 assohelpjob_sharedjob2 assohelpjob_helpwithappli2 assohelpjob_other2 assocotherhelpjob2 dummyassohelpbusiness2 assohelpbusiness2 assootherhelpbusiness2, after(covassociationhelptypeother)





********** SN
order snfindcurrentjobnamelist, after(snfindcurrentjob)

order snfindjobnamelist, after(snfindjob)

order snrecojobsuccessnamelist, after(snrecojobsuccess)

order nbcontact_headbusiness nbcontact_policeman nbcontact_civilserv nbcontact_bankemployee nbcontact_panchayatcommittee nbcontact_peoplecouncil nbcontact_recruiter nbcontact_headunion, after(contactlist)




********** ID
merge m:m HHID_panel INDID_panel using "_tempNEEMSIS2HHINDID", keepusing(HHID2020 INDID2020)
keep if _merge==3
drop _merge
order HHID2020 INDID2020
drop HHID_panel INDID_panel
drop parent_key
drop lefthomeid lefthomename INDID_left


********** SAVE
save"Last\NEEMSIS2-ego", replace

