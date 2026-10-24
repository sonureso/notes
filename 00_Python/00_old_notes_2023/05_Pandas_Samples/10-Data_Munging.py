import pandas as pd

data = pd.read_csv("Book2.csv",index_col=0)
print(data)
df = data.head(3)
sd = df.reindex(columns = ['Age']) #creating new dataFrame with specific column
print(df)
print(sd) #if two column: for difference: sd.diff(axis=1)
data.to_html('Book1.html') #Converting to html
