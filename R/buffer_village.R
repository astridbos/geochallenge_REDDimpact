#create buffer around villages
vil_int_buffer <- function(x){
        vil_int_buffer <- buffer(village_intervention, width=x)
        vil_int_buffer <- spTransform(vil_int_buffer, CRS(proj4string(TreeCover2000)))
}

vil_con_buffer <- function(x){
        vil_con_buffer <- buffer(village_control, width=x)
        vil_con_buffer <- spTransform(vil_con_buffer, CRS(proj4string(TreeCover2000)))
}