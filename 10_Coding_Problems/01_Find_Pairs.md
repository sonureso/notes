## Problem Statement:

Given an array A of length N (1-based indexing usually).  
Count the number of **ordered pairs** (i, j) (i ≠ j) such that:

(A[i] − A[j]) is divisible by (i − j)  
i.e.  (A[i] − A[j]) % (i − j) == 0

Constraints (most common):
- 1 ≤ N ≤ 2×10⁵
- |A[i]| ≤ 10⁹   (sometimes positive only)

Input (single test case version):
First line: N
Second line: N integers A[1] … A[N]

Output: single integer – number of such ordered pairs
Multiple test cases variant also exists (first line T, then T test cases).

## Solution Pattern (O(N) time, O(N) space)

Group indices by the value of (A[i] − i).  
For each group with frequency f → contributes f × (f−1) ordered pairs (i≠j).

## Python Code – Clean & Fast Version

```python
# Count ordered pairs (i,j) i≠j where (A[i]-A[j]) % (i-j) == 0

N = int(input())                  # Reading input from STDIN
A = input()
A = [int(i) for i in A.split(" ")]
d = {}
counter = 0
for i in range(N):
    counter = counter + d.get(A[i]-i, 0)
    d[A[i]-i] = d.get(A[i]-i, 0) + 1
print(counter * 2)
```

**Memorize the transformation:  (A[i]−A[j]) % (i−j)==0  ⇔  A[i]−i == A[j]−j**
