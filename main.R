#title: "WUR Geochallange - Analysing REDD+ impact"
#author: 'Astrid Bos'
#date: "Thursday, January 29, 2015"

######################################################
############# Description of the project #############
######################################################

# The Center for International Forestry Research (CIFOR)
# is currently carrying out a research called Global
# Comparative Study on REDD+ (GCS REDD+) (Sunderlin et al.,
# 2014). REDD+ stands for “reducing emissions from
# deforestation and forest degradation and enhancing
# carbon stocks. In module 2 of CIFOR’s study subnational
# initiatives are being analysed before and after the
# REDD+ intervention.

# This geo-challenge project fits into this broader project
# by developing a script that enables a first analysis of
# deforestation rates, its (potential) changes over time
# and the associated carbon emissions caused by deforestation
# using Tier 1 biomass data.

######################################################
#################### Initialization ##################
######################################################

# Libraries & packages

######################################################
################ Data pre-processing #################
######################################################

# Loading data

## RASTER DATA
# Tree cover 2000 (selected area)
# Loss
# Loss year
# AGB Tier 1 Baccini
# AGB Tier 1 Saatchi


## VECTOR DATA
# village location (control & intervention)
# IPCC Above ground biomass (AGB) density values


######################################################
############### Calculate deforestation ##############
######################################################

# Set treecover threshold --> forest

# Make raster with forest 2000 for intervention village

# Make raster with forest 2000 for control village

# Calculate forest loss 2000-2012 for intervention village

# Calculate forest loss 2000-2012 for control village

######################################################
############### Calculate biomass (AGB) ##############
######################################################

######################################################
############# Calculate carbon emissions #############
######################################################

# ******** OPTION 1 = IPCC/FAO ***********************
# Rasterize vector data

# Calculate total emissions for site



# ******** OPTION 2 = Baccini ************************

# ******** OPTION 3 = Saatchi ************************


######################################################
################### Visualization ####################
######################################################

# animation 

# maps deforestation control & intervention

# table with carbon emissions


######################################################
################### Export results ###################
######################################################

# animation 

# maps deforestation control & intervention

# table with carbon emissions

#****************** End of script*********************