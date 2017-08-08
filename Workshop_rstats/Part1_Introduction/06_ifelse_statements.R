# Learning R: 06_ifelse_statements.R
# author: Tina Cormier
# date: August, 2017

# ifelse(condition, value if true, value if false)
score <- 5
contest <- ifelse(score >=2, "winner", "try again")
contest

# OR, another way of writing it, which is useful
# when you need to do something more complex depending 
# on the condition.
score <- 1
if (score >=2) {
	contest <- "winner"
} else {
	contest <- "try again"
	}
print(contest)
	
# If you have multiple conditions
score <- 50
# score <- 3
# score <- 1
if (score >=2 && score < 4) {
	contest <- "pretty good"
} else if (score >= 10) {
	contest <- "superb"
} else {
	contest <- "try again"
	}
print(contest)

