library(ggplot2)
library(dplyr)
library(maps)
library(gridExtra)
library(data.table)
library(sp)
library(raster)
library(data.table)
library(reshape2)
library(RODBC)
library(geosphere)
library(terra)
library(sp)
library(ggplot2)
library(dplyr)
library(maps)
library(grid)


setwd("~/Desktop/VICENÇ MUT inicio/OHW Intercoonecta/Talleres avanzados y Hackaton/Taller Marina Avanzado/Datos capturas ICCAT")

dat_ICCAT <- read.csv("~/Desktop/VICENÇ MUT inicio/OHW Intercoonecta/Talleres avanzados y Hackaton/Taller Marina Avanzado/Datos capturas ICCAT/dat_ICCAT_filtrado.csv")


head(dat_ICCAT)


# > head(dat_ICCAT)
# FlagName      FleetName YearC TimePeriodID SchoolTypeCode  YFT   BET   SKJ tottrop londec latdec
# 1 EU-Espa?a EU.ESP-ES-ETRO  1994            1            FAD 1180  4590 10440   16210    0.5   -1.5
# 2 EU-Espa?a EU.ESP-ES-ETRO  1994            1            FAD 3340  2520  2790    8650    1.5   -1.5
# 3 EU-Espa?a EU.ESP-ES-ETRO  1994            1            FAD 6880 26900 61220   95000    2.5   -4.5
# 4 EU-Espa?a EU.ESP-ES-ETRO  1994            1            FAD  390  1530  3480    5400   -0.5   -0.5
# 5 EU-Espa?a EU.ESP-ES-ETRO  1994            1            FAD  390  1530  3480    5400   -2.5   -0.5
# 6 EU-Espa?a EU.ESP-ES-ETRO  1994            1            FAD 5460 21400 48680   75540   -3.5   -0.5


##################################################### PLOT BY YEARS of TOTTROP and by Species

# Extract the YearC column from dat_ICCAT
years <- dat_ICCAT$YearC

# Create the histogram
histogram <- ggplot(data = NULL, aes(x = years)) +
  geom_histogram(binwidth = 1, fill = "skyblue", color = "black") +
  labs(title = "ICCAT Frequency per Year", x = "Year", y = "Frequency") +
  theme_minimal()

# Display the histogram
print(histogram)

head(dat_ICCAT)
# Aggregate data over years for each SchoolTypeCode
sum_data_tottrop_yearly <- aggregate(tottrop ~ YearC + SchoolTypeCode, data = dat_ICCAT, FUN = sum)

ggplot(sum_data_tottrop_yearly, aes(x = YearC, y = tottrop, color = SchoolTypeCode)) +
  geom_line() +
  scale_color_manual(values = c("FAD" = "red", "FSC" = "blue", "n/a" = "green"), labels = c("FAD", "FSC", "n/a")) + # Manually specify colors and labels
  labs(title = "ICCAT Total Yearly Catches for FAD, FSC ",
       x = "Year",
       y = "Sum of the three species",
       color = "School Type") +
  theme_minimal()



##########################Grafics de FAD i FSC 
# Filter data for BET species
dat_ICCAT_BET <- subset(dat_ICCAT, select = c("YearC", "SchoolTypeCode", "BET"))

# Sum BET over time for each SchoolTypeCode
sum_dat_ICCAT_BET <- aggregate(BET ~ YearC + SchoolTypeCode, data = dat_ICCAT_BET, FUN = sum)

# Plotting BET using ggplot with facets
ggplot(sum_dat_ICCAT_BET, aes(x = YearC, y = BET, color = SchoolTypeCode)) +
  geom_line() +
  labs(title = "ICCAT BET catches for FAD and FSC",
       x = "Year",
       y = "Sum of BET",
       color = "School Type") +
  theme_minimal()

# Filter data for YFT species
dat_ICCAT_YFT <- subset(dat_ICCAT, select = c("YearC", "SchoolTypeCode", "YFT"))

# Sum YFT over time for each SchoolTypeCode
sum_dat_ICCAT_YFT <- aggregate(YFT ~ YearC + SchoolTypeCode, data = dat_ICCAT_YFT, FUN = sum)

# Plotting YFT using ggplot with facets
ggplot(sum_dat_ICCAT_YFT, aes(x = YearC, y = YFT, color = SchoolTypeCode)) +
  geom_line() +
  labs(title = "ICCAT YFT catches for FAD and FSC",
       x = "Year",
       y = "Sum of YFT",
       color = "School Type") +
  theme_minimal()

# Filter data for SKJ species
dat_ICCAT_SKJ <- subset(dat_ICCAT, select = c("YearC", "SchoolTypeCode", "SKJ"))

# Sum SKJ over time for each SchoolTypeCode
sum_dat_ICCAT_SKJ <- aggregate(SKJ ~ YearC + SchoolTypeCode, data = dat_ICCAT_SKJ, FUN = sum)

# Plotting SKJ using ggplot with facets
ggplot(sum_dat_ICCAT_SKJ, aes(x = YearC, y = SKJ, color = SchoolTypeCode)) +
  geom_line() +
  labs(title = "ICCAT SKJ catches for FAD and FSC",
       x = "Year",
       y = "Sum of SKJ",
       color = "School Type") +
  theme_minimal()

head(dat_ICCAT)


dat_ICCAT <- subset(dat_ICCAT, SchoolTypeCode != "FSC")


##############################################################################
########################## Map distribution ##########################
##############################################################################

 # plot(dat_ICCAT$londec, dat_ICCAT$latdec, pch = 16, cex = .9, col = 'goldenrod1', xlab = "Longitude", ylab = "Latitude", main = "ICCAT Distribution of Catches")
 # maps::map(add = TRUE, fill = TRUE, col = 'black')
# 





##############################################################

lon_range <- range(dat_ICCAT$londec, na.rm = TRUE)

# Calculate the range for latitude
lat_range <- range(dat_ICCAT$latdec, na.rm = TRUE)

# Print the ranges
lon_range
lat_range

##############################################################################################
######################## Map per year y guardarlos como imagen o tiff ###############
###############################################################################################


bbox <- c(min(dat_ICCAT$londec), max(dat_ICCAT$londec), min(dat_ICCAT$latdec), max(dat_ICCAT$latdec))

# Calculate the maximum total trop sum across all years
max_tottrop_sum <- max(sapply(1993:2022, function(year) {
  data_year <- dat_ICCAT %>% filter(YearC == year)
  aggregated_data <- data_year %>% 
    group_by(latdec, londec) %>% 
    summarise(tottrop_sum = sum(tottrop))
  max(aggregated_data$tottrop_sum)
}))

# Calculate the minimum total trop sum across all years
min_tottrop_sum <- min(sapply(1993:2022, function(year) {
  data_year <- dat_ICCAT %>% filter(YearC == year)
  aggregated_data <- data_year %>% 
    group_by(latdec, londec) %>% 
    summarise(tottrop_sum = sum(tottrop))
  min(aggregated_data$tottrop_sum)
}))

# Plot function
plot_tottrop_distribution <- function(year) {
  # Filter data for the specified year
  data_year <- dat_ICCAT %>%
    filter(YearC == year)
  
  # Aggregate data, summing tottrop when latdec and londec are the same
  aggregated_data <- data_year %>%
    group_by(latdec, londec) %>%
    summarise(tottrop_sum = sum(tottrop))
  # Set legend limits based on the maximum total trop sum
  legend_limits <- c(min_tottrop_sum, max_tottrop_sum)
  
  # Plot distribution of tottrop for the specified year
  ggplot(aggregated_data, aes(x = londec, y = latdec)) +
    geom_tile(aes(fill = tottrop_sum)) +
    scale_fill_gradient(low = "blue", high = "red", limits = legend_limits) +  # Set consistent legend limits
    labs(x = "Longitude", y = "Latitude", fill = "Total Trop (kg)") +
    theme_light() +  # Change the theme to set a white background
    ggtitle(paste("ICCAT Total catches for", year)) +
    theme(legend.position = "right") +  # Set legend position to the right
    coord_fixed() +  # Keep aspect ratio
    xlim(bbox[1], bbox[2]) +  # Limit x-axis to the bounding box
    ylim(bbox[3], bbox[4]) +  # Limit y-axis to the bounding box
    
    # Add map
    geom_path(data = map_data("world"), aes(x = long, y = lat, group = group), color = "black") +  # Add borders
    geom_polygon(data = map_data("world"), aes(x = long, y = lat, group = group), fill = "black") +  # Add fill
    theme(panel.background = element_rect(fill = "transparent")) +
    theme(legend.box.background = element_rect(color = "black")) +  # Set legend box color
    theme(legend.key = element_rect(color = "black", fill = "white"))  # Set legend key color
}



plot <- plot_tottrop_distribution(1993)
print(plot)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_1991.png", plot)
# 
# plot <- plot_tottrop_distribution(1992)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_1992.png", plot)
# 
# plot <- plot_tottrop_distribution(1993)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_1993.png", plot)
# 
# plot <- plot_tottrop_distribution(1994)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_1994.png", plot)
# 
# plot <- plot_tottrop_distribution(1995)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_1995.png", plot)
# 
# plot <- plot_tottrop_distribution(1996)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_1996.png", plot)
# 
# plot <- plot_tottrop_distribution(1997)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_1997.png", plot)
# 
# plot <- plot_tottrop_distribution(1998)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_1998.png", plot)
# 
# plot <- plot_tottrop_distribution(1999)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_1999.png", plot)
# 
# plot <- plot_tottrop_distribution(2000)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_2000.png", plot)
# 
# plot <- plot_tottrop_distribution(2001)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_2001.png", plot)
# 
# plot <- plot_tottrop_distribution(2002)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_2002.png", plot)
# 
# plot <- plot_tottrop_distribution(2003)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_2003.png", plot)
# 
# plot <- plot_tottrop_distribution(2004)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_2004.png", plot)
# 
# plot <- plot_tottrop_distribution(2005)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_2005.png", plot)
# 
# plot <- plot_tottrop_distribution(2006)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_2006.png", plot)
# 
# plot <- plot_tottrop_distribution(2007)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_2007.png", plot)
# 
# plot <- plot_tottrop_distribution(2008)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_2008.png", plot)
# 
# plot <- plot_tottrop_distribution(2009)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_2009.png", plot)
# 
# plot <- plot_tottrop_distribution(2010)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_2010.png", plot)
# 
# plot <- plot_tottrop_distribution(2011)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_2011.png", plot)
# 
# plot <- plot_tottrop_distribution(2012)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_2012.png", plot)
# 
# plot <- plot_tottrop_distribution(2013)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_2013.png", plot)
# 
# plot <- plot_tottrop_distribution(2014)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_2014.png", plot)
# 
# plot <- plot_tottrop_distribution(2015)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_2015.png", plot)
# 
# plot <- plot_tottrop_distribution(2016)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_2016.png", plot)
# 
# plot <- plot_tottrop_distribution(2017)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_2017.png", plot)
# 
# plot <- plot_tottrop_distribution(2018)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_2018.png", plot)
# 
# plot <- plot_tottrop_distribution(2019)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_2019.png", plot)
# 
# plot <- plot_tottrop_distribution(2020)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_2020.png", plot)
# 
# plot <- plot_tottrop_distribution(2021)
# ggsave("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Mapes/ICCAT/plot_2021.png", plot)



########################################## Save maps as TIFF



# # Define the bounding box
# bbox <- c(min(dat_ICCAT$londec), max(dat_ICCAT$londec), min(dat_ICCAT$latdec), max(dat_ICCAT$latdec))
# 
# # Calculate the maximum total trop sum across all years
# max_tottrop_sum <- max(sapply(1993:2022, function(year) {
#   data_year <- dat_ICCAT %>% filter(YearC == year)
#   aggregated_data <- data_year %>%
#     group_by(latdec, londec) %>%
#     summarise(tottrop_sum = sum(tottrop))
#   max(aggregated_data$tottrop_sum, na.rm = TRUE)
# }))
# 
# # Calculate the minimum total trop sum across all years
# min_tottrop_sum <- min(sapply(1993:2022, function(year) {
#   data_year <- dat_ICCAT %>% filter(YearC == year)
#   aggregated_data <- data_year %>%
#     group_by(latdec, londec) %>%
#     summarise(tottrop_sum = sum(tottrop))
#   min(aggregated_data$tottrop_sum, na.rm = TRUE)
# }))
# 
# # Function to export data to GeoTIFF
# export_to_geotiff <- function(year) {
#   # Filter data for the specified year
#   data_year <- dat_ICCAT %>%
#     filter(YearC == year)
#   
#   # Aggregate data, summing tottrop when latdec and londec are the same
#   aggregated_data <- data_year %>%
#     group_by(latdec, londec) %>%
#     summarise(tottrop_sum = sum(tottrop))
#   
#   # Create a raster from the aggregated data
#   r <- rasterFromXYZ(as.data.frame(aggregated_data)[, c("londec", "latdec", "tottrop_sum")])
#   
#   # Set the coordinate reference system (CRS) if known, e.g., WGS84
#   crs(r) <- CRS("WGS84")
#   
#   # Specify the output directory
#   output_dir <- "D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/QGIS/Data-in"
#   
#   # Ensure the directory exists
#   if (!dir.exists(output_dir)) {
#     dir.create(output_dir, recursive = TRUE)
#   }
#   
#   # Export to GeoTIFF
#   output_filename <- paste0(output_dir, "/ICCAT_Total_Catches_", year, ".tif")
#   writeRaster(r, filename = output_filename, format = "GTiff", overwrite = TRUE)
# }
# 
# # Loop over years and export each year to a GeoTIFF file
# for (year in 1993:2022) {
#   export_to_geotiff(year)
# }





###########################################################
############### Center of gravity by  species #############
###########################################################

dat_ICCAT <- read.csv("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Datos/My_data/dat_ICCAT.csv")


# Aggregate the data by summing SKJ, BET, and YFT based on SchoolTypeCode, YearC, TimePeriodID, londec, and latdec
dat_ICCAT_2 <- aggregate(cbind(SKJ, BET, YFT) ~ SchoolTypeCode + YearC + TimePeriodID + londec + latdec, data = dat_ICCAT, FUN = sum)


# Convert dat_ICCAT_2 to a data.table object
dat_ICCAT_2 <- data.table(dat_ICCAT_2)

head(dat_ICCAT_2)

# Calculate the total catches of SKJ, BET, and YFT for each combination of SchoolTypeCode, YearC, and TimePeriodID
dat_ICCAT_2[, totSKJ := sum(SKJ), by = .(SchoolTypeCode, YearC, TimePeriodID)]
dat_ICCAT_2[, totBET := sum(BET), by = .(SchoolTypeCode, YearC, TimePeriodID)]
dat_ICCAT_2[, totYFT := sum(YFT), by = .(SchoolTypeCode, YearC, TimePeriodID)]

# Convert dat_ICCAT_2 back to a data.frame
dat_ICCAT_2 <- data.frame(dat_ICCAT_2)

# Calculate the weighted average of londec and latdec for each combination of SchoolTypeCode, YearC, TimePeriodID, and species
for (i in c('SKJ', 'BET', 'YFT')) {
  dat_ICCAT_2[, paste0('lonagg_', i)] <- dat_ICCAT_2$londec * dat_ICCAT_2[, i] / dat_ICCAT_2[, paste0('tot', i)]  # Calculate weighted average of londec
  dat_ICCAT_2[, paste0('latagg_', i)] <- dat_ICCAT_2$latdec * dat_ICCAT_2[, i] / dat_ICCAT_2[, paste0('tot', i)]  # Calculate weighted average of latdec
}

head(dat_ICCAT_2)


# Aggregate lonagg_SKJ, latagg_SKJ, lonagg_BET, latagg_BET, lonagg_YFT, and latagg_YFT by SchoolTypeCode, YearC, and TimePeriodID
dat_ICCAT_3 <- aggregate(x = dat_ICCAT_2[, c(12:17)], 
                         by = list(dat_ICCAT_2$SchoolTypeCode, dat_ICCAT_2$YearC, dat_ICCAT_2$TimePeriodID), 
                         FUN = sum)

head(dat_ICCAT_3)

# Rename the columns of dat_ICCAT_3
names(dat_ICCAT_3)[1:3] <- c('settype', 'year', 'month')

# Display the first few rows of dat_ICCAT_3
head(dat_ICCAT_3)



# Reshape the data from wide to long format using melt function from reshape2 package
dat_ICCAT_4 <- reshape2::melt(dat_ICCAT_3, id.vars = c('settype', 'year', 'month'))


head(dat_ICCAT_4)

# Extract the first three characters to get the species abbreviation
dat_ICCAT_4$var <- substr(dat_ICCAT_4$variable, 1, 3)

head(dat_ICCAT_4)

# Extract the species abbreviation from the variable name
dat_ICCAT_4$species <- substr(dat_ICCAT_4$variable, 8, 10)

head(dat_ICCAT_4)

# Select only the required columns
dat_ICCAT_4 <- dat_ICCAT_4[, c('settype', 'year', 'month', 'species', 'var', 'value')]

head(dat_ICCAT_4)

# Create a date column using ISOdate with day fixed as 15 for each month
dat_ICCAT_4$date <- ISOdate(dat_ICCAT_4$year, dat_ICCAT_4$month, 15)

head(dat_ICCAT_4)



####### Per mes

# Create a line plot of value over date, colored by species, with facets for var and settype
ggplot(dat_ICCAT_4, aes(x = date, y = value, colour = species)) +
  geom_line() +
  facet_grid(rows = vars(var), cols = vars(settype), scale = 'free_y') + # Facet by var and settype with free y-axis scale
  geom_smooth() + # Add a smoothed line
  scale_color_manual(values = c('red', 'blue', 'goldenrod1')) + # Manually specify line colors
  labs(title = "ICCAT Catch distribution per year and species for FAD and FSC ") + # Add title
  theme_minimal() # Set a minimal theme for better visualization





######## MITJA Mes

head(dat_ICCAT_4)


filtered_data_last_decade <- subset(dat_ICCAT_4, settype == "FAD" & var == "lat" & year > 2013)
filtered_data_second_decade <- subset(dat_ICCAT_4,settype == "FAD" & var == "lat" & year >= 2003 & year <= 2012)
filtered_data_first_decade <- subset(dat_ICCAT_4, settype == "FAD" & var == "lat" & year < 2003)


# Aggregate data by month and species
avg_monthly_data_last_decade <- aggregate(value ~ month + species + var + settype, data = filtered_data_last_decade, FUN = mean)
avg_monthly_data_second_decade <- aggregate(value ~ month + species + var + settype, data = filtered_data_second_decade, FUN = mean)
avg_monthly_data_first_decade <- aggregate(value ~ month + species + var + settype, data = filtered_data_first_decade, FUN = mean)

# Define the order of months
month_order <- c("J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D")



# Define the plots as before

plot_first_decade <- ggplot(avg_monthly_data_first_decade, aes(x = month, y = value, colour = species)) +
  geom_line() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black") +  # Add horizontal line
  facet_grid(rows = vars(var), cols = vars(settype), scale = 'free_y', labeller = label_value) + 
  geom_smooth() + 
  scale_color_manual(values = c('red', 'blue', 'goldenrod1')) +
  labs(title = "1993-2002", x = element_blank()) +  
  theme_minimal() + 
  theme(
    axis.title.y = element_blank(),
    axis.text.x = element_text(hjust = 1, size = rel(2)), # Increase axis text size
    axis.text.y = element_text(hjust = 1, size = rel(2)),
    strip.text.x = element_blank(), 
    strip.text.y = element_blank(),
    legend.position = "none",
    plot.title = element_text(size = rel(2)) # Increase title text size
  ) +
  scale_x_continuous(breaks = 1:12, labels = month_order) + # Set x-axis labels to month names in order
  ylim(-10, 10) # Set y-axis limits

plot_second_decade <- ggplot(avg_monthly_data_second_decade, aes(x = month, y = value, colour = species)) +
  geom_line() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black") +  # Add horizontal line
  facet_grid(rows = vars(var), cols = vars(settype), scale = 'free_y') + 
  geom_smooth() + 
  scale_color_manual(values = c('red', 'blue', 'goldenrod1')) +
  labs(title = "2003-2012", x = element_blank()) + 
  theme_minimal() + 
  theme(
    axis.title.y = element_blank(),
    axis.text.x = element_text(hjust = 1, size = rel(2)), # Increase axis text size
    axis.text.y = element_text(hjust = 1, size = rel(2)),
    strip.text.x = element_blank(), 
    strip.text.y = element_blank(),
    legend.position = "none",
    plot.title = element_text(size = rel(2)) # Increase title text size
  ) +
  scale_x_continuous(breaks = 1:12, labels = month_order) + # Set x-axis labels to month names in order
  ylim(-10, 10) # Set y-axis limits

plot_last_decade <- ggplot(avg_monthly_data_last_decade, aes(x = month, y = value, colour = species)) +
  geom_line() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black") +  # Add horizontal line
  facet_grid(rows = vars(var), cols = vars(settype), scale = 'free_y') + 
  geom_smooth() + 
  scale_color_manual(values = c('red', 'blue', 'goldenrod1')) +
  labs(title = "2013-2022", y = element_blank(), x = element_blank()) + 
  theme_minimal() + 
  theme(
    axis.title.y = element_blank(),
    axis.text.x = element_text(hjust = 1, size = rel(2)), # Increase axis text size
    axis.text.y = element_text(hjust = 1, size = rel(2)),
    strip.text.x = element_blank(), 
    strip.text.y = element_blank(),
    legend.position = "none",
    plot.title = element_text(size = rel(2)) # Increase title text size
  ) +
  scale_x_continuous(breaks = 1:12, labels = month_order) + # Set x-axis labels to month names in order
  ylim(-10, 10) # Set y-axis limits

# Create the y-axis title and ticks for the first plot
y_axis_extra <- ggplot(avg_monthly_data_first_decade, aes(y = value)) +
  geom_blank() +
  theme_minimal() +
  theme(
    axis.title.y = element_text(vjust = 1.5, size = rel(2)),
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank()
  ) +
  labs(y = "Latitude")

# Create the title with a larger size
title <- textGrob("ICCAT Weighted Average Catch Latitude", gp = gpar(fontsize = rel(25)))

# Arrange the plots with the title and y-axis title/ticks
grid.arrange(
  arrangeGrob(
    y_axis_extra,
    plot_first_decade, plot_second_decade, plot_last_decade,
    ncol = 4,
    widths = c(0.1, 1, 1, 1)
  ),
  top = title
)






# Split the dataset into two subsets based on var (lon and lat)
lon_data <- subset(dat_ICCAT_4, var == "lon", select = c(settype, year, species, date, value, month))
lat_data <- subset(dat_ICCAT_4, var == "lat", select = c(settype, year, species, date, value, month))

# Merge the two subsets by the common columns (settype, year, species, date)
dat_ICCAT_4b <- merge(lon_data, lat_data, by = c("settype", "year", "species", "date", "month"))

# Rename the columns for clarity
names(dat_ICCAT_4b)[names(dat_ICCAT_4b) == "value.x"] <- "lon"
names(dat_ICCAT_4b)[names(dat_ICCAT_4b) == "value.y"] <- "lat"

# Print the first few rows to verify the changes
head(dat_ICCAT_4b)




# # # Assuming dat_ICCAT_4b is your dataframe to be saved
#  write.csv(dat_ICCAT_4b, file = "D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Datos/My_data/ICCAT_CG.csv", row.names = FALSE)

 



 ################################################################################
 ################################ Boxplot #######################################
 ################################################################################


# Load the data
ICCAT_CG <- read.csv("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Datos/My_data/ICCAT_CG.csv")

head(ICCAT_CG)

 # Convert 'year' column to numeric
 ICCAT_CG$year <- as.numeric(ICCAT_CG$year)
 
 
 # Create a new column for decades
 ICCAT_CG <- ICCAT_CG %>%
   mutate(decade = case_when(
     year >= 1993 & year <= 2002 ~ "1993-2002",
     year >= 2003 & year <= 2012 ~ "2003-2012",
     year >= 2013 & year <= 2022 ~ "2013-2022",
     TRUE ~ NA_character_
   ))
 
 
 First_D_BET <- ICCAT_CG %>% filter(species == "BET", decade == "1993-2002")
 Second_D_BET <- ICCAT_CG %>% filter(species == "BET", decade == "2003-2012")
 Last_D_BET <- ICCAT_CG %>% filter(species == "BET", decade == "2013-2022")
 
 First_D_YFT <- ICCAT_CG %>% filter(species == "YFT", decade == "1993-2002")
 Second_D_YFT <- ICCAT_CG %>% filter(species == "YFT", decade == "2003-2012")
 Last_D_YFT <- ICCAT_CG %>% filter(species == "YFT", decade == "2013-2022")
 
 First_D_SKJ <- ICCAT_CG %>% filter(species == "SKJ", decade == "1993-2002")
 Second_D_SKJ <- ICCAT_CG %>% filter(species == "SKJ", decade == "2003-2012")
 Last_D_SKJ <- ICCAT_CG %>% filter(species == "SKJ", decade == "2013-2022")
 
 
 species_colors <- c("SKJ" = "blue", "BET" = "red", "YFT" = "orange")
 
 plot_species <- function(species_name) {
   ggplot(ICCAT_CG %>% filter(species == species_name & !is.na(decade)), 
          aes(x = decade, y = lat, color = species_name)) +
     geom_boxplot(size = 1.2) +
     scale_color_manual(values = species_colors) +  # Use custom colors
     labs(title = NULL, y = "Latitude") +
     theme_minimal(base_size = 16) +  # Set base size to increase overall text size
     theme(
       text = element_text(size = 16),  # General text size
       axis.text = element_text(size = 16),  # Axis text size
       axis.title = element_text(size = 16),  # Axis title text size
       axis.title.x = element_blank(),
       legend.position = "none"  # Hide the legend
     ) +
     annotate("text", x = 0.5, y = Inf, label = species_name, hjust = 0, vjust = 2, 
              size = 8, fontface = "bold")  # Double the size of annotate text
 }
 
 
 # Create the title with a larger size
 title2 <- textGrob("ICCAT Latitude Distribution", gp = gpar(fontsize = 26, fontface = "bold"))
 
 # Arrange the plots with the title
 grid.arrange(
   arrangeGrob(plot_species("SKJ"), plot_species("YFT"), plot_species("BET"), ncol = 1),
   top = title2
 )
 
 
 #####################################################################
 ################ Analisis estad?stico entre d?cadas  #################
 ##################################################################

 # Load the data
 ICCAT_CG <- read.csv("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Datos/My_data/ICCAT_CG.csv")
 
 head(ICCAT_CG)
 
 # Convert 'year' column to numeric
 ICCAT_CG$year <- as.numeric(ICCAT_CG$year)
 
 
 # Create a new column for decades
 ICCAT_CG <- ICCAT_CG %>%
   mutate(decade = case_when(
     year >= 1993 & year <= 2002 ~ "1993-2002",
     year >= 2003 & year <= 2012 ~ "2003-2012",
     year >= 2013 & year <= 2022 ~ "2013-2022",
     TRUE ~ NA_character_
   ))
 
 
 First_D_BET <- ICCAT_CG %>% filter(species == "BET", decade == "1993-2002")
 Second_D_BET <- ICCAT_CG %>% filter(species == "BET", decade == "2003-2012")
 Last_D_BET <- ICCAT_CG %>% filter(species == "BET", decade == "2013-2022")
 
 First_D_YFT <- ICCAT_CG %>% filter(species == "YFT", decade == "1993-2002")
 Second_D_YFT <- ICCAT_CG %>% filter(species == "YFT", decade == "2003-2012")
 Last_D_YFT <- ICCAT_CG %>% filter(species == "YFT", decade == "2013-2022")
 
 First_D_SKJ <- ICCAT_CG %>% filter(species == "SKJ", decade == "1993-2002")
 Second_D_SKJ <- ICCAT_CG %>% filter(species == "SKJ", decade == "2003-2012")
 Last_D_SKJ <- ICCAT_CG %>% filter(species == "SKJ", decade == "2013-2022")
 
 ############################## First and Second BET


 # Check assumptions - normality (using Shapiro-Wilk test)
 shapiro.test(First_D_BET$lat)
 shapiro.test(Second_D_BET$lat)


 # Perform appropriate statistical test based on normality assumption
 if (shapiro.test(First_D_BET$lat)$p.value > 0.05 & shapiro.test(Second_D_BET$lat)$p.value > 0.05) {
   # Use two-sample t-test for normally distributed data
   t.test(First_D_BET$lat, Second_D_BET$lat)
 } else {
   # Use Wilcoxon-Mann-Whitney test for non-normally distributed data
   wilcox.test(First_D_BET$lat, Second_D_BET$lat)
 }


 latitudes_BET_First_Second <- c(First_D_BET$lat, Second_D_BET$lat)

 # Create a grouping variable
 group_BET_First_Second <- c(rep("First", nrow(First_D_BET)), rep("Second", nrow(Second_D_BET)))

 # Perform the Fligner-Killeen test
 fligner_result_BET_First_Second <- fligner.test(latitudes_BET_First_Second ~ group_BET_First_Second)

 # Print the result
 print(fligner_result_BET_First_Second)

 ############################## First and Last BET

 # Check assumptions - normality (using Shapiro-Wilk test)
 shapiro.test(First_D_BET$lat)
 shapiro.test(Last_D_BET$lat)


 # Perform appropriate statistical test based on normality assumption
 if (shapiro.test(First_D_BET$lat)$p.value > 0.05 & shapiro.test(Last_D_BET$lat)$p.value > 0.05) {
   # Use two-sample t-test for normally distributed data
   t.test(First_D_BET$lat, Last_D_BET$lat)
 } else {
   # Use Wilcoxon-Mann-Whitney test for non-normally distributed data
   wilcox.test(First_D_BET$lat, Last_D_BET$lat)
 }


 latitudes_BET_First_LAST <- c(First_D_BET$lat, Last_D_BET$lat)

 # Create a grouping variable
 group_BET_First_LAST <- c(rep("First", nrow(First_D_BET)), rep("Last", nrow(Last_D_BET)))

 # Perform the Fligner-Killeen test
 fligner_result_BET_First_LAST <- fligner.test(latitudes_BET_First_LAST ~ group_BET_First_LAST)

 # Print the result
 print(fligner_result_BET_First_LAST)

 ############################## Second and Last BET

 # Check assumptions - normality (using Shapiro-Wilk test)
 shapiro.test(Second_D_BET$lat)
 shapiro.test(Last_D_BET$lat)


 # Perform appropriate statistical test based on normality assumption
 if (shapiro.test(Second_D_BET$lat)$p.value > 0.05 & shapiro.test(Last_D_BET$lat)$p.value > 0.05) {
   # Use two-sample t-test for normally distributed data
   t.test(Second_D_BET$lat, Last_D_BET$lat)
 } else {
   # Use Wilcoxon-Mann-Whitney test for non-normally distributed data
   wilcox.test(Second_D_BET$lat, Last_D_BET$lat)
 }


 latitudes_BET_Second_Last <- c(Second_D_BET$lat, Last_D_BET$lat)

 # Create a grouping variable
 group_BET_Second_Last <- c(rep("Second", nrow(Second_D_BET)), rep("Last", nrow(Last_D_BET)))

 # Perform the Fligner-Killeen test
 fligner_result_BET_Second_Last <- fligner.test(latitudes_BET_Second_Last ~ group_BET_Second_Last)

 # Print the result
 print(fligner_result_BET_Second_Last)





 ############################## First and Second YFT


 # Check assumptions - normality (using Shapiro-Wilk test)
 shapiro.test(First_D_YFT$lat)
 shapiro.test(Second_D_YFT$lat)


 # Perform appropriate statistical test based on normality assumption
 if (shapiro.test(First_D_YFT$lat)$p.value > 0.05 & shapiro.test(Second_D_YFT$lat)$p.value > 0.05) {
   # Use two-sample t-test for normally distributed data
   t.test(First_D_YFT$lat, Second_D_YFT$lat)
 } else {
   # Use Wilcoxon-Mann-Whitney test for non-normally distributed data
   wilcox.test(First_D_YFT$lat, Second_D_YFT$lat)
 }


 latitudes_YFT_First_Second <- c(First_D_YFT$lat, Second_D_YFT$lat)

 # Create a grouping variable
 group_YFT_First_Second <- c(rep("First", nrow(First_D_YFT)), rep("Second", nrow(Second_D_YFT)))

 # Perform the Fligner-Killeen test
 fligner_result_YFT_First_Second <- fligner.test(latitudes_YFT_First_Second ~ group_YFT_First_Second)

 # Print the result
 print(fligner_result_YFT_First_Second)

 ############################## First and Last YFT

 # Check assumptions - normality (using Shapiro-Wilk test)
 shapiro.test(First_D_YFT$lat)
 shapiro.test(Last_D_YFT$lat)


 # Perform appropriate statistical test based on normality assumption
 if (shapiro.test(First_D_YFT$lat)$p.value > 0.05 & shapiro.test(Last_D_YFT$lat)$p.value > 0.05) {
   # Use two-sample t-test for normally distributed data
   t.test(First_D_YFT$lat, Last_D_YFT$lat)
 } else {
   # Use Wilcoxon-Mann-Whitney test for non-normally distributed data
   wilcox.test(First_D_YFT$lat, Last_D_YFT$lat)
 }


 latitudes_YFT_First_LAST <- c(First_D_YFT$lat, Last_D_YFT$lat)

 # Create a grouping variable
 group_YFT_First_LAST <- c(rep("First", nrow(First_D_YFT)), rep("Last", nrow(Last_D_YFT)))

 # Perform the Fligner-Killeen test
 fligner_result_YFT_First_LAST <- fligner.test(latitudes_YFT_First_LAST ~ group_YFT_First_LAST)

 # Print the result
 print(fligner_result_YFT_First_LAST)

 ############################## Second and Last YFT

 # Check assumptions - normality (using Shapiro-Wilk test)
 shapiro.test(Second_D_YFT$lat)
 shapiro.test(Last_D_YFT$lat)


 # Perform appropriate statistical test based on normality assumption
 if (shapiro.test(Second_D_YFT$lat)$p.value > 0.05 & shapiro.test(Last_D_YFT$lat)$p.value > 0.05) {
   # Use two-sample t-test for normally distributed data
   t.test(Second_D_YFT$lat, Last_D_YFT$lat)
 } else {
   # Use Wilcoxon-Mann-Whitney test for non-normally distributed data
   wilcox.test(Second_D_YFT$lat, Last_D_YFT$lat)
 }


 latitudes_YFT_Second_Last <- c(Second_D_YFT$lat, Last_D_YFT$lat)

 # Create a grouping variable
 group_YFT_Second_Last <- c(rep("Second", nrow(Second_D_YFT)), rep("Last", nrow(Last_D_YFT)))

 # Perform the Fligner-Killeen test
 fligner_result_YFT_Second_Last <- fligner.test(latitudes_YFT_Second_Last ~ group_YFT_Second_Last)

 # Print the result
 print(fligner_result_YFT_Second_Last)








 ############################## First and Second SKJ


 # Check assumptions - normality (using Shapiro-Wilk test)
 shapiro.test(First_D_SKJ$lat)
 shapiro.test(Second_D_SKJ$lat)


 # Perform appropriate statistical test based on normality assumption
 if (shapiro.test(First_D_SKJ$lat)$p.value > 0.05 & shapiro.test(Second_D_SKJ$lat)$p.value > 0.05) {
   # Use two-sample t-test for normally distributed data
   t.test(First_D_SKJ$lat, Second_D_SKJ$lat)
 } else {
   # Use Wilcoxon-Mann-Whitney test for non-normally distributed data
   wilcox.test(First_D_SKJ$lat, Second_D_SKJ$lat)
 }


 latitudes_SKJ_First_Second <- c(First_D_SKJ$lat, Second_D_SKJ$lat)

 # Create a grouping variable
 group_SKJ_First_Second <- c(rep("First", nrow(First_D_SKJ)), rep("Second", nrow(Second_D_SKJ)))

 # Perform the Fligner-Killeen test
 fligner_result_SKJ_First_Second <- fligner.test(latitudes_SKJ_First_Second ~ group_SKJ_First_Second)

 # Print the result
 print(fligner_result_SKJ_First_Second)

 ############################## First and Last SKJ

 # Check assumptions - normality (using Shapiro-Wilk test)
 shapiro.test(First_D_SKJ$lat)
 shapiro.test(Last_D_SKJ$lat)


 # Perform appropriate statistical test based on normality assumption
 if (shapiro.test(First_D_SKJ$lat)$p.value > 0.05 & shapiro.test(Last_D_SKJ$lat)$p.value > 0.05) {
   # Use two-sample t-test for normally distributed data
   t.test(First_D_SKJ$lat, Last_D_SKJ$lat)
 } else {
   # Use Wilcoxon-Mann-Whitney test for non-normally distributed data
   wilcox.test(First_D_SKJ$lat, Last_D_SKJ$lat)
 }


 latitudes_SKJ_First_LAST <- c(First_D_SKJ$lat, Last_D_SKJ$lat)

 # Create a grouping variable
 group_SKJ_First_LAST <- c(rep("First", nrow(First_D_SKJ)), rep("Last", nrow(Last_D_SKJ)))

 # Perform the Fligner-Killeen test
 fligner_result_SKJ_First_LAST <- fligner.test(latitudes_SKJ_First_LAST ~ group_SKJ_First_LAST)

 # Print the result
 print(fligner_result_SKJ_First_LAST)

 ############################## Second and Last SKJ

 # Check assumptions - normality (using Shapiro-Wilk test)
 shapiro.test(Second_D_SKJ$lat)
 shapiro.test(Last_D_SKJ$lat)


 # Perform appropriate statistical test based on normality assumption
 if (shapiro.test(Second_D_SKJ$lat)$p.value > 0.05 & shapiro.test(Last_D_SKJ$lat)$p.value > 0.05) {
   # Use two-sample t-test for normally distributed data
   t.test(Second_D_SKJ$lat, Last_D_SKJ$lat)
 } else {
   # Use Wilcoxon-Mann-Whitney test for non-normally distributed data
   wilcox.test(Second_D_SKJ$lat, Last_D_SKJ$lat)
 }


 latitudes_SKJ_Second_Last <- c(Second_D_SKJ$lat, Last_D_SKJ$lat)

 # Create a grouping variable
 group_SKJ_Second_Last <- c(rep("Second", nrow(Second_D_SKJ)), rep("Last", nrow(Last_D_SKJ)))

 # Perform the Fligner-Killeen test
 fligner_result_SKJ_Second_Last <- fligner.test(latitudes_SKJ_Second_Last ~ group_SKJ_Second_Last)

 # Print the result
 print(fligner_result_SKJ_Second_Last)

 



# ###### No s'utilitza ja (de moment)
 
#  #######################################################
# ############### Mapas Centro de gravedad ###############
# #################### Mes a?o y Lustro ##################
# ########################################################
#  
# 
#  
# # Create the map
# world_map <- map_data("world")
# 
# 
# #################### Mensual
# 
# 
# 
# # Mapa para la especie BET con el m?todo FAD
# bet_fad_data <- subset(dat_ICCAT_4b, species == "BET" & settype == "FAD")
# bet_fad_map <- ggplot() +
#   geom_polygon(data = world_map, aes(x = long, y = lat, group = group), fill = "lightgrey") +
#   geom_point(data = bet_fad_data, aes(x = lon, y = lat, color = year), size = 2) +
#   scale_color_gradient(low = "blue", high = "red") +
#   labs(title = "BET",
#        x = "Longitud", y = "Latitud", color = "A?o") +
#   theme_minimal() +
#   xlim(-30, 15) +   # Adjust x-axis limits
#   ylim(-20, 20)    # Adjust y-axis limits
# 
# # Mapa para la especie YFT con el m?todo FAD
# yft_fad_data <- subset(dat_ICCAT_4b, species == "YFT" & settype == "FAD")
# yft_fad_map <- ggplot() +
#   geom_polygon(data = world_map, aes(x = long, y = lat, group = group), fill = "lightgrey") +
#   geom_point(data = yft_fad_data, aes(x = lon, y = lat, color = year), size = 2) +
#   scale_color_gradient(low = "blue", high = "red") +
#   labs(title = "YFT",
#        x = "Longitud", y = "Latitud", color = "A?o") +
#   theme_minimal() +
#   xlim(-30, 15) +   # Adjust x-axis limits
#   ylim(-20, 20)    # Adjust y-axis limits
# 
# # Mapa para la especie SKJ con el m?todo FAD
# skj_fad_data <- subset(dat_ICCAT_4b, species == "SKJ" & settype == "FAD")
# skj_fad_map <- ggplot() +
#   geom_polygon(data = world_map, aes(x = long, y = lat, group = group), fill = "lightgrey") +
#   geom_point(data = skj_fad_data, aes(x = lon, y = lat, color = year), size = 2) +
#   scale_color_gradient(low = "blue", high = "red") +
#   labs(title = "SKJ",
#        x = "Longitud", y = "Latitud", color = "A?o") +
#   theme_minimal() +
#   xlim(-30, 10) +   # Adjust x-axis limits
#   ylim(-15, 20)    # Adjust y-axis limits
# 
# 
# 
# 
# # Arrange the plots with the title
# grid.arrange(
#   arrangeGrob(bet_fad_map, yft_fad_map, skj_fad_map, nrow = 1),
#   top = "Center of Gravity by Month"
# )
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# ##################### ANUAL
# 
# dat_ICCAT <- read.csv("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Datos/My_data/dat_ICCAT.csv")
# 
# 
# # Calculate the evolution of the center of gravity by school type and species...
# 
# # Aggregate the data by summing SKJ, BET, and YFT based on SchoolTypeCode, YearC, londec, and latdec
# dat_ICCAT_5 <- aggregate(cbind(SKJ, BET, YFT) ~ SchoolTypeCode + YearC + londec + latdec, data = dat_ICCAT, FUN = sum)
# 
# head(dat_ICCAT_5)
# 
# # Convert dat_ICCAT_5 to a data.table object
# dat_ICCAT_5 <- data.table(dat_ICCAT_5)
# 
# head(dat_ICCAT_5)
# 
# # Calculate the total catches of SKJ, BET, and YFT for each combination of SchoolTypeCode, YearC,
# dat_ICCAT_5[, totSKJ := sum(SKJ), by = .(SchoolTypeCode, YearC)]
# dat_ICCAT_5[, totBET := sum(BET), by = .(SchoolTypeCode, YearC)]
# dat_ICCAT_5[, totYFT := sum(YFT), by = .(SchoolTypeCode, YearC)]
# 
# # Convert dat_ICCAT_5 back to a data.frame
# dat_ICCAT_5 <- data.frame(dat_ICCAT_5)
# 
# # Calculate the weighted average of londec and latdec for each combination of SchoolTypeCode, YearC,  and species
# for (i in c('SKJ', 'BET', 'YFT')) {
#   dat_ICCAT_5[, paste0('lonagg_', i)] <- dat_ICCAT_5$londec * dat_ICCAT_5[, i] / dat_ICCAT_5[, paste0('tot', i)]  # Calculate weighted average of londec
#   dat_ICCAT_5[, paste0('latagg_', i)] <- dat_ICCAT_5$latdec * dat_ICCAT_5[, i] / dat_ICCAT_5[, paste0('tot', i)]  # Calculate weighted average of latdec
# }
# 
# head(dat_ICCAT_5)
# 
# 
# # Aggregate lonagg_SKJ, latagg_SKJ, lonagg_BET, latagg_BET, lonagg_YFT, and latagg_YFT by SchoolTypeCode, YearC
# dat_ICCAT_6 <- aggregate(x = dat_ICCAT_5[, c(11:16)], 
#                          by = list(dat_ICCAT_5$SchoolTypeCode, dat_ICCAT_5$YearC), 
#                          FUN = sum)
# 
# head(dat_ICCAT_6)
# 
# # Rename the columns of dat_ICCAT_6
# names(dat_ICCAT_6)[1:2] <- c('settype', 'year')
# 
# 
# head(dat_ICCAT_6)
# 
# # Reshape the data from wide to long format using melt function from reshape2 package
# dat_ICCAT_7 <- reshape2::melt(dat_ICCAT_6, id.vars = c('settype', 'year'))
# 
# head(dat_ICCAT_7)
# 
# # Extract the first three characters to get the species abbreviation
# dat_ICCAT_7$var <- substr(dat_ICCAT_7$variable, 1, 3)
# 
# head(dat_ICCAT_7)
# 
# # Extract the species abbreviation from the variable name
# dat_ICCAT_7$species <- substr(dat_ICCAT_7$variable, 8, 10)
# 
# head(dat_ICCAT_7)
# 
# # Select only the required columns
# dat_ICCAT_7 <- dat_ICCAT_7[, c('settype', 'year', 'species', 'var', 'value')]
# 
# head(dat_ICCAT_7)
# 
# # Create a date column using ISOdate with day fixed as 15 for each month
# dat_ICCAT_7$date <- ISOdate(dat_ICCAT_7$year, 07, 1)
# 
# head(dat_ICCAT_7)
# 
# 
# # Create a line plot of value over date, colored by species, with facets for var and settype
# ggplot(dat_ICCAT_7, aes(x = date, y = value, colour = species)) +
#   geom_line() +
#   facet_grid(rows = vars(var), cols = vars(settype), scale = 'free_y') + # Facet by var and settype with free y-axis scale
#   geom_smooth() + # Add a smoothed line
#   scale_color_manual(values = c('red', 'blue', 'goldenrod1')) + # Manually specify line colors
#   labs(title = "ICCAT Catch distribution per year and species for FAD and FSC ") + # Add title
#   theme_minimal() # Set a minimal theme for better visualization
# 
# 
# 
# head(dat_ICCAT_7, 100)
# 
# 
# 
# 
# 
# # Split the dataset into two subsets based on var (lon and lat)
# lon_data <- subset(dat_ICCAT_7, var == "lon", select = c(settype, year, species, date, value))
# lat_data <- subset(dat_ICCAT_7, var == "lat", select = c(settype, year, species, date, value))
# 
# # Merge the two subsets by the common columns (settype, year, species, date)
# dat_ICCAT_8 <- merge(lon_data, lat_data, by = c("settype", "year", "species", "date"))
# 
# # Rename the columns for clarity
# names(dat_ICCAT_8)[names(dat_ICCAT_8) == "value.x"] <- "lon"
# names(dat_ICCAT_8)[names(dat_ICCAT_8) == "value.y"] <- "lat"
# 
# # Print the first few rows to verify the changes
# head(dat_ICCAT_8)
# 
# 
# 
# 
# 
# 
# 
# 
# # Create a color palette from blue to red
# color_palette <- colorRampPalette(brewer.pal(9, "RdYlBu"))
# 
# # Create the map
# world_map <- map_data("world")
# 
# 
# 
# # Mapa para la especie BET con el m?todo FAD
# bet_fad_data <- subset(dat_ICCAT_8, species == "BET" & settype == "FAD")
# bet_fad_map <- ggplot() +
#   geom_polygon(data = world_map, aes(x = long, y = lat, group = group), fill = "lightgrey") +
#   geom_point(data = bet_fad_data, aes(x = lon, y = lat, color = year), size = 2) +
#   scale_color_gradient(low = "blue", high = "red") +
#   labs(title = "Distribuci?n de la especie BET usando el m?todo FAD",
#        x = "Longitud", y = "Latitud", color = "A?o") +
#   theme_minimal() +
#   xlim(-20, 10) +   # Adjust x-axis limits
#   ylim(-5, 20)    # Adjust y-axis limits
# 
# # Mapa para la especie YFT con el m?todo FAD
# yft_fad_data <- subset(dat_ICCAT_8, species == "YFT" & settype == "FAD")
# yft_fad_map <- ggplot() +
#   geom_polygon(data = world_map, aes(x = long, y = lat, group = group), fill = "lightgrey") +
#   geom_point(data = yft_fad_data, aes(x = lon, y = lat, color = year), size = 2) +
#   scale_color_gradient(low = "blue", high = "red") +
#   labs(title = "Distribuci?n de la especie YFT usando el m?todo FAD",
#        x = "Longitud", y = "Latitud", color = "A?o") +
#   theme_minimal() +
#   xlim(-20, 10) +   # Adjust x-axis limits
#   ylim(-5, 20)    # Adjust y-axis limits
# 
# # Mapa para la especie SKJ con el m?todo FAD
# skj_fad_data <- subset(dat_ICCAT_8, species == "SKJ" & settype == "FAD")
# skj_fad_map <- ggplot() +
#   geom_polygon(data = world_map, aes(x = long, y = lat, group = group), fill = "lightgrey") +
#   geom_point(data = skj_fad_data, aes(x = lon, y = lat, color = year), size = 2) +
#   scale_color_gradient(low = "blue", high = "red") +
#   labs(title = "Distribuci?n de la especie SKJ usando el m?todo FAD",
#        x = "Longitud", y = "Latitud", color = "A?o") +
#   theme_minimal() +
#   xlim(-20, 10) +   # Adjust x-axis limits
#   ylim(-5, 20)    # Adjust y-axis limits
# 
# 
# 
# # Juntar los mapas FAD en una sola grilla
# grid.arrange(bet_fad_map, yft_fad_map, skj_fad_map, nrow = 1)
# 
# 
# ##################### LUSTRO
# 
# dat_ICCAT <- read.csv("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Datos/My_data/dat_ICCAT.csv")
# 
# 
# head(dat_ICCAT)
# 
# dat_ICCAT_9 <-dat_ICCAT 
# 
# head(dat_ICCAT_9)
# 
# # Calcular el lustro
# dat_ICCAT_9$lustrum <- as.integer((dat_ICCAT_9$YearC - 1) / 5) * 5 + 1
# 
# # Mostrar las primeras filas con la nueva columna
# head(dat_ICCAT_9)
# 
# 
# # Calculate the evolution of the center of gravity by school type and species...
# 
# # Aggregate the data by summing SKJ, BET, and YFT based on SchoolTypeCode, lustrum, londec, and latdec
# dat_ICCAT_9 <- aggregate(cbind(SKJ, BET, YFT) ~ SchoolTypeCode + lustrum + londec + latdec, data = dat_ICCAT_9, FUN = sum)
# 
# head(dat_ICCAT_9)
# 
# # Convert dat_ICCAT_9 to a data.table object
# dat_ICCAT_9 <- data.table(dat_ICCAT_9)
# 
# head(dat_ICCAT_9)
# 
# # Calculate the total catches of SKJ, BET, and YFT for each combination of SchoolTypeCode, lustrum,
# dat_ICCAT_9[, totSKJ := sum(SKJ), by = .(SchoolTypeCode, lustrum)]
# dat_ICCAT_9[, totBET := sum(BET), by = .(SchoolTypeCode, lustrum)]
# dat_ICCAT_9[, totYFT := sum(YFT), by = .(SchoolTypeCode, lustrum)]
# 
# # Convert dat_ICCAT_9 back to a data.frame
# dat_ICCAT_9 <- data.frame(dat_ICCAT_9)
# 
# # Calculate the weighted average of londec and latdec for each combination of SchoolTypeCode, lustrum,  and species
# for (i in c('SKJ', 'BET', 'YFT')) {
#   dat_ICCAT_9[, paste0('lonagg_', i)] <- dat_ICCAT_9$londec * dat_ICCAT_9[, i] / dat_ICCAT_9[, paste0('tot', i)]  # Calculate weighted average of londec
#   dat_ICCAT_9[, paste0('latagg_', i)] <- dat_ICCAT_9$latdec * dat_ICCAT_9[, i] / dat_ICCAT_9[, paste0('tot', i)]  # Calculate weighted average of latdec
# }
# 
# head(dat_ICCAT_9)
# 
# 
# # Aggregate lonagg_SKJ, latagg_SKJ, lonagg_BET, latagg_BET, lonagg_YFT, and latagg_YFT by SchoolTypeCode, lustrum
# dat_ICCAT_10 <- aggregate(x = dat_ICCAT_9[, c(11:16)], 
#                           by = list(dat_ICCAT_9$SchoolTypeCode, dat_ICCAT_9$lustrum), 
#                           FUN = sum)
# 
# head(dat_ICCAT_10)
# 
# # Rename the columns of dat_ICCAT_10
# names(dat_ICCAT_10)[1:2] <- c('settype', 'lustrum')
# 
# 
# head(dat_ICCAT_10)
# 
# # Reshape the data from wide to long format using melt function from reshape2 package
# dat_ICCAT_11 <- reshape2::melt(dat_ICCAT_10, id.vars = c('settype', 'lustrum'))
# 
# head(dat_ICCAT_11)
# 
# # Extract the first three characters to get the species abbreviation
# dat_ICCAT_11$var <- substr(dat_ICCAT_11$variable, 1, 3)
# 
# head(dat_ICCAT_11)
# 
# # Extract the species abbreviation from the variable name
# dat_ICCAT_11$species <- substr(dat_ICCAT_11$variable, 8, 10)
# 
# head(dat_ICCAT_11)
# 
# # Select only the required columns
# dat_ICCAT_11 <- dat_ICCAT_11[, c('settype', 'lustrum', 'species', 'var', 'value')]
# 
# head(dat_ICCAT_11)
# 
# # Create a date column using ISOdate with day fixed as 15 for each month
# dat_ICCAT_11$date <- ISOdate(dat_ICCAT_11$lustrum+2, 07, 1)
# 
# head(dat_ICCAT_11)
# 
# 
# 
# 
# # Create a line plot of value over date, colored by species, with facets for var and settype
# ggplot(dat_ICCAT_11, aes(x = date, y = value, colour = species)) +
#   geom_line() +
#   facet_grid(rows = vars(var), cols = vars(settype), scale = 'free_y') + # Facet by var and settype with free y-axis scale
#   geom_smooth() + # Add a smoothed line
#   scale_color_manual(values = c('red', 'blue', 'goldenrod1')) + # Manually specify line colors
#   labs(title = "ICCAT Catch distribution per lustrum and species for FAD and FSC ") + # Add title
#   theme_minimal() # Set a minimal theme for better visualization
# 
# 
# 
# 
# # Split the dataset into two subsets based on var (lon and lat)
# lon_data <- subset(dat_ICCAT_11, var == "lon", select = c(settype, lustrum, species, date, value))
# lat_data <- subset(dat_ICCAT_11, var == "lat", select = c(settype, lustrum, species, date, value))
# 
# # Merge the two subsets by the common columns (settype, lustrum, species, date)
# dat_ICCAT_12 <- merge(lon_data, lat_data, by = c("settype", "lustrum", "species", "date"))
# 
# # Rename the columns for clarity
# names(dat_ICCAT_12)[names(dat_ICCAT_12) == "value.x"] <- "lon"
# names(dat_ICCAT_12)[names(dat_ICCAT_12) == "value.y"] <- "lat"
# 
# # Print the first few rows to verify the changes
# head(dat_ICCAT_12)
# 
# 
# 
# 
# 
# 
# 
# # Create the map
# world_map <- map_data("world")
# 
# 
# 
# # Mapa para la especie BET con el m?todo FAD
# bet_fad_data <- subset(dat_ICCAT_12, species == "BET" & settype == "FAD")
# bet_fad_map <- ggplot() +
#   geom_polygon(data = world_map, aes(x = long, y = lat, group = group), fill = "lightgrey") +
#   geom_point(data = bet_fad_data, aes(x = lon, y = lat, color = lustrum), size = 2) +
#   scale_color_gradient(low = "blue", high = "red") +
#   labs(title = "Distribuci?n de la especie BET usando el m?todo FAD",
#        x = "Longitud", y = "Latitud", color = "lustrum") +
#   theme_minimal() +
#   xlim(-15, 10) +   # Adjust x-axis limits
#   ylim(-5, 15)    # Adjust y-axis limits
# 
# # Mapa para la especie YFT con el m?todo FAD
# yft_fad_data <- subset(dat_ICCAT_12, species == "YFT" & settype == "FAD")
# yft_fad_map <- ggplot() +
#   geom_polygon(data = world_map, aes(x = long, y = lat, group = group), fill = "lightgrey") +
#   geom_point(data = yft_fad_data, aes(x = lon, y = lat, color = lustrum), size = 2) +
#   scale_color_gradient(low = "blue", high = "red") +
#   labs(title = "Distribuci?n de la especie YFT usando el m?todo FAD",
#        x = "Longitud", y = "Latitud", color = "lustrum") +
#   theme_minimal() +
#   xlim(-15, 10) +   # Adjust x-axis limits
#   ylim(-5, 15)    # Adjust y-axis limits
# 
# # Mapa para la especie SKJ con el m?todo FAD
# skj_fad_data <- subset(dat_ICCAT_12, species == "SKJ" & settype == "FAD")
# skj_fad_map <- ggplot() +
#   geom_polygon(data = world_map, aes(x = long, y = lat, group = group), fill = "lightgrey") +
#   geom_point(data = skj_fad_data, aes(x = lon, y = lat, color = lustrum), size = 2) +
#   scale_color_gradient(low = "blue", high = "red") +
#   labs(title = "Distribuci?n de la especie SKJ usando el m?todo FAD",
#        x = "Longitud", y = "Latitud", color = "lustrum") +
#   theme_minimal() +
#   xlim(-15, 10) +   # Adjust x-axis limits
#   ylim(-5, 15)    # Adjust y-axis limits
# 
# 
# 
# # Juntar los mapas FAD en una sola grilla
# grid.arrange(bet_fad_map, yft_fad_map, skj_fad_map, nrow = 1)
# 



######################################################################
#First and last decade comparison#
#######################################################################


dat_ICCAT <- read.csv("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Datos/My_data/dat_ICCAT.csv")


############################ SKJ
dat_ICCAT <- read.csv("D:/OneDrive/OneDrive - Bassat Partners/Data_Tesis_2024/R/Datos/My_data/dat_ICCAT.csv")

dat_ICCAT_FAD <- subset(dat_ICCAT, SchoolTypeCode == "FAD")

head(dat_ICCAT_FAD)

# Convert YearC and TimePeriodID to factors (for grouping)
dat_ICCAT_FAD$YearC <- as.factor(dat_ICCAT_FAD$YearC)
dat_ICCAT_FAD$TimePeriodID <- as.factor(dat_ICCAT_FAD$TimePeriodID)

# Aggregate by YearC, latdec, londec, and TimePeriodID, summing up the other columns
dat_ICCAT_FAD_AGG <- aggregate(. ~ YearC + latdec + londec + TimePeriodID, data = dat_ICCAT_FAD, FUN = sum)

# Subset data for the specified time periods
dat_ICCAT_FAD_AGG_data_1991_2000 <- subset(dat_ICCAT_FAD_AGG, YearC %in% as.factor(1993:2002))
dat_ICCAT_FAD_AGG_data_2013_2022 <- subset(dat_ICCAT_FAD_AGG, YearC %in% as.factor(2013:2022))

# Convert latdec and londec to spatial points for each time period
dat_ICCAT_FAD_AGG_points_1991_2000 <- SpatialPointsDataFrame(coords = dat_ICCAT_FAD_AGG_data_1991_2000[, c("londec", "latdec")], data = dat_ICCAT_FAD_AGG_data_1991_2000)
dat_ICCAT_FAD_AGG_points_2013_2022 <- SpatialPointsDataFrame(coords = dat_ICCAT_FAD_AGG_data_2013_2022[, c("londec", "latdec")], data = dat_ICCAT_FAD_AGG_data_2013_2022)

# Create raster layers for each time period
dat_ICCAT_FAD_AGG_raster_map_1991_2000 <- raster(extent(-50, 20, -25, 30), resolution = c(1, 1))
dat_ICCAT_FAD_AGG_raster_map_2013_2022 <- raster(extent(-50, 20, -25, 30), resolution = c(1, 1))

# Convert points to raster for each time period
dat_ICCAT_FAD_AGG_raster_data_1991_2000_SKJ <- rasterize(dat_ICCAT_FAD_AGG_points_1991_2000, dat_ICCAT_FAD_AGG_raster_map_1991_2000, field = "SKJ", fun = sum)
dat_ICCAT_FAD_AGG_raster_data_2013_2022_SKJ <- rasterize(dat_ICCAT_FAD_AGG_points_2013_2022, dat_ICCAT_FAD_AGG_raster_map_2013_2022, field = "SKJ", fun = sum)

# Determine the maximum value among both raster maps
dat_ICCAT_FAD_AGG_SKJ_max_value <- max(max(dat_ICCAT_FAD_AGG_raster_data_1991_2000_SKJ[], na.rm = TRUE), 
                                       max(dat_ICCAT_FAD_AGG_raster_data_2013_2022_SKJ[], na.rm = TRUE))


plot(dat_ICCAT_FAD_AGG_raster_data_1991_2000_SKJ, main = "ICCAT_1991-2000:FAD Distribution of SKJ", col = rev(terrain.colors(10)), xlim = c(-30, 21), ylim = c(-29, 39), zlim = c(0, dat_ICCAT_FAD_AGG_SKJ_max_value))
maps::map(add = TRUE, fill = TRUE, col = 'black')
plot(dat_ICCAT_FAD_AGG_raster_data_2013_2022_SKJ, main = "ICCAT_2013-2022:FAD Distribution of SKJ", col = rev(terrain.colors(10)), xlim = c(-30, 21), ylim = c(-29, 39), zlim = c(0, dat_ICCAT_FAD_AGG_SKJ_max_value))
maps::map(add = TRUE, fill = TRUE, col = 'black')


# Subtract raster maps
dat_ICCAT_FAD_AGG_SKJ_subtracted_map <- dat_ICCAT_FAD_AGG_raster_data_2013_2022_SKJ - dat_ICCAT_FAD_AGG_raster_data_1991_2000_SKJ

# Plot the subtracted map
plot(dat_ICCAT_FAD_AGG_SKJ_subtracted_map, main = "Difference in SKJ Distribution (2013-2022 minus 1991-2000)",   col = rev(terrain.colors(10)))




