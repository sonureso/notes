import pandas as pd

df1 = pd.DataFrame({"Name":['Ram','Raman','Rahul','Ranjan','Shyam']},index=[10,11,12,13,14])
df2 = pd.DataFrame({"Age":[22,23,25,16]},index=[10,11,12,13])

joined = df1.join(df2)
print(joined)
# Join add column which are not in other dataFrames

