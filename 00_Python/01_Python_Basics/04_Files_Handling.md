# File Handling in Python

File handling is a crucial part of any application. Python provides a set of built-in functions and libraries to create, read, update, and delete files.

## 1. File Operations in Python

The `open()` function is used to open a file. It returns a file object, which is used to manipulate the file.

### Opening Modes
| Mode | Description |
| :--- | :--- |
| `'r'` | **Read** (Default): Opens a file for reading; error if the file does not exist. |
| `'w'` | **Write**: Opens a file for writing; creates the file if it doesn't exist or truncates it if it does. |
| `'a'` | **Append**: Opens a file for appending; creates the file if it doesn't exist. |
| `'x'` | **Create**: Creates the specified file; returns an error if the file exists. |
| `'b'` | **Binary**: Opens the file in binary mode (e.g., images, PDFs). |
| `'t'` | **Text**: Opens the file in text mode (Default). |
| `'+'` | **Updating**: Opens a file for both reading and writing. |

### Practical Example: Basic Write and Read
```python
# Writing to a file
with open("example.txt", "w") as file:
    file.write("Hello Python!\nWelcome to File Handling.")

# Reading from a file
with open("example.txt", "r") as file:
    content = file.read()
    print(content)
```

---

## 2. Working with File Paths

Hardcoding paths can lead to errors across different operating systems. The `os` and `pathlib` modules provide a robust way to handle paths.

### Using `os` module
```python
import os

# Get current working directory
cwd = os.getcwd()
print(f"Current Directory: {cwd}")

# Joining paths (OS independent)
file_path = os.path.join(cwd, "data", "my_file.txt")
print(f"Full Path: {file_path}")

# Checking if file exists
if os.path.exists("example.txt"):
    print("File exists!")
```

### Using `pathlib` (Modern Approach)
`pathlib` provides an object-oriented approach to paths.
```python
from pathlib import Path

# Create a path object
path = Path("data") / "my_file.txt"

# Create directory if it doesn't exist
path.parent.mkdir(parents=True, exist_ok=True)

print(f"File name: {path.name}")
print(f"Extension: {path.suffix}")
print(f"Parent folder: {path.parent}")
```

---

## 3. Reading Files and Handling Errors

Reading files can fail (e.g., file not found, permission denied). Using `try-except-finally` blocks or `with` statements is essential.

### Reading Methods
- `read()`: Reads the entire file as a single string.
- `readline()`: Reads one line at a time.
- `readlines()`: Reads all lines into a list.

### Practical Example with Error Handling
```python
file_name = "non_existent.txt"

try:
    with open(file_name, "r") as file:
        for line in file:
            print(line.strip())
except FileNotFoundError:
    print(f"Error: The file '{file_name}' was not found.")
except PermissionError:
    print("Error: You do not have permission to read this file.")
except Exception as e:
    print(f"An unexpected error occurred: {e}")
finally:
    print("File operation attempt completed.")
```

---

## 4. File Formats and Best Practices

### Working with Common Formats

#### JSON (JavaScript Object Notation)
Used for structured data and APIs.
```python
import json

data = {"name": "Alice", "age": 25, "city": "New York"}

# Writing JSON
with open("data.json", "w") as f:
    json.dump(data, f, indent=4)

# Reading JSON
with open("data.json", "r") as f:
    loaded_data = json.load(f)
    print(loaded_data["name"])
```

#### CSV (Comma Separated Values)
Used for tabular data.
```python
import csv

# Writing CSV
rows = [["Name", "Age"], ["Bob", 30], ["Charlie", 35]]
with open("people.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerows(rows)

# Reading CSV
with open("people.csv", "r") as f:
    reader = csv.reader(f)
    for row in reader:
        print(f"Name: {row[0]}, Age: {row[1]}")
```

### Best Practices
1. **Always use the `with` statement**: This ensures the file is automatically closed even if an exception occurs.
2. **Specify Encoding**: Always specify `encoding="utf-8"` when opening text files to avoid platform-specific character issues.
   - `open("file.txt", "r", encoding="utf-8")`
3. **Avoid `read()` on Large Files**: For very large files, iterate over the file object line by line to save memory.
4. **Use `pathlib` over `os.path`**: It is more readable and modern.
5. **Validate Inputs**: Always check if a file exists before attempting to open it if you aren't using a `try-except` block.
