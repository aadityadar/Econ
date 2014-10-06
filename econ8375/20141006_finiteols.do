/*
In this do file we demonstrate the finite sample properties of the OLS estimator
using the methods prescribed in:
Cameron and Trivedi (2010) Microeconometrics Using Stata, Revised Edition, Ch 4.6 
*/

clear all

// Set path

local path "c:\users\dar\desktop\"
cd `path'

log using `path'log_finiteols, replace

// Define local macros for sample size and number of simulations
global nobs 10
global nsim 100
global alpha 0.50

// Write the program that calculates the ols estimator with chi-squared errors 
capture program drop ols
program ols, rclass
	drop _all
	set obs $nobs				// set number of observations 
	gen x = rchi2(1)			// regressor is random
	gen e = rchi2(1) - 1		// error is independent of the regressor (and skewed)
	gen y = 1 + 2 * x + e		// beta_1 = 1 and beta_2 = 2
	reg y x						
	return scalar b2 = _b[x]
	return scalar se2 = _se[x]
	return scalar t2 = (_b[x] - 2) / _se[x]
	return scalar r2 = abs(return(t2)) > invttail($nobs - 2, $alpha/2)
	return scalar p2 = 2 * ttail($nobs - 2, abs(return(t2)))
end

// Execute the program once
set seed 10101
ols
sum

// Run simulations

simulate b2f = r(b2) se2f = r(se2) t2f = r(t2) reject2f = r(r2) p2f = r(p2), reps ($nsim): ols

sum 
mean *

log close
