
## AIS fishing bq dataset
Downloaded date: Nov 15 2024 12:55 UTC
API Dataset versions: public-global-fishing-effort:v3.0

### Description
Global Fishing Watch uses data about a vessel’s identity, type, location, speed, direction and more that is broadcast using the Automatic Identification System (AIS) and collected via satellites and terrestrial receivers. AIS was developed for safety/collision-avoidance. Global Fishing Watch analyzes AIS data collected from vessels that our research has identified as known or possible commercial fishing vessels, and applies a fishing presence algorithm to determine “apparent fishing activity” based on changes in vessel speed and direction. The algorithm classifies each AIS broadcast data point for these vessels as either apparently fishing or not fishing and shows the former on the Global Fishing Watch fishing activity heat map. AIS data as broadcast may vary in completeness, accuracy and quality. Also, data collection by satellite or terrestrial receivers may introduce errors through missing or inaccurate data. Global Fishing Watch’s fishing presence algorithm is a best effort mathematically to identify “apparent fishing activity.” As a result, it is possible that some fishing activity is not identified as such by Global Fishing Watch; conversely, Global Fishing Watch may show apparent fishing activity where fishing is not actually taking place. For these reasons, Global Fishing Watch qualifies designations of vessel fishing activity, including synonyms of the term “fishing activity,” such as “fishing” or “fishing effort,” as “apparent,” rather than certain. Any/all Global Fishing Watch information about “apparent fishing activity” should be considered an estimate and must be relied upon solely at your own risk. Global Fishing Watch is taking steps to make sure fishing activity designations are as accurate as possible. Global Fishing Watch fishing presence algorithms are developed and tested using actual fishing event data collected by observers, combined with expert analysis of vessel movement data resulting in the manual classification of thousands of known fishing events. Global Fishing Watch also collaborates extensively with academic researchers through our research program to share fishing activity classification data and automated classification techniques.

Filters:  timestamp >= '2024-10-01T00:00:00.000Z' and timestamp < '2024-10-31T00:00:00.000Z'
Group by: None
Temporal resolution: daily (data is grouped by vessel and summarized by day)
Spatial aggregation: true


### Columns

* Time Range: The data format depends on the temporal resolution, for monthly (YYYY-MM), for daily (YYYY-MM-DD), for yearly (YYYY) and for entire the date-range query param value.
* Entry timestamp: Timestamp when the vessel acceded to the region.
* Exit timestamp: Timestamp when the vessel exited of the region.
A unique vessel identity developed for internal use by Global Fishing Watch and API (Application Programming Interfaces) users, that combines available vessel identifiers such as name, callsign, and Maritime Mobile Service Identity (MMSI) in order to identify vessels that may not consistently transmit AIS, or the same identifiers on AIS, over time. .
* Apparent Fishing Hours: Hours that the vessel associated with this vessel_id was fishing in the grid cell over the selected time range
* Flag: Flag state (ISO3 value) for the vessel as determined by the first three digits (MID) of the MMSI number.
* Vessel Name: AIS reported name of the vessel.
* Gear Type: The vessel gear types estimated by GFW were developed by aggregating available vessel registry records, reported AIS identity information, and estimated classification using our machine learning algorithm. Detailed information can be found [here](https://globalfishingwatch.org/datasets-and-code-vessel-identity/).
* Vessel Type: Vessel types from GFW include fishing vessels, carrier vessels, and support vessels. The vessel classification for fishing vessel is estimated using known registry information in combination with a convolutional neural network used to estimate vessel class. The vessel classification for carrier vessels is estimated using a cumulation of known registry information, manual review, and vessel class. All support vessels in the vessel viewer are considered purse seine support vessels based on internal review.
* MMSI: MMSI (Maritime Mobile Service Identity) of the vessel, AIS identifier.
* IMO: AIS reported IMO (International Maritime Organization) of the vessel.
* Call Sign: also known as IRCS (International Radio Call Sign) of the vessel, as reported on AIS.
* First transmission date: first date when there is a position transmitted on AIS by the vessel.
* Last transmission date: last date when there is a position transmitted on AIS by the vessel.

## License
Unless otherwise stated, Global Fishing Watch data is licensed under a Creative Commons Attribution-ShareAlike 4.0 International license and code under an Apache 2.0 license.

For additional information about:
these results, see the associated journal article: D.A. Kroodsma, J. Mayorga, T. Hochberg, N.A. Miller, K. Boerder, F. Ferretti, A. Wilson, B. Bergman, T.D. White, B.A. Block, P. Woods, B. Sullivan, C. Costello, and B. Worm. "Tracking the global footprint of fisheries." Science 361.6378 (2018). http://science.sciencemag.org/content/359/6378/904 
Data caveats and details: https://globalfishingwatch.org/dataset-and-code-fishing-effort/ 

## Data Versioning

The AIS data used by Global Fishing Watch are updated daily and periodically revised following occasional interruptions in our AIS feed.  Additionally, we are continuously working to improve our technology to most accurately classify and track vessels globally using AIS. Therefore, data downloaded from our map is subject to change over time. There may also be slight differences between data downloaded from the Global Fishing Watch map and the static datasets that are available on the data download page (https://globalfishingwatch.org/data-download/datasets/public-fishing-effort). Every effort is made to ensure these data are as similar as possible, however the intention of the downloadable datasets are slightly different. The static datasets have been thoroughly reviewed and use a specific versioning in order to be reproducible for in-depth research. The data provided through the Global Fishing Watch map is generated using 4wings experimental technology. The map uses the latest versioning of our data available, along with any improvements identified in our algorithms, and is updated every single day. We will continue to improve our documentation on versioning of our different downloadable data, and will notify users of these updates. 

## Suggested Citation

Global Fishing Watch. 2022, updated daily. Vessel presence and apparent fishing effort v20201001, [Oct 01 2024 00:00 UTC Oct 31 2024 00:00 UTC]. Data set accessed 2024-11-15 at https://globalfishingwatch.org/map
	
