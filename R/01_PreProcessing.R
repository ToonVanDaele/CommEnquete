#------------------------------------------------------
# Voorbereidingen voor het analyseren van de resultaten
# van de enquete interne communicatie. Voegt de
# resultaten van 2012, 2014, 2016 en 2018 samen.
#
# Input: Aangepaste xlsx bestanden van surveymonkey:
#        - extra rij toevoegen met nummering vragen Q1, Q2, Q...
#        - verwijderen van ongebruikte kolommen
#
# Output: 3 Rdata bestanden:
#          - Resp.Rdata = responses flat data
#          - Q.Rdata = lijst met vragen
#          - AType.Rdata = lijst met types en levels antwoorden
#------------------------------------------------------

# init
library(tidyverse)
library(readxl)

# Load data
path <- "G:/Mijn Drive/Project/CommunicatieEnquete_analyse/data/"

# Lijst met vragen (alle vragen over enquetes heen)
filename <- paste0(path, "input/Enquete_vragen.xlsx")
df.Q <- as.data.frame(readxl::read_excel(filename, col_names = TRUE))

# Lijst met antwoordtypen en levels van antwoordtypen
filename <- paste0(path, "input/Enquete_AntwoordType.xlsx")
df.AType <- as.data.frame(readxl::read_excel(filename, col_names = TRUE))

# Resultaten 2012 (lichtjes aangepaste output uit SurveyMonkey)
filename <- paste0(path, "input/Resultaten_2012.xls")
df.2012 <- as.data.frame(readxl::read_excel(filename, col_names = TRUE, skip = 2))
df.2012$jaar <- 2012
df.2012flat <- df.2012 %>%
  dplyr::select(-c(`Verzamelprogramma-ID`, `Datum`, `IP-adres`)) %>%
  tidyr::gather(key = Q, value = Resp, Q1:Q56)

# Resultaten 2014 (lichtjes aangepaste output uit SurveyMonkey)
filename <- paste0(path, "input/Resultaten_2014.xls")
df.2014 <- as.data.frame(readxl::read_excel(filename, col_names = TRUE, skip = 2))
df.2014$jaar <- 2014
df.2014flat <- df.2014 %>%
  dplyr::select(-c(`Verzamelprogramma-ID`, `Datum`, `IP-adres`)) %>%
  tidyr::gather(key = Q, value = Resp, Q1:Q56)

# Resultaten 2016 (lichtjes aangepaste output uit SurveyMonkey)
filename <- paste0(path, "input/Resultaten_2016.xls")
df.2016 <- as.data.frame(readxl::read_excel(filename, col_names = TRUE, skip = 2))
df.2016$jaar <- 2016
df.2016flat <- df.2016 %>%
  dplyr::select(-c(`Verzamelprogramma-ID`, `Datum`, `IP-adres`)) %>%
  tidyr::gather(key = Q, value = Resp, Q1:Q56)

# Resultaten 2018 (lichtjes aangepaste output uit SurveyMonkey)
filename <- paste0(path, "input/Resultaten_2018.xls")
df.2018 <- as.data.frame(readxl::read_excel(filename, col_names = TRUE, skip = 2))
df.2018$jaar <- 2018
df.2018flat <- df.2018 %>%
  dplyr::select(-c(`Verzamelprogramma-ID`, `Datum`, `IP-adres`)) %>%
  tidyr::gather(key = Q, value = Resp, Q2:Q56)

# Resultaten 2020 (lichtjes aangepaste output uit SurveyMonkey)
filename <- paste0(path, "input/Resultaten_2020.xls")
df.2020 <- as.data.frame(readxl::read_excel(filename, col_names = TRUE, skip = 2))
df.2020$jaar <- 2020
df.2020flat <- df.2020 %>%
  dplyr::select(-c(`Verzamelprogramma-ID`, `Datum`, `IP-adres`)) %>%
  tidyr::gather(key = Q, value = Resp, Q2:Q56)

# Samenvoegen van de resultaten
df.resp <- rbind(df.2012flat, df.2014flat, df.2016flat, df.2018flat, df.2020flat)

# Enkele correcties

# 'jonger dan 30 jaar' in 2012-2016 moet eigenlijk 'jonger dan 31 jaar' zijn.
# In de latere enquêtes is deze categorie correct.
# We passen de categorien uit de oudere enquetes aan.
df.resp <- mutate(df.resp,
                  Resp = ifelse(Resp == "Jonger dan 30 jaar",
                                "Jonger dan 31 jaar",
                                Resp))

# In 2020 zijn de antwoorden voor antwoordtype 'ANA' met een kleine letter
# Wijzigen dat alle antwoorden beginnen met hoofdletter
df.resp <- mutate(df.resp,
                  Resp = sub("(.)", "\\U\\1", Resp, perl=TRUE))


# Vanaf 2018 heeft het antwoordtype 'ANA' een categorie 'Weet het niet' ipv 'weet niet'
# Wijzigen alle 'Weet het niet' in 'Weet niet'
df.resp <- mutate(df.resp,
                  Resp = ifelse(Resp == "Weet het niet",
                                "Weet niet",
                                Resp))

# In 2018 is bij het antwoordtype 'ANA' de categorie 'Noch akkoord, noch niet akkoord'
# soms met een komma en soms niet. Aanpassen dat alle antwoorden voor alle jaren
# steeds met een komma zijn
df.resp <- mutate(df.resp,
                  Resp = ifelse(Resp == "Noch akkoord noch niet akkoord",
                                "Noch akkoord, noch niet akkoord",
                                Resp))

# In 2018 zijn de levels voor het antwoordtype 'belangrijkheid' plots
# anders dan in 2012 en 2014. De antwoorden van 2012 en 2014 worden omgezet in
# de equivalente levels van 2018.
#Totaal niet belangrijk, Niet belangrijk, Neutraal, Belangrijk, Heel belangrijk
#Onbelangrijk, Eerder onbelangrijk, Noch belangrijk, noch onbelangrijk, Eerder belangrijk, Belangrijk
df.resp <- df.resp %>%
  mutate(Resp = ifelse(jaar < 2018 & Resp == "Totaal niet belangrijk",
                       "Onbelangrijk", Resp)) %>%
  mutate(Resp = ifelse(jaar <- 2018 & Resp == "Niet belangrijk",
                      "Eerder onbelangrijk", Resp)) %>%
  mutate(Resp = ifelse(jaar < 2018 & Resp == "Neutraal",
                    "Noch belangrijk, noch onbelangrijk", Resp)) %>%
  mutate(Resp = ifelse(jaar < 2018 & Resp == "Belangrijk",
                        "Eerder belangrijk", Resp)) %>%
  mutate(Resp = ifelse(jaar < 2018 & Resp == "Heel belangrijk",
                                 "Belangrijk", Resp))


# In 2018 is er een andere indeling in beoordelingen voor de vragen
# over 'ik vind mijn weg naar...".
# ipv akkoord -> niet akkoord wordt het makkelijk -> moeilijk
# Om over de jaren heen te kunnen vergelijken passen we dit laatste aan
# naar akkoord -> niet-akkoord
df.resp <- mutate(df.resp,
                  Resp = ifelse(Resp == "Makkelijk",
                                "Akkoord",
                                Resp))

df.resp <- mutate(df.resp,
                  Resp = ifelse(Resp == "Eerder makkelijk",
                                "Eerder akkoord",
                                Resp))

df.resp <- mutate(df.resp,
                  Resp = ifelse(Resp == "Noch moeilijk, noch makkelijk",
                                "Noch akkoord, noch niet akkoord",
                                Resp))

df.resp <- mutate(df.resp,
                  Resp = ifelse(Resp == "Eerder moeilijk",
                                "Eerder niet akkoord",
                                Resp))

df.resp <- mutate(df.resp,
                  Resp = ifelse(Resp == "Moeilijk",
                                "Niet akkoord",
                                Resp))


# In 2020 is voor het antwoordtype 'belangrijkheid' het level
# 'Noch belangrijk, noch onbelangrijk' soms met en soms zonder komma en
# 'belangrijk <-> onbelangrijk' omgekeerd.
# Aanpassing zodat alles met komma en 'belangrijk, noch onbelangrijk'

df.resp <- mutate(df.resp,
                  Resp = ifelse(Resp == "Noch onbelangrijk, noch belangrijk" |
                                  Resp == "Noch onbelangrijk noch belangrijk",
                                "Noch belangrijk, noch onbelangrijk",
                                Resp))

# In 2020 is bij het antwoordtype ANA soms het level 'Noch akkoord, noch niet akkoord'
# de volgorde omgekeerd naar 'Noch niet akkoord noch akkoord' en zonder komma.
# Aanpassing: alles "Noch akkoord, noch niet akkoord'

df.resp <- mutate(df.resp,
                  Resp = ifelse(Resp == "Noch niet akkoord noch akkoord",
                                "Noch akkoord, noch niet akkoord",
                                Resp))



# Wegschrijven van de resultaten
saveRDS(df.resp, file = paste0(path, "/interim/Resp.Rdata"))
saveRDS(df.Q, file = paste0(path, "/interim/Q.Rdata"))
saveRDS(df.AType, file = paste0(path, "/interim/AType.Rdata"))


ana <- df.plot
ana$Resp <- factor(ana$Resp, levels = c("Niet akkoord", "Eerder niet akkoord",
                                        "Noch akkoord, noch niet akkoord",
                                        "Eerder akkoord", "Akkoord"))
