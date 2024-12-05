**# load data
import delimited using "/Users/sw3947/Desktop/FALL2024/Research Method B/assignment/4/crime-iv.csv",clear


label var defendantid "Defendant ID"
label var republicanjudge "Republican Judge"
label var severityofcrime "Severity of Crime"
label var monthsinjail "Months in Jail"
label var recidivates "Ricidivates"


**# Balance table

global balanceopts "prehead(\begin{tabular}{l*{6}{c}}) postfoot(\end{tabular}) noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01)"

estpost ttest  severityofcrime monthsinjail, by(republicanjudge) unequal welch
esttab . using "/Users/sw3947/Desktop/FALL2024/Research Method B/assignment/4/balancetable.tex", cell("mu_1(f(3)) mu_2(f(3)) b(f(3) star)") wide label collabels("Control" "Treatment" "Difference") noobs $balanceopts mlabels(none) eqlabels(none) replace mgroups(none)

**# first stage
reg monthsinjail republicanjudge severityofcrime
eststo r1



esttab r1  using"/Users/sw3947/Desktop/FALL2024/Research Method B/assignment/4/first_stage_table.tex", replace label se  wrap width(\hsize)title("\label{tab:assignment4} First Stage") mgroups("Months in Jail", pattern(1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span ) nomtitles keep(republicanjudge severityofcrime) order(republicanjudge severityofcrime )

**# reduced form

reg recidivates republicanjudge severityofcrime

eststo r1



esttab r1  using"/Users/sw3947/Desktop/FALL2024/Research Method B/assignment/4/reduced_form_table.tex", replace label se  wrap width(\hsize)title("\label{tab:assignment4} Reduced Form") mgroups("Recidivates", pattern(1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span ) nomtitles keep(republicanjudge severityofcrime) order(republicanjudge severityofcrime )


**# IV
ssc install ivreg2
ivreg2 recidivates (monthsinjail=republicanjudge) severityofcrime


