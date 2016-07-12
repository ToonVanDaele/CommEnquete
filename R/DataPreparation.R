#------------------------------------------------
# Voorbereidingen voor het analyseren van de data
#------------------------------------------------


# init
library(plyr)
library(dplyr)
library(readxl)

# Load data
path <- "C:/Users/toon_vandaele/toon.vandaele@inbo.be/Projecten/CommunicatieEnquete_analyse/data/"

filename <- paste0(path, "Resultaten enquete interne communicatie_2016.xls")

temp <- as.data.frame(readxl::read_excel(filename, col_names = TRUE, skip = 1))
str(temp)
summary(temp)
head(temp)
colnames(temp)

temp <- temp[,c(6:77)]

factorcolumns <- c(1:71)
temp[, factorcolumns] <- lapply(temp[, factorcolumns], factor)
str(temp)

LevVraagType1 <- levels(temp$Q6)


