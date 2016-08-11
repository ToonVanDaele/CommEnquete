#------------------------------------------------------
# Voorbereidingen voor het analyseren van de resultaten
# van de enquete interne communicatie. Voegt de
# resultaten van 2012, 2014 en 2016 samen.
#
# Input: Aangepaste xlsx bestanden van surveymonkey:
#        - extra rij met nummering vragen Q1, Q2, Q...
#        - verwijderen van ongebruikte kolommen
#
# Output: 3 Rdata bestanden:
#          - Resp.Rdata = responses flat data
#          - Q.Rdata = lijst met vragen
#          - AType.Rdata = lijst met types en levels antwoorden
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
df.2012flat <- df.2012 %>%
  dplyr::select(-c(`Verzamelprogramma-ID`, `Datum`, `IP-adres`)) %>%
  tidyr::gather(key = Q, value = Resp, Q1:Q56)

# Resultaten 2014 (lichtjes aangepaste output uit SurveyMonkey)
filename <- paste0(path, "Resultaten enquête interne communicatie_2014_mod.xls")
df.2014 <- as.data.frame(readxl::read_excel(filename, col_names = TRUE, skip = 2))
df.2014$jaar <- 2014
df.2014flat <- df.2014 %>%
  dplyr::select(-c(`Verzamelprogramma-ID`, `Datum`, `IP-adres`)) %>%
  tidyr::gather(key = Q, value = Resp, Q1:Q56)

# Resultaten 2016 (lichtjes aangepaste output uit SurveyMonkey)
filename <- paste0(path, "Resultaten enquête interne communicatie_2016_mod.xls")
df.2016 <- as.data.frame(readxl::read_excel(filename, col_names = TRUE, skip = 2))
df.2016$jaar <- 2016
df.2016flat <- df.2016 %>%
  dplyr::select(-c(`Verzamelprogramma-ID`, `Datum`, `IP-adres`)) %>%
  tidyr::gather(key = Q, value = Resp, Q1:Q56)

# Samenvoegen van de resultaten
df.Resp <- rbind(df.2012flat, df.2014flat, df.2016flat)

# Wegschrijven van de resultaten
saveRDS(df.Resp, file = paste0(path, "Resp.Rdata"))
saveRDS(df.Q, file = paste0(path, "Q.Rdata"))
saveRDS(df.AType, file = paste0(path, "AType.Rdata"))

