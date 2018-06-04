# AUTHOR: Colin Cookman
# CONTACT: ccookman at gmail dot com
# SOURCE: https://github.com/colincookman/pakistan_elections/
#
candidate_data <- read.csv("https://github.com/colincookman/pakistan_elections/pk_candidate_data.csv")  # load candidate data
constituency_data <- read.csv("https://github.com/colincookman/pakistan_elections/pk_constituency_data.csv")  # load constituency data
candidate_data$election_date <- mdy(candidate_data$election_date)
constituency_data$election_date <- mdy(constituency_data$election_date)

Party_Summary <- candidate_data %>% 
  filter(contest_status == "Contested") %>%
  group_by(assembly, election_date, contest_status, candidate_party, province) %>%
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
  group_by(assembly, election_date, province) %>%
  summarize(
    all_votes = sum(candidate_votes, na.rm = TRUE),
    all_seats = sum(candidate_rank == 1, na.rm = TRUE)
  )
Party_Summary <- left_join(Party_Summary, temp)

Party_Summary <- Party_Summary %>%
  group_by(election_date, assembly, province) %>%
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
  group_by(election_date, assembly, win_party, province) %>% 
  summarize(
    mean_win_MOV_pct = mean(MOV_pct, na.rm = TRUE), 
    # average margin of victory achieved by the party's winning candidates in province + assembly
    med_win_MOV_pct = median(MOV_pct, na.rm = TRUE) 
    # midpoint margin of victory achieved by the party's winning candidates in province + assembly
  )

names(temp)[names(temp) == "win_party"] <- "candidate_party"
Party_Summary <- left_join(Party_Summary, temp, 
                             by = c("election_date", "assembly", "candidate_party", "province"))
#
# Summarize and Reorder Tables
Party_Summary <- dplyr::select(Party_Summary, election_date, assembly, province, all_votes, all_seats,
                                 candidate_party,
                                 candidates_fielded, seats_contested_share, 
                                 seats_won, seats_second, seats_third, 
                                 win_rate, seats_won_share,
                                 mean_win_share, med_win_share, mean_win_MOV_pct, med_win_MOV_pct,
                                 party_votes, mean_vote_count, med_vote_count,
                                 party_vote_share, mean_vote_share, med_vote_share
)
Party_Summary <- arrange(Party_Summary, election_date, candidate_party, province)

# Filtered output table

assembly_select <- "Provincial" # assembly to target for summary output
prov_select <- "Punjab" # province to target for summary output
date_select <- "2013-05-11" # election date to target for summary output

Output <- Party_Summary %>% filter(assembly == assembly_select & election_date == date_select & province == prov_select)
Output <- arrange(Output, seats_won_share, candidates_fielded)
Output <- dplyr::select(Output, all_votes, all_seats, candidate_party, candidates_fielded, 
                                    seats_contested_share, seats_won, seats_won_share, win_rate, seats_second, 
                                    mean_win_MOV_pct, mean_vote_share, party_votes, party_vote_share)

# for brevit of output, exclude parties who did not contest more than the avg share of contested seats
threshold <- mean(Output$seats_contested_share, 0.5)
Output <- Output %>% filter(seats_contested_share >= threshold)

Output <- (Output[, c(6:16)]) # trim columns
Output <- arrange(Output, desc(seats_won_share), party_vote_share)

# rename variables for print
names(Output) <- c("Party Name", "# of Candidates Fielded", "Pct of Assembly Direct Seats Contested", "# of Seats Won",
                 "Pct of Assembly Direct Seats Won", "Pct of Contesting Candidates Who Won", "# of Runner-Up Candidates", 
                 "Mean MOV for Winners", "Mean Share of Vote Received by Candidates", 
                 "Total Votes Received by Party", "Party Votes as Pct of All Votes Cast")


