readNVivoFile = function(fileName, directory){
  print(paste("Reading ", fileName," file"))
  sample_data = read_docx(fileName)
  content = docx_summary(sample_data)$text

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

readWrongNVivoFile = function(fileName)
{
  print(paste("Reading ", fileName," file"))
  sample_data = read_docx(fileName)
  content = docx_summary(sample_data)$text
  myList = c()
  for (x in 1:length(content)){
    if(!is.na(content[x])){}
      if(str_contains(content[x], "id_") & content[x+1] == "" & str_contains(content[x+2], "."))
      {
        myList = append(myList, substr(fileName, 14, nchar(fileName)-5))
        myList = append(myList, substr(content[x], 4, 100))
        myList = append(myList, content[x + 2])
    }
  }
  return (myList)
}

readWrongAllNVivoFiles = function(directory, categories){
  content = c()
  for(row in 1:nrow(categories))
  {
    if(categories[row,1] == "Outros e Inválidos")
    {
      next
    }
    fileDirectory = paste(paste(directory, categories[row,1],  sep = "" ), ".docx", sep = "")
    content = append(content, readWrongNVivoFile(fileDirectory))
  }
  return (content)
}

readAllNVivoFiles = function(directory, categories){
  print(paste("AQUI"))
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