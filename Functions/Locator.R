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
        nvivoInput = append(nvivoInput, paste(gsub(" ", "", paste("*id_", data[line, 1], seq="")), mylocator,idx))
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