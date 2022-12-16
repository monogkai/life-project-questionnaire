getDens = function(participantData)
{
  for(goal in 1:15)
  {
    if(is.na(participantData[goal*3]))
    {
      return (goal-1)
    }
  }
  return (15)
}

getExtMin = function(participantData, goalsNumber)
{
  currentAge = participantData[1,2]
  tempAge = 200
  for(goal in 1:goalsNumber)
  {
    if(is.na(participantData[goal*3]) | is.na(participantData[(goal*3) + 2]))
    {
      return (0)
    }else
    {
      if(tempAge > participantData[1, (goal*3) + 2])
      {
        tempAge = participantData[1, (goal*3) + 2]
      }
    }
  }
  return (tempAge-currentAge)
}

getExtMax = function(participantData, goalsNumber)
{
  currentAge = participantData[1,2]
  tempAge = 0
  for(goal in 1:goalsNumber)
  {
    if(is.na(participantData[goal*3]) | is.na(participantData[(goal*3) + 2]))
    {
      next
    }else
    {
      if(tempAge < participantData[1,(goal*3) + 2])
      {
        tempAge = participantData[1,(goal*3) + 2]
      }
    }
  }
  if(tempAge == 0)
  {
    return (0)
  }
  return (tempAge-currentAge)
}

getExtMean = function(participantData,goalsNumber)
{
  currentAge = participantData[1,2]
  tempAge = 0
  for(goal in 1:goalsNumber)
  {
    if(is.na(participantData[(goal*3) + 2]) | participantData[(goal*3) + 2] == currentAge)
    {
      
    }else
    {
      tempAge = tempAge + (participantData[1,(goal*3) + 2] - currentAge)
    }
  }
  return (format(round(tempAge/goalsNumber, 2), nsmall = 2))
}

getExtMed = function(participantData, goalsNumber)
{
  currentAge = participantData[1,2]
  tempAge = c()
  for(goal in 1:goalsNumber)
  {
    if(is.na(participantData[(goal*3) + 2]) | participantData[(goal*3) + 2] == currentAge)
    {
      tempAge = append(tempAge, 0)
    }else
    {
      tempAge = append(tempAge, (participantData[1,(goal*3) + 2] - currentAge))
    }
  }
  return(median(tempAge))
}

getNMaint = function(participantData, goalsNumber)
{
  n_maint = 0
  for(goal in 1:goalsNumber)
  {
    if(is.na(participantData[(goal*3) + 2]))
    {
      n_maint = n_maint + 1
    }
  }
  return (n_maint)
}

getNShort = function(participantData, goalsNumber)
{
  n_short = 0
  currentAge = participantData[1,2]
  for(goal in 1:goalsNumber)
  {
    if(is.na(participantData[(goal*3) + 2]))
    {
      n_short = n_short + 1
    }else
    {
      if((participantData[1,(goal*3) + 2] - currentAge) <= 2)
      {
        n_short = n_short + 1
      }
    }
  }
  return (n_short)
}

getNMed = function(participantData, goalsNumber)
{
  n_med = 0
  currentAge = participantData[1,2]
  for(goal in 1:goalsNumber)
  {
    if(is.na(participantData[(goal*3) + 2]))
    {
      next
    }else
    {
      if(((participantData[1,(goal*3) + 2] - currentAge) > 3) & ((participantData[1,(goal*3) + 2] - currentAge) <= 9))
      {
        n_med = n_med + 1
      }
    }
  }
  return (n_med)
}

getNLong = function(participantData, goalsNumber)
{
  n_long = 0
  currentAge = participantData[1,2]
  for(goal in 1:goalsNumber)
  {
    if(is.na(participantData[(goal*3) + 2]))
    {
      next
    }else
    {
      if((participantData[1,(goal*3) + 2] - currentAge) >= 10)
      {
        n_long = n_long + 1
      }
    }
  }
  return (n_long)
}

getXDens = function(participantData, goalsNumber, category)
{
  x_dens = 0
  for(goal in 1:goalsNumber)
  {
    if(!is.na(participantData[(goal*3) + 1]))
    {
      if(str_contains(participantData[1,(goal*3) + 1], category))
      {
        x_dens = x_dens + 1
      }
    }
  }
  if(x_dens == 0)
  {
    return ("")
  }
  return (x_dens)
}

getXExtMean = function(participantData, goalsNumber, category)
{
  flag = 0
  x_ext_mean = 0
  currentAge = participantData[1,2]
  for(goal in 1:goalsNumber)
  {
    if(!is.na(participantData[(goal*3) + 1]))
    {
      if(str_contains(participantData[1,(goal*3) + 1], category))
      {
        flag = 1
        if(!is.na(participantData[(goal*3) + 2])){
          x_ext_mean = x_ext_mean + (participantData[1,(goal*3) + 2] - currentAge)
        }
      }
    }
  }
  if(flag == 0)
  {
    return ("")
  }
  if(x_ext_mean == 0)
  {
    return (0)
  }
  return (format(round(x_ext_mean/getXDens(participantData, goalsNumber, category), 2), nsmall = 2))
}

getXExtMed = function(participantData, goalsNumber, category)
{
  x_ext_med = c()
  currentAge = participantData[1,2]
  for(goal in 1:goalsNumber)
  {
    if(!is.na(participantData[(goal*3) + 1]))
    {
      if(str_contains(participantData[1,(goal*3) + 1], category))
      {
        if(is.na(participantData[1,(goal*3) + 2]))
        {
          x_ext_med = append(x_ext_med, 0)
        }else
        {
          x_ext_med = append(x_ext_med, (participantData[1,(goal*3) + 2] - currentAge))
        }
      }
    }
  }
  if(length(x_ext_med) == 0)
  {
    return ("")
  }
  return (median(x_ext_med))
}

getXExtMin = function(participantData, goalsNumber, category)
{
  x_ext_min = 100
  flag = 0
  currentAge = participantData[1,2]
  for(goal in 1:goalsNumber)
  {
    if(!is.na(participantData[(goal*3) + 1]))
    {
      if(str_contains(participantData[1,(goal*3) + 1], category))
      {
        value = participantData[1,(goal*3) + 2] - currentAge
        if(is.na(participantData[1,(goal*3) + 2]))
        {
          return (0)
        }
        if(value < x_ext_min)
        {
          flag = 1
          x_ext_min = participantData[1,(goal*3) + 2] - currentAge
        }
      }
    }
  }
  if(flag == 0)
  {
    return ("")
  }
  return (x_ext_min)
}

getXExtMax = function(participantData, goalsNumber, category)
{
  x_ext_max = 0
  flag = 0
  currentAge = participantData[1,2]
  for(goal in 1:goalsNumber)
  {
    if(!is.na(participantData[(goal*3) + 1]))
    {
      if(str_contains(participantData[1,(goal*3) + 1], category))
      {
        flag = 1
        value = participantData[1,(goal*3) + 2] - currentAge
        if(is.na(participantData[1,(goal*3) + 2]))
        {
          next
        }
        if(value > x_ext_max)
        {
          x_ext_max = participantData[1,(goal*3) + 2] - currentAge
        }
      }
    }
  }
  if(flag == 0)
  {
    return ("")
  }
  if(x_ext_max == 0)
  {
    return (0)
  }
  return (x_ext_max)
}

getXPrior = function(participantData, goalsNumber, category)
{
  currentAge = participantData[1,2]
  for(goal in 1:goalsNumber)
  {
    if(!is.na(participantData[(goal*3) + 1]))
    {
      if(str_contains(participantData[1,(goal*3) + 1], category))
      {
        return (goal)
      }
    }
  }
  return ("")
}

createSctucturedTableForIndicatorsExtraction = function(table, categories)
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
      specificXMetric = append(specificXMetric, getXDens(table[participant,], dens, categories[category, 2]))
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