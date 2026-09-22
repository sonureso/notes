# Object Oriented Programming (OOPs) in Python

Object-Oriented Programming is a programming paradigm based on the concept of "objects", which can contain data (attributes) and code (methods).

---

## 1. Classes and Objects in Python

A **Class** is a blueprint for creating objects. An **Object** is an instance of a class.

### Practical Example:
```python
class Dog:
    # Class Attribute
    species = "Canine"

    # Constructor (Initializer)
    def __init__(self, name, breed):
        self.name = name   # Instance Attribute
        self.breed = breed # Instance Attribute

    # Instance Method
    def bark(self):
        return f"{self.name} says Woof!"

# Creating Objects (Instances)
dog1 = Dog("Buddy", "Golden Retriever")
dog2 = Dog("Max", "German Shepherd")

print(dog1.bark()) # Output: Buddy says Woof!
print(dog2.species) # Output: Canine
```

---

## 2. Inheritance

Inheritance allows a class (Child/Derived) to inherit attributes and methods from another class (Parent/Base).

### Types of Inheritance:
- **Single**: Child inherits from one Parent.
- **Multiple**: Child inherits from multiple Parents.
- **Multilevel**: Child inherits from a Parent, which inherits from another Parent.
- **Hierarchical**: Multiple Children inherit from one Parent.

### Practical Example:
```python
class Animal:
    def speak(self):
        print("Animal makes a sound")

# Single Inheritance
class Cat(Animal):
    def speak(self): # Method Overriding
        print("Meow")

# Multiple Inheritance
class Flyer:
    def fly(self):
        print("Flying high")

class Bat(Animal, Flyer):
    pass

my_bat = Bat()
my_bat.speak() # From Animal
my_bat.fly()   # From Flyer
```

---

## 3. Polymorphism

Polymorphism allows different classes to be treated as instances of the same general class through the same interface. Usually achieved via method overriding.

### Practical Example:
```python
class Bird:
    def move(self):
        print("Birds fly")

class Penguin(Bird):
    def move(self):
        print("Penguins swim")

class Ostrich(Bird):
    def move(self):
        print("Ostriches run")

# Polymorphic function
def animal_move(bird_obj):
    bird_obj.move()

birds = [Bird(), Penguin(), Ostrich()]
for b in birds:
    animal_move(b)
```

---

## 4. Encapsulation

Encapsulation restricts direct access to data to prevent accidental modification. In Python, this is indicated by underscores:
- `_variable` (Protected): Hint that it's internal.
- `__variable` (Private): Triggers name mangling to make it harder to access.

### Practical Example:
```python
class BankAccount:
    def __init__(self, balance):
        self.__balance = balance # Private attribute

    def deposit(self, amount):
        if amount > 0:
            self.__balance += amount
            return True
        return False

    def get_balance(self): # Getter method
        return self.__balance

account = BankAccount(1000)
account.deposit(500)
print(account.get_balance()) # Output: 1500
# print(account.__balance) # This would raise an AttributeError
```

---

## 5. Abstraction

Abstraction hides complex implementation details and only shows the necessary features. Python uses the `abc` (Abstract Base Classes) module.

### Practical Example:
```python
from abc import ABC, abstractmethod

class Shape(ABC):
    @abstractmethod
    def area(self):
        pass

class Square(Shape):
    def __init__(self, side):
        self.side = side
    
    def area(self):
        return self.side * self.side

# s = Shape() # This would raise TypeError: cannot instantiate abstract class
sq = Square(5)
print(sq.area()) # Output: 25
```

---

## 6. Magic Methods (Dunder Methods)

Magic methods start and end with double underscores (`__`). They allow you to define how objects behave with built-in Python operations.

### Common Magic Methods:
- `__init__`: Initializes an object.
- `__str__`: Defines the string representation (for `print()`).
- `__repr__`: Defines the developer-friendly representation.
- `__len__`: Defines behavior for `len()`.

### Practical Example:
```python
class Book:
    def __init__(self, title, author, pages):
        self.title = title
        self.author = author
        self.pages = pages

    def __str__(self):
        return f"'{self.title}' by {self.author}"

    def __len__(self):
        return self.pages

book = Book("Python Crash Course", "Eric Matthes", 500)
print(book)       # Calls __str__ -> 'Python Crash Course' by Eric Matthes
print(len(book))  # Calls __len__ -> 500
```

---

## 7. Operator Overloading

Operator overloading allows you to redefine the behavior of built-in operators (`+`, `-`, `*`, etc.) for your own classes using magic methods.

### Practical Example:
```python
class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    # Overloading the + operator
    def __add__(self, other):
        return Point(self.x + other.x, self.y + other.y)

    def __str__(self):
        return f"({self.x}, {self.y})"

p1 = Point(1, 2)
p2 = Point(3, 4)
p3 = p1 + p2 # Triggers __add__
print(p3) # Output: (4, 6)
```

---

## 8. Exception Handling and Custom Exceptions

Exception handling allows a program to deal with errors gracefully.

### Standard Exception Handling:
```python
try:
    num = int(input("Enter a number: "))
    result = 10 / num
except ValueError:
    print("Invalid input! Please enter a number.")
except ZeroDivisionError:
    print("Cannot divide by zero!")
except Exception as e:
    print(f"An unexpected error occurred: {e}")
else:
    print(f"Division successful: {result}")
finally:
    print("Execution completed.")
```

### Custom Exception Handling:
You can create your own exceptions by inheriting from the `Exception` class.

### Practical Example:
```python
class InsufficientFundsError(Exception):
    """Raised when account balance is too low for withdrawal."""
    def __init__(self, balance, amount):
        self.balance = balance
        self.amount = amount
        self.message = f"Attempted to withdraw {amount} but balance is only {balance}"
        super().__init__(self.message)

def withdraw(balance, amount):
    if amount > balance:
        raise InsufficientFundsError(balance, amount)
    return balance - amount

try:
    withdraw(100, 500)
except InsufficientFundsError as e:
    print(f"Transaction Failed: {e}")
```
