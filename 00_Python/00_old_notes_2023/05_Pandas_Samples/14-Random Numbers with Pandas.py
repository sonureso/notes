import pandas as pd
import numpy as np
from numpy.random import randn

np.random.seed(101)
df = pd.DataFrame(randn(3,3),['A','B','C'],['D','E','F'])
print(df)
## Will print 9 random numbers with ABC as index and DEF as Columns.
print(type(df)) ## dataFrame
print(type(df['D'])) ## Series
print(df.head(2)) ## Will print two rows.
print(df.tail(1)) ## print last one row.
print(df.isnull().any()) ## will print row wise False
## df.drop('C') : this will drop row with index 'C'
 
