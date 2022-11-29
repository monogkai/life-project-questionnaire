##Import files
source("Functions/NVivo.R")
source("Functions/Kappas.R")
source("Functions/Excel.R")
source("Functions/Categories.R")
source("Functions/Tables.R")
source("Functions/Indicators_Extraction.R")

##Read Input files
nvivoContentA = readNVivoFile("InputFiles/NVivo/Amizades.docx")
#nvivoContentB = readNVivoFile("InputFiles/NVivo/Relacionamentos Amorosos.docx")
goalsTable = readInputExcelFile("InputFiles/GoalsTable.xlsx")
categories = readInputExcelFile("InputFiles/CategoriesPT.xlsx")
inputMoreCompleted = readInputExcelFile("InputFiles/InputMoreCompleted.xlsx")
nvivoWrong = readWrongNVivoFile("InputFiles/Amizades.docx")
nvivoContent = readAllNVivoFiles(categories)

####
#indianaraData = readIndianaraFile("InputFiles/PV_Indianara.docx")
cleanData = cleanIndianaraData(indianaraData)
createExcel(cleanData, "OutputFiles/PV_Indianara.xlsx")
####

####
#tableWithCategoriesColumns = addColumnsToDataFrame(inputMoreCompleted)
#tableWithContentC = insertCategoriesToInputTableC(tableWithCategoriesColumns, nvivoContent, categories)
#candidateTableSctucturedForKappas = generateKsTable(tableWithContentC, categories)
#dataKsAndPs = getKsAndPs(candidateTableSctucturedForKappas, candidateTableSctucturedForKappas, categories)
#createExcel(dataKsAndPs, "OutputFiles/AllKsAndPsTable.xlsx")
#sctucturedTableForIndicatorsExtraction = createSctucturedTableForIndicatorsExtraction(tableWithContentC, categories)

#tableWithContentCWrong = insertCategoriesToInputTableC(tableWithCategoriesColumns, nvivoWrong, categories)
####

##Add categories to Goals Table
#tableWithCategoriesColumns = addColumnsToDataFrame(goalsTable)
#tableWithContentA = insertCategoriesToInputTable(tableWithCategoriesColumns, nvivoContentA, categories)
#tableWithContentB = insertCategoriesToInputTable(tableWithCategoriesColumns, nvivoContentB, categories)
#tableWithContentC = insertCategoriesToInputTableC(tableWithCategoriesColumns, nvivoContent, categories)

##Create a table a Goals table with the categories of A and B candidates
#tableWithAllCategoriesInserted = mergeTablesWithCategories(tableWithContentA, tableWithContentB)
#createExcel(tableWithAllCategoriesInserted, "OutputFiles/AllCategoriesInsertedInGoalsTable.xlsx")

##Generate Ks and Ps
#candidateATableSctucturedForKappas = generateKsTable(tableWithContentA, categories)
#candidateBTableSctucturedForKappas = generateKsTable(tableWithContentB, categories)
#kappas = getKsAndPs(candidateATableSctucturedForKappas, candidateBTableSctucturedForKappas)

##Generate Extraction of indicators table
#inputMoreCompletedWithExtraColumns = addColumnsToDataFrame(inputMoreCompleted)
#sctucturedTableForIndicatorsExtraction = createSctucturedTableForIndicatorsExtraction(inputMoreCompletedWithExtraColumns)
#createExcel(sctucturedTableForIndicatorsExtraction, "OutputFiles/AllCategoriesInsertedInGoalsTable2.xlsx")