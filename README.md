# Elixir Materials

If you are a beginner this is a good place to start learning Elixir

- [Elixir Materials](#elixir-materials)
  - [Work In Progress](#work-in-progress)
  - [Working with the shell](#working-with-the-shell)
  - [Working with variables](#working-with-variables)
  - [Immutability](#immutability)
  - [Understanding the type system](#understanding-the-type-system)
    - [Atoms](#atoms)
    - [Tuples](#tuples)
  - [Modules](#modules)
  - [Functions](#functions)
  - [Chaining functions](#chaining-functions)
  - [If expressions](#if-expressions)
  - [Cond expressions](#cond-expressions)
  - [Case expression](#case-expression)

## Work In Progress

This repository is (and likely will be for quite some time) a work in progress. Suggestions for
articles on concepts and themes are welcome, as well as corrections/clarifications on already
available material.

## Working with the shell
Elixir as many other languages has an interactive shell where you can immediately jump into trying stuff in Elixir. Basically writing code and getting some results back.

To launch Elixir's shell just type `iex` in your terminal:
```elixir
$ iex
Interactive Elixir (1.13.3) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)>
```

Running `iex` starts an instance of the `BEAM` _(BEAM is the virtual machine used to implement Erlang. Therefore Elixir also runs on it)_ and then starts an interactive Elixir shell inside it.

In the interactive shell you can enter an expression and the shell will return it's result. 
For example:
```elixir
iex(1)> 1 + 1
2
iex(2)
```

With some explanations:
```
iex(1)> 1 + 1 <-- This is the expression we've entered
2 <-- This is the result
iex(2) <-- The shell immediately gives us the next row to enter a new expression
```

**NOTE** Everything is Elixir is an expression that has a return value. This includes not only function calls, but also constructs like `if` and many other which you'll learn more about later on.

You don't need to write everything on one line in the shell. The shell is smart to understand that if you hit Enter and the expression is not finished it will continue on the same row.
```elixir
iex(2)> 1 +
...(2)> 1 +
...(2)> 1 +
...(2)> 2
5
iex(3)>
```

## Working with variables
Elixir is a _dynamic_ language, which means that when you declare a variable you are not specifying a type. The type is going to be automatically determined from the data it contains at the moment. This means that the type can change based on the usage. We can initialize a variable with an integer value and later bind it to a string value without any issue.
```elixir
iex(1)> a = 1
1
iex(2)> a = "hello world"
"hello world"
iex(3)> 
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


## Understanding the type system

This section is not going to go through all types but rather point one the interesting ones and how Elixir goes about them.

### Atoms

Atoms are constants where their name is equal to their value. An atom is denoted by the colon at the beginning. They are usually named now you would name a variable in Elixir _(using snake case)_ - `:atom`.

Interestingly booleans in Elixir are actually implemented as atoms the `:true` and  `:false`, but there is a syntax sugar that make it so that you can use `true` instead of `:true` and `false` instead of `:false`. This is applied to the atom `:nil` as well which is actually the `null` equivalent in other languages.

```elixir
iex(1)> true == :true
true
iex(2)> false == :false
true
iex(3)> nil == :nil
true
```

Atoms are usually used for constants that represent some information. A good example would be for status: `:success` _(or as commonly referred to as `:ok` in Elixir)_ and `:failure` _(or as commonly referred to as `:error` in Elixir)_

**NB** Since atoms are constants where the name is equal to the value they can never change. Once an atom is created it's added to a special atom table in the memory of the BEAM VM. They are never garbage collected and will stay in memory until the system exits. So it's never a good idea to use atoms for things that can grow indefinitely like ids and such or have them be created from an input. BEAM will crash once the limit of atoms is reached. _(You can check your current limit via `:erlang.system_info(:atom_limit)`. That number can be increased, but if you have this problem then you are probably doing something wrong.)_

### Tuples

Tuples are something like untyped structures, or records and they are often used to group a fixed number of elements. When using tuples it is not uncommon to have different types of values for the different elements _(where as in lists you'll most likely lean towards having all elements be only one type)_. 

The following snippet shows how we could use a tuple to contain information about a person's name and age:
```elixir
iex(1)> person = {"Bob", 24}
{"Bob", 24}
```
Where the first element is the name of the person and the second his age.

To pull elements from a tuple we could use `Kernel.elem/2` or `elem/2`, where the first element is the tuple and the second is the index (which is 0 indexed) _(The `Kernel` module is automatically imported into the shell and any module that you create. Therefore you almost never actually need to type the module name when using it's functions)_. 
```elixir
iex(2)> elem(person, 0)
"Bob" 
```

## Modules

Modules are where you'll write your elixir functions. Since Elixir is a functional language, modules are separated by the context of the functions inside.

A modules would look something like this:
```elixir
defmodule MyFirstModule do
  def hello_word do
    "hello world"
  end
end
```

There are couple of things to notice here. 
  - The module name is using `PascalCase`
  - The scope of a module/function/construct is wrapped between `do/end` blocks
  - We are not defining return type of the function `hello_world`
  - We don't have the famous `return` word. Elixir just returns the last expression in the function.
  - The function has no parenthesis. This is because if a function does not take parameter you can omit them.

## Functions

There are two syntaxes for defining a function. A regular one and a short one _(usually used when the function is "one liner")_

```elixir
defmodule MyFirstModule do
  def hello_word do
    "hello world"
  end

  def hello_short, do: "hello world"

  def add(a, b), do: a + b
end
```

Parenthesis can be omitted when the function does not accept parameters. The amount of parameters a function accepts is called `arity`.
When referring to the function `add` it would be like so: `MyFirstModule.add/2` or `add/2` where the `2` is pointing to the `arity`.

## Chaining functions
Elixir has the Pipe `|>` operator which can change functions together, which makes reading function composition so much easier.

Let's say that we want to add the number `5` to the number `2` and repeat that 3 times. 
```elixir
defmodule Math do
  def add(a, b), do: a + b
  
  def add_3_times(a, b) do
    a
    |> add(b)
    |> add(b)
    |> add(b)
  end
end
```
Of course this just for illustrative purpose on how piping works. 
Note that we are piping from the very beginning. First the variable `a` to the function `add` in which we need to pass a second argument, in our case the is the variable `b`.
Then we pipe another `add` function, which takes the result of the first `add` function as the first parameter and the variable `b` as the second and so on.
At the end the function `add_3_times` returns the result from this whole chaining, which in this case would be `11`.

## If expressions
If expressions are a little bit different in the sense that there is no `else if`. It's either true or not. The only thing you have to remember that is different from what you are probably used to is that they are actually expressions so they return a value and you have to be careful sometimes with that.

Lets see an example:
```elixir
def hello(language) do
  if (language == "spanish") do
    "hola"
  else 
    "hi"
  end
end
```

Here we can see that it doesn't seem like the function returns anything, but it actually returns the result of the `if` expression. So it would either return "hola" or "hi".

A thing to be careful with is that if you don't provide an `else` case, the `if` will return a `nil` value _(the equivalent to a `null` in other languages)_. So take it as a rule that if you are going to use the result of the `if`, always provide an `else` case.

```elixir
def hello(language) do
  this_value_might_be_nil = 
    if (language == "spanish") do
      "hola"
    end

  this_value_might_be_nil
end
```

In this example, we are binding the variable `this_value_might_be_nil` to the result of the `if`, but since the `if` doesn't have an `else` case, when the `language` that is passed is not "spanish" the result will be `nil`.


## Cond expressions
Cond is the expression you are looking for the cases where you need an `else if` branch. In `cond` you can have as many conditions as you'll like and usually ends with a default case. _(similar to how switch works in other languages)_

```elixir
def hello(language, name) do
  greeting = cond do
    language == "spanish" -> "hola"
    language == "german" -> "bonjour"
    true -> "hello"
  end

  "#{greeting} #{name}"
end
```

## Case expression

Case 