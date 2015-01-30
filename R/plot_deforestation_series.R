# create series of plots for deforestation in both the intervention (right) and control (left) village
plot_deforestation_series <- function(){
        names(s_con) <- paste("year", 2001:2012)
        names(s_int) <- paste("year", 2001:2012)
        plot(TreeCover2000, legend=F)
        for (i in 1:12) {
                jpeg("output/defor%02d.jpg")
                                plot(s_int, i, col = 'firebrick', add=T, legend = F)
                plot(s_con, i, col='firebrick', add=T, legend = F)
                dev.off()
        }
}
