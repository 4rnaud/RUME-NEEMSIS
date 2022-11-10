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






********** 
use"NEEMSIS2-occupations_allwide", clear

drop name sex age jatis parent_key INDID_total relationshiptohead maritalstatus canread edulevel caste

drop kowinc_1 kowinc_2 kowinc_3 kowinc_4 kowinc_5 kowinc_6 kowinc_7 kowinc_8 kowinc_indiv_agri kowinc_indiv_selfemp kowinc_indiv_sjagri kowinc_indiv_sjnonagri kowinc_indiv_uwagri kowinc_indiv_uwhhagri kowinc_indiv_uwhhnonagri kowinc_indiv_uwnonagri mainocc_annualincome_indiv mainocc_hoursayear_indiv mainocc_jobdistance_indiv mainocc_kindofwork_indiv mainocc_occupation_indiv mainocc_occupationname_indiv mainocc_profession_indiv mainocc_sector_indiv setofoccupations setofemployment

drop construction_coolie construction_regular construction_qualified

drop occupcode2020 sector kindofwork_new annualincome_indiv nboccupation_indiv occinc_1 occinc_2 occinc_3 occinc_4 occinc_5 occinc_6 occinc_7 occinc_indiv_agri occinc_indiv_agricasual occinc_indiv_nonagricasual occinc_indiv_nonagriregnonqual occinc_indiv_nonagriregqual occinc_indiv_selfemp occinc_indiv_nrega worker working_pop profession occupation occupa_unemployed occupa_unemployed_15_70

drop othermainoccupation2 maxhoursayear mainoccuptype dummymainoccupation2 everattendedschool classcompleted10ormore

drop dummyworkedpastyear agefromearlier agefromearlier1 agefromearlier2




********** Order
order HHID_panel INDID_panel occupationid occupationnumber occupationname kindofwork monthsayear daysamonth hoursaday hoursayear annualincome datestartoccup yearestablishment businesscastebased businessskill businesslocation businesslocationname dummybusinesslabourers nbbusinesslabourers, first


order namebusinesslabourer1 dummybusinesslabourerhhmember1 addressbusinesslabourer1 relationshipbusinesslabourer1 castebusinesslabourer1 businesslabourertypejob1 businesslabourerwagetype1 businesslabourerbonus1 businesslabourerinsurance1 businesslabourerpension1 businesslabourerdate1 namebusinesslabourer2 dummybusinesslabourerhhmember2 addressbusinesslabourer2 relationshipbusinesslabourer2 castebusinesslabourer2 businesslabourertypejob2 businesslabourerwagetype2 businesslabourerbonus2 businesslabourerinsurance2 businesslabourerpension2 businesslabourerdate2 namebusinesslabourer3 dummybusinesslabourerhhmember3 addressbusinesslabourer3 relationshipbusinesslabourer3 castebusinesslabourer3 businesslabourertypejob3 businesslabourerwagetype3 businesslabourerbonus3 businesslabourerinsurance3 businesslabourerpension3 businesslabourerdate3 namebusinesslabourer4 dummybusinesslabourerhhmember4 addressbusinesslabourer4 relationshipbusinesslabourer4 castebusinesslabourer4 businesslabourertypejob4 businesslabourerwagetype4 businesslabourerbonus4 businesslabourerinsurance4 businesslabourerpension4 businesslabourerdate4 namebusinesslabourer5 dummybusinesslabourerhhmember5 addressbusinesslabourer5 relationshipbusinesslabourer5 castebusinesslabourer5 businesslabourertypejob5 businesslabourerwagetype5 businesslabourerbonus5 businesslabourerinsurance5 businesslabourerpension5 businesslabourerdate5 namebusinesslabourer6 dummybusinesslabourerhhmember6 addressbusinesslabourer6 relationshipbusinesslabourer6 castebusinesslabourer6 businesslabourertypejob6 businesslabourerwagetype6 businesslabourerbonus6 businesslabourerinsurance6 businesslabourerpension6 businesslabourerdate6 namebusinesslabourer7 dummybusinesslabourerhhmember7 addressbusinesslabourer7 relationshipbusinesslabourer7 castebusinesslabourer7 businesslabourertypejob7 businesslabourerwagetype7 businesslabourerbonus7 businesslabourerinsurance7 businesslabourerpension7 businesslabourerdate7 namebusinesslabourer8 dummybusinesslabourerhhmember8 addressbusinesslabourer8 relationshipbusinesslabourer8 castebusinesslabourer8 businesslabourertypejob8 businesslabourerwagetype8 businesslabourerbonus8 businesslabourerinsurance8 businesslabourerpension8 businesslabourerdate8 namebusinesslabourer9 dummybusinesslabourerhhmember9 addressbusinesslabourer9 relationshipbusinesslabourer9 castebusinesslabourer9 businesslabourertypejob9 businesslabourerwagetype9 businesslabourerbonus9 businesslabourerinsurance9 businesslabourerpension9 businesslabourerdate9 namebusinesslabourer10 dummybusinesslabourerhhmember10 addressbusinesslabourer10 relationshipbusinesslabourer10 castebusinesslabourer10 businesslabourertypejob10 businesslabourerwagetype10 businesslabourerbonus10 businesslabourerinsurance10 businesslabourerpension10 businesslabourerdate10 namebusinesslabourer11 dummybusinesslabourerhhmember11 addressbusinesslabourer11 relationshipbusinesslabourer11 castebusinesslabourer11 businesslabourertypejob11 businesslabourerwagetype11 businesslabourerbonus11 businesslabourerinsurance11 businesslabourerpension11 businesslabourerdate11 namebusinesslabourer12 dummybusinesslabourerhhmember12 addressbusinesslabourer12 relationshipbusinesslabourer12 castebusinesslabourer12 businesslabourertypejob12 businesslabourerwagetype12 businesslabourerbonus12 businesslabourerinsurance12 businesslabourerpension12 businesslabourerdate12 namebusinesslabourer13 dummybusinesslabourerhhmember13 addressbusinesslabourer13 relationshipbusinesslabourer13 castebusinesslabourer13 businesslabourertypejob13 businesslabourerwagetype13 businesslabourerbonus13 businesslabourerinsurance13 businesslabourerpension13 businesslabourerdate13 namebusinesslabourer14 dummybusinesslabourerhhmember14 addressbusinesslabourer14 relationshipbusinesslabourer14 castebusinesslabourer14 businesslabourertypejob14 businesslabourerwagetype14 businesslabourerbonus14 businesslabourerinsurance14 businesslabourerpension14 businesslabourerdate14 namebusinesslabourer15 dummybusinesslabourerhhmember15 addressbusinesslabourer15 relationshipbusinesslabourer15 castebusinesslabourer15 businesslabourertypejob15 businesslabourerwagetype15 businesslabourerbonus15 businesslabourerinsurance15 businesslabourerpension15 businesslabourerdate15, after(nbbusinesslabourers)


order joblocation jobdistance joblocationname nbemployer wagejobnbworker typewageemployer1 relationemployer1 relationemployer_labour1 relationemployer_relative1 relationemployer_political1 relationemployer_religious1 relationemployer_neighbor1 relationemployer_shg1 relationemployer_businessman1 relationemployer_wkp1 relationemployer_traditional1 relationemployer_friend1 relationemployer_notappli1 relationemployer_noresponse1 casteemployer1 othercasteemployer1 otheremployertype1 typewageemployer2 relationemployer2 relationemployer_labour2 relationemployer_relative2 relationemployer_political2 relationemployer_religious2 relationemployer_neighbor2 relationemployer_shg2 relationemployer_businessman2 relationemployer_wkp2 relationemployer_traditional2 relationemployer_friend2 relationemployer_notappli2 relationemployer_noresponse2 casteemployer2 othercasteemployer2 otheremployertype2 typewageemployer3 relationemployer3 relationemployer_labour3 relationemployer_relative3 relationemployer_political3 relationemployer_religious3 relationemployer_neighbor3 relationemployer_shg3 relationemployer_businessman3 relationemployer_wkp3 relationemployer_traditional3 relationemployer_friend3 relationemployer_notappli3 relationemployer_noresponse3 casteemployer3 othercasteemployer3 otheremployertype3 typewageemployer4 relationemployer4 relationemployer_labour4 relationemployer_relative4 relationemployer_political4 relationemployer_religious4 relationemployer_neighbor4 relationemployer_shg4 relationemployer_businessman4 relationemployer_wkp4 relationemployer_traditional4 relationemployer_friend4 relationemployer_notappli4 relationemployer_noresponse4 casteemployer4 othercasteemployer4 otheremployertype4 typewageemployer5 relationemployer5 relationemployer_labour5 relationemployer_relative5 relationemployer_political5 relationemployer_religious5 relationemployer_neighbor5 relationemployer_shg5 relationemployer_businessman5 relationemployer_wkp5 relationemployer_traditional5 relationemployer_friend5 relationemployer_notappli5 relationemployer_noresponse5 casteemployer5 othercasteemployer5 otheremployertype5 typewageemployer6 relationemployer6 relationemployer_labour6 relationemployer_relative6 relationemployer_political6 relationemployer_religious6 relationemployer_neighbor6 relationemployer_shg6 relationemployer_businessman6 relationemployer_wkp6 relationemployer_traditional6 relationemployer_friend6 relationemployer_notappli6 relationemployer_noresponse6 casteemployer6 othercasteemployer6 otheremployertype6 typewageemployer7 relationemployer7 relationemployer_labour7 relationemployer_relative7 relationemployer_political7 relationemployer_religious7 relationemployer_neighbor7 relationemployer_shg7 relationemployer_businessman7 relationemployer_wkp7 relationemployer_traditional7 relationemployer_friend7 relationemployer_notappli7 relationemployer_noresponse7 casteemployer7 othercasteemployer7 otheremployertype7 typewageemployer8 relationemployer8 relationemployer_labour8 relationemployer_relative8 relationemployer_political8 relationemployer_religious8 relationemployer_neighbor8 relationemployer_shg8 relationemployer_businessman8 relationemployer_wkp8 relationemployer_traditional8 relationemployer_friend8 relationemployer_notappli8 relationemployer_noresponse8 casteemployer8 othercasteemployer8 otheremployertype8 typewageemployer9 relationemployer9 relationemployer_labour9 relationemployer_relative9 relationemployer_political9 relationemployer_religious9 relationemployer_neighbor9 relationemployer_shg9 relationemployer_businessman9 relationemployer_wkp9 relationemployer_traditional9 relationemployer_friend9 relationemployer_notappli9 relationemployer_noresponse9 casteemployer9 othercasteemployer9 otheremployertype9, after(businesslabourerdate15)



********** Drop non-worker
drop if annualincome==.
drop occupationnumber
*dropmiss, force





********** Merge parent_key
merge m:1 HHID_panel INDID_panel using "temp_NEEMSIS2-HHINDID", keepusing(HHID2020 INDID2020)
keep if _merge==3
drop _merge
drop HHID_panel INDID_panel
order HHID2020 INDID2020

duplicates report HHID2020 INDID2020 occupationid





********** SAVE
save"Last\NEEMSIS2-occupations", replace

