#create seperate rasters for each year of deforestation

seperate_loss_year <- function(){
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
}