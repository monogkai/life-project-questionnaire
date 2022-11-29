##Import files
source("Functions/NVivo.R")
source("Functions/Kappas.R")
source("Functions/Excel.R")
source("Functions/Categories.R")
source("Functions/Tables.R")
source("Functions/Indicators_Extraction.R")
source("Functions/Indianara.R")

args = commandArgs(TRUE)
switch(  
  args[1],  
  "indianara" = {
    indianaraData = readIndianaraFile("InputFiles/PV_Indianara.docx")
    cleanData = cleanIndianaraData(indianaraData)
    createExcel(cleanData, "OutputFiles/PV_Indianara.xlsx")
    print(paste("Indianara data created!"))
  },  
  "indicators"= {
    categories = readInputExcelFile("InputFiles/CategoriesEN.xlsx")
    inputMoreCompleted = readInputExcelFile("InputFiles/InputMoreCompleted.xlsx")
    inputMoreCompletedWithExtraColumns = addColumnsToDataFrame(inputMoreCompleted)
    sctucturedTableForIndicatorsExtraction = createSctucturedTableForIndicatorsExtraction(inputMoreCompletedWithExtraColumns, categories)
    createExcel(sctucturedTableForIndicatorsExtraction, "OutputFiles/AllCategoriesInsertedInGoalsTable.xlsx")
    print(paste("Indicators data created!"))
  },
  "ks"= {
    categories = readInputExcelFile("InputFiles/CategoriesPT.xlsx")
    inputMoreCompleted = readInputExcelFile("InputFiles/InputMoreCompleted.xlsx")
    tableWithCategoriesColumns = addColumnsToDataFrame(inputMoreCompleted)
    inputMoreCompletedWithExtraColumns = addColumnsToDataFrame(inputMoreCompleted)
    nvivoContent = readAllNVivoFiles(categories)
    tableWithContentC = insertCategoriesToInputTableC(tableWithCategoriesColumns, nvivoContent, categories)
    
    ##Generate Ks and Ps
    candidateATableSctucturedForKappas = generateKsTable(tableWithContentC, categories)
    candidateBTableSctucturedForKappas = generateKsTable(tableWithContentC, categories)
    kappas = getKsAndPs(candidateATableSctucturedForKappas, candidateBTableSctucturedForKappas, categories)
    createExcel(kappas, "OutputFiles/AllKsAndPs.xlsx")
    print(paste("Ks data created!"))
  }
)

