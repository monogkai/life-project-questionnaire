readInputExcelFile = function(filename)
{
  library("xlsx")
  print(paste("Reading", filename,"file"))
  mydata = read.xlsx(filename, sheetIndex=1)
  return (mydata)
}

createExcel = function(dataframe, outputFilename)
{
  library("writexl")
  write_xlsx(dataframe, outputFilename)
  print(paste("The file", outputFilename, "was created/modified."))
}