mergeTablesWithAsterisks = function(datacoderF, datacoderS)
{
  table = datacoderF
  for(row in 1:nrow(datacoderF))
  {
    for(column in 1:length(datacoderF))
    {
      c = ((column)*3)+1
      if(c > 47)
      {
        break
      }
      if(is.na(datacoderF[row, c]) & !is.na(datacoderS[row, c]))
      {
        table[row, c] =  datacoderS[row, c]
      }
      if(is.na(datacoderF[row, c]) & !is.na(datacoderS[row, c]))
      {
        if(str_contains(datacoderS[row, c], ","))
        {
          table = addAsterisk(table, row, c)
        }
      }
      if(is.na(datacoderS[row, c]) & !is.na(datacoderF[row, c]))
      {
        if(str_contains(datacoderF[row, c], ","))
        {
          table = addAsterisk(table, row, c)
        }
      }
      if(!is.na(datacoderF[row, c]) & !is.na(datacoderS[row, c]) & datacoderF[row, c] != datacoderS[row, c])
      {
        table[row, c] = removeReplication(datacoderF[row, c], datacoderS[row, c])
        table = addAsterisk(table, row, c)
      }
      if(str_contains(table[row, c], ",") & !str_contains(table[row, c], "*"))
      {
        table = addAsterisk(table, row, c)
      }
    }
  }
  return (table)
}

removeReplication = function(content1, content2)
{
  list_categories_content1 = as.list(strsplit(gsub(" ", "", content1), ",")[[1]])
  list_categories_content2 = as.list(strsplit(gsub(" ", "", content2), ",")[[1]])
  unique_list_categories = unique(c(list_categories_content1, list_categories_content2))
  
  unique_list_categories_with_commas = paste(unique_list_categories, collapse=", ")
  return (unique_list_categories_with_commas)
}

getCorrectCell = function(table, candidate, content)
{
  candidate = correctWrongCandidate(candidate)
  for(row in 1:nrow(table))
  {
    if(table[row, 1] == candidate)
    {
      for(column in 1:length(table))
      {
        if(!is.na(table[row, column]))
        {
          if(str_contains(table[row, column], content) | str_contains(paste(table[row, column], " ", seq=""), content))
          {
            position = c(row, column+1)
            return (position)
          }
        }
      }
    }
  }
  print(paste("ERROR: This phrase ", content, " don't exist in the table for the candidate ", candidate, sep=""))
}
