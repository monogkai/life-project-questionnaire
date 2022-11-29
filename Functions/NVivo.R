readNVivoFile = function(fileName){
  ##Read File
  library(officer)
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

readIndianaraFile = function(fileName){
  ##Read File
  library(officer)
  sample_data = read_docx(fileName)
  content = docx_summary(sample_data)$text
 return (content)
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

cleanIndianaraData = function(content){
  myList = c()
  indianara = data.frame()
  candidate = "NULL"
  for(x in 1:length(content))
  {
    if(str_contains(content[x], "*id_"))
    {
     if(str_contains(content[x], candidate)) 
     {
       myList = append(myList, content[x + 2])
     }else
     {
       if(candidate == "NULL")
       {
         candidate = content[x]
         myList = c(candidate, content[x+2])
       }
       else
       {
         indianara = rbind(indianara, addSpaces(myList))
         candidate = content[x]
         myList = c()
         myList = append(myList, content[x])
         myList = append(myList, content[x+2])
       }
     }
    }
  }
  indianara = rbind(indianara, addSpaces(myList))
  colnames(indianara) = c('id', 'LPS_goal1_content', 'LPS_goal2_content', 'LPS_goal3_content', 'LPS_goal4_content', 'LPS_goal5_content', 'LPS_goal6_content', 'LPS_goal7_content', 'LPS_goal8_content', 'LPS_goal9_content', 'LPS_goal10_content', 'LPS_goal11_content', 'LPS_goal12_content', 'LPS_goal13_content', 'LPS_goal14_content', 'LPS_goal15_content')
return (indianara)
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