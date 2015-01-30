##function to export bar plot with emissions for control and intervention villages, per carbon stock source

barplot_emissions <- function(){
        
        png(filename="output/result_REDD_emissions.png", width = 600, height=400)
        par(mfrow=c(1,2))
        colors = c("gold", "dodgerblue3", "firebrick")
        barplot(result_em_table[,1], main = 'Carbon Emissions around \nthe control village', xlab = 'Carbon stock source', ylim = c(0,50000), col=colors)
        abline(h=mean(result_em_table[,1]),col='forestgreen')
        
        barplot(result_em_table[,2], main = 'Carbon Emissions around \nthe REDD+ intervention village', xlab = 'Carbon stock source', ylim = c(0,50000), col=colors)
        abline(h=mean(result_em_table[,2]),col='forestgreen')
        
        dev.off()
}