library(rvest)
library(reshape2)
library(tidyr)

# 2019-2020 season
#first: 401160623
#last:  401161326

# 2018-2019 <- 401070791:401070854,401070856:401071902
# 2019-2020 <- 401160622:401160631,401160652:401161325

link_num <- c(401070791:401070854,401070856:401071902,401160622:401160631,401160652:401161325) #found a "skip" in the order of games, don't know why? 

full_nba <- c()

for (game in link_num){
  game = game + 1
  nbaparse <- read_html(paste0('https://www.espn.com/nba/matchup?gameId=',game))

  nbanodes <- html_nodes(nbaparse, "table")

  nbaparse%>% 
    html_nodes('.abbrev')%>%
    html_text() -> team_name

  nbaparse%>%
    html_nodes('.score-container')%>%
    html_text() -> score_game 

  nba <- html_table(nbanodes, header = T, fill = T)[[2]]

  names(nba) <- paste(c("In-game stats", "T", "O")) # Add team abbreviation from website

  nba <- nba[-c(18:20),] #remove "biggest lead", "technical fouls" and "flagrant fouls"

# Extract "attempts" from behind the "-"
  fg_att <- sub(".*-", "",nba[c(1), c(2,3)])
  p3_att <- sub(".*-", "",nba[c(3), c(2,3)])
  ft_att <- sub(".*-", "",nba[c(5), c(2,3)])

# Add name to variable
  fg_att <- c('FG attempts',fg_att)
  p3_att <- c('3P attempts', p3_att)
  ft_att <- c('FT attempts', ft_att)
  score_game <- c('Points', score_game)

  nba <- do.call('rbind', list(nba, fg_att,p3_att,ft_att,score_game))

# Remove the attempt (in front the "-")
  nba[1,2:3] <- sub("-.*", "",nba[c(1), c(2,3)])
  nba[3,2:3] <- sub("-.*", "",nba[c(3), c(2,3)])
  nba[5,2:3] <- sub("-.*", "",nba[c(5), c(2,3)])

# make the columns numeric
  nba[,2] <- as.numeric(nba[,2])
  nba[,3] <- as.numeric(nba[,3])

# add new column to calc difference
  nba['Difference'] <- nba[,2] - nba[,3]

  nba <- t(nba)
  colnames(nba) <- nba[1,]
  nba <- nba[-1,]


  nba <- nba %>%
    melt()%>%
    unite(col = untited, 1:2, sep = "-")%>%
    t()

  colnames(nba) <- nba[1,] #set row 1 as column names
  row.names(nba)[2] <- paste(team_name[1],team_name[2],sep = " vs ") # set row name as the teams playing
  
  nba <- as.data.frame(nba)
  nba <- nba[-1,]
  
  
  full_nba <- rbind(nba[1,],full_nba)
}
####################################



view(full_nba)

write.csv(full_nba, file = '2018_2020_raw_data.csv')

getwd()

