readNVivoFile = function(fileName){
  ##Read File
  library(officer)
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
    myList = append(myList, substr(fileName, 18, nchar(fileName)-5))
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
  library(officer)
  library("sjmisc")
  sample_data = read_docx(fileName)
  content = docx_summary(sample_data)$text
  myList = c()
  for (x in 1:length(content)){
    if(str_contains(content[x], "id") & content[x+1] != "")
    {
      myList = append(myList, substr(fileName, 12, nchar(fileName)-5))
      myList = append(myList, substr(content[x], 4, 100))
      myList = append(myList, content[x + 1])
    }
  }
  return (myList)
}

readAllNVivoFiles = function(categories){
  content = c()
  for(row in 1:nrow(categories))
  {
    fileDirectory = paste(paste("InputFiles/NVivo/", categories[row,1],  sep = "" ), ".docx", sep = "")
    content = append(content, readNVivoFile(fileDirectory))
  }
  return (content)
}