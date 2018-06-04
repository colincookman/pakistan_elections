# AUTHOR: Colin Cookman
# CONTACT: ccookman at gmail dot com
# SOURCE: https://github.com/colincookman/pakistan_elections/
#
constituency_data <- read.csv("https://github.com/colincookman/pakistan_elections/data/pk_constituency_data.csv")  # load candidate data
constituency_data$election_date <- mdy(constituency_data$election_date) 

Subset_NA_2013 <- constituency_data %>% filter(election_date == "2013-05-11" & assembly == "National")

Disqualification_Plot <- ggplot(data = Subset_NA_2013,
            mapping = aes(y = reorder(constituency_number, votes_disq))) +
  geom_point(aes(x = disq_pct, color = "red"), size = 1, alpha = 0.75) +
  geom_point(aes(x = MOV_votes / votes_cast, color = "blue"), size = 1, alpha = 0.75) +
  scale_x_continuous(labels = scales::percent, breaks=seq(0,1,by=0.15)) +
  labs(y = "Constituency Results (Rank Ordered By Number of Votes Disqualified)",
       x = "Share of Total Votes Cast",
       title = "Disqualifications and Margins of Victory in Pakistan's 2013 General Elections",
       subtitle = "A look at the potential significance of disqualification decisions in relation to margins of victory in national assembly contests.",
       caption = "Author: Colin Cookman (Twitter: @colincookman)\nFor code and data used to generate this chart see: https://github.com/colincookman/pakistan_elections\nCaveat: No guarantees are made as to underlying accuracy of this data.",
       color = "Votes") +
  scale_color_manual(name = "", values = c("red" = "red", "blue" = "blue"), labels = c("Margin of victory (difference between winner's validated vote\n and runner-up) as share of total votes cast", "Disqualified votes as share of total votes cast")) +
  theme(legend.position = "bottom", axis.ticks.y = element_blank(), axis.text.y = element_blank(), plot.caption = element_text(hjust = 0))

Disqualification_Plot
