readIndianaraFile = function(fileName){
  sample_data = read_docx(fileName)
  content = docx_summary(sample_data)$text
  return (content)
}

organizeDataToCreateNvivoInput = function(data)
{
  nvivoInput = c()
  for(line in 1:nrow(data))
  {
    for(column in 1:length(data))
    {
      if(is.na(data[line, column + 1]))
      {
        break
      }
      nvivoInput = append(nvivoInput, gsub(" ", "", paste("*id_", data[line, 1], seq="")))
      nvivoInput = append(nvivoInput, "")
      content = data[line, column + 1]
      nvivoInput = append(nvivoInput, substring(content,1, nchar(content)))
      nvivoInput = append(nvivoInput, "")
    }
  }
  return (nvivoInput)
}

createNVivoInput = function(indianaraData, directory)
{
  doc = read_docx()
  for(line in 1:length(indianaraData))
  {
    doc = doc %>% body_add_par(indianaraData[line])
  }
  print(doc, directory)
  print(paste("The file", directory, "was created/modified."))
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
