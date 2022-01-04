# -*- coding: utf-8 -*-
"""
Created on Sun Dec  5 20:19:59 2021

@author: Administrator
"""
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import f1_score as f1
from sklearn.metrics import recall_score as recall
from sklearn.metrics import confusion_matrix as cm
import pandas
import numpy
import sklearn.model_selection as ms
import matplotlib.pyplot as plt


data=r'F:\\pythonWork\\TCGA-LIHC\\LIHCclassify\\psosvr-bacteria_cell.csv'


Xdata=(pandas.read_csv(data)).iloc[:,2:]
Xdata.dtype=float
X=Xdata.values
ydata=(pandas.read_csv(data)).iloc[:,1]
y =numpy.zeros(len(ydata),dtype=int)

for i in range(len(ydata)):
    if ydata[i]=='normal':
        y[i]=0
    if ydata[i]=='cancer':
            y[i]=1
    i=i+1


X_train,X_test,y_train,y_test = train_test_split(X,y,train_size=0.75)



from sklearn.model_selection import StratifiedKFold
skf = StratifiedKFold(n_splits=3, random_state=1)

models, coefs = [], []  # in case you want to inspect the models later, too
train_accuracy=[]
test_accuracy=[]
for train, test in skf.split(X_train,y_train):
        #print(train, test)
    cl = LogisticRegression(penalty='l2')
    cl.fit(X_train[train], y_train[train])
train_accuracy.append(cl.score(X_train,y_train))
test_accuracy.append(cl.score(X_test,y_test))
models.append(cl)
coefs.append(cl.coef_[0])

pandas.DataFrame(coefs).mean()



print('Test accuracy of logistic regression:'+str(cl.score(X_test,y_test))+'\n')


print('F1 score:'+str(f1(y_test,cl.predict(X_test)))+'\n')

print('Recall score (the closer to 1, the better):'+str(recall(y_test,cl.predict(X_test)))+'\n')

print('Confusion matrix:'+'\n'+str(cm(y_test,cl.predict(X_test)))+'\n')