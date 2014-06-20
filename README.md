myElectionApp
=============

##Introduction

The idea starts with result of general election of India, 2014.
The data was available at [election comission of India website](http://eciresults.nic.in/ConstituencywiseU011.htm), I pulled the data and saved it to my another [github repo](https://github.com/kuberiitb/analytics/).   
I tried to plot the data using ggplot2 and got [this](https://github.com/kuberiitb/analytics/blob/master/LeadingParty.png), but then I felt singe graph can not give enough information. When I came to know about R shiny package, I gave it some time and now I can say it was fruitful attempt with [myElectionApp](https://kuberiitb.shinyapps.io/myElectionApp/).   

##Usage

The app gives you option to visualize the election result data on state level as well as country level.
In Input tab, You can choose Country (India) or any State or UT and in Output tab, you can choose if you want to see vote share or Seats won by parties. 
NOTE: Since there are a lot of partied in the data, I ahd to merge all the partied getting less than 1% vote and merge them into "Other" party.

