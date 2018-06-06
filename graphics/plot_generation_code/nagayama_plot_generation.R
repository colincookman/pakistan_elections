# AUTHOR: Colin Cookman
# CONTACT: ccookman at gmail dot com
# SOURCE: https://github.com/colincookman/pakistan_elections/
#
constituency_data <- read.csv("https://github.com/colincookman/pakistan_elections/data/pk_constituency_data.csv")  # load candidate data
constituency_data$election_date <- mdy(constituency_data$election_date)

# find the median values by election date for chart intercept lines
constituency_data <- constituency_data %>% 
  group_by(election_date) %>%
  mutate(date_win_med = median(win_pct, na.rm = TRUE),
         date_second_med = median(second_pct, na.rm = TRUE)
  )
#
Nagayama_Plot_Year <- 
  ggplot(data = subset(constituency_data, 
                       election_type == "General Election" &
                         assembly == "National"),
         mapping = aes(x= win_pct, y = second_pct, color = province,
                       shape = province # may improve legibility on B&W printing
                       )
         ) +
  geom_hline(aes(yintercept = date_second_med, group = as.factor(election_date)), size = 1.2, color="gray80") +
  geom_vline(aes(xintercept = date_win_med, group = as.factor(election_date)), size = 1.2, color="gray80") +
  geom_point(alpha = .8) +
  facet_wrap(~ election_date) +
  scale_color_brewer(palette = "Set1") +
  scale_x_continuous(labels = scales::percent, breaks=seq(0,1,by=0.1)) +
  scale_y_continuous(labels = scales::percent, breaks=seq(0,1,by=0.1)) +
  scale_shape_manual(values = c(15, 18, 17, 19, 13)) +
  labs(y = "Share of Validated Vote Taken by Runner-Up",
       x = "Share of Validated Vote Taken by Winner",
       title = "Nagayama Diagrams for Pakistani National Assembly Elections 1993-2013",
       subtitle = "Excludes uncontested races and by-elections. Adapted from Diwakar (2007)",
       caption = "Author: Colin Cookman (Twitter: @colincookman)\nFor code and data used to generate this chart see: https://github.com/colincookman/pakistan_elections\nCaveat: No guarantees are made as to underlying accuracy of this data.",
       color = "Province",
       shape = "Province"
       ) +
  theme(legend.position = "bottom", plot.caption = element_text(hjust = 0))

Nagayama_Plot_Year

# alternatively, faceted by province

constituency_data <- constituency_data %>% 
  group_by(province) %>%
  mutate(prov_win_med = median(win_pct, na.rm = TRUE),
         prov_second_med = median(second_pct, na.rm = TRUE)
  )
#
Nagayama_Plot_Prov <- 
  ggplot(data = subset(constituency_data, 
                       election_type == "General Election" &
                         assembly == "National"),
         mapping = aes(x= win_pct, y = second_pct, color = as.factor(election_date),
                       shape = as.factor(election_date) # may improve legibility on B&W printing
                       )
  ) +
  geom_hline(aes(yintercept = prov_second_med, group = as.factor(province)), size = 1.2, color="gray80") +
  geom_vline(aes(xintercept = prov_win_med, group = as.factor(province)), size = 1.2, color="gray80") +
  geom_point(alpha = .8) +
  facet_wrap(~ province) +
  scale_color_brewer(palette = "Set1") +
  scale_x_continuous(labels = scales::percent, breaks=seq(0,1,by=0.1)) +
  scale_y_continuous(labels = scales::percent, breaks=seq(0,1,by=0.1)) +
  scale_shape_manual(values = c(15, 18, 17, 19, 13)) +
  labs(y = "Share of Validated Vote Taken by Runner-Up",
       x = "Share of Validated Vote Taken by Winner",
       title = "Nagayama Diagrams for Pakistani National Assembly Elections 1993-2013",
       subtitle = "Excludes uncontested races and by-elections. Adapted from Diwakar (2007)",
       caption = "Author: Colin Cookman (Twitter: @colincookman)\nFor code and data used to generate this chart see: https://github.com/colincookman/pakistan_elections\nCaveat: No guarantees are made as to underlying accuracy of this data.",
       color = "Election Date",
       shape = "Election Date"
  ) +
  theme(legend.position = "bottom", plot.caption = element_text(hjust = 0))

Nagayama_Plot_Prov
#