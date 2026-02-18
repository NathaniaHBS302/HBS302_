****************************************************
* From Basic to Polished—Visualization Design
* Author: Nathania Magana 
* Date: 02/18/26
* Sections:
* 1. What makes up a chart
* 2. Using schemepack for professional styles
* 3. Exporting charts from Stata
****************************************************
* Project summary: This project analyzes proverty in the counties of Tennessee. It includes an estimation of families in proverty according to their demographic and where they live. This project will identify trends in these demographics using visualizations. 

*******************************************************************************
* 0. Preliminaries: Stata Setup
*******************************************************************************

* Clear all data, variables, and stored results from memory to ensure a clean working environment
clear

* Allow Stata to handle large matrices (useful for models with many variables or fixed effects)
set matsize 800

* Run this do-file under Stata 19.5 syntax to ensure reproducibility across software versions
version 19.5

* Prevent Stata from pausing output with the --more-- prompt so the do-file runs uninterrupted
set more off

* Require full variable names
set varabbrev off

* Set project directory
cd "C:/Users/nathaniam/Documenta/stata"

* Start the log fle to record your results*
log using "HBS_PS1_021826", replace

*******************************************************************************
****************************************************
* 1. What makes up a chart
****************************************************

* 1) Load dataset from last assignment 
 use merged_poverty_data.dta, clear
 *******************************************************************************
* 2. Explore your dataset
*******************************************************************************

* Use summarize, tabulate, or tabstat to explore at least three variables
summarize Total_Fam_pov_under18 Total_Fam_pov_under5 Fam_pov_WhiteOnly Fam_pov_Black

* Comment: The data shows high standard deviation for White and Black families in poverty. Concerning Black families, It was interesting how the minimum was 0 and the max reported 117,093 Black families in poverty. 

*******************************************************************************
* 3. Generate Tables
*******************************************************************************

* Frequency table: Distribution of Poverty 
tabulate poverty_cat
* Cross-tabulation: Create variable for high child poverty
gen high_child_pov = (Total_Fam_pov_under18 > 29000) if !missing(Total_Fam_pov_under18)

label define high_lab 0 "Low/Moderate" 1 "High"
label values high_child_pov high_lab
*tabulate both the poverty category and high child poverty 
tabulate poverty_cat high_child_pov, column 

* these variables show that even when a category is considered low poverty, there can be high child poverty. As a result, 11 areas show low to moderate child poverty, while 7 areas show high child poverty. 

*******************************************************************************
* 4. Visualize Your Findings & Exporting
*******************************************************************************
* Graph 1: Bar Chart (Pov by Race)

*schemepack 
set scheme gg_tableau

graph bar Fam_pov_WhiteOnly Fam_pov_Black, ///
	over (poverty_cat) ///
		blabel(bar, format(%9.0f)) ///
		title("Poverty Counts by Race & Category: Mean") ///
		ytitle ("Number of families") ///
		legend (label(1 "White Only") label(2 "Black/African American")) ///
		scheme (gg_tableau) ///
		note("Poverty in Tennesssee Counties", size(vsmall)) 
		
graph export "BarChart-PovertyData.png", replace width(2000)

* COMMENT: This bar chart shows a report of 39,396 White Families in low poverty, while 3701 Blsck Families are in low poverty. There seems to be a notable increase in Medium Poverty for Black families with a report of 81,356.

* Graph 2: Scatter Plot

twoway ///
	(scatter Total_Fam_pov_under18 Total_Fam_pov_under5 if high_child_pov==0, ///
		msymbol(0) msize(small) mcolor(blue)) ///
	(scatter Total_Fam_pov_under18 Total_Fam_pov_under5 if high_child_pov==1, ///
		msymbol(D) msize(small) mcolor(pink)), ///
	ylabel(, grid) ///
	xtitle("Families in Poverty(With Children Under 5)") ///
	ytitle("Families in Poverty (With Children Under 18)") ///
	legend(order(1 "Moderate Child Poverty" 2 "High Child Poverty") ///
		position(6) ring(0)) ///
	title("Families in Poverty: Children Under 5 vs. Children Under 18") ///
		note("Poverty in Tennessee Counties", size (vsmall)) /// 
		scheme (gg_tableau)

graph export "Scatter Plot- PovertyData.png", replace width 2000

* COMMENT: This scatter plot made a clear distinction between moderate child poverty and high child poverty. It was interesting to find that for high child poverty with children under 18 it had a point exceeding 100,000 families. 

*******************************************************************************
* 5. Wrap Up and Submit
*******************************************************************************

* Summary: During the process of creating these visuals, I learned that even if a family is placed in a low povert category, it can still have a substantial amount of high child poverty. Additionally, I learned that Black families had a huge increase in medium poverty compared to low poverty. In the scatter plot, most families with high child poverty have children under 18, while less that 5,000 families in moderate child poverty have children under 18 or 5 years old. 

log close
*******************************************************************************

