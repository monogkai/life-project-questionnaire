readInputExcelFile = function(filename)
{
  library("xlsx")
  mydata = read.xlsx(filename, sheetIndex=1)
  return (mydata)
}

createExcel = function(dataframe, outputFilename)
{
  library("writexl")
  write_xlsx(dataframe, outputFilename)
}