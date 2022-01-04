PSO-SVR

Prepare the input file TXT format. (row name is gene and column name is cell; row name is gene and column name is sample ID) step1: transpose the two TXT data files input Rdata file for direct reading in subsequent steps Step2: kernel function corealg Step3: doperm performs 1000 times of Step4: SVM deconvolution to get the result step5: drawing program to visualize the calculated immune cell results



(step1-step5 can be run sequentially)

The results were PBMC psosvr results Txt note that the RM (list = LS ()) statement at the beginning of each step is used to clear the work window variables. If you choose to run step by step, do not execute this statement after step 2.

After step 1, save the two data files after the intersection as nevinput_ LM22_ PBMC. txt，NEWinput_ matrix_ PBMC. Txt (there is no genesymbol field, it is directly the top grid of the column name) run R get the running results of cibersort PBMC cibersort results Txt (take the first data set as an example)