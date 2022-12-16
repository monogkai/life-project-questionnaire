readIndianaraFile = function(fileName){
  sample_data = read_docx(fileName)
  content = docx_summary(sample_data)$text
  return (content)
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