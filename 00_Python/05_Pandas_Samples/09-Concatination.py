import pandas as pd

df1 = pd.DataFrame({"Name":['Ram','Raman','Rahul','Ranjan'],
                    "Age":[22,23,25,15]},index=[10,11,12,13])

df2 = pd.DataFrame({"Name":['Ram','Raman','Rahul','Ranjan'],
                    "Age":[22,23,25,15]},index=[10,15,16,17])
print(df1)
print(df2)
concat = pd.concat([df1,df2])
print(concat)
