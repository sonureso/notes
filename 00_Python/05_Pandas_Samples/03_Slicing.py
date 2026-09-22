import pandas as pd
data = {"Day":[1,2,3,4,5],
        "Visitors":[100,200,150,170,130],
        "Bounce_rate":[10,15,12,13,8]}
df = pd.DataFrame(data,index=['one','two','three','four','five'])
print(df[2:4]) # OR print(df.head(2))
print(df.head(2))
print(df.tail(3))
