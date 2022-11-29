removeNATable = function(table)
{
  newTable = table
  for(row in 1:nrow(table))
  {
    for(column in 1:length((table)))
    {
      if(is.na(table[row, column]))
      {
        newTable[row, column] = ""
      }
    }
  }
  return(newTable)
}

addColumnToDataFrame = function(data, previous_label)
{
  library(tibble)
  data = data %>% add_column(label = NA, .after = previous_label)
  return (data)
}

addColumnsToDataFrame = function(data)
{
  for(x in 1:15)
  {
    ##Add Column
    data = addColumnToDataFrame(data, paste('LPS_goal', paste(x,'_content', sep=""), sep=""))
    
    ##Change Column name
    colnames(data)[(3*x) + 1] = paste('LPS_goal', paste(x,'_category', sep=""), sep="")
  }
  return (data)
}

getCorrectCell = function(table, candidate, content)
{
  library("sjmisc")
  if(content == "Família. ")
  {
    content = "Familia. "
  }
  if(content == "Tirar a cidadania europeia. ")
  {
    content = "Tirar a cidadania européia. "
  }
  if(content == "Trabalho assistencial casa idosos. ")
  {
    content = "Trabalho assistencial cada idosos. "
  }
  for(row in 1:nrow(table))
  {
    if(table[row, 1] == candidate)
    {
      for(column in 1:length(table))
      {
        if(!is.na(table[row, column]))
        {
          if(str_contains(table[row, column], content))
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