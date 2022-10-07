- [Working with variables](#working-with-variables)
  - [Immutability](#immutability)
- [Understanding the type system](#understanding-the-type-system)
  - [Strings](#strings)
    - [Exercises](#exercises)
  - [Charlists](#charlists)
    - [Exercises](#exercises-1)
  - [Atoms](#atoms)
    - [Exercises](#exercises-2)
  - [Tuples](#tuples)
    - [Exercises](#exercises-3)
  - [Anonymous functions](#anonymous-functions)
    - [Exercises](#exercises-4)
  - [Lists](#lists)
    - [Exercises](#exercises-5)

# Working with variables
Elixir is a _dynamic_ language, which means that when you declare a variable you are not specifying a type. The type is going to be automatically determined from the data it contains at the moment. This means that the type can change based on the usage. We can initialize a variable with an integer value and later bind it to a string value without any issue.
```elixir
iex(1)> a = 1
1
iex(2)> a
1
iex(3)> a = "hello world"
"hello world"
iex(4)> a
"hello world"
```

**NB** Having the possibility to do so does not mean it's generally a good idea. You should restrain yourself from binding the same variable to a value with different type. This just brings confusion and bugs.

In Elixir the practice is to use snake case for defining variables / function parameters. 
- `this_is_good_variable_name` _snake_case_
- `thisIsNot` _camelCase_
- `ThisIsNotValid` _PascalCase_ _(used for naming modules)_

## Immutability
Even though we are using the name variables, in Elixir it makes more sense to look at variables as "labels for values". When we bind the variable `a` to the value of 5 and then rebind it to 6 we just change the value to which `a` points to. The value of 5 is still in memory and if it's not being used anywhere, at some point it will be garbage collected.

When you pass the variable `a` to a function you are not passing the reference to the variable, but the value itself. That function could never change the value to which `a` is pointing to.

**NB** Variables aren't the immutable thing, the data they point to is. Elixir simply does not allow values in certain memory location to change.

# Understanding the type system

As we mentioned before, Elixir's type system is dynamic, meaning that when we are creating variables and function we don't specify types. Types are automatically inferred from the value that you bind them to. Variables can change types as well. You can assign a variable to a string and then to a number on the next line. This is usually not a good idea because it just brings confusion and opens a door for potential bugs, yet the language allows it, so keep that in mind. 

## Strings
Unlike some other languages where you might be able to use single or double quotes to create a String, in Elixir you can only use double quotes.

```elixir
iex(1)> "this is a string"
"this is a string"
iex(2)> 'this is not'
'this is not'
iex(3)> "a" == 'a'
false
```

Strings are concatenates using the `<>` symbol
```elixir
iex(1)> "hello" <> " world"
"hello world"
iex(2)> 'hello' <> ' world'
** (ArgumentError) expected binary argument in <> operator but got: 'hello'
    (elixir 1.13.4) lib/kernel.ex:1926: Kernel.wrap_concatenation/3
    (elixir 1.13.4) lib/kernel.ex:1913: Kernel.extract_concatenations/2
    (elixir 1.13.4) expanding macro: Kernel.<>/2
    iex:5: (file)
```

### Exercises

1. Create a function called `connect/2` that takes two strings as parameters and concatenates them with a space in between.
    ```elixir
    iex(1)> connect("hello", "world")
    "hello world"
    iex(2)> connect("hello ", "world")
    "hello  world"
    ```
2. Create a function called `connectWith/3` that takes three strings, where the third is meant to be the 'connection' between the first two strings.
    ```elixir
    iex(1)> connectWith("hello", "world", " ")
    "hello world"
    iex(2)> connectWith("hello ", "world", " my ")
    "hello my world"
    ```

## Charlists
Charlists are surrounded by single quotes. Under the hood they are just a list of ascii numbers which can be represented as a whole between single quotes.

```elixir
iex(1)> 'hello' == [104, 101, 108, 108, 111]
true
iex(2)> [104, 101, 108, 108, 111]
'hello'
iex(3)> [97, 98, 99]
'abc'
```

As you can see if you create a list of numbers where each number has a representation in the ascii table, the result will be represented as a charlist. Yet as soon as you add a number which is outside the ascii table, the result will be a list of numbers

```elixir
iex(1)> [97, 98, 99, 0]
[97, 98, 99, 0]
```

You can get the ascii number of every character by adding a question mark before it. Think of it as a function that takes a character and produces a number.
```elixir
iex(1)> ?a
97
iex(2)> ?0
48
iex(3)> ?\\ # <-- For some you have to escape the symbol with a backslash. Here we escape backslash with a backslash
92
iex(4)> ?\n # <-- This is the symbol for new line
10
iex(5)> [?h, ?e, ?l, ?l, ?o] # <-- Now we can do the same example as above but use the question mark instead of numbers
'hello'
```

### Exercises
1. Try to get the ascii value of an escape character that does not exist and look at the output. (_Use the `?` symbol_)


## Atoms

Atoms are constants where their name is equal to their value. An atom is denoted by the colon at the beginning. They are usually named now you would name a variable in Elixir _(using snake case)_ - `:atom`.

Interestingly booleans in Elixir are actually implemented as the atoms `:true` and `:false`, but there is a syntax sugar that makes it so you can use `true` instead of `:true` and `false` instead of `:false`. The same is valid for the `nil` value that is represented with the atom `:nil`.

```elixir
iex(1)> true == :true
true
iex(2)> false == :false
true
iex(3)> nil == :nil
true
```

Atoms are usually used for constants that represent some information. A good example would be for status: `:success` _(or as commonly referred to as `:ok` in Elixir)_ and `:failure` _(or as commonly referred to as `:error` in Elixir)_

Usually where as in other languages it's common to represent constant text values with strings in Elixir it's common to use atoms. For example, to represent the days of the week, `string` seem to do the work, but they could be changed. The value would be constant because of our usage, not its nature. While as by using atoms there is no way the value could be changed, if so, that is a completely different atom.

Therefore use this
```elixir
days_of_week = [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday]
```

Instead of this 
```elixir
days_of_week = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
```

Some symbols cannot be represented as tuple just as is. In those scenarios we have to wrap them in double quotes.

```elixir
iex(1)> :]
** (SyntaxError) iex:21:1: unexpected token: ":" (column 1, code point U+003A)
    |
 21 | :]
    |
iex(2)> :"]"
:"]"
iex(3)> String.to_atom("hello world") # <-- Strings can be converted to atoms
:"hello world"
```

**NB** Since atoms are constants where the name is equal to the value, they can never change. Once an atom is created it's added to a special atom table in the memory of the BEAM VM. They are never garbage collected and will stay in memory until the system exits. So it's never a good idea to use atoms for things that can grow indefinitely like ids and such or have them be created from an input. BEAM will crash once the limit of atoms is reached. _(You can check your current limit via `:erlang.system_info(:atom_limit)`. That number can be increased, but if you have this problem then you are probably doing something wrong)_

### Exercises
1. Create a function that takes two strings, removes all trailing and leading spaces, connects them together with an underscore and converts it to an atom.
    ```elixir
    iex(1)> connectToAtom("hello", "world")
    :hello_world
    iex(2)> connectToAtom(" hello", "world ")
    :hello_world
    ```

Notes
1. [`String.trim/1`](https://hexdocs.pm/elixir/1.12/String.html#trim/1)


## Tuples

A tuple is a finite (usually fix sized), zero indexed sequence of elements. Usually used to group couple of data values together. Even though tuples have the possibility to add/update/remove elements, more often than not they are used with a fix amount of values. When using tuples it is not uncommon to have different types of values for the different elements _(where as in lists you'll most likely lean towards having all elements be only one type)_.

The following snippet shows how to use a tuple to contain information about a person's name and age:
```elixir
iex(1)> person = {"Bob", 24}
{"Bob", 24}
```

Accessing elements in a tuple is done via `elem/2`, where the first element is the tuple and the second is the index.
```elixir
iex(2)> elem(person, 0)
"Bob" 
```

### Exercises
1. Write a function that given a string returns a 2 element tuple with the given string and its length.
    ```elixir
    iex(1)> with_length("hello")
    {"hello", 5}
    iex(1)> with_length("")
    {"", 0}
    ```

## Anonymous functions
Anonymous function in Elixir are treated a first-class citizens, which means that they can be used as any other basic type: bound to a variable, returned from a function, passed as argument to a function. Because of this it's really easy pass executable code around.

An anonymous function is delimited by the keywords `fn` and `end`.
The recipe is the following: `fn ({args...}) -> {expression} end`
```elixir
iex(1)> add = fn (a, b) -> a + b end # <-- Notice that the returned value is a reference to the function
#Function<41.3316493/2 in :erl_eval.expr/6>
iex(2)> add.(1, 2) # <-- To call an anonymous function a dot should be placed between the name and the opening parentheses
3
iex(3)> multiply = fn (a, b) -> # <-- Can be written on more than one line
...(3)> a * b
...(3)> end
#Function<41.3316493/2 in :erl_eval.expr/6>
iex(4)> multiply.(2, 4)
8
```

Anonymous function are also identified by the amount of arguments (also called `arity`) they receive. Elixir provides `is_function/1` and `is_function/2` to verify if something is a function and how many arguments it's expecting.

```elixir
iex(1)> add = fn (a, b) -> a + b end
#Function<41.3316493/2 in :erl_eval.expr/6>
iex(2)> is_function(add)
true
iex(3)> is_function(add, 1)
false
iex(4)> is_function(add, 2)
true
```

A variable assigned inside an anonymous function does not affect it's surrounding environment
```elixir
iex(1)> x = 42
42
iex(2)> (fn -> x = 0 end).() # <-- Writing and executing on the same line
0
iex(3)> x
42
```

Function can be passed down as arguments
```elixir
iex(1)> add = fn (a, b) -> a + b end 
#Function<41.3316493/2 in :erl_eval.expr/6>
iex(2)> multiply = fn (a, b) -> a * b end
#Function<41.3316493/2 in :erl_eval.expr/6>
iex(3)> execute = fn (fun, arg1, arg2) -> fun.(arg1, arg2) end # <-- Taking a function as an argument
#Function<40.3316493/3 in :erl_eval.expr/6>
iex(4)> execute.(add, 2, 4)
6
iex(5)> execute.(multiply, 2, 4)
8
```

### Exercises

1. Write a function for dividing two numbers
2. Write a **currying** function for adding two numbers

Notes
1. `Currying` is a transformation of functions that translates a function from callable as `f(a, b, c)` into callable as `f(a)(b)(c)`. To learn more about the topic go to [wikipedia](https://en.wikipedia.org/wiki/Currying)

## Lists
Lists in Elixir are implemented as linked lists. What that means is that the elements are not stored together in the memory, but rather every element has a pointer to the memory where the next element is stored. Because of that adding elements to the beginning of lists in Elixir is a faster operation than adding it to the end of the list _(Adding an element at the end means that Elixir has to traverse the whole list to find where the end is. In contract adding to the beginning is just as easy as having the new element point to the current list.)_

In linked lists `head` is considered the first element of the list and `tail` is referred to the rest of the list after the `head`, or to the last node in the list. In Elixir a list can be represented by a `head` and a `tail` like so: `[head | tail]`. Where `head` is some value and `tail` is either a list of values or an empty list. Therefore: `[1 | [2, 3]]` which is representation of `[1, 2, 3]` or `[1 | []]` which is representation of `[1]`.

How to visualize linked lists in Elixir
```
[elem_1 | tail]
            |
            |> [elem_2 | tail]
                           |
                           |> [elem_3 | tail]
                                          |
                                          |> []
[1 | [2, 3]]
        |
        |> [2 | [3]]
                 |
                 |> [3 | []]
```
The same can be represented like so:
```
[elem_1 | elem_2 | elem_3 | []]
```
The pipe can be used as much time as there are elements in the list.

Adding an element at the end of a list is done by concatenating another list with a single element. For the concatenation we are using `++`.
```elixir
iex(1)> list = [1, 2, 3]
[1, 2, 3]
iex(2)> list ++ [4]
[1, 2, 3, 4]
```
Here Elixir is traversing the `list` variable to find the end of the list in order to attach the new list. This is an `O(n)` operation, meaning that the more elements there are in a list, the slower the operation becomes.

Adding an element to the beginning is done by simply creating a new list where the `head` is the new value to be added and the `tail` is the current list.
```elixir
iex(1)> list = [1, 2, 3]
[1, 2, 3]
iex(2)> [0 | list]
[0, 1, 2, 3]
```
This is an `O(1)` operation. This means that no matter how many elements are present in the list, the performance is constant.

Let's redo the previous example with variables named `head` and `tail`:
```elixir
iex(1)> head = 0
0
iex(2)> tail = [1, 2, 3]
[1, 2, 3]
iex(3)> [head | tail]
[0, 1, 2, 3]
```

We can use `hd` and `tl` to pull `head` / `tail` from a list:
```elixir
iex(1)> hd([1, 2, 3])
1
iex(2)> tl([1, 2, 3])
[2, 3]
```
Both operations are `O(1)`, because they amount to reading one or the other value from the `[head | tail]` pair.

### Exercises
1. Write a function will capitalize only the first letter for a given String
    ```elixir
    iex(1)> capitalizeFirst("hello")
    "Hello"
    iex(1)> capitalizeFirst("_hello")
    "_hello"
    ```
2. Write a function that given a list of numbers
   1. Returns `true` if the first number in the list is `even`, otherwise returns `false`
   2. Returns a list where each number is multiplied by 5
   3. Returns only the even numbers
   4. Returns a sum of all the numbers multiplied by 5

Notes
1. [`String.graphemes/1`](https://hexdocs.pm/elixir/1.12/String.html#graphemes/1)
2. [`rem`](https://hexdocs.pm/elixir/1.12/Kernel.html#rem/2)
3. [`Enum.map`](https://hexdocs.pm/elixir/1.12/Enum.html#map/2)
4. [`Enum.filter`](https://hexdocs.pm/elixir/1.12/Enum.html#filter/2)
5. [`Enum.reduce`](https://hexdocs.pm/elixir/1.12/Enum.html#reduce/3)