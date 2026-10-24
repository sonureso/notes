import pandas as pd

list1 = ['a','b','c']
list2 = [1,2,3]
ser = pd.Series(list1,index=list2)
print(ser)
print(list1*2) # o/p: ['a','b','c','a','b','c']
print(ser*2) # o/p: aa bb cc at index 1,2,3 resp...



