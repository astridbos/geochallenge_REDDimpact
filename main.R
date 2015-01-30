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
library(rgdal)
library(rgeos)
library(raster)
library(maptools)


# Check and (if necessary) set working directory
getwd()
#setwd("./geochallenge_REDDimpact")

# load functions
source("R/barplot_emissions.R")
source("R/plot_deforestation.R")
source("R/plot_deforestation_series.R")
source("R/buffer_village.R")
source("R/seperate_loss_year.R")

######################################################
################ Data pre-processing #################
######################################################

prj.geo <-"+proj=longlat +datum=WGS84" #projection

#prj.geo <- "+proj=utm +zone=19 +south +datum=WGS84" #projection

# Loading data & removing NA's

## RASTER DATA
# Tree cover 2000 (here: subset)
TreeCover2000 <- raster('./data/TreeCover2000.tif')
TreeCover2000 <- projectRaster(TreeCover2000, crs=prj.geo)
TreeCover2000[TreeCover2000 > 100] <- NA

# Loss
Loss <- raster('./data/Loss.tif')
Loss <- projectRaster(Loss, crs=prj.geo)
Loss[Loss == 255] <- NA
Loss[Loss < 1] <- NA

# Loss year
LossYear <- raster('./data/LossYear.tif')
LossYear <- projectRaster(LossYear, crs=prj.geo, method = 'ngb')

LossYear[LossYear > 12] <- NA
LossYear[LossYear == 0] <- NA

# AGB Tier 1 Baccini Carbon stock data
Carbon_Baccini <- raster('./data/Carbon_Baccini.tif')
Carbon_Baccini <- projectRaster(Carbon_Baccini, crs=prj.geo)

# AGB Tier 1 Saatchi Carbon stock data
Carbon_Saatchi <- raster('./data/Carbon_Saatchi.tif')
Carbon_Saatchi <- projectRaster(Carbon_Saatchi, crs=prj.geo)
#summary(CarbonSaatchi)
#plot(CarbonSaatchi)

## VECTOR DATA
# village location (control & intervention)
villages <- readOGR('data/villages.shp', 'villages')
#villages <- spTransform(villages, CRS(proj4string(TreeCover2000)))

#distinguishing between control and intervention village
point.df=data.frame(villages)
village_intervention <- villages[villages$REDD_class == 'intervention',]

village_control <- villages[villages$REDD_class == 'control',]

# buffer around villages
buffer = 5000
vil_int_buffer <- buffer(village_intervention, width=buffer) #create buffer of 5000m around intervention village
vil_int_buffer <- spTransform(vil_int_buffer, CRS(proj4string(TreeCover2000)))

vil_con_buffer <- buffer(village_control, width=buffer)
vil_con_buffer <- spTransform(vil_con_buffer, CRS(proj4string(TreeCover2000))) 

# IPCC Above ground biomass (AGB) density values
IPCC_AGB <- readShapePoly(fn = 'data/IPCC_AGB_Forest', proj4string = CRS(prj.geo))
Carbon_IPCC_AGB <- rasterize(IPCC_AGB, TreeCover2000, field='AGB_Tier1',
                             progress='text')  # convert AGB from poly to raster 30m

######################################################
############### Calculate deforestation ##############
######################################################

# Set treecover threshold --> forest
forest_threshold = 10
Forest <- TreeCover2000
Forest[Forest <= forest_threshold] <- NA

# Make raster with forest 2000 for intervention village
Forest_int <- mask(Forest, vil_int_buffer)

#Forest_int_area <- rasterToPolygons(Forest_int)
#rr[] <- gArea(Forest_int_area)

cell_size_int<-area(Forest_int, na.rm=T, weights=FALSE)
cell_size_int<-cell_size_int[!is.na(cell_size_int)]
Forest_int_area<-(length(cell_size_int)*median(cell_size_int))*100 #size in ha

print(paste("Within a", buffer/1000, "km buffer around the REDD+ intervention village,",
            as.integer(Forest_int_area), "ha is classified as forest in the year 2000."))

# Make raster with forest 2000 for control village
Forest_con <- mask(Forest, vil_con_buffer)

cell_size_con<-area(Forest_con, na.rm=T, weights=FALSE)
cell_size_con<-cell_size_con[!is.na(cell_size_con)]
Forest_con_area<-(length(cell_size_con)*median(cell_size_con))*100 #size in ha

print(paste("Within a", buffer/1000, "km buffer around the control village,",
            as.integer(Forest_con_area), "ha is classified as forest in the year 2000."))

# Calculate forest loss 2000-2012 for intervention village
Forest_int_mask <- Forest_int
Forest_int_mask[!is.na(Forest_int_mask)] <- 1 # mask in which all forest cells get value 1

Deforestation_int <- Forest_int_mask + Loss

cs_def_int<-area(Deforestation_int, na.rm=T, weights=FALSE)

cs_def_int<-cs_def_int[!is.na(cs_def_int)]
Deforestation_int_area<- sum(cs_def_int)*100 #size in ha

def_int_percent <- Deforestation_int_area/Forest_int_area*100

print(paste("Between 2000 and 2012, the deforestation around the REDD+ intervention village was",
            as.integer(Deforestation_int_area), "ha. That is", format(round(def_int_percent, 2), nsmall = 2),
            "% of the forest area of 2000."))

# Calculate forest loss 2000-2012 for control village
Forest_con_mask <- Forest_con
Forest_con_mask[!is.na(Forest_con_mask)] <- 1 # mask in which all forest cells get value 1
#plot(Forest_con_mask)

Deforestation_con <- Forest_con_mask * Loss
#plot(Deforestation_int)
#plot(Deforestation_con, add=T)

cs_def_con<-area(Deforestation_con, na.rm=T, weights=FALSE)
cs_def_con<-cs_def_con[!is.na(cs_def_con)]
Deforestation_con_area<- sum(cs_def_con)*100 #size in ha

def_con_percent <- Deforestation_con_area/Forest_con_area*100

print(paste("Between 2000 and 2012, the deforestation around the control village was",
            as.integer(Deforestation_con_area), "ha. That is", format(round(def_con_percent, 2), nsmall = 2),
            "% of the forest area of 2000."))

######################################################
############# Calculate carbon emissions #############
######################################################

# ******** OPTION 1 = IPCC/FAO ***********************
# Calculate total emissions for intervention village

Carbon_IPCC_int <- (Deforestation_int * Carbon_IPCC_AGB)
Carbon_IPCC_int <- (Carbon_IPCC_int*0.5) * 0.09 # # compute C emissions (tC) from AGB density (t/ha)
Carbon_IPCC_int_sum <- as.integer(cellStats(Carbon_IPCC_int, 'sum')) #total emissions for village area (tC)

# Calculate total emissions for control village
Carbon_IPCC_con <- (Deforestation_con * Carbon_IPCC_AGB)
Carbon_IPCC_con <- (Carbon_IPCC_con*0.5) * 0.09 # # compute C emissions (tC) from AGB density (t/ha)
Carbon_IPCC_con_sum <- as.integer(cellStats(Carbon_IPCC_con, 'sum')) #total emissions for village area (tC)

# ******** OPTION 2 = Baccini ************************
Carbon_Baccini <- resample(Carbon_Baccini, TreeCover2000, method = 'bilinear')

Carbon_Baccini_int <- (Deforestation_int * Carbon_Baccini)
Carbon_Baccini_int <- (Carbon_Baccini_int*0.5) * 0.09 # # compute C emissions (tC) from AGB density (t/ha)
Carbon_Baccini_int_sum <- as.integer(cellStats(Carbon_Baccini_int, 'sum'))

Carbon_Baccini_con <- (Deforestation_con * Carbon_Baccini)
Carbon_Baccini_con <- (Carbon_Baccini_con*0.5) * 0.09 # # compute C emissions (tC) from AGB density (t/ha)
Carbon_Baccini_con_sum <- as.integer(cellStats(Carbon_Baccini_con, 'sum'))


# ******** OPTION 3 = Saatchi ************************
Carbon_Saatchi <- resample(Carbon_Saatchi, TreeCover2000, method = 'bilinear')

Carbon_Saatchi_int <- (Deforestation_int * Carbon_Saatchi)
Carbon_Saatchi_int <- (Carbon_Saatchi_int*0.5) * 0.09 # # compute C emissions (tC) from AGB density (t/ha)
Carbon_Saatchi_int_sum <- as.integer(cellStats(Carbon_Saatchi_int, 'sum'))

Carbon_Saatchi_con <- (Deforestation_con * Carbon_Saatchi)
Carbon_Saatchi_con <- (Carbon_Saatchi_con*0.5) * 0.09 # # compute C emissions (tC) from AGB density (t/ha)
Carbon_Saatchi_con_sum <- as.integer(cellStats(Carbon_Saatchi_con, 'sum'))

######################################################
######### Visualization & Export results #############
######################################################

# maps deforestation control & intervention
plot_deforestation()

# animation
# make seperate layers of deforested cells per year
# first for the intervention village...
Def_year_int <-mask(LossYear, Forest_int)
Def_year_int_1 <- Def_year_int
Def_year_int_1[Def_year_int_1!=1] <- NA

Def_year_int_2 <- Def_year_int
Def_year_int_2[Def_year_int_2!=2] <- NA

Def_year_int_3 <- Def_year_int
Def_year_int_3[Def_year_int_3!=3] <- NA

Def_year_int_4 <- Def_year_int
Def_year_int_4[Def_year_int_4!=4] <- NA

Def_year_int_5 <- Def_year_int
Def_year_int_5[Def_year_int_5!=5] <- NA

Def_year_int_6 <- Def_year_int
Def_year_int_6[Def_year_int_6!=6] <- NA

Def_year_int_7 <- Def_year_int
Def_year_int_7[Def_year_int_7!=7] <- NA

Def_year_int_8 <- Def_year_int
Def_year_int_8[Def_year_int_8!=8] <- NA

Def_year_int_9 <- Def_year_int
Def_year_int_9[Def_year_int_9!=9] <- NA

Def_year_int_10 <- Def_year_int
Def_year_int_10[Def_year_int_10!=10] <- NA

Def_year_int_11 <- Def_year_int
Def_year_int_11[Def_year_int_11!=11] <- NA

Def_year_int_12 <- Def_year_int
Def_year_int_12[Def_year_int_12!=12] <- NA

# ... and for the control village
Def_year_con <-mask(LossYear, Forest_con)
Def_year_con_1 <- Def_year_con
Def_year_con_1[Def_year_con_1!=1] <- NA

Def_year_con_2 <- Def_year_con
Def_year_con_2[Def_year_con_2!=2] <- NA

Def_year_con_3 <- Def_year_con
Def_year_con_3[Def_year_con_3!=3] <- NA

Def_year_con_4 <- Def_year_con
Def_year_con_4[Def_year_con_4!=4] <- NA

Def_year_con_5 <- Def_year_con
Def_year_con_5[Def_year_con_5!=5] <- NA

Def_year_con_6 <- Def_year_con
Def_year_con_6[Def_year_con_6!=6] <- NA

Def_year_con_7 <- Def_year_con
Def_year_con_7[Def_year_con_7!=7] <- NA

Def_year_con_8 <- Def_year_con
Def_year_con_8[Def_year_con_8!=8] <- NA

Def_year_con_9 <- Def_year_con
Def_year_con_9[Def_year_con_9!=9] <- NA

Def_year_con_10 <- Def_year_con
Def_year_con_10[Def_year_con_10!=10] <- NA

Def_year_con_11 <- Def_year_con
Def_year_con_11[Def_year_con_11!=11] <- NA

Def_year_con_12 <- Def_year_con
Def_year_con_12[Def_year_con_12!=12] <- NA

s_con <- stack(Def_year_con_1,Def_year_con_2,Def_year_con_3,Def_year_con_4,
               Def_year_con_5,Def_year_con_6,Def_year_con_7,Def_year_con_8,
               Def_year_con_9,Def_year_con_10,Def_year_con_11,Def_year_con_12)
s_int <- stack(Def_year_int_1,Def_year_int_2,Def_year_int_3,Def_year_int_4,
               Def_year_int_5,Def_year_int_6,Def_year_int_7,Def_year_int_8,
               Def_year_int_9,Def_year_int_10,Def_year_int_11,Def_year_int_12)

plot_deforestation_series() # plot deforestation in sequence

names(s_con) <- paste("year", 2001:2012) # extra for visualisation in R
names(s_int) <- paste("year", 2001:2012)
plot(TreeCover2000, legend=F)
for (i in 1:12) {
        plot(s_int, i, col = 'firebrick', add=T, legend = F)
        plot(s_con, i, col='firebrick', add=T, legend = F)
}


# table with carbon emissions
result_em_table <- matrix(, nrow = 3, ncol = 2)
dimnames(result_em_table) = list(
        c("IPCC", "Baccini", "Saatchi"),        # row names 
        c("control", "intervention"))           # column names 

result_em_table[1,1]<- Carbon_IPCC_con_sum      #IPCC control
result_em_table[2,1]<- Carbon_Baccini_con_sum   #Baccini control
result_em_table[3,1]<- Carbon_Saatchi_con_sum   #Saatchi control
result_em_table[1,2]<- Carbon_IPCC_int_sum      #IPCC intervention
result_em_table[2,2]<- Carbon_Baccini_int_sum   #Baccini intervention
result_em_table[3,2]<- Carbon_Saatchi_int_sum   #Saatchi intervention

write.csv(result_em_table, "output/result_REDD_emissions.csv")

# export barplots
barplot_emissions()

#****************** End of script*********************
