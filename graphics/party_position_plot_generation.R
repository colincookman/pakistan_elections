# AUTHOR: Colin Cookman
# CONTACT: ccookman at gmail dot com
# SOURCE: https://github.com/colincookman/pakistan_elections/
#
party_positions <- read.csv("https://github.com/colincookman/pakistan_elections/end_of_term_party_positions.csv")


ggplot(data = subset(party_positions, assembly == assembly_target),
       aes(x = party_name, y = )
       