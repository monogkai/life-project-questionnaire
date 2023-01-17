getAbreviation = function(categories, category)
{
  for(row in 1:nrow(categories))
  {
    if(categories[row,1] == category)
    {
      return (categories[row,2])
    }
  }
}

addAsterisk = function(table, position1, position2)
{
  if(!str_contains(table[position1, position2], "*"))
  {
    table[position1, position2] = paste( "*", table[position1, position2], sep = "")
    if(!str_contains(colnames(table)[position2], "*"))
    {
      colnames(table)[position2] = paste ("*", colnames(table)[position2], sep = "")
    }
    if(!str_contains(table[position1, 1], "*"))
    {
      table[position1, 1] = paste ("*", table[position1, 1], sep = "")
    }
  }
  return (table)
}

editCellPositionWithAsterisk = function(table, position, category)
{
  if(is.na(table[position[1], position[2]]))
  {
    table[position[1], position[2]] = category
  }else
  {
    table[position[1], position[2]] = paste(paste(table[position[1], position[2]], ", ", sep = ""), category, sep = "")
    table = addAsterisk(table, position[1], position[2]);
  }
  return (table)
}

editCellPosition = function(table, position, category)
{
  if(is.na(table[position[1], position[2]]))
  {
    table[position[1], position[2]] = category
  }else
  {
    table[position[1], position[2]] = paste(paste(table[position[1], position[2]], ", ", sep = ""), category, sep = "")
  }
  return (table)
}

insertCategoriesToInputTable = function(inputTable, wordContent, categories)
{
  currentCategory = wordContent[1]
  for(x in 1:((length(wordContent)-1)/2))
  {
    currentCandidate = unlist(wordContent[(x*2)])
    currentContent = unlist(wordContent[(x*2) + 1])
    position = getCorrectCell(inputTable, currentCandidate, currentContent)
    editedTable = editCellPosition(inputTable, position, getAbreviation(categories,currentCategory))
  }
  return(editedTable)
}

insertCategoriesToInputTableWithCategory = function(inputTable, wordContent, categories)
{
  editedTable = inputTable
  for(x in 1:(length(wordContent)/3))
  {
    currentCategory = wordContent[(x*3) - 2]
    currentCandidate = unlist(wordContent[(x*3) - 1])
    currentContent = unlist(wordContent[(x*3)])
    position = getCorrectCell(inputTable, currentCandidate, currentContent)
    editedTable = editCellPosition(editedTable, position, getAbreviation(categories,currentCategory))
  }
  return(editedTable)
}

insertCategoriesToInputTableWithCategoryWithAsterisk = function(inputTable, wordContent, categories)
{
  editedTable = inputTable
  for(x in 1:(length(wordContent)/3))
  {
    currentCategory = wordContent[(x*3) - 2]
    currentCandidate = unlist(wordContent[(x*3) - 1])
    currentContent = unlist(wordContent[(x*3)])
    position = getCorrectCell(inputTable, currentCandidate, currentContent)
    editedTable = editCellPositionWithAsterisk(editedTable, position, getAbreviation(categories,currentCategory))
  }
  return(editedTable)
}