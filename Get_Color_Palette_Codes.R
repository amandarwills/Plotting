################################################################################
#Title: Get brewer color palette codes
#Author: Amanda Williams 
#Date Last Modified: 202311014
################################################################################

# Clear workspace and restart R
rm(list=ls())  
.rs.restartR()

# Load libraries
library(devtools) 
library(RColorBrewer)
library(ggplot2)


# Display all brewer palettes
display.brewer.all()

# Show only colorblind-friendly brewer palettes
display.brewer.all(colorblindFriendly = TRUE)


### Visualize a specific brewer palette
# n: Number of different colors in the palette, minimum 3, maximum depending on palette

# 1. Visualize a single RColorBrewer palette by specifying its name
display.brewer.pal(10, "BuGn")

# 2. Return the hexadecimal color code of the palette
color.pal <- brewer.pal(10, "Blues")

