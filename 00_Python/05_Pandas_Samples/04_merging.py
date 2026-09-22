import pandas as pd

df1 = pd.DataFrame({"Name":['Ram','Raman','Rahul','Ranjan'],
                    "Age":[22,23,25,15]},index=[10,11,12,13])

df2 = pd.DataFrame({"Name":['Ram','Raman','Rahul','Ranjan'],
                    "Age":[22,23,25,16]},index=[14,15,16,17])
print(df1)
print(df2)
merge = pd.merge(df1,df2, on="Name")
print(merge)
