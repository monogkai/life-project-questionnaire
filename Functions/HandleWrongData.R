correctWrongCandidate = function(candidate)
{
  new_candidate = candidate
  if(substr(candidate,1,1) == "_")
  {
    new_candidate = substr(candidate, 2, nchar(candidate))
  }
  return (new_candidate)
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
