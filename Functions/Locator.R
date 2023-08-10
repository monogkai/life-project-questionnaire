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
        if(is.na(data[line, column + 1] && is.na(data[line, column + 2])) && is.na(data[line, column]))
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
    ps = append(ps, sprintf(cohenResult$p.value, fmt = '%#.3f'))
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

getCorrectCellWithLocator = function(table, candidate, pos)
{
  for(row in 1:nrow(table))
  {
    if(table[row, 1] == candidate)
    {
      position = c(row, 1 + (3*strtoi(pos)))
      return (position)
    }
  }
  print(paste("ERROR: This phrase ", content, " don't exist in the table for the candidate ", candidate, sep=""))
}

readNVivoFileWithLocator = function(fileName, directory){
  print(paste("Reading ", fileName," file"))
  sample_data = read_docx(fileName)
  cont = docx_summary(sample_data)$text
  
  content = removeRepitedLines(cont)
  ##Select only the relevant content
  numReferences = (length(content) - 4)/5
  myList = c()
  
  for (x in 1:numReferences){
    if(is.na(content[(6*x) - 1]))
    {
      if(length(myList) != (numReferences*3) && !is.na(content[(6*x) - 5]) && !is.na(content[(6*x) - 3]) && (substr(content[(6*x) - 3], 1, nchar(content[(6*x) - 3])) != ""))
      {
        myList = append(myList, substr(fileName, nchar(directory)+1, nchar(fileName)-5))
        myList = append(myList, substr( content[(6*x) - 5], 5, 100))
        myList = append(myList, substr(content[(6*x) - 3], 1, nchar(content[(6*x) - 3])))
      }
      return(myList)
    }
    
      myList = append(myList,substr(fileName, nchar(directory)+1, nchar(fileName)-5))
      if(!str_contains(content[(6*x - 1)], "*id"))
      {
        if(str_contains(content[(6*x) - 1], "Referência"))
        {
          myList = append(myList,substr(content[(6*x) - 5], 5, 100))
          myList = append(myList,substr(content[(6*x) - 3], 1, nchar(content[(6*x) - 1])))
        }else
        {
          myList = append(myList,substr(content[(6*x) - 3], 5, 100))
          myList = append(myList,substr(content[(6*x) - 1], 1, nchar(content[(6*x) - 1])))
        }
      }else
      {
        myList = append(myList,substr(content[(6*x) - 1], 5, 100))
        myList = append(myList,substr(content[(6*x) + 1], 1, nchar(content[(6*x) + 1])))
      } 
  }
  return (myList)
}

readAllNVivoFilesWithLocator = function(directory, categories){
  content = c()
  for(row in 1:nrow(categories))
  {
    if(categories[row,1] == "Outros e Inválidos")
    {
      next
    }
    fileDirectory = paste(paste(directory, categories[row,1],  sep = "" ), ".docx", sep = "")
    content = append(content, readNVivoFileWithLocator(fileDirectory, directory))
  }
  return (content)
}

insertCategoriesToInputTableWithLocator = function(inputTable, wordContent, categories)
{
  editedTable = inputTable
  #print(paste(wordContent))
  for(x in 1:(length(wordContent)/3))
  {
    currentCategory = wordContent[(x*3) - 2]
    #print(paste(currentCategory))
    currentCandidate = substring(unlist(wordContent[(x*3) - 1]), 0, 8)
    #print(paste(currentCandidate))
    currentPosition = gsub(" ", "", substring(unlist(wordContent[(x*3) - 1]), 15))
    #print(paste(currentPosition))
    currentContent = unlist(wordContent[(x*3)])
    position = getCorrectCellWithLocator(inputTable, currentCandidate, currentPosition)
    #print(paste(position))
    editedTable = editCellPosition(editedTable, position, getAbreviation(categories,currentCategory))
  }
  return(editedTable)
}

numbers_only = function(x) !grepl("\\D", x)

diffFile = function(dataCoderTable, categories, directory)
{
  error = FALSE;
  modifiedDataCoderTable = dataCoderTable;
  for(line in 1:nrow(dataCoderTable))
  {
    for(column in 1:length(dataCoderTable))
    {
      ##Category
      if(str_contains(colnames(dataCoderTable)[column], "category") && !is.na(dataCoderTable[line, column]))
      {
        if(!grepl(",", dataCoderTable[line, column]))
        {
          matchCategory = FALSE;
          for(category in 1:nrow(categories))
          {
            if(dataCoderTable[line, column] == categories[category, 2])
            {
              matchCategory = TRUE;
              break;
            }
          }
          if(!matchCategory)
          {
            error = TRUE
            modifiedDataCoderTable = addAsterisk(modifiedDataCoderTable, line, column)
          }
        }else
        {
          occurances = unlist(strsplit(dataCoderTable[line, column], split=","))
          for(occurance in 1:length(occurances))
          {
            matchCategory = FALSE;
            for(category in 1:nrow(categories))
            {
              if(gsub(" ", "", occurances[occurance]) == categories[category, 2])
              {
                matchCategory = TRUE;
                break;
              }
            }
            if(!matchCategory)
            {
              error = TRUE
              modifiedDataCoderTable = addAsterisk(modifiedDataCoderTable, line, column)
            }
          }
        }
      }
      ##Age
      if(str_contains(colnames(dataCoderTable)[column], "_age") && !is.na(dataCoderTable[line, column]) && !is.na(dataCoderTable[line, 2]) && numbers_only(dataCoderTable[line, column]))
      {
        currentAge = dataCoderTable[line, 2]
        if(strtoi(dataCoderTable[line, column]) < strtoi(currentAge))
        {
          error = TRUE
          modifiedDataCoderTable = addAsterisk(modifiedDataCoderTable, line, column)
        }
      }
    }
  }
  if(!error)
  {
    print("No error was found!")
  }else
  {
    createExcel(modifiedDataCoderTable, directory)
  }
  return(modifiedDataCoderTable)
}
