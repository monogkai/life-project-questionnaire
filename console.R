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
    if(length(args) == 2)
    {
      print(paste("You added an extra argument: ", myLocator))
      rawData = readInputExcelFile("Datasets/Raw_Data.xlsx")
      nvivoInputData = organizeDataToCreateNvivoInputWithLocator(rawData, myLocator)
      createNVivoInput(nvivoInputData, "Datasets/NVivo_Input.docx")
    }
    else
    {
      rawData = readInputExcelFile("Step1/Raw_Data.xlsx")
      nvivoInputData = organizeDataToCreateNvivoInput(rawData)
      createNVivoInput(nvivoInputData, "Step1/NVivo_Input.docx")
    }
    print("Step 1 - Finished successfully")
  },
  "step2" = {
    coderName = args[2]
    print("Step 2 - Create Analyzed data")
    directory = paste(paste("Step2/",coderName, sep=""),"/", sep="")
    if(length(args) == 3)
    {
      print(paste("You added an extra argument: ", myLocator))
      categories = readInputExcelFile("Categories/CategoriesEN.xlsx")
      inputMoreCompleted = readInputExcelFile(paste("Datasets/", "Raw_Data.xlsx", sep=""))
      inputMoreCompletedWithExtraColumns = addColumnsToDataFrame(inputMoreCompleted)
      nvivoContent = readAllNVivoFilesWithLocator(directory, categories)
      tableWithCategories = insertCategoriesToInputTableWithLocator(inputMoreCompletedWithExtraColumns, nvivoContent, categories)
      
      outputDirectoryFile = paste(directory,"Data_", coderName ,".xlsx", sep="")
      createExcel(tableWithCategories, outputDirectoryFile)
    }
    else
    {
      categories = readInputExcelFile("Categories/CategoriesPT.xlsx")
      inputMoreCompleted = readInputExcelFile(paste(directory, "InputMoreCompleted.xlsx", sep=""))
      tableWithCategoriesColumns = addColumnsToDataFrame(inputMoreCompleted)
      inputMoreCompletedWithExtraColumns = addColumnsToDataFrame(inputMoreCompleted)
      
      nvivoContent = readAllNVivoFiles(directory, categories)
      tableWithCategories = insertCategoriesToInputTableWithCategory(tableWithCategoriesColumns, nvivoContent, categories)
      
      outputDirectoryFile = paste(directory,"Analyzed_Data_", coderName ,".xlsx", sep="")
      createExcel(tableWithCategories, outputDirectoryFile)
    } 
    print("Step 2 - Finished successfully")
  },
  "step3" = {
    coderName1 = args[2]
    coderName2 = args[3]
    print("Step 3 - Create Unified data and ks/ps")
    categories = readInputExcelFile("Categories/CategoriesPT.xlsx")
    if(length(args) == 4)
    {
      print(paste("You added an extra argument: ", myLocator))
      datacoderName1 = readInputExcelFile(paste("Analysis/", coderName1, "/Data_", coderName1 ,".xlsx", sep=""))
      datacoderName2 = readInputExcelFile(paste("Analysis/", coderName2, "/Data_", coderName2 ,".xlsx", sep=""))
      
      ##Generate Ks and Ps
      candidate1TableSctucturedForKappas = generateKsTable(datacoderName1, categories)
      candidate2TableSctucturedForKappas = generateKsTable(datacoderName2, categories)
      kappas = getKsAndPsWithLabels(candidate1TableSctucturedForKappas, candidate2TableSctucturedForKappas, categories)
      createExcel(kappas, "Analysis/Kappa.xlsx")
      
      ##Generate Unified Data
      unifiedData = mergeTablesWithAsterisks(datacoderName1, datacoderName2)
      createExcel(unifiedData, "Analysis/Unified_Data.xlsx")
    }
    else
    {
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
    }
    print("Step 3 - Finished successfully")
  },
  "step4" = {
    print("Step 4 - Create Indicators")
    categories = readInputExcelFile("Categories/CategoriesPT.xlsx")
    if(length(args) == 2)
    {
      print(paste("You added an extra argument: ", myLocator))
      finalData = readInputExcelFile("Datasets/Final_Data.xlsx")
      indicators = createSctucturedTableForIndicatorsExtractionWithZeros(finalData, categories)
      createExcel(indicators, "Analysis/Indicators.xlsx")
    }
    else
    {
      finalData = readInputExcelFile("Step4/Final_Data.xlsx")
      indicators = createSctucturedTableForIndicatorsExtraction(finalData, categories)
      createExcel(indicators, "Step4/Indicators.xlsx")
    }
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
