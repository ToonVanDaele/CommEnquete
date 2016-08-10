#------------------------------------------------------
# Voorbereidingen voor het analyseren van de resultaten
# van de enquete interne communicatie
#
# Combineren van de resultaten van 2012, 2014 en 2016
#------------------------------------------------------


# init
library(plyr)
library(dplyr)
library(readxl)

# Load data
path <- "C:/Users/toon_vandaele/toon.vandaele@inbo.be/Projecten/CommunicatieEnquete_analyse/data/"

# Lijst met vragen (alle vragen over enquetes heen)
filename <- paste0(path, "Enquete_vragen.xlsx")
df.Q <- as.data.frame(readxl::read_excel(filename, col_names = TRUE))

# Lijst met antwoordtypen en levels van antwoordtypen
filename <- paste0(path, "Enquete_AntwoordType.xlsx")
df.AType <- as.data.frame(readxl::read_excel(filename, col_names = TRUE))

# Resultaten 2012 (lichtjes aangepaste output uit SurveyMonkey)
filename <- paste0(path, "Resultaten enquête interne communicatie_2012_mod.xls")
df.2012 <- as.data.frame(readxl::read_excel(filename, col_names = TRUE, skip = 2))
df.2012$jaar <- 2012

# Resultaten 2014 (lichtjes aangepaste output uit SurveyMonkey)
filename <- paste0(path, "Resultaten enquête interne communicatie_2014_mod.xls")
df.2014 <- as.data.frame(readxl::read_excel(filename, col_names = TRUE, skip = 2))
df.2014$jaar <- 2014

# Resultaten 2016 (lichtjes aangepaste output uit SurveyMonkey)
filename <- paste0(path, "Resultaten enquête interne communicatie_2016_mod.xls")
df.2016 <- as.data.frame(readxl::read_excel(filename, col_names = TRUE, skip = 2))
df.2016$jaar <- 2016


ummary(temp)
head(temp)
colnames(temp)

temp <- temp[,c(6:77)]

factorcolumns <- c(1:71)
temp[, factorcolumns] <- lapply(temp[, factorcolumns], factor)
str(temp)

LevVraagType1 <- levels(temp$Q6)


