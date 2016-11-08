###

#Ongebruikte code



# Figuur met alle categorieën voor specifiek jaar

```{r}

PlotAll <- function(myQ, myYear) {

  df.plot <- df.Respp %>%
    filter(Q == myQ, jaar == myYear) %>%
    dplyr::left_join(df.Q, by = c("Q" = "VraagID"))

  # Ook levels met 0 antwoorden moeten worden getoond
  myAType <- filter(df.Q, VraagID == myQ)$AntwoordTypeID
  mylevels <- filter(df.AType, TypeID == myAType, !Level == "Weet niet")$Level
  df.plot$Resp <- factor(df.plot$Resp, levels = mylevels)

  n <- sum(df.plot$freq)
  nNA <- filter(df.RespNA, jaar == myYear, Q == myQ)$freq

  myTitle <- paste(df.plot$VraagTitel[1], " \n(n = ", n, ", Weet niet = ", nNA, ")")

  print(myQ)

  myplot <- ggplot(df.plot,  aes(x = Resp, y = Percentage)) +
    geom_bar(stat = 'identity') +
    scale_y_continuous("Percentage (%)") +
    ggtitle(myTitle) +
    theme(axis.title.x = element_blank(),
        axis.ticks.x = element_blank())

  print(myplot)
}

Qlist <- cbind(df.Q[10:12,1], 2016)

m_ply(.data = Qlist, .fun = PlotAll)

```



# Figuur met alle categorieën voor alle jaren

```{r}

PlotTime <- function(myQ) {

  df.plot <- df.Respp %>%
    filter(Q == myQ) %>%
    dplyr::left_join(df.Q, by = c("Q" = "VraagID"))

  # Ook levels met 0 antwoorden moeten worden getoond
  myAType <- filter(df.Q, VraagID == myQ)$AntwoordTypeID
  mylevels <- filter(df.AType, TypeID == myAType, !Level == "Weet niet")$Level
  df.plot$Resp <- factor(df.plot$Resp, levels = mylevels)

  #n <- sum(df.plot$freq)
  #nNA <- filter(df.RespNA, jaar == myYear, Q == myQ)$freq

  myTitle <- paste(df.plot$VraagTitel[1])  #, " \n(n = ", n, ", Weet niet = ", nNA, ")")

  print(myQ)

  myplot <- ggplot(df.plot,  aes(x = Resp, y = Percentage, fill = jaar)) +
    geom_bar(stat = 'identity', position = 'dodge') +
    scale_y_continuous("Percentage (%)") +
    ggtitle(myTitle) +
    theme(axis.title.x = element_blank(),
        axis.ticks.x = element_blank())

  print(myplot)
}

Qlist <- df.Q[8:10,1]

m_ply(.data = Qlist, .fun = PlotTime)

```


# stacked bar alle categorieën voor specifiek jaar

```{r fig.height= 3}

PlotStackedAll <- function(myQ, myYear) {

  df.plot <- df.Respp %>%
    filter(Q == myQ, jaar == myYear) %>%
    dplyr::left_join(df.Q, by = c("Q" = "VraagID"))

  # Ook levels met 0 antwoorden moeten worden getoond
  myAType <- filter(df.Q, VraagID == myQ)$AntwoordTypeID
  mylevels <- filter(df.AType, TypeID == myAType, !Level == "Weet niet")$Level
  df.plot$Resp <- factor(df.plot$Resp, levels = mylevels, ordered = TRUE)
  df.plot <- df.plot[order(df.plot$Resp),]

  n <- sum(df.plot$freq)
  nNA <- filter(df.RespNA, jaar == myYear, Q == myQ)$freq

  myTitle <- paste(df.plot$VraagTitel[1], " \n(n = ", n, ", Weet niet = ", nNA, ")")

  #labels

  df.plot$labely <- cumsum(df.plot$Percentage) - (0.5 * df.plot$Percentage)

  print(myQ)

  myplot <- ggplot(arrange(df.plot, Resp),
                   aes(x = Q, y = Percentage, fill = Resp, order = Resp)) +
    geom_bar(stat = 'identity') +
    geom_text(aes(y = labely, label = round(Percentage, 0), )) +
    scale_y_continuous("Percentage (%)") +
    ggtitle(myTitle) +
    coord_flip() +
    scale_fill_brewer(palette = 'RdYlGn') +
    theme(axis.title.x = element_blank(),
        axis.ticks.x = element_blank())

  print(myplot, )
}

Qlist <- cbind(df.Q[1:8,1], 2016)

m_ply(.data = Qlist, .fun = PlotStackedAll)

```

