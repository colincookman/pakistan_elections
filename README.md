# Pakistan Elections Data

## Project description
This repository collects data, graphics, and analysis conducted as part of a study assessing Pakistan's 2018 parliamentary elections. The report reviews the major trends of the past five years and of previous Pakistani national election cycles, looks at competing interest groups in both the formal and informal political system, and examines how the electoral competition is structured, administered, and adjudicated. The full report can be read [here](LINK).

Candidate and constituency-level data used for this report and released in open-source, tidy format can be found in the [data folder](https://github.com/colincookman/pakistan_elections/data/), and code used to generate graphics for the report in the [graphics folder](https://github.com/colincookman/pakistan_elections/graphics/).

## Description of data generation
As part of research for this study, the author also compiled a dataset of electoral results for Pakistan’s major national elections over the past 25 years. The principal sources used were the [website of the Election Commission of Pakistan](https://ecp.gov.pk/) (for the results of the 2008 and 2013 national and provincial assembly elections); ECP official gazette notifications on election results and other associated ECP publications; and a [2010 publication by Church World Service and the Free and Fair Elections Network (FAFEN)](http://fafen.org/wp-content/uploads/2010/08/Compendium-National-Assembly-Elections-1970-2008-Pakistan.pdf), which collects and summarizes data for earlier national elections dating back to 1970. In March 2018, FAFEN [released a new election web portal](https://electionpakistan.com/), which was used in some instances to cross-check the new dataset.

Significant cleaning and reorganization was required to restructure this data for analytical purposes, and important caveats about its reliability and accuracy remain. The ECP did not release — or apparently systematically collect and maintain, as subsequent court investigations found — comprehensive polling station-level results for the 2013 elections, offering only aggregate constituency-wide figures and forestalling more granular analysis of vote patterns below the constituency level (the composition of which, after the 2017-18 delimitation process, have now changed). Several data errors were found during the cleaning process, including transposed figures, missing candidate data, and inaccurate vote totals; these were corrected where evident as part of the construction of the new dataset. 

## Limitations and caveats
In many cases the source of apparent ECP tabulation errors could not be independently resolved, and other data errors may be less evident and have eluded the cleaning process. Significant gaps in the dataset currently remain, including by-election results prior to 2013, provincial assembly results for elections held prior to 2008, and the coding of unique candidate identifiers that would allow for more rigorous tracking of candidate performance across elections or parties.

Beyond obvious omissions or errors, there is no way to reliably assess the accuracy of the reported figures, their correlation to actual votes cast, or the conditions in which they were recorded — a particular concern given recurrent complaints about ballot rigging, voter fraud, or intimidation at the polls. Thus, while some general analytical findings may be possible from this dataset, caution should be given to attributing reported vote figures as a measure of direct popular support, as opposed to an imperfect proxy for candidate strength under Pakistan’s current system of competition.

## Plans for expansion and contribution
This dataset will eventually be updated to include the July 2018 parliamentary outcomes, once concluded, and will ultimately be expanded to fully report election results at the national and provincial level dating back to 1970, as well as accompanying polling station, census, and geographic data where available. These will be tracked in the issues tab of this repository.

Any corrections to the dataset, questions, or suggestions for its improvement are greatly appreciated.
