import numpy as np
a=np.array([1,2,3])
print(a) ## one-D array
a=np.array([(1,2,3),(2,3,4)])
print(a) ## Two-D Array
print(a.ndim) ## o/p : 2
print(a.itemsize) ## o/p: 4
print(a.size) ## o/p: 6
print(a.dtype) ## o/p: int32
print(a.shape) ## o/p: (2,3)
#print(a.reshape(3,2)) ## array will covert to 3 row and 2 cols.
print(a[0,2]) # o/p: 3
print(a[0:,2]) # o/p: [3 4]
print(np.linspace(2,10,5)) ## o/p: [2. 4. 6. 8. 10.]
print(a.min())
print(a.max())
print(a.sum())
print(a.sum(axis=0)) # o/p: [3 5 7]
print(a.sum(axis=1)) # o/p: [6 9]
print(np.sqrt(a)) # sqrt of all numbers will be printed
b=np.array([(1,2,3),(2,3,4)])
#print(a+b) # matrix will be added and can be sub,mul,div...
print(np.vstack((a,b))) #  four rows three cols printed
print(np.hstack((a,b))) # two rows and six columns printed...



