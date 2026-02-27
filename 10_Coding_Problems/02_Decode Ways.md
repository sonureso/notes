### Decode Ways – Number of Possible Decodings  
**Problem**  
Given a string `s` containing only digits, count how many ways we can decode it back to letters where:  
- '1' → A, '2' → B, ..., '9' → I, '10' → J, ..., '26' → Z  
Rules:  
- '0' alone → invalid  
- '30', '40', ..., '90' → invalid  
- '01', '02', ... → invalid (no leading zero in 2-digit)  
- Empty string / leading '0' → 0 ways  

**Examples**  
- "12" → 2 ways ("AB", "L")  
- "226" → 3 ways ("BBF", "VF", "BZ")  
- "06" → 0  
- "10" → 1 ("J")  
- "30" → 0  
- "111" → 3 ("AAA", "AK", "KA")  

**Optimal Solution**  

```python
def numDecodings(s: str) -> int:
    if not s or s[0] == '0':
        return 0
    
    n = len(s)
    prev2 = 1          # ways for empty string (before index 0)
    prev1 = 1          # ways for first char (already != '0')
    
    for i in range(1, n):
        curr = 0
        
        # single digit
        if s[i] != '0':
            curr += prev1
        
        # two digits
        two = int(s[i-1:i+1])
        if s[i-1] != '0' and 10 <= two <= 26:
            curr += prev2
        
        if curr == 0:      # optimization: impossible from here
            return 0
        
        prev2 = prev1
        prev1 = curr
    
    return prev1
```

**Quick Explanation (why it works)**  
- `prev2` = ways to decode string[0..i-2]  
- `prev1` = ways to decode string[0..i-1]  
- At each step → decide whether to attach current digit alone or pair with previous  
- If both invalid → curr = 0 → whole string impossible from this point  

**Edge Cases to Remember**  
- "" → 0 (or 1 depending on platform — but usually 0)  
- "0" → 0  
- "10" → 1  
- "01" → 0  
- "101" → 1 (only "J A")  
- "110" → 1  
- Very long string → Python int handles big numbers automatically  
