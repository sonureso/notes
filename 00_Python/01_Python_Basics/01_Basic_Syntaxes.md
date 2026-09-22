# Python Basic Syntaxes

## 1. Variables
Variables are containers for storing data values. Python has no command for declaring a variable; it is created the moment you first assign a value to it.

```python
x = 5
name = "GitHub Copilot"
is_active = True
```

## 2. Basic Datatypes
Commonly used built-in datatypes in Python:

- **Integer (`int`):** Whole numbers. E.g., `10`, `-5`.
- **Float (`float`):** Decimal numbers. E.g., `10.5`, `3.14`.
- **String (`str`):** Sequence of characters. E.g., `"Hello"`.
- **Boolean (`bool`):** Represents `True` or `False`.
- **List (`list`):** Ordered, mutable collection. E.g., `[1, 2, "Apple"]`.
- **Tuple (`tuple`):** Ordered, immutable collection. E.g., `(1, 2, 3)`.
- **Dictionary (`dict`):** Unordered collection of key-value pairs. E.g., `{"name": "AI", "version": 4}`.

## 3. Operators
### Arithmetic Operators
`+` (Addition), `-` (Subtraction), `*` (Multiplication), `/` (Division), `%` (Modulus), `**` (Exponentiation), `//` (Floor Division).

### Comparison Operators
`==` (Equal), `!=` (Not Equal), `>` (Greater than), `<` (Less than), `>=` (Greater or equal), `<=` (Less or equal).

### Logical Operators
`and`, `or`, `not`.

## 4. Conditional Statements
Used to perform different actions based on different conditions.

```python
age = 18
if age >= 18:
    print("You are an adult.")
elif age > 12:
    print("You are a teenager.")
else:
    print("You are a child.")
```

## 5. Loops
### For Loop
Iterates over a sequence (list, tuple, string, range).

```python
fruits = ["apple", "banana", "cherry"]
for fruit in fruits:
    print(fruit)
```

### While Loop
Executes a set of statements as long as a condition is true.

```python
count = 0
while count < 5:
    print(count)
    count += 1
```
