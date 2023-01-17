mergeTablesWithCategories = function(completedTable, completedTable2)
{
  mergedtable = completedTable
  numberCandidates = nrow(completedTable)
  for(candidate in 1:numberCandidates)
  {
    numberColumns = ((length(completedTable)-2)/3)
    for(goal in 1:numberColumns)
    {
      currentColumn = (goal*3)+1
      if(!is.na(completedTable2[candidate,currentColumn]))
      {
        if(is.na(completedTable[candidate,currentColumn]) && !is.na(completedTable2[candidate,currentColumn]))
        {
          mergedtable[candidate,currentColumn] = completedTable2[candidate,currentColumn]
        }
        else if(completedTable[candidate,currentColumn] != completedTable2[candidate, currentColumn])
        {
          mergedtable[candidate,currentColumn] = paste(mergedtable[candidate,currentColumn], paste(', ', completedTable2[candidate, currentColumn], sep=""), sep="")
        }
      }
    }
  }
  return (mergedtable)
}

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
