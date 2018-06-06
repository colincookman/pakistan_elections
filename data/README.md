# Pakistan Elections Dataset

## Description of data
This directory contains base datasets in tidy csv format collecting data on Pakistani candidates competing in National Assembly elections, Provincial Assembly elections, and special by-elections for vacant seats. It also contains code used to aggregate candidate-level data as a constituency-level dataset, and separate code to generate summary tables of party performance by province.

As of initial release, this includes National Assembly data for general elections from 1993-2013, and by-elections from August 2013 - March 2018. It does *not* currently include comprehensive data on by-elections in previous election cycles, with the exception of those held immediately after the 2008 general elections to fill seats vacated by candidates who chose to take other seats where they won. (Pakistani election law does not impose residency requirements and does not restrict candidates to contesting a single constituency, but winning candidates are only allowed to occupy a single seat.)

As of inception, the dataset also only includes results from the 2008 and 2013 general election cycles for Provincial Assembly elections (again, with the above limitations on by-election data prior to 2013). Future planned expansions of the dataset will eventually incorporate this data, as well as results from the scheduled July 2018 elections when available.

For a full description of this project, author analysis, and important caveats and limitations regarding the data collection and cleaning process, please see the [main project page](https://github.com/colincookman/pakistan_elections/README.md).

## Dataset variable key:

### pk_candidate_data
**election_date:** Date of election in month / date / year format.

**election_type:** General Election or By-Election 

**contest_status:** Contested, Uncontested, or other rarer categories (postponed / terminated but votes still reported)

**constituency_number:** Number of constituency (note - constituency boundaries change between elections except for 2002-2018 period)

**constituency_name:** Via ECP (not standardized)

**province:** Province

**assembly:** National or Provincial Assembly

**voter_reg:** Total voter registration figures in contest as reported by ECP

**validated_votes:** Total validated votes in contest as calculated from ECP figures (may not agree with published ECP total vote figures in some cases)

**votes_disq:** Votes disqualified in contest as reported by ECP (not disaggregated by candidate)

**candidateID:** Randomly generated unique ID string for candidate. **Note:** as of initial release, candidate matches have not yet been coded, so all entries have their own unique ID and this cannot be used to track candidates across elections, parties, or constituencies.

**candidate_name:** Candidate name as reported by ECP (not standardized)

**candidate_party:** Candidate party as reported by ECP (standardized in cleaning process)

**candidate_votes:** Valid votes received by candidate as reported by ECP

**candidate_share:** Share of validated_votes in race received by candidate

**candidate_rank:** Candidate's rank out of contestants in race (ties show as equal rank value)

**outcome:** Candidate won or lost

### pk_constituency_data

**election_date:** Date of election in month / date / year format.

**election_type:** General Election or By-Election 

**contest_status:** Contested, Uncontested, or other rarer categories (postponed / terminated but votes still reported)

**constituency_number:** Number of constituency (note - constituency boundaries change between elections except for 2002-2018 period)

**constituency_name:** Via ECP (not standardized)

**province:** Province

**assembly:** National or Provincial Assembly

**voter_reg:** Total voter registration figures in contest as reported by ECP

**votes_cast:** Total votes recorded (includes both valid and invalid votes)

**turnout:** Total votes cast as a percentage of total voter registration

**votes_disq:** Votes disqualified in contest as reported by ECP (not disaggregated by candidate)

**disq_pct:** Votes disqualified as a percentage of total votes cast

**validated_votes:** Total validated votes in contest as calculated from ECP figures (may not agree with published ECP total vote figures in some cases)

**MOV_votes:** Difference between winner's valid votes and runner-up valid votes

**MOV_pct:** MOV as a percentage of total valid votes cast

**win_votes:** Winner's valid votes

**win_pct:** Winner's votes as a share of total valid votes

**win_party:** Winner's party affiliation at time of contest

**win_name:** Winning candidate's name

**second_votes:** Runner-up candidates's valid votes

**second_pct:** Runner-up candidates's votes as a share of total valid votes

**second_party:** Runner-up candidates's party affiliation at time of contest

**second_name:** Runner-up candidates's name

**third_votes:** Third-place candidates's valid votes

**third_pct:** Third-place candidates's votes as a share of total valid votes

**third_party:** Third-place candidates's party affiliation at time of contest

**third_name:** Third-place candidates's name

**remainder_votes:** Remainder of votes taken by other candidates

**remainder_pct:** Remainder of votes as a share of total valid votes

**effective_parties:** Calculation of number of "effective parties"

**Cox_SF_ratio:** Calculation of Gary Cox's S/F ratio

**winbuckets:** Groups other smaller parties for simpler winner labels

**delimit:** Contest conducted under 2002-2013 constituency delimitation pattern (also used for post-2013 by-elections) or other boundaries
