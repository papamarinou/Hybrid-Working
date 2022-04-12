* The whole process of cleaning and proceed to analyse the data for this empirical analysis
clear all
set maxvar 120000

*First use the wave from 2016 from the LISS panel
cd "/Volumes/MARINOS/MASTER/RESEARCH METHODS/DATA/Append"
use wave9

* Append all the other waves that are available till 2021.
append using wave10
append using wave11
append using wave12
append using wave13
append using wave14

* Use the command sort in order to sort the respondents by their ID.
sort nomem_encr

* Generate different variable for each year of interest. From 2016 till 2021 and drop out the missing values.
gen twosixteen = 0
replace twosixteen = 1 if cw16i_m != .
gen twoseventeen = 0
replace twoseventeen = 1 if cw17j_m != .
gen twoeighteen = 0
replace twoeighteen = 1 if cw18k_m != .
gen twonineteen = 0
replace twonineteen = 1 if cw19l_m != .
gen twotwenty = 0
replace twotwenty = 1 if cw20m_m != .
gen twotwentyone = 0
replace twotwentyone = 1 if cw21n_m != .

*Replace the variable year to be taken the value of the years of interest.
gen year = 2016 if twosixteen == 1
replace year = 2017 if twoseventeen == 1
replace year = 2018 if twoeighteen == 1
replace year = 2019 if twonineteen == 1
replace year = 2020 if twotwenty == 1
replace year = 2021 if twotwentyone == 1


* Set dataset to be a panel data.
xtset nomem_encr year

*Lets take a look of the dataset till now
br

* Merge the dataset "Working and Schooling" with the "Background" dataset

* Merge *
merge m:1 nomem_encr using april2016
drop _merge
merge m:1 nomem_encr using may2016
drop _merge
merge m:1 nomem_encr using april2017
drop _merge
merge m:1 nomem_encr using may2017
drop _merge
merge m:1 nomem_encr using april2018
drop _merge
merge m:1 nomem_encr using may2018
drop _merge
merge m:1 nomem_encr using april2019
drop _merge
merge m:1 nomem_encr using may2019
drop _merge
merge m:1 nomem_encr using april2020
drop _merge
merge m:1 nomem_encr using may2020
drop _merge
merge m:1 nomem_encr using april2021
drop _merge
merge m:1 nomem_encr using may2021
drop _merge



* Modify the main variable of the analysis which will take the value of 1 for those who working from home just one, and more than one day per week from home

gen wfh = 0
replace wfh = 1 if cw16i142 == 3 | cw16i142 == 4
replace wfh = 1 if cw17j142 == 3 | cw17j142 == 4
replace wfh = 1 if cw18k142 == 3 | cw18k142 == 4
replace wfh = 1 if cw19l142 == 3 | cw19l142 == 4
replace wfh = 1 if cw20m142 == 3 | cw20m142 == 4
replace wfh = 1 if cw21n142 == 3 | cw21n142 == 4


*Generate variable age for the analysis 
gen age = 0
replace age = cw16i003 if cw16i003 != .
replace age = cw17j003 if cw17j003 != .
replace age = cw18k003 if cw18k003 != .
replace age = cw19l003 if cw19l003 != .
replace age = cw20m003 if cw20m003 != .
replace age = cw21n003 if cw21n003 != .

drop if age < 18
drop if age > 67
label variable age "Respondent's age"


*generate variable female
gen female = 0
replace female = 1 if geslacht == 2
label variable female "1 for female"


*Generate variable sector (drop the missing values)
gen sector = 0
replace sector = cw16i122 if cw16i122 != .
replace sector = cw17j122 if cw17j122 != .
replace sector = cw18k122 if cw18k122 != .
replace sector = cw19l122 if cw19l122 != .
replace sector = cw20m122 if cw20m122 != .
replace sector = cw21n122 if cw21n122 != .

*Generate variable Education (drop the missing values)


gen educ = 0
replace educ = 1 if oplzon == 1 | oplzon == 2 | oplzon ==  3 | oplzon == 4
label variable educ "1 for those with a higher education (above mbo)"

/* Still working on this part

gen employ_type = 0
replace employ_type = cw16i121 if cw16i121 != .
replace employ_type = cw17j121 if cw17j121 != .
replace employ_type = cw18k121 if cw18k121 != .
replace employ_type = cw19l121 if cw19l121 != .
replace employ_type = cw20m121 if cw20m121 != .
replace employ_type = cw21n121 if cw21n121 != .
label variable employ_type "The type of employment's contract'"



gen organisation = 0
replace organisation = cw16i122 if cw16i122 != .
replace organisation = cw17j122 if cw17j122 != .
replace organisation = cw18k122 if cw18k122 != .
replace organisation = cw19l122 if cw19l122 != .
replace organisation = cw20m122 if cw20m122 != .
replace organisation = cw21n122 if cw21n122 != .
label variable organisation "1 for those who working in public-sector'"

*drop missing values
drop if organisation == 0

gen public = 0 
replace public = 1 if organisation == 1

label variable public "1 for those who working in public-sector'"


gen commute = 0
replace commute = cw16i136 if cw16i136 != .
replace commute = cw17j136 if cw17j136 != .
replace commute = cw18k136 if cw18k136 != .
replace commute = cw19l136 if cw19l136 != .
replace commute = cw20m136 if cw20m136 != .
replace commute = cw21n136 if cw21n136 != .
label variable commute "minutes to travel between work and home"


gen w_weekend = 0
replace w_weekend = cw16i141 if cw16i141 != .
replace w_weekend = cw17j141 if cw17j141 != .
replace w_weekend = cw18k141 if cw18k141 != .
replace w_weekend = cw19l141 if cw19l141 != .
replace w_weekend = cw20m141 if cw20m141 != .
replace w_weekend = cw21n141 if cw21n141 != .
label variable w_weekend "Work at the weekend, and how often"

gen weekend = 0
replace weekend = 1 if w_weekend == 4
label variable weekend "Work during the weekend almost every week"


*Working-at-home day
gen wfh = 0
replace wfh = cw16i142 if cw16i142 != .
replace wfh = cw17j142 if cw17j142 != .
replace wfh = cw18k142 if cw18k142 != .
replace wfh = cw19l142 if cw19l142 != .
replace wfh = cw20m142 if cw20m142 != .
replace wfh = cw21n142 if cw21n142 != .
label variable wfh "Do you have a partial working-at-home day"

drop if wfh == 0

gen hybrid = 0
replace hybrid = 1 if wfh == 2 | wfh == 3 | wfh == 4
label variable hybrid "1 for those who replied yes I have wfh day"


*Sector, In what sector do you work? one of the most important questions for my analysis
gen sector = 0
replace sector = cw16i402 if cw16i402 != .
replace sector = cw17j402 if cw17j402 != .
replace sector = cw18k402 if cw18k402 != .
replace sector = cw19l402 if cw19l402 != .
replace sector = cw20m402 if cw20m402 != .
replace sector = cw21n402 if cw21n402 != .
label variable sector "In what sector do you work?"

drop if sector == 0

  


gen cov = 0
replace cov = 1 if twotwenty == 1 | twotwentyone == 1 
label variable cov "1 for Covid period"


drop if cw16i001 == 0
drop if cw17j001 == 0
drop if cw18k001 == 0
drop if cw19l001 == 0
drop if cw20m001 == 0
drop if cw21n001 == 0




gen whs = 0
replace whs = cw16i129 if cw16i129 != .
replace whs = cw17j129 if cw17j129 != .
replace whs = cw18k129 if cw18k129 != .
replace whs = cw19l129 if cw19l129 != .
replace whs = cw20m129 if cw20m129 != .
replace whs = cw21n129 if cw21n129 != .

drop if whs == 999

gen whs_dum = 0
replace whs_dum = 1 if whs > 7
label variable whs_dum "1 for those replied higher than 7 in the scale  from 0 to 10"

gen actual = 0
replace actual = cw16i127 if cw16i127 != .
replace actual = cw17j127 if cw17j127 != .
replace actual = cw18k127 if cw18k127 != .
replace actual = cw19l127 if cw19l127 != .
replace actual = cw20m127 if cw20m127 != .
replace actual = cw21n127 if cw21n127 != .
drop if actual < 10
drop if actual > 80
label variable actual "actual hours work on average per week"

gen child8 = 0
replace child8 = 1 if cw16i439 == 1
replace child8 = 1 if cw17j439 == 1
replace child8 = 1 if cw18k439 == 1
replace child8 = 1 if cw19l439 == 1
replace child8 = 1 if cw20m439 == 1
replace child8 = 1 if cw21n439 == 1
label variable child8 "1 for those who have a child younger than 8 years old"


gen child = 0
replace child = 1 if cw16i436 == 1
replace child = 1 if cw17j436 == 1
replace child = 1 if cw18k436 == 1
replace child = 1 if cw19l436 == 1
replace child = 1 if cw20m436 == 1
replace child = 1 if cw21n436 == 1
label variable child "1 for those who have a child"



*Job satisfaction, I am satisfied with my job
gen j_satisfaction = 0
replace j_satisfaction = cw16i426 if cw16i426 != .
replace j_satisfaction = cw17j426 if cw17j426 != .
replace j_satisfaction = cw18k426 if cw18k426 != .
replace j_satisfaction = cw19l426 if cw19l426 != .
replace j_satisfaction = cw20m426 if cw20m426 != .
replace j_satisfaction = cw21n426 if cw21n426 != .
label variable j_satisfaction "Are you satisfied with your job"

drop if j_satisfaction == 0


gen job_satisfaction = 0
replace job_satisfaction = 1 if j_satisfaction == 3 | j_satisfaction == 4
label variable job_satisfaction "1 for those who are satisfied"


gen promotion = 0
replace promotion = cw16i434 if cw16i434 != .
replace promotion = cw17j434 if cw17j434 != .
replace promotion = cw18k434 if cw18k434 != .
replace promotion = cw19l434 if cw19l434 != .
replace promotion = cw20m434 if cw20m434 != .
replace promotion = cw21n434 if cw21n434 != .

gen promotions = 0
replace promotions = 1 if promotion == 1 | promotion == 2
label variable promotions "1 for those who believe that career promotion in their job are NOT poor"

 
 
gen was = 0
replace was = cw16i131 if cw16i131 != .
replace was = cw17j131 if cw17j131 != .
replace was = cw18k131 if cw18k131 != .
replace was = cw19l131 if cw19l131 != .
replace was = cw20m131 if cw20m131 != .
replace was = cw21n131 if cw21n131 != .
label variable was "saisfied with the atmosphere among colleagues from 0 to 10"
*Drop those with the value of "I don't know'"


gen was_dum = 0
replace was_dum = 1 if was > 7
label variable was_dum "satisfactied atmosphere among your colleagues"





 
 
 
*DESCRIPTIVE STATISTICS



tabstat job_satisfaction hybrid female age educ child  woonvorm aantalhh urban employ_type public commute weekend actual was_dum whs_dum promotions ,stat(mean sd variance cv n)
 
 
 
 

 

 *LINE TO PROVE WFH BEFORE COVID
egen m_wfh = mean(hybrid), by (year)
graph twoway (line m_wfh year, sort)
 
 
 
 
 
 
 
*SOS SOS SOS SOS SOS TAKE A LOOK TO EMPLOY_TYPE
 
 
 
*ANALYSIS




*IV REGRESSIONS WITH TEST OF ENDOGENEITY



* IV FOR JOB SATISFACTION


* 1st Model - Personal characteristics
ivregress 2sls job_satisfaction female age educ (hybrid = cov), first
outreg2 using job.doc, word replace ctitle(1)
estat endog

*2nd Model - Household characteristics
ivregress 2sls job_satisfaction female age educ child  i.woonvorm aantalhh urban (hybrid = cov), first
outreg2 using job.doc, word append ctitle(2)
estat endog


*3rd Model - Job characteristics (Full Model)
ivregress 2sls job_satisfaction female age educ child i.woonvorm aantalhh urban i.employ_type public commute weekend actual  (hybrid = cov), first 
outreg2 using job.doc, word append ctitle(3)
estat endog











* IV FOR PROMOTION SATISFACTION


* 1st Model - Personal characteristics
ivregress 2sls promotions female age educ (hybrid = cov), first
outreg2 using promotion.doc, word replace ctitle(1)
estat endog

*2nd Model - Household characteristics
ivregress 2sls promotions female age educ child  i.woonvorm aantalhh urban (hybrid = cov), first
outreg2 using promotion.doc, word append ctitle(2)
estat endog


*3rd Model - Job characteristics (Full Model)
ivregress 2sls promotions female age educ child i.woonvorm aantalhh urban employ_type public commute weekend actual  (hybrid = cov), first 
outreg2 using promotion.doc, word append ctitle(3)
estat endog










* IV FOR SATISFIED ATMOSPHERE AMONG COLLEAGUES



* 1st Model - Personal characteristics
ivregress 2sls was_dum female age educ (hybrid = cov), first
outreg2 using colleagues.doc, word replace ctitle(1)


*2nd Model - Household characteristics
ivregress 2sls was_dum female age educ child  i.woonvorm aantalhh urban (hybrid = cov), first
outreg2 using colleagues.doc, word append ctitle(2)



*3rd Model - Job characteristics (Full Model)
ivregress 2sls was_dum female age educ child i.woonvorm aantalhh urban employ_type public commute weekend actual  (hybrid = cov), first 
outreg2 using colleagues.doc, word append ctitle(3)
estat endog







* IV FOR WORKING HOURS SATISFACTION



* 1st Model - Personal characteristics
ivregress 2sls whs_dum female age educ (hybrid = cov), first
outreg2 using hours.doc, word replace ctitle(1)
estat endog

*2nd Model - Household characteristics
ivregress 2sls whs_dum female age educ child  i.woonvorm aantalhh urban (hybrid = cov), first
outreg2 using hours.doc, word append ctitle(2)
estat endog


*3rd Model - Job characteristics (Full Model)
ivregress 2sls whs_dum female age educ child i.woonvorm aantalhh urban employ_type public commute weekend actual  (hybrid = cov), first 
outreg2 using hours.doc, word append ctitle(3)
estat endog





























/* EXTRA ANALYSIS PROBABLY WILL NOT BE USED

reg whs_dum wfh cov female child8 age actual sector partner 

outreg2 using ols.doc, word replace ctitle(OLS)

reg whs_dum wfh cov female child8 age actual partner, robust

outreg2 using ols.doc, word append ctitle(Robust)


*Test the consistency and efficiency of estimators under FE vs RE


*Fixed Effects
xtreg whs_dum wfh cov child8 age actual sector , fe 

outreg2 using results.doc, word replace ctitle(Fixed Effects)
*store the results as fixed effects
eststo fe

*Random Effects
xtreg whs_dum wfh cov child8 age actual  sector, re 

outreg2 using results.doc, word append ctitle(Random Effects)
*store the results as random effects
eststo re

*Hausman Test
hausman fe re
outreg2 using hausman1.doc, word replace ctitle(Hausman Test)



*Use Fixed effects            
xtreg whs_dum wfh cov child8 age actual sector , fe vce(robust)
outreg2 using main.doc, word replace ctitle(Fixed Effects)

gen job_satisfaction_dum = 0
replace job_satisfaction_dum = 1 if job_satisfaction ==3 | job_satisfaction == 4

reg job_satisfaction hybrid female age whs child educ employ_type organisation public commute weekend child8 age actual sector








*Extra analysis but do not know yet which is the base category since it is DiDiDiD method
xtreg whs_dum wfh##cov##female##child8 age actual partner, fe vce(cluster female)

outreg2 using extra.doc, word replace ctitle(Fixed Effects (DiDiD))

xtreg whs_dum wfh##cov##female age child8 actual partner, fe vce(cluster female)


*/

