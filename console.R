##Import files
source("Functions/Indianara.R")
source("Functions/NVivo.R")
source("Functions/Kappas.R")
source("Functions/Excel.R")
source("Functions/Categories.R")
source("Functions/Tables.R")
source("Functions/Indicators_Extraction.R")
source("Functions/HandleWrongData.R")

##Import libraries
library("xlsx")
library("writexl")
library("officer")
library("sjmisc")
library("irr")
library("psych")
library("lpSolve")
library("tibble")

##Console
args = commandArgs(TRUE)
switch(  
  args[1], 
  "step1" = {
    print("Step 1 - Create NVivo Input data")
    rawData = readInputExcelFile("Step1/Raw_Data.xlsx")
    nvivoInputData = organizeDataToCreateNvivoInput(rawData)
    createNVivoInput(nvivoInputData, "Step1/NVivo_Input.docx")
    print("Step 1 - Finished successfully")
  },
  "step2" = {
    coderName = args[2]
    print("Step 2 - Create Analyzed data")
    directory = paste(paste("Step2/",coderName, sep=""),"/", sep="")
    categories = readInputExcelFile("Categories/CategoriesPT.xlsx")
    inputMoreCompleted = readInputExcelFile(paste(directory, "InputMoreCompleted.xlsx", sep=""))
    tableWithCategoriesColumns = addColumnsToDataFrame(inputMoreCompleted)
    inputMoreCompletedWithExtraColumns = addColumnsToDataFrame(inputMoreCompleted)
    
    nvivoContent = readAllNVivoFiles(directory, categories)
    tableWithCategories = insertCategoriesToInputTableWithCategory(tableWithCategoriesColumns, nvivoContent, categories)
    
    outputDirectoryFile = paste(directory,"Analyzed_Data_", coderName ,".xlsx", sep="")
    createExcel(tableWithCategories, outputDirectoryFile)
    print("Step 2 - Finished successfully")
  },
  "step3" = {
    coderName1 = args[2]
    coderName2 = args[3]
    print("Step 3 - Create Unified data and ks/ps")
    categories = readInputExcelFile("Categories/CategoriesPT.xlsx")
    
    datacoderName1 = readInputExcelFile(paste("Step2/", coderName1, "/Analyzed_Data_", coderName1 ,".xlsx", sep=""))
    datacoderName2 = readInputExcelFile(paste("Step2/", coderName2, "/Analyzed_Data_", coderName2 ,".xlsx", sep=""))
    
    ##Generate Ks and Ps
    candidate1TableSctucturedForKappas = generateKsTable(datacoderName1, categories)
    candidate2TableSctucturedForKappas = generateKsTable(datacoderName2, categories)
    kappas = getKsAndPs(candidate1TableSctucturedForKappas, candidate2TableSctucturedForKappas, categories)
    createExcel(kappas, "Step3/Kappa.xlsx")
    
    ##Generate Unified Data
    unifiedData = mergeTablesWithAsterisks(datacoderName1, datacoderName2)
    createExcel(unifiedData, "Step3/Unified_Data.xlsx")
    print("Step 3 - Finished successfully")
  },
  "step4" = {
    print("Step 4 - Create Indicators")
    categories = readInputExcelFile("Categories/CategoriesPT.xlsx")
    finalData = readInputExcelFile("Step4/Final_Data.xlsx")
    
    indicators = createSctucturedTableForIndicatorsExtraction(finalData, categories)
    
    createExcel(indicators, "Step4/Indicators.xlsx")
    print("Step 4 - Finished successfully")
  },
  "indianara" = {
    print("Indianara was selected!")
    indianaraData = readIndianaraFile("Step1/NVivo_Input.docx")
    cleanData = cleanIndianaraData(indianaraData)
    createExcel(cleanData, "Step1/PV_Indianara.xlsx")
    print("Indianara data created!")
  },  
)
