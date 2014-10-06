/*
In this do file we demonstrate the CLT using the methods prescribed in
Cameron and Trivedi (2010) Microeconometrics Using Stata, Revised Edition, Ch 4.3
*/

clear all

// Set path

local path "c:\users\dar\desktop\"
cd `path'

log using `path'log_clt, replace

// Set observations
set obs 30

// Generate index
gen t = _n

// First, set a "seed" so that we can control "reproducibility of results"
set seed 10101 
 
// Now,  generate an uniform distributed variable 
gen x = runiform()

// Find summary statistics
sum x

// Calculate population parameters. To do this we use the r-class commands.

/*
Digression: what are r-class commands? Stata stores results from most commands 
so that they can be accessed later on. The ones that store results for analyzed 
data are called r-class commands. They are different from e-class (estimation 
commands) and s-class (parsing commands). To learn more <help return>.
*/

// Digression: see what are the commands Stata stores after running sum

return list

// Save the mean and variance as scalar variables

/*
Digression: what are scalar variables? Scalars can store numbers or strings. 
You won't see scalars in the data editor/browser. To display scalar you can use 
<display> or <scalar list> or <scalar dir>. For more <help scalar>.
*/

scalar mu = r(mean)
scalar sigma = r(Var)

// Display scalars
scalar list

// Graph x to verify that x is generated from a uniform distribution
hist x, width(0.1)
graph save `path'x, replace


/*

Before you begin the next section, please practice using r-class commands. See
<rclass.do>

So far we have drawn one sample from a uniform distribution and calculated it's 
mean and variance. Now, imagine if we repeat this procedure multiple times. If 
we were to redo this, say, 1000 times we will get 1000 samples of size 30 and 
1000 sample means. CLT says that the distribution of the sample means is going to 
converge in distribution to a normal distribution i.e. as N -> \infinity the sample
mean is approximately normally distributed. 

To demonstrate this we will need to write a program, because we don't want to code
this manually 1000 times. To do so, we name a program sample and define it to 
be rclass, which means that we will be able to store results in r(). This is 
important because we want to save the mean of each sample and then look at the 
distribution of the mean. 

To sum up, we are going to write a program that:
1. draws 30 observations from a uniform distribution
2. calculates the sample mean 
3. repeat this procedure 1000 times

Before we do this we need to be comfortable writing a program. Refer to 
<program_time.do> for more.

*/

// Write a program to draw a sample of 30 from a uniform dist and return sample mean

program sample, rclass
	drop _all 							// drop all observations and variables
	set obs 30							// set number of observations in dataset
	gen x = runiform()					// define a variable x as a draw from a uniform dist
	sum x								// provide summary stats for variable x
	return scalar samplemean = r(mean) 	// save mean of variable x in -samplemean-
end

// Execute the program

set seed 10101
sample
return list

// Now we need to repeat this procedure 1000 times and save all the samplemeans

/*

Digression: there are two ways to perform simulations in Stata:
(a) use the -simulate- command
(b) use the -postfile- command

See -help simulate- and -help postfile- for syntax and examples

*/

simulate xbar = r(samplemean), seed(10101) reps(1000) : sample

// Note: the data editor will no longer have data on the variable x; it has been replaced by xbar

// Test CLT

sum xbar
hist xbar, kdensity
graph save `path'xbar, replace
graph combine "x" "xbar"

// Alternatively, we could use the -postfile- command which offers greater flexibility

set more off
set seed 10101
postfile sim_mean xbar using simresults, replace 
// xbar is the "memory object" where the results are stored

forvalues i = 1/1000 {
	drop _all					
	set obs 30					
	tempvar x					// A local macro that may be used as a temporary variable
	gen `x' = runiform()		//  
	sum `x'						
	post sim_mean (r(mean))		// Post result to the internal filename 
}

postclose sim_mean

log close
