removeRepitedLines = function(content)
{
  newContent = content
  for(x in 1:length(newContent))
  {
    a = length(newContent)
    y = x + 1
    if(!is.na(newContent[x]) && !is.na(newContent[x+1]) && a != y && x != y)
    {
      if(newContent[x] == "" && newContent[x+1] == "")
      {
        newContent = newContent[-x]
        x = x + 1;
      }
    }
  }
  return (newContent)
}

readNVivoFile = function(fileName, directory){
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
      return(myList)
    }
    myList = append(myList,substr(fileName, nchar(directory)+1, nchar(fileName)-5))
    myList = append(myList,substr(content[(6*x) - 1], 5, 100))
    myList = append(myList,substr(content[(6*x) + 1], 1, nchar(content[(6*x) + 1])))
  }
  return (myList)
}

addSpaces = function(list)
{
  len = length(list)
  add = list
  for(x in 1:16-len)
  {
    add = append(add, "")
  }
  return (add)
}

readAllNVivoFiles = function(directory, categories){
  content = c()
  for(row in 1:nrow(categories))
  {
    if(categories[row,1] == "Outros e Inválidos")
    {
      next
    }
    fileDirectory = paste(paste(directory, categories[row,1],  sep = "" ), ".docx", sep = "")
    content = append(content, readNVivoFile(fileDirectory, directory))
  }
  return (content)
}
