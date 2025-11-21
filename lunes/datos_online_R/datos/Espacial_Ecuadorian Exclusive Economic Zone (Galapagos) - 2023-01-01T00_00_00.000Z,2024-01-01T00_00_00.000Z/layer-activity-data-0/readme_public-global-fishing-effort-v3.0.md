
## AIS fishing bq dataset
Downloaded date: Nov 15 2024 14:13 UTC
API Dataset versions: public-global-fishing-effort:v3.0

### Description
Global Fishing Watch uses data about a vessel’s identity, type, location, speed, direction and more that is broadcast using the Automatic Identification System (AIS) and collected via satellites and terrestrial receivers. AIS was developed for safety/collision-avoidance. Global Fishing Watch analyzes AIS data collected from vessels that our research has identified as known or possible commercial fishing vessels, and applies a fishing presence algorithm to determine “apparent fishing activity” based on changes in vessel speed and direction. The algorithm classifies each AIS broadcast data point for these vessels as either apparently fishing or not fishing and shows the former on the Global Fishing Watch fishing activity heat map. AIS data as broadcast may vary in completeness, accuracy and quality. Also, data collection by satellite or terrestrial receivers may introduce errors through missing or inaccurate data. Global Fishing Watch’s fishing presence algorithm is a best effort mathematically to identify “apparent fishing activity.” As a result, it is possible that some fishing activity is not identified as such by Global Fishing Watch; conversely, Global Fishing Watch may show apparent fishing activity where fishing is not actually taking place. For these reasons, Global Fishing Watch qualifies designations of vessel fishing activity, including synonyms of the term “fishing activity,” such as “fishing” or “fishing effort,” as “apparent,” rather than certain. Any/all Global Fishing Watch information about “apparent fishing activity” should be considered an estimate and must be relied upon solely at your own risk. Global Fishing Watch is taking steps to make sure fishing activity designations are as accurate as possible. Global Fishing Watch fishing presence algorithms are developed and tested using actual fishing event data collected by observers, combined with expert analysis of vessel movement data resulting in the manual classification of thousands of known fishing events. Global Fishing Watch also collaborates extensively with academic researchers through our research program to share fishing activity classification data and automated classification techniques.

Filters:  timestamp >= '2023-01-01T00:00:00.000Z' and timestamp < '2024-01-01T00:00:00.000Z'
Group by: flag
Temporal resolution: daily (data is grouped by flag and summarized by day)
Spatial aggregation: false
 Resolution: high (100th degree resolution)

### Columns

* Lat: the latitude of the center of the grid cell, in 10ths or 100th of a degree (depending on spatial resolution selection) 
* Lon: the longitude of the center of the grid cell, in 10ths or 100th of a degree (depending on spatial resolution selection)
* Time Range: The data format depends on the temporal resolution, for monthly (YYYY-MM), for daily (YYYY-MM-DD), for yearly (YYYY) and for entire the date-range query param value.
* flag: flag.
* Vessel IDs: Number of different vessel ids.

flag.
* Apparent Fishing Hours: Hours that the vessel associated with this vessel_id was fishing in the grid cell over the selected time range


## License
Unless otherwise stated, Global Fishing Watch data is licensed under a Creative Commons Attribution-ShareAlike 4.0 International license and code under an Apache 2.0 license.

For additional information about:
these results, see the associated journal article: D.A. Kroodsma, J. Mayorga, T. Hochberg, N.A. Miller, K. Boerder, F. Ferretti, A. Wilson, B. Bergman, T.D. White, B.A. Block, P. Woods, B. Sullivan, C. Costello, and B. Worm. "Tracking the global footprint of fisheries." Science 361.6378 (2018). http://science.sciencemag.org/content/359/6378/904 
Data caveats and details: https://globalfishingwatch.org/dataset-and-code-fishing-effort/ 

## Data Versioning

The AIS data used by Global Fishing Watch are updated daily and periodically revised following occasional interruptions in our AIS feed.  Additionally, we are continuously working to improve our technology to most accurately classify and track vessels globally using AIS. Therefore, data downloaded from our map is subject to change over time. There may also be slight differences between data downloaded from the Global Fishing Watch map and the static datasets that are available on the data download page (https://globalfishingwatch.org/data-download/datasets/public-fishing-effort). Every effort is made to ensure these data are as similar as possible, however the intention of the downloadable datasets are slightly different. The static datasets have been thoroughly reviewed and use a specific versioning in order to be reproducible for in-depth research. The data provided through the Global Fishing Watch map is generated using 4wings experimental technology. The map uses the latest versioning of our data available, along with any improvements identified in our algorithms, and is updated every single day. We will continue to improve our documentation on versioning of our different downloadable data, and will notify users of these updates. 

## Suggested Citation

Global Fishing Watch. 2022, updated daily. Vessel presence and apparent fishing effort v20201001, [Jan 01 2023 00:00 UTC Jan 01 2024 00:00 UTC]. Data set accessed 2024-11-15 at https://globalfishingwatch.org/map
	
