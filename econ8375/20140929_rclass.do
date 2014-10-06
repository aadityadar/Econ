// The objective of this do file is to familiarize yourself with the rclass commands and scalars
// Reference: -help return- in Stata

// Import data
sysuse auto, clear

// Summarize variable
sum mpg

// Return stored results
return list

// Display some of the stored results
di r(Var)
di r(sd)

// Find range and save the result as a scalar
scalar range = r(max) - r(min)

// Display the scalar
display "sample range = " range

// Could you use a local macro as well? 
local range r(max) - r(min)
di `range'

// What if we used generate instead of scalar?
gen range = r(max) - r(min)

// Test yourself: can you calculate the interquartile range for mpg using the rclass command?
// Hint: you have to use an option to display additional statistics in with the -summarize- command
// See -help summarize-