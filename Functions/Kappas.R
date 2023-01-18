generateKsTable = function(table, categories)
{
  data1 = data.frame()
  for(category in 1:17)
  {
    emptyList = list()
    for(candidate in 1:nrow(table))
    {
      for(goal in 1:getDens(table[candidate,]))
      {
        if(is.na(table[candidate, (goal*3) + 1]))
        {
          emptyList = append(emptyList, "no")
        }else
        {
          if(str_contains(table[candidate, (goal*3) + 1], getAbreviation(categories, categories[category, 1])))
          {
            emptyList = append(emptyList, "yes")
          }else
          {
            emptyList = append(emptyList, "no")
          }
        }
      }
    }
    data1 = rbind(data1, emptyList)
  }
  return (t(data1))
}

getKsAndPs = function(dataA, dataB, categories)
{
  allData = data.frame()
  ks = c()
  ps = c()
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
  colnames(allData) = c(categories[1:17, 2])
  rownames(allData ) = c("Ks", "Ps")
  return (allData)
}
