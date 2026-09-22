# Functions and Libraries in Python

## 1. Functions Basics
Functions are reusable blocks of code that perform a specific task. They help in organizing code, reducing repetition, and improving maintainability.

### Defining and Calling a Function
```python
def greet(name):
    """This function greets the person passed in as a parameter"""
    return f"Hello, {name}!"

# Calling the function
print(greet("Alice")) # Output: Hello, Alice!
```

### Arguments and Parameters
- **Positional Arguments:** Arguments passed in the order they were defined.
- **Keyword Arguments:** Arguments passed by explicitly naming the parameter.
- **Default Parameters:** Parameters that take a default value if no argument is provided.
- **Variable-length Arguments (`*args` and `**kwargs`):** Used when the number of arguments is unknown.

```python
def describe_pet(animal_type, pet_name, age=1):
    print(f"I have a {animal_type} named {pet_name} who is {age} year(s) old.")

# Using default value
describe_pet("Hamster", "Harry") 

# Using keyword arguments
describe_pet(pet_name="Goldie", animal_type="Fish", age=2)

# Using *args for multiple positional arguments
def make_pizza(*toppings):
    print("Toppings: " + ", ".join(toppings))

make_pizza("Pepperoni", "Mushrooms", "Extra Cheese")

# Using **kwargs for multiple keyword arguments
def build_profile(first, last, **user_info):
    user_info['first_name'] = first
    user_info['last_name'] = last
    return user_info

user_profile = build_profile('Albert', 'Einstein', location='Princeton', field='Physics')
print(user_profile)
```

---

## 2. Lambda Functions
Lambda functions are small, anonymous functions defined without a name using the `lambda` keyword. They can take any number of arguments but can only have one expression.

**Syntax:** `lambda arguments: expression`

### Examples
```python
# Simple addition lambda
add = lambda x, y: x + y
print(add(5, 3)) # Output: 8

# Squaring a number
square = lambda x: x**2
print(square(4)) # Output: 16
```

---

## 3. Map Functions
The `map()` function applies a given function to each item of an iterable (list, tuple, etc.) and returns a map object (an iterator).

**Syntax:** `map(function, iterable)`

### Examples
```python
# Using map with a regular function
def double(n):
    return n * 2

numbers = [1, 2, 3, 4]
result = map(double, numbers)
print(list(result)) # Output: [2, 4, 6, 8]

# Using map with a lambda function (Most Common)
numbers = [1, 2, 3, 4]
squared = list(map(lambda x: x**2, numbers))
print(squared) # Output: [1, 4, 9, 16]
```

---

## 4. Filter Functions
The `filter()` function constructs an iterator from elements of an iterable for which a function returns true. It is used to "filter out" items that don't meet a certain condition.

**Syntax:** `filter(function, iterable)`

### Examples
```python
# Filter even numbers
def is_even(n):
    return n % 2 == 0

numbers = [1, 2, 3, 4, 5, 6]
evens = list(filter(is_even, numbers))
print(evens) # Output: [2, 4, 6]

# Using filter with lambda to find words longer than 5 letters
words = ["Apple", "Banana", "Cherry", "Date", "Elderberry"]
long_words = list(filter(lambda w: len(w) > 5, words))
print(long_words) # Output: ['Banana', 'Cherry', 'Elderberry']
```

---

## 5. About Import
The `import` statement is used to bring functions, classes, or variables from one module into another.

### Ways to Import
1. **Import entire module:**
   ```python
   import math
   print(math.sqrt(16)) # Output: 4.0
   ```
2. **Import specific attributes:**
   ```python
   from math import pi, sqrt
   print(pi) # Output: 3.14159...
   ```
3. **Import with an alias:**
   ```python
   import numpy as np
   import pandas as pd
   ```

---

## 6. Packages in Python
A package is a way of structuring Python's module system into a hierarchy. Technically, a package is a directory containing a special `__init__.py` file (though in Python 3.3+, "namespace packages" don't strictly require it, it is still best practice).

### Creating a Simple Package
Imagine a folder structure:
```
my_math_package/
    ├── __init__.py
    ├── basic_ops.py
    └── advanced_ops.py
```

**basic_ops.py:**
```python
def add(a, b): return a + b
def subtract(a, b): return a - b
```

**advanced_ops.py:**
```python
def power(a, b): return a ** b
```

**Using the package:**
```python
from my_math_package import basic_ops
from my_math_package.advanced_ops import power

print(basic_ops.add(10, 5)) # Output: 15
print(power(2, 3))          # Output: 8
```

---

## 7. Standard Libraries to Know
Python comes with a "batteries included" philosophy, providing a vast standard library.

### Commonly Used Libraries
| Library | Usage | Example |
| :--- | :--- | :--- |
| `os` | OS interactions (files, directories) | `os.listdir('.')` |
| `sys` | System-specific parameters/functions | `sys.argv` (command line args) |
| `datetime` | Date and time manipulation | `datetime.datetime.now()` |
| `random` | Generating pseudo-random numbers | `random.randint(1, 10)` |
| `json` | Parsing and creating JSON data | `json.loads(json_string)` |
| `re` | Regular expressions | `re.search(pattern, text)` |
| `collections` | Specialized container datatypes | `collections.Counter(list)` |
| `shutil` | High-level file operations (Copy, Move, Archive) | `shutil.copy('src.txt', 'dst.txt')` |
| `glob` | File pattern matching (wildcards) | `glob.glob('*.csv')` |
| `csv` | Reading and writing CSV files | `csv.reader(file)` |
| `itertools` | Efficient looping and combinatorics | `itertools.cycle([1,2])` |
| `pathlib` | Object-oriented filesystem paths | `Path('dir').mkdir()` |

### Example: using `os` and `random`
```python
import os
import random

# Get current working directory
cwd = os.getcwd()
print(f"Current directory: {cwd}")

# Pick a random number
num = random.randint(1, 100)
print(f"Random Number: {num}")
```

### Data Engineering Examples: `shutil`, `glob`, and `pathlib`
```python
import shutil
import glob
from pathlib import Path

# 1. Using shutil to backup a file
# shutil.copy2 preserves metadata (timestamps, etc.)
shutil.copy2('data_source.csv', 'backup/data_source_bak.csv')

# 2. Using glob to find all CSV files in a directory for processing
csv_files = glob.glob('landing_zone/*.csv')
print(f"Files to process: {csv_files}")

# 3. Using pathlib for clean directory management
log_dir = Path('logs/daily_runs')
log_dir.mkdir(parents=True, exist_ok=True)
log_file = log_dir / 'run_20260922.log'
log_file.write_text('Process started successfully')
```

---

## 8. Best Practices
### For Functions
- **Single Responsibility:** A function should do one thing and do it well.
- **Docstrings:** Always use `"""Docstrings"""` to explain what the function does, its arguments, and its return value.
- **Type Hinting:** Use type hints for better readability and debugging.
  ```python
  def calculate_area(radius: float) -> float:
      return 3.14 * (radius ** 2)
  ```
- **Avoid Global Variables:** Pass data into functions as arguments instead of relying on global state.

### For Libraries and Packages
- **Explicit Imports:** Prefer `from module import function` over `from module import *` to avoid namespace pollution.
- **Virtual Environments:** Always use a virtual environment (`venv` or `conda`) to manage project-specific dependencies.
- **Modularization:** Split large scripts into smaller modules/packages based on functionality.
- **Naming Conventions:** Follow PEP 8 (modules should have short, all-lowercase names).
