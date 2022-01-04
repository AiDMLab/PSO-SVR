

import pandas
from pyswarm import pso
from sklearn.svm import SVR
from sklearn.model_selection import KFold
import numpy as np

fold_count=10 # K-Fold Cross validation.




Data = r'G:/newLM22.csv'

Dif = r'G:/PBMC_match_LM22.csv'

X = pandas.read_csv(Data,names=['a','b','c','d','e','f','g','h','i','j','k','l','m','n',
                               'o','p','q','r','s','t','u','v'])
X = X.iloc[1:,].values
Y = pandas.read_csv(Dif,names=['diff1','diff2','diff3','diff4','diff5','diff6','diff7','diff8','diff9','diff10','diff11','diff12','diff13','diff14','diff15','diff16','diff17','diff18','diff19','diff20','previousarrvial'])
Y = Y.iloc[1:,].values

def calsMAPE(X_test,previousarrvial,Y_test, result):
    sum_up = 0
    n = 0
    Y_test= Y_test.astype(np.float)
    size = len(X_test)
    for i in range(size):
        if previousarrvial[i] != 0:
            diff = (result[i] - Y_test[i])*(result[i] - Y_test[i])
            #diff = abs(diff)
            n = n+1
            sum_up = sum_up + diff
    MAPE = sum_up/n
    return MAPE


def svrPso(params):
     kf = KFold(fold_count)
     mapeTotal = 0
     i=0

     for i in range(0,1):
         for train, test in kf.split(X):
             mapeTotal = 0


             X_train, X_test, y_train, y_test = X[train], X[test], Y[train,i], Y[test,i]
             previousarrvial = Y[test,-1]
        
             nn = SVR(C=params[0], epsilon = params[1])
             nn.fit(X_train,y_train)
             result = nn.predict(X_test)

             thisMape = calsMAPE(X_test,previousarrvial,y_test, result)
             print(result)
             mapeTotal = mapeTotal + thisMape 
             
             mapeCV = mapeTotal/fold_count; 

             print('Optimizing the Parameters ..... C = {c}, epsilon={e}, MAPE={m}'.format(c=params[0], e=params[1], m=mapeCV))
     #nn.coef_
     nn.intercept_
     i=i+1
     return mapeCV  

print("************  Initializing PSO based SVR *****************")
lb = [0.1, 0]
ub = [3.0, 0.005]
        
xopt, fopt = pso(svrPso, lb, ub, maxiter=10, debug=True,phip=10, swarmsize=200, minfunc=0.001 )
        
print(" ")
print("************ Objective Function optimized *****************")
print(" ")
print('ALL Parameters optimized: C = {c}, epsilon={e}, Overall MAPE={m}'.format(c=xopt[0], e=xopt[1], m=fopt))
print(" ")
print(" ")
print("************  Optimization Finished *****************")

