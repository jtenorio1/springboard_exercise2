#The following is Jorge Tenorio's submission for exercise 2 of the Springboard Introduction to Data Science course. 
#install packages
install.packages("dplyr")
install.packages("tidyr")

#load packages
suppressMessages(library(dplyr))
suppressMessages(library(tidyr))

ship <- tbl_df(titanic_original)

#----------------------------------------------------------------------------------------------------------
#TASK 1: Point of Embarcation - Replace the blank values in the embarked column with S. 
#Identify what a blank "looks" like
ship %>% select(embarked) %>% unique()

#FAILED ATTEMPTS
#ship[,11] <- gsub("", "S", as.matrix(ship[,11]), ignore.case = TRUE); this case replaces all spaces with S (undesired result)
#ship$embarked[is.na(ship$embarked)] <- "S"; this case dosn't insert S where is.na == TRUE... I think I need to make into an if statement to work?

#SUCCESS: in cases where ship$embarked is "" insert S
ship$embarked[ship$embarked == ""] <- "S"

ship
View(ship)

#Double-check to make sure there are no blanks
ship %>% select(embarked) %>% unique()

#----------------------------------------------------------------------------------------------------------
#TASK 2: Replace the missing ages using the mean/median
#Using the mean of age to fill in missing age

#Part 1: use colMeans to find mean. CODE: ship %>% select(age) %>% colMeans(, na.rm = TRUE) = 29.88113

#FAILED ATTEMPT to insert mean(age) where age == NA
#ship$age[ship$age == is.na()] <- 29.88113

#SUCCESS
ship[["age"]][is.na(ship[["age"]])] <- ship %>% select(age) %>% colMeans(, na.rm = TRUE)

View(ship)

#QUESTION: what's the difference between 
#ship %>% select(age) and #ship$age?

#Q: Other methods for populating NA's in age?
#1. We could use a random/normal distribution with a mean equal to that of the population for whom we have age values for, then use this distribution to randomly assign ages
#2. We could identify the type of dsitrbution that best fits the age data we have, then randomly sample using this distribution to fill in NA's
#3. Just sample a uniform distrbution using the min/max of known ages as our limits. 

#----------------------------------------------------------------------------------------------------------
#TASK 3: Fill in empty slots for boat passengers with 'None' or 'NA'
ship$boat[ship$boat == ""] <- "none"
View(ship)

#----------------------------------------------------------------------------------------------------------
#TASK 4: 
#Q - Does it make sense to fill in missing cabin numbers with a value? What does a missing value mean here?
#A - It does make sense that there are missing cabin numbers. By performing a quick query on those who have a cabin vs those who don't,
#you can see those with a cabin had either siblings/parents on board. This might suggest that cabins were more likely to be used by families,
#and single voyagers (wanting to spend less) would not purchase a cabin. 

#Query for those with cabins vs those without:
ship %>% filter(cabin != "")
ship %>% filter(cabin == "")

#Create new colummn for those with a cabin vs those without called "has_cabin_number"
ship <- ship %>% mutate(has_cabin_number = ifelse(cabin == "", 0, 1))
View(ship)

#----------------------------------------------------------------------------------------------------------
#JUST FOR FUN: Let's group by economic class and perform a count on the number that have a cabin.
ship %>% group_by(pclass) %>% select(has_cabin_number) %>% table()

#We can see that mostly only 1st cass passengers are able/willing to purchase a cabin. Very few second and third class passengers had a cabin. 

#----------------------------------------------------------------------------------------------------------
#Task 5: Export as csv
write.csv(ship, file = "titanic_clean.csv")


