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
switch(  
  args[1], 
  "step1" = {
    print("Step 1 - Create NVivo Input data")
    rawData = readInputExcelFile("Datasets/Raw_Data.xlsx")
    nvivoInputData = organizeDataToCreateNvivoInputWithLocator(rawData, myLocator)
    createNVivoInput(nvivoInputData, "Datasets/NVivo_Input.docx")
    print("Step 1 - Finished successfully")
  },
  "step2" = {
    coderName = args[2]
    print("Step 2 - Create Analyzed data")
    directory = paste(paste("Analysis/",coderName, sep=""),"/", sep="")
    categories = readInputExcelFile("Categories/CategoriesEN.xlsx")
    inputMoreCompleted = readInputExcelFile(paste("Datasets/", "Raw_Data.xlsx", sep=""))
    inputMoreCompletedWithExtraColumns = addColumnsToDataFrame(inputMoreCompleted)
    nvivoContent = readAllNVivoFilesWithLocator(directory, categories)
    tableWithCategories = insertCategoriesToInputTableWithLocator(inputMoreCompletedWithExtraColumns, nvivoContent, categories)
    
    outputDirectoryFile = paste(directory,"Data_", coderName ,".xlsx", sep="")
    createExcel(tableWithCategories, outputDirectoryFile)
    print("Step 2 - Finished successfully")
  },
  "step3" = {
    coderName1 = args[2]
    coderName2 = args[3]
    print("Step 3 - Create Unified data and ks/ps")
    categories = readInputExcelFile("Categories/CategoriesEN.xlsx")
    datacoderName1 = readInputExcelFile(paste("Analysis/", coderName1, "/Data_", coderName1 ,".xlsx", sep=""))
    datacoderName2 = readInputExcelFile(paste("Analysis/", coderName2, "/Data_", coderName2 ,".xlsx", sep=""))
    
    ##Generate Unified Data
    unifiedData = mergeTablesWithAsterisks(datacoderName1, datacoderName2)
    createExcel(unifiedData, "Analysis/Unified_Data.xlsx")
    print("Step 3 - Finished successfully")
  },
  "step4" = {
    coderName1 = args[2]
    coderName2 = args[3]
    categories = readInputExcelFile("Categories/CategoriesEN.xlsx")
    datacoderName1 = readInputExcelFile(paste("Analysis/", coderName1, "/Data_", coderName1 ,".xlsx", sep=""))
    datacoderName2 = readInputExcelFile(paste("Analysis/", coderName2, "/Data_", coderName2 ,".xlsx", sep=""))
    
    ##Generate Ks and Ps
    candidate1TableSctucturedForKappas = generateKsTable(datacoderName1, categories)
    candidate2TableSctucturedForKappas = generateKsTable(datacoderName2, categories)
    kappas = getKsAndPsWithLabels(candidate1TableSctucturedForKappas, candidate2TableSctucturedForKappas, categories)
    createExcel(kappas, "Analysis/Kappa.xlsx")
    print("Step 4 - Finished successfully")
  },
  "step5" = {
    print(paste("You added an extra argument: ", myLocator))
    categories = readInputExcelFile("Categories/CategoriesEN.xlsx")
    finalData = readInputExcelFile("Analysis/Final_Data.xlsx")
    indicators = createSctucturedTableForIndicatorsExtractionWithZeros(finalData, categories)
    createExcel(indicators, "Analysis/Indicators.xlsx")
  },
  "step6" = {
    categories = readInputExcelFile("Categories/CategoriesEN.xlsx")
    
    directory = paste(paste("Step2/","Coder1", sep=""),"/", sep="")
    inputMoreCompleted = readInputExcelFile(paste("Datasets/", "Raw_Data.xlsx", sep=""))
    inputMoreCompletedWithExtraColumns = addColumnsToDataFrame(inputMoreCompleted)
    
    testDataCoder1 = readInputExcelFile("step6/Data_Coder1.xlsx")
    testDataCoder2 = readInputExcelFile("step6/Data_Coder2.xlsx")
    testFinalData = readInputExcelFile("step6/Final_Data.xlsx")
    
    dataCoder1 = readInputExcelFile("step2/Coder1/Data_Coder1.xlsx")
    dataCoder2 = readInputExcelFile("step2/Coder2/Data_Coder2.xlsx")
    finalData = readInputExcelFile("Datasets/Final_Data.xlsx")
    
    Data_Coder1_error = diffFile(inputMoreCompletedWithExtraColumns, testDataCoder1, dataCoder1, "Step2/Coder1/Data_Coder1_error.xlsx")
    Data_Coder2_error = diffFile(inputMoreCompletedWithExtraColumns, testDataCoder2, dataCoder2, "Step2/Coder2/Data_Coder2_error.xlsx")
    Final_Data_error = diffFile(inputMoreCompletedWithExtraColumns, testFinalData, finalData, "Datasets/Final_Data_error.xlsx")
  },
  "indianara" = {
    print("Indianara was selected!")
    indianaraData = readIndianaraFile("Step1/NVivo_Input.docx")
    cleanData = cleanIndianaraData(indianaraData)
    createExcel(cleanData, "Step1/PV_Indianara.xlsx")
    print("Indianara data created!")
  },  
)