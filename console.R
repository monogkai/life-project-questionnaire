##Import files
source("Functions/Indianara.R")
source("Functions/NVivo.R")
source("Functions/Kappas.R")
source("Functions/Excel.R")
source("Functions/Categories.R")
source("Functions/Tables.R")
source("Functions/Indicators_Extraction.R")
source("Functions/HandleWrongData.R")
source("Functions/Locator.R")

##Import libraries
library("xlsx")
library("writexl")
library("officer")
library("sjmisc")
library("irr")
library("psych")
library("lpSolve")
library("tibble")

myLocator = "*loc_"

##Console
args = commandArgs(TRUE)
if(args[1] == "Create" && args[2] == "Input_NVivo")
{
  print("Start Create Input_NVivo")
  
  rawData = readInputExcelFile("Datasets/Raw_Data.xlsx")
  nvivoInputData = organizeDataToCreateNvivoInputWithLocator(rawData, myLocator)
  createNVivoInput(nvivoInputData, "Datasets/NVivo_Input.docx")
  
  print("Finished Create Input_NVivo successfully")
} else if(args[1] == "Create" && args[2] == "Data_Coder1")
{
  coderName = "Coder1"
  print("Start Create Data_Coder1")
  
  directory = paste(paste("Analysis/",coderName, sep=""),"/", sep="")
  categories = readInputExcelFile("Categories/CategoriesEN.xlsx")
  inputMoreCompleted = readInputExcelFile(paste("Datasets/", "Raw_Data.xlsx", sep=""))
  inputMoreCompletedWithExtraColumns = addColumnsToDataFrame(inputMoreCompleted)
  nvivoContent = readAllNVivoFilesWithLocator(directory, categories)
  tableWithCategories = insertCategoriesToInputTableWithLocator(inputMoreCompletedWithExtraColumns, nvivoContent, categories ,myLocator)
  
  outputDirectoryFile = paste(directory,"Data_", coderName ,".xlsx", sep="")
  createExcel(tableWithCategories, outputDirectoryFile)
  
  print("Finished Create Data_Coder1 successfully")
} else if(args[1] == "Create" && args[2] == "Data_Coder2")
{
  coderName = "Coder2"
  print("Start Create Data_Coder2")
  
  directory = paste(paste("Analysis/",coderName, sep=""),"/", sep="")
  categories = readInputExcelFile("Categories/CategoriesEN.xlsx")
  inputMoreCompleted = readInputExcelFile(paste("Datasets/", "Raw_Data.xlsx", sep=""))
  inputMoreCompletedWithExtraColumns = addColumnsToDataFrame(inputMoreCompleted)
  nvivoContent = readAllNVivoFilesWithLocator(directory, categories)
  tableWithCategories = insertCategoriesToInputTableWithLocator(inputMoreCompletedWithExtraColumns, nvivoContent, categories, myLocator)
  
  outputDirectoryFile = paste(directory,"Data_", coderName ,".xlsx", sep="")
  createExcel(tableWithCategories, outputDirectoryFile)
  
  print("Finished Create Data_Coder2 successfully")
}else if(args[1] == "Create" && args[2] == "Unified_Data")
{
  coderName1 = "Coder1"
  coderName2 = "Coder2"
  print("Start Create Unified_Data")
  
  categories = readInputExcelFile("Categories/CategoriesEN.xlsx")
  datacoderName1 = readInputExcelFile(paste("Analysis/", coderName1, "/Data_", coderName1 ,".xlsx", sep=""))
  datacoderName2 = readInputExcelFile(paste("Analysis/", coderName2, "/Data_", coderName2 ,".xlsx", sep=""))
  
  ##Generate Unified Data
  unifiedData = mergeTablesWithAsterisks(datacoderName1, datacoderName2)
  createExcel(unifiedData, "Analysis/Unified_Data.xlsx")
  
  print("Finished Create Unified_Data successfully")
}else if(args[1] == "Test" && args[2] == "Kappa")
{
  coderName1 = "Coder1"
  coderName2 = "Coder2"
  print("Start Test Kappa")
  
  categories = readInputExcelFile("Categories/CategoriesEN.xlsx")
  datacoderName1 = readInputExcelFile(paste("Analysis/", coderName1, "/Data_", coderName1 ,".xlsx", sep=""))
  datacoderName2 = readInputExcelFile(paste("Analysis/", coderName2, "/Data_", coderName2 ,".xlsx", sep=""))
  
  ##Generate Ks and Ps
  candidate1TableSctucturedForKappas = generateKsTable(datacoderName1, categories)
  candidate2TableSctucturedForKappas = generateKsTable(datacoderName2, categories)
  kappas = getKsAndPsWithLabels(candidate1TableSctucturedForKappas, candidate2TableSctucturedForKappas, categories)
  createExcel(kappas, "Analysis/Kappa.xlsx")
  
  print("Finished Test Kappa successfully")
}else if(args[1] == "Create" && args[2] == "Indicators")
{
  print("Start Create Indicators")
  categories = readInputExcelFile("Categories/CategoriesEN.xlsx")
  finalData = readInputExcelFile("Analysis/Final_Data.xlsx")
  indicators = createSctucturedTableForIndicatorsExtractionWithZeros(finalData, categories)
  createExcel(indicators, "Analysis/Indicators.xlsx")
  print("Finished Create Indicators successfully")
  
}else if(args[1] == "Test" && args[2] == "Data_Coder1")
{
  print("Start Test Data_Coder1")
  
  directory = "Analysis/Coder1/Data_Coder1.xlsx"
  error_directory = "Analysis/Coder1/Data_Coder1_error.xlsx"
  categories = readInputExcelFile("Categories/CategoriesEN.xlsx")
  dataCoder1 = readInputExcelFile(directory)
  data_Coder1_error = diffFile(dataCoder1, categories, error_directory)
  
  print("Finished Test Data_Coder1 successfully")
}else if(args[1] == "Test" && args[2] == "Data_Coder2")
{
  print("Start Test Data_Coder2")
  
  directory = "Analysis/Coder2/Data_Coder2.xlsx"
  error_directory = "Analysis/Coder2/Data_Coder2_error.xlsx"
  categories = readInputExcelFile("Categories/CategoriesEN.xlsx")
  dataCoder2 = readInputExcelFile(directory)
  data_Coder2_error = diffFile(dataCoder2, categories, error_directory)
  
  print("Finished Test Data_Coder2 successfully")
}else if(args[1] == "Test" && args[2] == "Final_Data")
{
  print("Start Test Final_Data")
  
  directory = "Datasets/Final_Data.xlsx"
  error_directory = "Datasets/Final_Data_error.xlsx"
  categories = readInputExcelFile("Categories/CategoriesEN.xlsx")
  finalData = readInputExcelFile(directory)
  final_Data_error = diffFile(finalData, categories, error_directory)

  print("Finished Test Final_Data successfully")
}else
{
  print("The command is not known")
}
