# AUTHOR: Colin Cookman
# CONTACT: ccookman at gmail dot com
# SOURCE: https://github.com/colincookman/pakistan_elections/
#
library(tidyverse)
library(lubridate)

candidate_data <- read.csv("./data/pk_candidate_data.csv") # load candidate data
candidate_data$election_date <- mdy(candidate_data$election_date)
  
constituency_data <- candidate_data %>%  
  filter(contest_status == "Contested") %>%
  group_by(election_type, election_date, contest_status, constituency_number, 
           constituency_name, province, assembly, voter_reg) %>%
  summarize(
    validated_votes = sum(candidate_votes),
    votes_disq = sort(votes_disq, decreasing = TRUE) [1],
    win_votes = sort(candidate_votes, decreasing = TRUE) [1],
    win_pct = win_votes/validated_votes,
    second_votes = sort(candidate_votes, decreasing = TRUE) [2],
    second_pct = second_votes/validated_votes,
    third_votes = sort(candidate_votes, decreasing = TRUE) [3],
    third_pct = third_votes/validated_votes,
    remainder_votes = validated_votes-(win_votes+second_votes+third_votes),
    remainder_pct = remainder_votes/validated_votes
  )
#
# calculate the number of "effective parties" in a constituency
#
EffectiveParties <- candidate_data %>%  
  filter(contest_status == "Contested") %>%
  group_by(election_date, constituency_number) %>%
  summarize(
    effective_parties = 1/sum(candidate_share^2)
  )
constituency_data <- left_join(constituency_data, EffectiveParties)
#
constituency_data <- mutate(constituency_data, votes_cast = sum(validated_votes, votes_disq))
constituency_data <- mutate(constituency_data, turnout = votes_cast / voter_reg)
constituency_data <- mutate(constituency_data, disq_pct = votes_disq / votes_cast)
constituency_data <- mutate(constituency_data, MOV_votes = win_votes - second_votes)
constituency_data <- mutate(constituency_data, MOV_pct = win_pct - second_pct)
constituency_data <- mutate(constituency_data, Cox_SF_ratio = third_votes / second_votes)
#
# optional - pull candidate data for 1st, 2nd, and 3rd-place finishers to accompany 
#
temp <- 
  candidate_data %>%
  filter(contest_status == "Contested") %>%
  group_by(election_date, constituency_number) %>%
  filter(candidate_rank == 1) %>%
  dplyr::select(constituency_number, candidate_party, candidate_name)
names(temp)[names(temp) == "candidate_party"] <- "win_party"
names(temp)[names(temp) == "candidate_name"] <- "win_name"
constituency_data <- left_join(constituency_data, temp, by = c("election_date", "constituency_number"))
#
temp <- 
  candidate_data %>%
  filter(contest_status == "Contested") %>%
  group_by(election_date, constituency_number) %>%
  filter(candidate_rank == 2) %>%
  dplyr::select(constituency_number, candidate_party, candidate_name)
names(temp)[names(temp) == "candidate_party"] <- "second_party"
names(temp)[names(temp) == "candidate_name"] <- "second_name"
constituency_data <- left_join(constituency_data, temp, by = c("election_date", "constituency_number"))
#
temp <- 
  candidate_data %>%
  filter(contest_status == "Contested") %>%
  group_by(election_date, constituency_number) %>%
  filter(candidate_rank == 3) %>%
  dplyr::select(constituency_number, candidate_party, candidate_name)
names(temp)[names(temp) == "candidate_party"] <- "third_party"
names(temp)[names(temp) == "candidate_name"] <- "third_name"
constituency_data <- left_join(constituency_data, temp, by = c("election_date", "constituency_number"))
#
#
constituency_data <- dplyr::select(constituency_data, election_date, election_type, contest_status, 
                                   constituency_number, constituency_name, province, assembly,
                                   voter_reg, votes_cast, turnout, votes_disq, disq_pct, validated_votes,
                                   MOV_votes, MOV_pct, Cox_SF_ratio, effective_parties,
                                   win_votes, win_pct, win_party, win_name,
                                   second_votes, second_pct, second_party, second_name,
                                   third_votes, third_pct, third_party, third_name,
                                   remainder_votes, remainder_pct)
#
constituency_data <- arrange(constituency_data, constituency_number, election_date)
#
# create an additional variable grouping smaller parties and major parties for simpler winner labels
winbuckets <- constituency_data %>%
  group_by(election_date, win_party) %>%
  summarize(ct = n()) %>%
  mutate(freq = ct/sum(ct))
#
winbuckets <- winbuckets %>% 
  group_by(election_date) %>%
  mutate(threshold = mean(ct) - ((mean(ct)/2)))
#
winbuckets$winbuckets = ifelse(winbuckets$ct >= winbuckets$threshold,
                               winbuckets$win_party, "Other Parties")
constituency_data <- left_join(constituency_data, winbuckets, by = c("election_date", "win_party"))
constituency_data$ct <- NULL
constituency_data$freq <- NULL
constituency_data$threshold <- NULL
constituency_data$delimit = ifelse(constituency_data$election_date >= "2002-10-10", "Delimitation 2002-2013", "Other Delimitation")

constituency_data <- dplyr::select(constituency_data, election_date, election_type, contest_status, 
                                   constituency_number, constituency_name, province, assembly,
                                   voter_reg, votes_cast, turnout, votes_disq, disq_pct, validated_votes,
                                   MOV_votes, MOV_pct, 
                                   win_votes, win_pct, win_party, win_name,
                                   second_votes, second_pct, second_party, second_name,
                                   third_votes, third_pct, third_party, third_name,
                                   remainder_votes, remainder_pct,
                                   effective_parties, Cox_SF_ratio, winbuckets, delimit)
#
constituency_data <- arrange(constituency_data, constituency_number, election_date)
write.csv(constituency_data, "./data/pk_constituency_data.csv", row.names = F)
