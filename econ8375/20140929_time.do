/*
How to write a simple program (with no arguments)?
Reference: Cameron and Trivedi (2010) Microeconometrics Using Stata, Revised Edition, Appendix A Programing in Stata, pp. 651-653
*/

clear all

// Write a program that tells us the time and date

program time
di c(current_time) c(current_date)
end

// Execute the program

time

/*

Note: To drop a program use <program drop time> or <clear all>
Also, <clear time> will not drop the program
To drop all programs use <clear programs> or <program drop _all>

*/


