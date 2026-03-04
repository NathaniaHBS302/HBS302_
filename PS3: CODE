****************************************************
* Project Title: Visualizating Relationships and Regression Results
* Author: Nathania Magana
* Date: 03/03/2026
* Sections:
* 1. Identify and describe your Datasets
* 2. Specify Your Regression Model
* 3. Visualize Relationships
* 4. Visualize Predicted Values
* 5. Export Your Regression Model
* 6. Reflect and Comment
* 7. Submit your work
****************************************************

*Project summmary: In this project I will be taking the next step into my developing analysis. I will be creating an analytical visualization of ppoverty in the counties of Tennessee. I will specify and estimate a simple regression model using my dataset. 

*******************************************************************************************************
* 0. Preliminaries: Stata Setup
*******************************************************************************************************
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
cd "C:/Users/nathaniam/Documents/Stata"

********************************************************************************
* 1. Identify and Describe Dataset
********************************************************************************
* Importing dataset from Project 2 via Google link
import delimited "https://drive.google.com/uc?export=download&id=1xnZjPkM-QKG5miW0nolxu1o-bvzEfh1E", clear

** Confirm variable names are consistent with Project 2
describe
summarize

*******************************************************************************
* 2. Specify Your Regression Model
*******************************************************************************
* Dependent Variable (DV): ppov (poverty rate - continous)
* Independent Variable (IV): total_families (continous)

* Hypothesis: There will be a significant relationship between the the poverty rate of each county and total families

* Labeling and running the model 
regress ppov total_families
est store model1

******************************************************************************** 3. Visualize Relationships
*******************************************************************************
* Creating a scatterplot with a fitted linear regression line 
* Optional: Set the visual scheme 
* ssc install schemepack, replace
set scheme white_tableau

twoway ///
(scatter ppov total_families, mcolor(navy) msize(small)) ///
(lfit ppov total_families, lcolor(red) lwidth(medthick)), ///
title("Poverty Rate vs. Total amount of Families") ///
ytitle("Poverty Rate (%)") ///
xtitle("Total Families (County Level)") ///
legend(order(1 "Observed Data" 2 "Fitted Linear Trend")) ///
name(scatterplot_poverty, replace)

*Comment on whether the plot aligns with your regression results: The fitted linear model is nearly flat. This indicates that total families has a small effect on the poverty rate. The regression results shows that the relationship is not very strong. 

******************************************************************************** 4. Visualize Predicted Values (Margin)
*******************************************************************************
* Using margins and marginsplot to display predictions on poverty rates across different population sizes 

regress ppov total_families
margins, at(total_families=(10000(20000)200000))

marginsplot, ///
recast(line) recastci(rarea) ///
ciopts(fcolor(forest_green) lwidth(none)) ///
title("Predicted Poverty Rates by Family Count") // 
xtitle("Total Families") ytitle("Predicted Poverty rate") ///
name(Margin_poverty, replace)

*Interpret what the trends reveal in policy terms: According to the graph, the shaded area gets wider as the populations increases. Therefore, the predicted poverty rate can range from 16% to 10% as the population size increases. It represents increasing uncertainty. 

******************************************************************************** 5. Export Your Regression Table
******************************************************************************** Use regress, est store, and esttab (or similar)
* We use 'esttab' to create a publication-quality table from our stored 'model1'
* We specify 3 decimal places, standard errors, and classic significance stars

esttab model1 using "Poverty_Regression_Table.rtf", replace ///
b(3) se(3) star(* 0.05 *** 0.01 *** 0.001) ///
label ///
title("Table 1: Impact of County Population on Poverty Levels") ///
mtitle("OLS Model") ///
addnotes("Standard Errors in Parentheses" "Data: Project 2 Merged Data")

******************************************************************************** 6. Reflect & Comment
********************************************************************************Briefly interpret your regression results
*Explain whether visualization helped or challenged your understanding
*Identify a possible next step (e.g., adding a control or comparing groups)

* With the regression result it was revealed that poverty rates and total families did not have a strong relationship. In the scatterplot the fitted linear model was nearly flat indicating that total families has a small effect on poverty rates. Additionally, in the marginsplot the shaded area got wider as the population size increased. This represents a increasing uncertainty. The visualization helped me understand that poverty rate and population size does not hold a strong relationship. The marginsplot also expressed the range of uncertainty. 

* To improve this model I would add the control variable fam_pov_hispanic to express the relationship with Hispanic families.  


*End of Do File 
log close 
