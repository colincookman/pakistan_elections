# AUTHOR: Colin Cookman
# CONTACT: ccookman at gmail dot com
# SOURCE: https://github.com/colincookman/pakistan_elections/
#
constituency_data <- read.csv("https://github.com/colincookman/pakistan_elections/data/pk_constituency_data.csv")  # load candidate data
constituency_data$election_date <- mdy(constituency_data$election_date)

# find the median values by election date for chart intercept lines
constituency_data <- constituency_data %>% 
  group_by(election_date) %>%
  mutate(date_MOV_med = median(MOV_pct, na.rm = TRUE),
        date_TO_med = median(turnout, na.rm = TRUE)
  )
#
#
Competition_Plot_Year <- ggplot(data = subset(constituency_data, 
                                              election_type == "General Election" &
                                                assembly == "National" 
                                              ),
mapping = aes(x = MOV_pct, y = turnout, color = province)) + 
  facet_wrap (~election_date, nrow = 2) +
  geom_hline(aes(yintercept = date_TO_med, group = as.factor(election_date)), size = 1.2, color="gray80") +
  geom_vline(aes(xintercept = date_MOV_med, group = as.factor(election_date)), size = 1.2, color="gray80") +
  geom_point(alpha = 0.75) +
  scale_color_brewer(palette = "Set1") +
# optional loess regressional curve 
#  geom_smooth(method = "loess", color = "dodgerblue4", 
#              data = subset(constituency_data, election_type == "General Election" & assembly == "National"),
#              mapping = aes(x = MOV_pct, y = turnout, color = as.factor(election_date))) +
  scale_x_continuous(labels = scales::percent, breaks=seq(0,1,by=0.15)) +
  scale_y_continuous(labels = scales::percent, breaks=seq(0,1,by=0.15)) +
  coord_equal() +
  labs(x = "Margin of Victory (Winner's Share of Validated Vote Minus Runner-Up Share of Validated Vote)", 
       y = "\"Turnout\" (Share of Total Votes Cast (incl. Invalidated) as a Percentage of Registered Voters)",
       title = "The Most Competitive Races in Pakistan's National Assembly Elections 1993-2013",
       subtitle = "Excludes by-elections. Points are constituencies. Intercepts are median values for their respective election period.",
       caption = "Author: Colin Cookman (Twitter: @colincookman)\nFor code and data used to generate this chart see: https://github.com/colincookman/pakistan_elections\nCaveat: No guarantees are made as to underlying accuracy of this data."
  ) +
  theme(legend.position = "bottom", plot.caption = element_text(hjust = 0))

Competition_Plot_Year


# alternatively, faceted by province

constituency_data <- constituency_data %>% 
  group_by(province) %>%
  mutate(prov_MOV_med = median(MOV_pct, na.rm = TRUE),
         prov_TO_med = median(turnout, na.rm = TRUE)
  )
#
#
Competition_Plot_Prov <- ggplot(data = subset(constituency_data, 
                                              election_type == "General Election" &
                                                assembly == "National" 
                                              ),
mapping = aes(x = MOV_pct, y = turnout, color = as.factor(election_date))) + 
  facet_wrap (~province, nrow = 2) +
  geom_hline(aes(yintercept = prov_TO_med, group = as.factor(province)), size = 1.2, color="gray80") +
  geom_vline(aes(xintercept = prov_MOV_med, group = as.factor(province)), size = 1.2, color="gray80") +
  geom_point(alpha = 0.75) +
  scale_color_brewer(palette = "Set1") +
  # optional loess regressional curve 
  #  geom_smooth(method = "loess", color = "dodgerblue4", 
  #              data = subset(constituency_data, election_type == "General Election" & assembly == "National"),
  #              mapping = aes(x = MOV_pct, y = turnout, color = as.factor(election_date))) +
  scale_x_continuous(labels = scales::percent, breaks=seq(0,1,by=0.15)) +
  scale_y_continuous(labels = scales::percent, breaks=seq(0,1,by=0.15)) +
  coord_equal() +
  labs(x = "Margin of Victory (Winner's Share of Validated Vote Minus Runner-Up Share of Validated Vote)", 
       y = "\"Turnout\" (Share of Total Votes Cast (incl. Invalidated) as a Percentage of Registered Voters)",
       title = "The Most Competitive Races in Pakistan's National Assembly Elections 1993-2013",
       subtitle = "Excludes by-elections. Points are constituencies. Intercepts are median values for their respective election period.",
       caption = "Author: Colin Cookman (Twitter: @colincookman)\nFor code and data used to generate this chart see: https://github.com/colincookman/pakistan_elections\nCaveat: No guarantees are made as to underlying accuracy of this data.",
       color = "Election Date"
  ) +
  theme(legend.position = "bottom", plot.caption = element_text(hjust = 0))

Competition_Plot_Prov
#