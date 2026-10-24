# Python Data Structures

This page covers the primary built-in data structures in Python: Lists, Sets, Dictionaries, and Tuples. These structures allow you to organize and store data efficiently, each offering different properties regarding order, mutability, and uniqueness.

## 1. List and List Comprehension
Lists are ordered, mutable collections that allow duplicate members.

### Common List Methods
```python
fruits = ["apple", "banana", "cherry"]

fruits.append("orange")      # Adds element to the end
fruits.insert(1, "mango")    # Adds element at specific index
fruits.remove("banana")      # Removes specific element
popped = fruits.pop()        # Removes and returns last element
fruits.sort()               # Sorts list ascending
fruits.reverse()            # Reverses list order
fruits.clear()              # Removes all elements
```

### List Comprehension
A concise way to create lists based on existing lists.
**Syntax:** `[expression for item in iterable if condition]`

```python
# Example: Square of even numbers from 0 to 9
squares = [x**2 for x in range(10) if x % 2 == 0]
# Result: [0, 4, 16, 36, 64]
```

## 2. Sets in Python
Sets are unordered, unindexed collections with no duplicate members.

### Common Set Methods
```python
s1 = {1, 2, 3, 4}
s2 = {3, 4, 5, 6}

s1.add(5)                   # Adds an element
s1.remove(2)                # Removes element (raises error if not present)
s1.discard(10)              # Removes element (no error if not present)

# Set Operations
print(s1.union(s2))         # All elements from both sets
print(s1.intersection(s2))   # Elements present in both sets
print(s1.difference(s2))     # Elements in s1 but not in s2
print(s1.symmetric_difference(s2)) # Elements in either s1 or s2, but not both

### Practical: Looping over Sets
```python
# Sets are unordered, so they don't support indexing
colors = {"red", "green", "blue"}
for color in colors:
    print(color)
```

## 3. Dictionaries in Python
Dictionaries are unordered, changeable, and indexed collections of key-value pairs.

### Common Dictionary Methods
```python
user = {"name": "Alice", "age": 25, "city": "New York"}

user["email"] = "alice@example.com"  # Adds/Updates key-value pair
del user["city"]                     # Removes specific key

print(user.keys())       # Returns all keys
print(user.values())     # Returns all values
print(user.items())      # Returns all key-value pairs as tuples

val = user.get("age")    # Safely gets value, returns None if key doesn't exist
user.update({"age": 26}) # Updates dictionary with another dictionary/iterable
user.pop("name")         # Removes key and returns its value

### Practical: Looping over Dictionaries
```python
# Looping through keys and values
for key, value in user.items():
    print(f"{key} -> {value}")

# Sorting a dictionary by value
sorted_dict = dict(sorted(user.items(), key=lambda item: item[1]))
```

## 4. Tuples in Python
Tuples are ordered, immutable collections that allow duplicate members.

### Common Tuple Methods
Since tuples are immutable, they have fewer methods than lists.
```python
tpl = (10, 20, 30, 20, 40)

print(tpl.count(20))     # Returns number of occurrences of 20
print(tpl.index(30))     # Returns first index of value 30

# Packing and Unpacking
coordinates = (4, 5)            # Packing
x, y = coordinates              # Unpacking

### Practical: Looping over Tuples
```python
# Tuples are looped like lists
point = (10, 20, 30)
for coord in point:
    print(coord)
```

### Practical: Looping over Tuples
```python
# Tuples are looped like lists
point = (10, 20, 30)
for coord in point:
    print(coord)
```

## Summary Table

| Structure | Ordered | Mutable | Duplicates | Key Feature |
| :--- | :---: | :---: | :---: | :--- |
| **List** | Yes | Yes | Yes | Versatile, index-based access |
| **Set** | No | Yes | No | Unique elements, mathematical operations |
| **Dictionary** | Yes* | Yes | Keys: No | Key-Value pairing, fast lookups |
| **Tuple** | Yes | No | Yes | Immutable, faster than lists |

*\*Dictionaries are ordered by insertion since Python 3.7+*

