organizeDataToCreateNvivoInputWithLocator = function(data, mylocator)
{
  nvivoInput = c()
  flag = TRUE
  for(line in 1:nrow(data))
  {
    idx = 1
    for(column in 3:length(data))
    {
      if(flag == TRUE){
        if(is.na(data[line, column + 1] && is.na(data[line, column + 2])))
        {
          break
        }
        nvivoInput = append(nvivoInput, paste(gsub(" ", "", paste("*id_", data[line, 1], seq="")), paste(gsub(" ", "", paste(mylocator,idx)))))
        nvivoInput = append(nvivoInput, "")
        content = data[line, column]
        nvivoInput = append(nvivoInput, substring(content,1, nchar(content)))
        nvivoInput = append(nvivoInput, "")
        flag = FALSE
        idx = idx + 1
      }else
      {
        flag = TRUE
      }
    }
  }
  return (nvivoInput)
}

getKsAndPsWithLabels = function(dataA, dataB, categories)
{
  allData = data.frame()
  ks = c("K")
  ps = c("p")
  for (goal in 1:17)
  {
    dataA1 = dataA[ , c(goal)]
    dataB1 = dataB[ , c(goal)]
    dataA1 = cbind(dataA1, dataB1)
    cohenResult = kappa2(dataA1)
    ks = append(ks, cohenResult$value)
    ps = append(ps, cohenResult$p.value)
  }
  allData = rbind(allData, ks)
  allData = rbind(allData, ps)
  colnames(allData) = c("", categories[1:17, 2])
  return (allData)
}

createSctucturedTableForIndicatorsExtractionWithZeros = function(table, categories)
{
  indicatorsExtractionTable = data.frame()
  specificNames = c()
  for(participant in 1:nrow(table))
  {
    id = table[participant,1]
    dens = getDens(table[participant,]);
    ext_min = getExtMin(table[participant,], dens)
    ext_max = getExtMax(table[participant,], dens)
    ext_mean = getExtMean(table[participant,], dens)
    ext_med = getExtMed(table[participant,], dens)
    n_maint = getNMaint(table[participant,], dens)
    n_short = getNShort(table[participant,], dens)
    n_med = getNMed(table[participant,], dens)
    n_long = getNLong(table[participant,], dens)
    
    specificXMetric = c()
    for(category in 1:(nrow(categories)-1))
    {
      myDens = getXDens(table[participant,], dens, categories[category, 2])
      if(myDens == "")
      {
        myDens = "0"
      }
      specificXMetric = append(specificXMetric, myDens)
      specificXMetric = append(specificXMetric, getXPrior(table[participant,], dens, categories[category, 2]))
      specificXMetric = append(specificXMetric, getXExtMin(table[participant,], dens, categories[category, 2]))
      specificXMetric = append(specificXMetric, getXExtMax(table[participant,], dens, categories[category, 2]))
      specificXMetric = append(specificXMetric, getXExtMean(table[participant,], dens, categories[category, 2]))
      specificXMetric = append(specificXMetric, getXExtMed(table[participant,], dens, categories[category, 2]))
    }
    row = c(id, dens, ext_min, ext_max, ext_mean, ext_med, n_maint, n_short, n_med, n_long, specificXMetric)
    indicatorsExtractionTable = rbind(indicatorsExtractionTable, row)
  }
  for(category in 1:(nrow(categories)-1))
  {
    specificNames = append(specificNames, paste(categories[category, 2], "_dens"))
    specificNames = append(specificNames, paste(categories[category, 2], "_prior"))
    specificNames = append(specificNames, paste(categories[category, 2], "_ext_min"))
    specificNames = append(specificNames, paste(categories[category, 2], "_ext_max"))
    specificNames = append(specificNames, paste(categories[category, 2], "_ext_mean"))
    specificNames = append(specificNames, paste(categories[category, 2], "_ext_med"))
  }
  colnames(indicatorsExtractionTable) = c('id', 'dens', 'ext_min', 'ext_max', 'ext_mean', 'ext_med', 'n_maint', 'n_short', 'n_med', 'n_long', gsub(" ", "", specificNames))
  return (indicatorsExtractionTable)
}
