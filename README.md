# RSwissPos
R package to get data on Swiss direct democratic ballots. 

The package also provides posterior estimates of ballot discrimination based on Bayesian Item Response Theory models (static or dynamic) to compute the position of the five main Swiss parties over-time. The exemple for the "getPosResDD" and for the "getPostEstDD" functions show how to measure the positions of Swiss municipalities on the party competition space as presented in Walder (2025).

If you use this measurement please cite: Walder, M.(2025) Latent ideological positions of swiss parties and subsets of the population. _Swiss Political Science Review_.

To install the package, run: 

```{r}
devtools::install_github('maxwaldo/RSwissPos')
```

The package has different functions to import data related to Swiss Direct democracy. 

### Get results of direct democratic ballots for different geographical levels

To import data on municipal result of Direct Democratic ballot, you can run:

```{r}
data_mun <- getPopResDD()
```

You can also download the latest version of the data by inclusing a Download=T option in the function 

```{r}
data_mun <- getPopResDD(Download = T)
```

Finally, you can precise the type of place you are interested in. The default option is _All_ but you can specify the geographical level by changing the PlaceType parameter to _Country_, _Canton_, _District_, _Municipality_. For instance, if you only want the national results, you can run: 

```{r}
data_mun <- getPopResDD(PlaceType="Country")
```

### Get information on Direct Democratic ballot from Swissvotes

To import the _Swissvotes_ data containing many information at the ballot level, you can run: 

```{r}
Swissvotes <- getSwissvotes()
```

This function downloads the lastest version of the Swissvotes dataset. This dataset contains many information at the ballot level. For a complete list of the variable you can consul the codebook available at: https://swissvotes.ch/storage/84d5514faa708639fc5586ab54b0c7aae6c56ae6b9485e653988dbf72bbb8784

You can filter the variables of interest using the parameter Column.names. The default value is _All_, but it can be changed to a vector containing the names of variables on interest in the dataset. For instance, if you want to download information related to the date of the ballot, the short title of the ballot in french, and the position of the federal council on the ballot, you can run: 

```{r}
Swissvotes <- getSwissvotes(Column.names = c("datum", "titel_kurz_f", "bv.pos"))
```

### Get the Comparative Agenda's project expert's coding of the ballot proposals.

To import the _Comparative Agenda's project_ coding of the ballot proposals you can run: 

```{r}
CAP <- getCAP()
```

This dataset contains information about the major topic and the subtopic of ballot proposals. For more information on the coding you can visit: https://www.comparativeagendas.net.

You can filter the variables of interest using the parameter Column.names. The default value is _All_ but it can be changed to a vector containing the names of variables on interest in the dataset. For instance, if you are interested in a dataset containg information on the ballot ID and the majortopic of the ballot, you can run: 


```{r}
CAP <- getCAP(Column.names = c("id", "majortopic"))
```

### Get posterior estimates value of the static and dynamic Bayesian IRT models used to measure latent position of the sub-population in Walder (2025). 

The package also provides posterior estimates from the Bayesian Item-Response Theory models used to compute static and dynamic ideological position of parties and sub-national population in the paper Walder (2025) Latent ideological positions of swiss parties and subsets of the population. _Swiss Political Science Review_. These parameters can be used to replicated the measurement developped in this paper and be applied to other research. To have a full hand on approach on how to replicate the models to measure the ideological of sub-national population, see the vignette XXX.

Four types of parameter are available in the package. First, estimates that indicate static and dynamic party positions are available. To get the static party position you can run: 

```{r}
data(party_pos_static_estimates)
```

To have the over-time dynamic estimation of party position, you can run: 

```{r}
data(party_pos_dynamic_estimates)
```

The second type of parameter relates to the ballot discrimination score. To get the estimates of ballot discrimination for the static model, you can run:

```{r}
data(static_estimates)
```


To get the estimates of ballot discrimination for the dynamic model, you can run:

```{r}
data(dynamic_estimates)
```
