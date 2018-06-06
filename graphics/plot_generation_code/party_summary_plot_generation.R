# AUTHOR: Colin Cookman
# CONTACT: ccookman at gmail dot com
# SOURCE: https://github.com/colincookman/pakistan_elections/
#
library(tidyverse)
library(lubridate)
library(ggrepel)
candidate_data <- read.csv("https://github.com/colincookman/pakistan_elections/pk_candidate_data.csv")  # load candidate data
constituency_data <- read.csv("https://github.com/colincookman/pakistan_elections/pk_constituency_data.csv")  # load constituency data
candidate_data$election_date <- mdy(candidate_data$election_date)
constituency_data$election_date <- mdy(constituency_data$election_date)

Party_Summary <- candidate_data %>% 
  filter(contest_status == "Contested") %>%
  group_by(assembly, election_date, election_type, contest_status, candidate_party) %>%
  summarize(
    party_votes = sum(candidate_votes, na.rm = TRUE), 
    # total votes received by the party in all constituencies in a province
    mean_vote_count = mean(candidate_votes, na.rm = TRUE), 
    # average number of votes received by the party per constituency contested
    med_vote_count = median(candidate_votes, na.rm = TRUE), 
    # midpoint number of votes received by the party of all constituencies contested
    candidates_fielded = n(), 
    # number of candidates fielded by party
    seats_won = sum(candidate_rank == 1), 
    # count the number of constituencies in which the party's candidate received the max vote
    seats_second = sum(candidate_rank == 2), 
    # count the number of constituencies in which the party's candidate received the second most votes
    seats_third = sum(candidate_rank == 3), 
    # count the number of constituencies in which the party's candidate received the third most votes
    win_rate = seats_won/candidates_fielded,
    # share of the party's total fielded candidates who won their races
    mean_vote_share = mean(candidate_share, na.rm = TRUE), 
    # average share of the constituency vote total received by all of the party's contesting candidates
    med_vote_share = median(candidate_share, na.rm = TRUE), 
    # midpoint share of the constituency vote total received by all of the party's contesting candidates
    mean_win_share = mean(candidate_share[candidate_rank == 1], na.rm = TRUE), 
    # average share of the constituency vote total received by the party's winning candidates
    med_win_share = median(candidate_share[candidate_rank == 1], n.rm = TRUE) 
    # midpoint share of the constituency vote total received the party's winning candidates
  )
#
# find all contested seats and call votes cast within a given assembly and province 
temp <- candidate_data %>% 
  filter(contest_status == "Contested") %>%
  group_by(assembly, election_date) %>%
  summarize(
    all_votes = sum(candidate_votes, na.rm = TRUE),
    all_seats = sum(candidate_rank == 1, na.rm = TRUE)
  )
Party_Summary <- left_join(Party_Summary, temp)

Party_Summary <- Party_Summary %>%
  group_by(election_date, assembly) %>%
  mutate(
    party_vote_share = party_votes/all_votes,
    # total number of votes received by the party as a share of all votes cast in province + assembly
    seats_won_share = seats_won/all_seats,
    # share of assembly seats won by party in province
    seats_contested_share = candidates_fielded/all_seats,
    # share of assembly seats contested by party in province
    votes_seats_diff = party_vote_share - seats_won_share
    # difference between share of votes won by party and share of seats won by party
  )
#
temp <- constituency_data %>%
  filter(contest_status == "Contested") %>%
  group_by(election_date, assembly, win_party) %>% 
  summarize(
    mean_win_MOV_pct = mean(MOV_pct, na.rm = TRUE), 
    # average margin of victory achieved by the party's winning candidates in province + assembly
    med_win_MOV_pct = median(MOV_pct, na.rm = TRUE) 
    # midpoint margin of victory achieved by the party's winning candidates in province + assembly
  )

names(temp)[names(temp) == "win_party"] <- "candidate_party"
Party_Summary <- left_join(Party_Summary, temp, 
                             by = c("election_date", "assembly", "candidate_party"))
#
# Summarize and Reorder Tables
Party_Summary <- dplyr::select(Party_Summary, election_date, election_type, assembly, all_votes, all_seats,
                                 candidate_party,
                                 candidates_fielded, seats_contested_share, 
                                 seats_won, seats_second, seats_third, 
                                 win_rate, seats_won_share,
                                 mean_win_share, med_win_share, mean_win_MOV_pct, med_win_MOV_pct,
                                 party_votes, mean_vote_count, med_vote_count,
                                 party_vote_share, mean_vote_share, med_vote_share
)
Party_Summary <- arrange(Party_Summary, election_date, candidate_party)

# subset major parties for color labels
major_parties <- unique(Party_Summary$candidate_party[Party_Summary$seats_won > quantile(Party_Summary$seats_won, .95, na.rm = TRUE)])
major_parties <- as.data.frame(major_parties)
major_parties$major = TRUE
major_parties <- major_parties %>%
  rename(
    candidate_party = major_parties
  )
major_parties <- major_parties %>% filter(!is.na(candidate_party))
major_parties <- left_join(Party_Summary, major_parties)


ggplot(data = subset(Party_Summary, assembly == "National" & election_type == "General Election" & election_date >= "2002-10-10"), 
       aes(y = log(seats_contested_share), x = log(mean_vote_share), size = seats_won
           )) +
  facet_wrap(~ as.factor(election_date)) +
  geom_point(alpha = .5) +
  geom_point(alpha = .75, data = subset(major_parties, assembly == "National" & election_type == "General Election" & election_date >= "2002-10-10" &
                                       major == TRUE),
             aes(log(seats_contested_share), x = log(mean_vote_share), size = seats_won, color = candidate_party)
             ) +
  scale_color_manual(values = c("#a6cee3", "#ffff99", "#b2df8a", "#33a02c", "#fb9a99", "#b15928", "#fdbf6f", "#ff7f00", "#cab2d6", "#6a3d9a", "#1f78b4", "#e31a1c", "black")) +
  labs(x = "Mean Vote Share per Constituency of Party Candidates (log scale)",
       y = "Share of Assembly Seats Contested (log scale)",
       title = "Party Performance in Pakistan's National Assembly Elections (2002 - 2013)",
       caption = "Author: Colin Cookman (Twitter: @colincookman)\nFor code and data used to generate this chart see: https://github.com/colincookman/pakistan_elections\nCaveat: No guarantees are made as to underlying accuracy of this data.",
       color = "Major Parties",
       size = "Number of seats won"
  ) +
  theme(plot.caption = element_text(hjust = 0))
#  geom_text_repel(data = subset(Party_Summary, assembly == "National" & election_type == "General Election" & election_date >= "2002-10-10" &
#                                  (log(mean_vote_share) >= (quantile(log(mean_vote_share), .80, na.rm = TRUE)) |
#                                     log(seats_contested_share) >= (quantile(log(seats_contested_share), .80, na.rm = TRUE))
#                                  )
#                                ),
#                    mapping = aes(label = candidate_party), size = 2.5, box.padding = unit(.3, "lines"))
  