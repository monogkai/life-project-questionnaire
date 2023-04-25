organizeDataToCreateNvivoInputWithLocator = function(data, mylocator)
{
  nvivoInput = c()
  flag = TRUE
  for(line in 1:nrow(data))
  {
    idx = 1
    for(column in 3:length(data))
    {
      if(flag == TRUE){
        if(is.na(data[line, column + 1] && is.na(data[line, column + 2])))
        {
          break
        }
        nvivoInput = append(nvivoInput, paste(gsub(" ", "", paste("*id_", data[line, 1], seq="")), mylocator,idx))
        nvivoInput = append(nvivoInput, "")
        content = data[line, column]
        nvivoInput = append(nvivoInput, substring(content,1, nchar(content)))
        nvivoInput = append(nvivoInput, "")
        nvivoInput = append(nvivoInput, "")
        flag = FALSE
        idx = idx + 1
      }else
      {
        flag = TRUE
      }
    }
  }
  return (nvivoInput)
}