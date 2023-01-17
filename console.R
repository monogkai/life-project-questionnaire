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
    inputMoreCompleted = readInputExcelFile("Step1/Row_Data.xlsx")
    indianaraData = organizeDataToCreateIndianara(inputMoreCompleted)
    createNVivoInput(indianaraData, "Step1/NVivo_Input.docx")
  },
  "step2" = {
    coderName = args[2]
    print(paste("Step 2"))
    directory = paste(paste("Step2/",coderName, sep=""),"/", sep="")
    categories = readInputExcelFile("Categories/CategoriesPT.xlsx")
    inputMoreCompleted = readInputExcelFile(paste(directory, "InputMoreCompleted.xlsx", sep=""))
    tableWithCategoriesColumns = addColumnsToDataFrame(inputMoreCompleted)
    inputMoreCompletedWithExtraColumns = addColumnsToDataFrame(inputMoreCompleted)
    nvivoContent = readAllNVivoFiles(directory, categories)
    tableWithContentC = insertCategoriesToInputTableWithCategory(tableWithCategoriesColumns, nvivoContent, categories)
    
    outputDirectoryFile = paste(directory,"Analyzed_Data_", coderName ,".xlsx", sep="")
    createExcel(tableWithContentC, outputDirectoryFile)
  },
  "step3" = {
    print(paste("Step 3 - Agreement was selected!"))
    coderName1 = args[2]
    coderName2 = args[3]
    categories = readInputExcelFile("Categories/CategoriesPT.xlsx")
    
    datacoderName1 = readInputExcelFile(paste("Step2/", coderName1, "/Analyzed_Data_", coderName1 ,".xlsx", sep=""))
    datacoderName2 = readInputExcelFile(paste("Step2/", coderName2, "/Analyzed_Data_", coderName2 ,".xlsx", sep=""))
    
    ##Generate Ks and Ps
    candidate1TableSctucturedForKappas = generateKsTable(datacoderName1, categories)
    candidate2TableSctucturedForKappas = generateKsTable(datacoderName2, categories)
    kappas = getKsAndPs(candidate1TableSctucturedForKappas, candidate2TableSctucturedForKappas, categories)
    merge = mergeTablesWithAsterisks(datacoderName1, datacoderName2)
    createExcel(merge, "Step3/Unified_Data.xlsx")
    print(paste(" Unified_Data created!"))
    createExcel(kappas, "Step3/Kappa.xlsx")
    print(paste("Ks/Ps data created!"))
  },
  "step4" = {
    #print(paste("Step 4 - Indicators was selected!"))
    #categories = readInputExcelFile("Categories/CategoriesPT.xlsx")
    #nvivoContent = readAllNVivoFiles("Step2/Coder1/",categories)
    #inputMoreCompleted = readInputExcelFile("InputFiles/InputMoreCompleted.xlsx")
    #tableWithCategoriesColumns = addColumnsToDataFrame(inputMoreCompleted)
    #tableWithContentC = insertCategoriesToInputTable(tableWithCategoriesColumns, nvivoContent, categories)
    #createExcel(tableWithContentC, "Step4/Final_Data.xlsx")
    #sctucturedTableForIndicatorsExtraction = createSctucturedTableForIndicatorsExtraction(tableWithContentC, categories)
    #createExcel(sctucturedTableForIndicatorsExtraction, "Step4/Indicators.xlsx")
    #print(paste("Indicators data created!"))
    
    print(paste("Step 4 - Indicators was selected!"))
    categories = readInputExcelFile("Categories/CategoriesPT.xlsx")
    tableWithContent = readInputExcelFile("Step4/Final_Data.xlsx")
    sctucturedTableForIndicatorsExtraction = createSctucturedTableForIndicatorsExtraction(tableWithContent, categories)
    createExcel(sctucturedTableForIndicatorsExtraction, "Step4/Indicators.xlsx")
    print(paste("Indicators data created!"))
  },
  "indianara" = {
    print(paste("Indianara was selected!"))
    indianaraData = readIndianaraFile("Step1/NVivo_Input.docx")
    cleanData = cleanIndianaraData(indianaraData)
    createExcel(cleanData, "Step1/PV_Indianara.xlsx")
    print(paste("Indianara data created!"))
  },  
)
