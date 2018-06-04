# AUTHOR: Colin Cookman
# CONTACT: ccookman at gmail dot com
# SOURCE: https://github.com/colincookman/pakistan_elections/
#
candidate_data <- read.csv("https://github.com/colincookman/pakistan_elections/data/pk_candidate_data.csv")  # load candidate data
candidate_data$election_date <- mdy(candidate_data$election_date)
#
Incumbency <- candidate_data %>%
  # constituency boundaries changed in 2002 so prior data excluded
  filter(election_date == "2013-05-11" | election_date == "2008-02-18" | election_date == "2002-10-10") %>%
  group_by(constituency_number, candidate_party) %>%
  mutate(
    lagged_win = dplyr::lag(outcome, n = 1, default = NA),
    lagged_party_vote = dplyr::lag(candidate_votes, n = 1, default = NA),
    lagged_party_share = dplyr::lag(candidate_share, n = 1, default = NA)
  )

Incumbency <- Incumbency %>% group_by(election_date, constituency_number) %>% 
  mutate(
    winner_vote = max(candidate_votes),
    runner_up = candidate_votes[candidate_rank == 2]
)

Incumbency <- Incumbency %>% mutate(
  MOV_votes = ifelse(candidate_rank == 1, (candidate_votes - runner_up), (candidate_votes - winner_vote)),
  MOV_pct = MOV_votes / validated_votes
)

Incumbency <- Incumbency %>% group_by(constituency_number, candidate_party) %>%
  mutate(
    lagged_MOV = dplyr::lag(MOV_pct, n = 1, default = NA)
  )

Incumbency$outcome <- ifelse(Incumbency$outcome == "Win", 1, 0)
Incumbency$lagged_win <- ifelse(Incumbency$lagged_win == "Win", 1, 0)

# Independent candidates don't lag properly and are excluded from final plot
Incumbency <- Incumbency %>% filter(candidate_party != "Independents")

Party_Incumb_Plot <- ggplot(subset(Incumbency, 
                                   assembly == "National" &
                                     (election_date == "2013-05-11") | (election_date == "2008-02-18")
                                     ),
                            aes(y= MOV_pct, x = lagged_MOV, color = province)) + 
  facet_wrap(~ election_date) +
  geom_hline(aes(yintercept = 0, group = as.factor(election_date)), size = 1.2, color="gray80") +
  geom_vline(aes(xintercept = 0, group = as.factor(election_date)), size = 1.2, color="gray80") +
  geom_abline(intercept = 0, slope = 1, size = 1.2, color = "gray80") +
  geom_point(alpha = .75) +
  scale_color_brewer(palette = "Set1") +
  scale_x_continuous(labels = scales::percent, breaks=seq(-1,1,by=0.2)) +
  scale_y_continuous(labels = scales::percent, breaks=seq(-1,1,by=0.2)) +
  coord_equal() +
# include a regression line
  geom_smooth(method = "loess", color = "dodgerblue4", 
              data = subset(Incumbency, assembly == "National" &
                              (election_date == "2013-05-11") | (election_date == "2008-02-18")
                            ),
              mapping = aes(y = MOV_pct, x = lagged_MOV, color = province)) +
  labs(x = "Margin of Victory for Candidate's Party in Same Constituency in Previous Election",
       y = "Candidate Margin of Victory in Current Election",
       title = "Party Incumbency Trends in Pakistan's National Assembly Elections (2002 - 2013)",
       subtitle = "Points are candidates. Excludes independent candidates. Preceding elections data may in some instances be by-elections held immediately after the last general election cycle.\nCaution is advised against extending this analysis to previous or future election cycles. Please see accompanying paper for further discussion.",
       caption = "Author: Colin Cookman (Twitter: @colincookman)\nFor code and data used to generate this chart see: https://github.com/colincookman/pakistan_elections\nCaveat: No guarantees are made as to underlying accuracy of this data.",
       color = "Province"
  ) +
  theme(legend.position = "bottom", panel.spacing = unit(1.5, "lines"), plot.caption = element_text(hjust = 0))

Party_Incumb_Plot
