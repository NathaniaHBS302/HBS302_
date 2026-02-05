
****************************************************
* Data Management — From Raw to Ready
* Author: Nathania Magana
* Sections:
* 0. Preliminaries
* 1. Data Import
* 2. Data Cleaning
* 3. Renaming and Labeling Variables
* 4. Variable Transformationg (Destring ↔ Tostring)
* 5. Missing Values
* 6. Variable Construction and Transformation 
* 7. Merging and Appending Datasets
* 8. Reshaping Data (Wide ↔ Long)
* 9. Data Export
****************************************************


****************************************************
* 0. Preliminaries: Stata Setup
****************************************************

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

****************************************************
* 1. Data Import
****************************************************

* Import raw data from a CSV file
* Use this command when the raw data are stored as comma-separated values
. import excel "/Users/nathaniam/Library/Mobile Documents/com~apple~Numbers/Documents/HB
> S 302_ProblemSet1.xlsx", sheet("Sheet 1 - ACSST1Y2023.S1702-Dat") allstring

* Alternatively, import data directly from Google Drive
* Step 1: Obtain a shareable download link (not the edit link)
* https://drive.google.com/file/d/1SSQYhAGo1Q2EK5P5NzBR6dX9Yavp8O1O/view?usp=sharing
* Step 2: Use the direct download URL in Stata
* https://drive.google.com/uc?id=1SSQYhAGo1Q2EK5P5NzBR6dX9Yavp8O1O&export=download
* Example below assumes a publicly accessible CSV file
* import delimited "https://drive.google.com/uc?id=FILE_ID&export=download", clear
* Import ACS data from a CSV file stored on Google Drive
* The file is accessed using a direct download link
* clear: remove any existing data in memory before importing
* Import excel using google docs spreadsheet, first row clear
import excel using "https://docs.google.com/spreadsheets/d/1SxETbL3hwDDhSNaC0kmb0l6-dRH4h0Bz/export?format=xlsx", cellrange(A2:WD25) firstrow clear
****************************************************
* 2. Data Cleaning
****************************************************

* Import the dataset first
* Inspect variable names, data types, and storage formats
* This helps identify variables imported as strings instead of numeric
describe

* Review the first few observations for obvious data issues
list in 1/10

* List all variables that start with S1702_
ds S1702_*

* Drop margins of error (variables ending with "m")
* We only keep the estimates for analysis
drop *M

* Save cleaned dataset with a descriptive name
* The file will be saved in the current working directory
* (i.e., the directory you previously set using the cd command)
* replace: if a file with the same name already exists, Stata will overwrite it.
save "firstclean.dta", replace

* Verify remaining variables
describe

****************************************************
* 3. Renaming and Labeling Variables
****************************************************

* Estimate of Total Poverty for Families
rename S1702_C01_001E Total_Families_pov
label variable Total_Families_pov "Estimate of Total Poverty for Families"

* Estimate Total poverty with related children of the householder under 18 years
rename S1702_C01_002E Total_Fam_pov_under18
label variable Total_Fam_pov_under18 "Estimate Total poverty with related children of the householder under 18 years"

* Estimate Total With related children of householder under 18 years and under 5 years
rename S1702_C01_003E Total_Fam_pov_under5
label variable Total_Fam_pov_under5 "Estimate Total With related children of householder under 18 years and under 5 years"

*Estimate of families in poverty White alone
rename S1702_C01_006E Fam_pov_WhiteOnly
label variable Fam_pov_WhiteOnly "Estimate of families in poverty White alone"

*Estimate of families poverty Black or African American alone
rename S1702_C01_007E Fam_pov_Black
label variable Fam_pov_Black "Estimate of families poverty Black or African American alone"

*Estimate of families in poverty American Indian and Alaska Native alone
rename S1702_C01_008E Fam_pov_AmerIndian
label variable Fam_pov_AmerIndian "Estimate of families in poverty American Indian and Alaska Native alone"

*Estimate of families in poverty Asian alone
rename S1702_C01_009E Fam_pov_Asian
label variable Fam_pov_Asian "Estimate of families in poverty Asian alone"

*Estimate of families in poverty Native Hawaiian and Other Pacific Islander
rename S1702_C01_010E Fam_pov_NativeHawaiian
label variable Fam_pov_NativeHawaiian "Estimate of families in poverty Native Hawaiian and Other Pacific Islander"

*Estimate of families in poverty some other race alone
rename S1702_C01_011E Fam_pov_OtherRace
label variable Fam_pov_OtherRace "Estimate of families in poverty some other race alone"

*Estimate of families in poverty Hispanic or Latino origin (of any race)
rename S1702_C01_013E Fam_pov_Hispanic
label variable Fam_pov_His
panic "Estimate of families in poverty Hispanic or Latino origin (of any race)"


*Keep only variable you need 
* Also, keep keep geo_id and name
keep GEO_ID NAME Total_Families_pov Total_Fam_pov_under18 Total_Fam_pov_under5 Fam_pov_WhiteOnly Fam_pov_Black Fam_pov_AmerIndian Fam_pov_Asian Fam_pov_NativeHawaiian Fam_pov_OtherRace Fam_pov_Hispanic

* Verify remaining variables
describe

* Save the dataset after renaming and labeling
* We can still use the same filename (firstclean.dta)
* because this is an updated version of the cleaned data
save "firstclean.dta", replace

  ****************************************************
* 4. Convert String Variables to Numeric
****************************************************
use "firstclean.dta", clear

* Using describe, we see that all remaining variables are stored as strings.
describe

* Convert variables from string to numeric
destring Total_* Fam_*, replace

save "firstclean", replace

****************************************************
* 5. Missing Values
****************************************************
use "firstclean.dta", clear

* Always summarize variables BEFORE constructing new ones
* This helps us understand ranges, missing values, and scale
* before we create derived measures
summarize Total_* Fam_*

destring Total_* Fam_*, replace ignore(",") force
tab Fam_pov_NativeHawaiian
destring Total_* Fam_*, replace ignore("," "-" "(X)" "**") force

* You can also summarize selected variables ///
  (e.g., by double-clicking variable names or typing them explicitly)
summarize Total_Families_pov Total_Fam_pov_under18 Total_Fam_pov_under5 Fam_pov_WhiteOnly Fam_pov_Black Fam_pov_AmerIndian Fam_pov_Asian Fam_pov_NativeHawaiian Fam_pov_OtherRace Fam_pov_Hispanic

* Alternatively, we can explicitly check missing values using code:
misstable summarize Total_* Fam_*


/* =========================
   Handling with Missing
   ========================= */
drop if missing(Total_Families_pov)
recode Fam_pov_* (miss = 0)
summarize Total_* Fam_*
count 

save "firstclean", replace****************************************************
* 6. Variable Construction and Transformation
****************************************************
use "firstclean.dta", clear

* Always inspect variables before constructing or transforming them
summarize Total_* Fam_*

/* =========================
   Construction using gen
   ========================= */
   

* Standardize unemployment rate (z-score)
egen pov_total_z = std(Total_Families_pov)
label variable pov_total_z "Standardized Total Family Poverty (z-score)"

* Create a simple labor market index using row means
egen minority_pov_index = rowmean(Fam_pov_Black Fam_pov_Hispanic)
label variable minority_pov_index "Mean of Black and Hispanic families in poverty"

gen pct_fam_poverty = (Total_Families / 1847158) * 100
label variable pct_fam_poverty "Percentage of Families in Poverty (TN)"

label variable pov_rate_z "Standardized Poverty Rate (z-score)"

* To see your new variables alongside the names of the areas, run:
list NAME pct_fam_poverty pov_rate_z in 1/10

/* =========================
   Transformation using recode
   ========================= */
   
* Create 0 for low/normal and 1 for high poverty
recode pct_fam_poverty (0/12 = 0) (12.0001/100 = 1), gen(high_poverty)

label variable high_poverty "High Poverty Indicator (1 = Poverty > 12%)"

* Check how many of your 23 observations are "High Poverty"
tab high_poverty

* Let's use 0-8% (Low), 8-15% (Medium), and 15%+ (High)
recode pct_fam_poverty ///
    (0/8 = 1) ///
    (8.0001/15 = 2) ///
    (15.0001/100 = 3), gen(poverty_cat)

* Now, create labels so you see words instead of just 1, 2, 3
label define pov_labels 1 "Low Poverty" 2 "Medium Poverty" 3 "High Poverty"
label values poverty_cat pov_labels

label variable poverty_cat "Poverty Category (Low / Medium / High)"

* Inspect your new categories
tab poverty_cat

save 
****************************************************
* 7. Merging and Appending Datasets
****************************************************
* This section introduces two ways to combine datasets:
* - merge   : add variables (columns) by matching keys
* - append  : add observations (rows) by stacking datasets

/* =========================
   Merging Datasets 1:1 
   ========================= */
import excel "https://docs.google.com/spreadsheets/d/1K-BbAiH_RTUf6a0J4fTo12pK9eHWPWy-/export?format=xlsx", firstrow clear

*Drop the junk rows at the top
drop in 1/7

* Rename columns 
rename D GEO_ID
rename G poverty_rate_pm

* NOW clean the text BEFORE it becomes a number
replace poverty_rate_pm = subinstr(poverty_rate_pm, "%", "", .)
destring poverty_rate_pm, replace force

* Format the GEO_ID to match your other file
tostring GEO_ID, replace
replace GEO_ID = "0500000US" + GEO_ID

*merging both datasets
merge 1:1 GEO_ID using "poverty_counts"
keep if _merge == 3

*ngenerate the group means and clean up the names.
bysort poverty_cat: egen mean_pov_cat = mean(poverty_rate_pm)
label variable mean_pov_cat "Mean poverty rate by category"

* Removes " County, Tennessee" so it just says the name (e.g., "Knox")
replace NAME = subinstr(NAME, " County, Tennessee", "", .)

list NAME poverty_rate_pm mean_pov_cat

* Label variable J
label variable J "Location"
drop I

* Rename column F and label variable
rename F ppov
label variable ppov "poverty percentage"

*rename column B
rename B county 
label variable county "county"

*rename column C
rename C state
label variable state "state"

*rename column H year 
rename H year 
label variable year "poverty percentage in year 2022"

drop E
drop J

save "merged_poverty_data.dta", replace
/* =========================
   Appending Datasets 
   ========================= */

* 1. Load your current merged data (the 18 counties)
use "merged_poverty_data.dta", clear

* 2. Save the first 9 counties as 'Part 1'
preserve
    keep in 1/9
    gen source_file = "Group A"
    save "part1.dta", replace
restore

* 3. Save the remaining counties as 'Part 2'
preserve
    keep in 10/18
    gen source_file = "Group B"
    save "part2.dta", replace
restore

* Load the first dataset
use "part1.dta", clear

* Append the second dataset (this stacks Part 2 under Part 1)
append using "part2.dta"

* Verify the append just like the professor's example
count
tab source_file

save "poverty_appended_final.dta", replace

****************************************************
* 8. Reshaping Data (Wide ↔ Long)
****************************************************
* Step 1: Load the appended dataset
use "poverty_appended_final.dta", replace
count

* 2. DUPLICATE the data so we have two of every county (making 36 rows)
expand 2
sort NAME
count

* 3. Now assign the years 2022 and 2023
* Use the 'county' variable we created earlier
rename NAME county
bysort county: gen Year = 2021 + _n

* 4. Verify - this MUST show 18 for 2022 and 18 for 2023
tab Year

* Now that we officially have 2022 and 2023 data:
reshape wide poverty_rate_pm, i(county) j(Year)

* This list will finally show both columns
list county poverty_rate_pm2022 poverty_rate_pm2023 in 1/5

*Save dataset
save "final_Poverty_Wide.dta", replace


****************************************************
* 9. Data Export
****************************************************
* We now export the merged dataset into different formats, ///

use "final_Poverty_Wide.dta", clear

* Save in Stata Format
* You have already known from previous practices
* You have already seen this from previous practices.
* Common syntax:
*   save "filename.dta", replace

* Saving as a .dta file preserves:
* - variable labels
* - value labels
* - data types
save "final_Poverty_PM.dta", replace

* Export to CSV Format
* CSV files can be opened in:
* - Excel
* - R
* - Python
* - Tableau
* - GIS software

* Note:
* CSV format does NOT preserve variable labels or formats.
export delimited using "final_Poverty_PM.csv", replace

* Export to Excel Format
* Excel format is useful for:
* - sharing with non-Stata users
* - quick inspection

* firstrow(variables):
* - writes variable names in the first row of the spreadsheet

export excel using "final_Poverty_PM.xlsx", firstrow(variables) replace
