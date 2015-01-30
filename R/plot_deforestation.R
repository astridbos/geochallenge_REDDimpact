##function to export raster plot with Treecover in 2000 and deforestation in 2000-2012

plot_deforestation <- function(){
        png(filename="output/deforestation.png", width = 600, height=400)
        opar <- par(mfrow=c(1,1), bg='darkgray')

        plot(TreeCover2000, main = "Treecover(2000) and deforestation ('00-'12) \nfor control(left) and REDD+ intervention(right) village")
        plot(vil_con_buffer, add=T, border='darkslateblue', lwd=3)
        plot(vil_int_buffer, add=T, border='hotpink2', lwd=3)
        plot(Deforestation_con, add=T, col='firebrick', legend = FALSE)
        plot(Deforestation_int, add=T, col='firebrick', legend = FALSE)
        par(opar)
        dev.off()
}