# -*- coding: utf-8 -*-
"""
Created on Thu Dec 30 11:45:01 2021

@author: Administrator
"""

#split the train sets and test sets,
import numpy as np
import pandas
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split

data=r'F:\\pythonWork\\TCGA-LIHC\\LIHCclassify\\psosvr-bacteria_cell.csv'


Xdata=(pandas.read_csv(data)).iloc[:,2:]
Xdata.dtype=float
X=Xdata.values
ydata=(pandas.read_csv(data)).iloc[:,1]
y =np.zeros(len(ydata),dtype=int)

for i in range(len(ydata)):
    if ydata[i]=='normal':
        y[i]=0
    if ydata[i]=='cancer':
            y[i]=1
    i=i+1


X_train,X_test,y_train,y_test = train_test_split(X,y,train_size=0.75)
sgd_clf= LogisticRegression(penalty='l2')



from sklearn.model_selection import StratifiedKFold
from sklearn.base import clone

skfolds = StratifiedKFold(n_splits=3, random_state=42)

for train_index, test_index in skfolds.split(X_train, y_train):
    clone_clf = clone(sgd_clf)
    X_train_folds = X_train[train_index]
    y_train_folds = (y_train[train_index])
    X_test_fold = X_train[test_index]
    y_test_fold = (y_train[test_index])

    clone_clf.fit(X_train_folds, y_train_folds)
    y_pred = clone_clf.predict(X_test_fold)
    n_correct = sum(y_pred == y_test_fold)
    print(n_correct / len(y_pred))
