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
    - [Lists](#lists)
    - [Maps](#maps)
    - [Keyword List](#keyword-list)
    - [Range](#range)
  - [First-class functions](#first-class-functions)
  - [Modules](#modules)
  - [Functions](#functions)
  - [Chaining functions](#chaining-functions)
  - [If expressions](#if-expressions)
  - [Unless expression](#unless-expression)
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

As we mentioned before Elixir's type system is dynamic, meaning that when we are creating variables and function we don't need to specify types. Types are automatically inferred from the value that you bind them to. Variables can change types as well. You can assign a variable to a string and then to a number on the next line. This is usually not a good idea because it just brings confusion and opens a door for potential bugs, yet the language allows it, so keep that in mind. Elixir has most of the types that you probably are familiar with and a few that might be new to you. Some have quirks and this section is going to showcase the potential new types you might encounter and some of the ones that you are familiar with but have some quirks in Elixir.

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

### Lists
List is type that you might be very familiar with, but in Elixir it has some quirks that are good to know.
Lists in Elixir are implemented as linked lists. What that means is that the elements are not stored together in the memory, but rather every element is has a pointer to the memory where the next is stored. `[elem1 | rest -> [elem2 | rest -> [elem3 | rest -> []]]]`. Because of that adding elements to the beginning of lists in Elixir is a faster than adding it to the end of the list _(Adding an element at the end means that Elixir has to traverse the whole list so that it find where the end. In contract adding to the beginning is just as easy as pointing the next element to the current list.)_

Adding an element to the end of a list
```elixir
iex(1)> list = [1, 2, 3]
[1, 2, 3]
iex(2)> list ++ [4]
[1, 2, 3, 4]
```
Adding an element at the end of a list is done by concatenating another list with a single element. For the concatenation we are using `++`. Here Elixir is traversing the `list` variable to find where the end of the list is in order to attach the new list. This is an `O(n)` operation. This means that depending on how many elements there are in the list, the slower the operation becomes.

Adding an element to the beginning
```elixir
iex(1)> list = [1, 2, 3]
[1, 2, 3]
iex(2)> [0 | list]
[0, 1, 2, 3]
```
Here we are using the `|` symbol for attaching a new `"head"` to the list. Here Elixir is creating a list where the head is '0' and a pointer to the rest of the list pointing to where '[1, 2, 3]' is stored in memory. This is an `O(1)` operation. This means that no matter how many elements are present in the list, the performance is constant. _("head" is called the first element of a list, where as "tail" is the rest of the list. For the list [0, 1, 2, 3], '0' is the "head" and '[1, 2, 3]' is the "tail")_

Let's represent the previous example with `head` and `tail`:
```elixir
iex(1)> head = 0
0
iex(2)> tail = [1, 2, 3]
[1, 2, 3]
iex(3)> [head | tail]
[0, 1, 2, 3]
```

We can use `hd` and `tl` to pull `head` / `tail` respectively from a list:
```elixir
iex(1)> hd([1, 2, 3])
1
iex(2)> tl([1, 2, 3])
[2, 3]
```
Both operations are `O(1)`, because they amount to reading one or the other value from the (head, tail) pair.

### Maps

As you probably know maps are a structure which is a key/value based, where a key points to a value. Keys in Maps are indexed, meaning that you have direct access _O(1) operation_ to a value. They are mainly used for structuring data and information. Think of it like a tuple where you actually have a key for the values.

Maps in Elixir are not that different from the ones in other languages. Here you'll see how they are written and some little quirks about them.

The following snippet demonstrates how to create a map.
```elixir
iex(1)> person = %{:name => "Georgi", :age => 27}
%{name: "Georgi", age: 27}
```
What you'll notice is that on the next line our map looks a little bit different, instead of the fat arrows `=>` it has a colon `:` and the colon of the atom is gone. This is just a syntax sugar for visualizing maps when all of the keys are atoms. If there is even one key which is not an atom, this won't be the case.

```elixir
iex(1)> person = %{:name => "Georgi", :age => 27, "works_at" => "Quanterall"}
%{:name => "Georgi", :age => 27, "works_at" => "Quanterall"}
```

When you are only using atoms you can actually write the map using the short syntax
```elixir
iex(1)> person = %{name: "Georgi", age: 27}
%{name: "Georgi", age: 27}
```

To retrieve a field from a map you can use the access operator `[]`
```elixir
iex(1)> person = %{name: "Georgi", age: 27}
%{name: "Georgi", age: 27}
iex(2)> person[:name]
"Georgi"
iex(3)> person[:non_existing_field]
nil
```

If you are accessing fields which keys are atoms you can access field with the `.` operator
```elixir
iex(1)> person = %{name: "Georgi", age: 27}
%{name: "Georgi", age: 27}
iex(2)> person.name
"Georgi"
iex(3)> person.non_existing_field
** (KeyError) key :b not found in: %{:a => 1, "b" => 2}
```

**NB** _Note that when you are accessing field with the `.` operator if the key is missing from the map, this throws an exception, where as using the `[]` operator you get `nil`_

Modifying values in Map can be done either with a function from the `Map` module or by using the syntax for updating a Map
```elixir
iex(1)> person = %{name: "Georgi", age: 27}
%{name: "Georgi", age: 27}
iex(2)> %{person | age: 28}
%{name: "Georgi", age: 28}
iex(3)> person
%{name: "Georgi", age: 27}
iex(4)> %{person | non_existing_key: 1}
** (KeyError) key :non_existing_key not found in: %{age: 27, name: "Georgi"}
    (stdlib 3.16.1) :maps.update(:non_existing_key, 1, %{age: 27, name: "Georgi"})
    (stdlib 3.16.1) erl_eval.erl:256: anonymous fn/2 in :erl_eval.expr/5
    (stdlib 3.16.1) lists.erl:1267: :lists.foldl/3
```
**NB** _Notice that we are not updating value bound to the `person` variable. This update syntax is an expression, so it returns a result._

If you want to update the `person` variable to the result of the update Map you have to rebind the variable.

```elixir
iex(1)> person = %{name: "Georgi", age: 27}
%{name: "Georgi", age: 27}
iex(2)> person = %{person | age: 28}
%{name: "Georgi", age: 28}
iex(3)> person
%{name: "Georgi", age: 28}
```

### Keyword List
A keyword list is a special type of list where each element is a tuple of 2 elements and the first element of each tuple is an atom. The second element can be of any type.
```elixir
iex(1)> [{:monday, 1}, {:tuesday, 2}, {:wednesday: 3}]
```

Elixir allows a nicer way of writing this.
```elixir
iex(1)> [monday: 1, tuesday: 2, wednesday: 3]
```
Both structures yield the same result, just the syntax is different. If you map on a keyword list each element will be a tuple. 

**NB** _Don't forget that you are dealing with a list here. The lookup operation is still an O(n) operation._

### Range
A range is an abstraction that allows you to represent a range of numbers. Elixir provides a special syntax for defining ranges.
```elixir
iex(1)> 1..3
1..3
```
It looks kind of strange. So can we work with ranges? Well ranges are treated enumerable, therefore you can use it with all functions from the `Enum` module. You can even create a list of the range.
```elixir
iex(1)> Enum.to_list(1..3)
[1, 2, 3]
iex(2)> Enum.map(1..3, fn v -> v + 1 end)
[2, 3, 4]
```
As you can see, after going through the `Enum.map` function the range has converted to a list. Keep in mind that _range_ is not a separate type in Elixir, it's just representation of a range of numbers. 

**NB** _Ranges are really small in footprint, so even a million number range will be small_

## First-class functions
In Elixir a function is a first-class citizen, which means that it can be bound to a variable, which won't execute it, but it will bind the function definition instead, so you can use the variable now to call the function. 

Let's see how this looks in actions
```elixir
iex(1) square = fn v -> v * v end
#Function<44.65746770/1 in :erl_eval.expr/5>
iex(2) square.(5)
25
```
Calling the function might look a little weird because we have to put a dot between the variable name and the brackets. The reason why the dot is there is to differentiate an anonymous function from a regular one. This way, when you see how a function is called you'll immediately know whether it's anonymous or not.

If the function doesn't take any arguments nothing much will change
```elixir
iex(1)> returns_5 = fn -> 5 end
#Function<45.65746770/0 in :erl_eval.expr/5>
iex(2)> returns_5.()
5
```

Because functions can be bound to a variable they can be passed as a parameter to other functions.

```elixir
iex(1) square = fn v -> v * v end
#Function<44.65746770/1 in :erl_eval.expr/5>
iex(2) Enum.map(1..3, square)
[1, 4, 9]
```

Bare in mind that when you pass some function instead of typing out the required anonymous function you have consider how many parameters is the anonymous function requiring. If you pass more or less than it should have it will crash, because it cannot invoke your function.

```elixir
iex(1)> times = fn (v, t) -> v * t end
#Function<44.65746770/1 in :erl_eval.expr/5>
iex(2)> Enum.map(1..3, times)
** (BadArityError) #Function<43.65746770/2 in :erl_eval.expr/5> with arity 2 called with 1 argument (1)
    (elixir 1.13.3) lib/enum.ex:1597: anonymous fn/3 in Enum.map/2
    (elixir 1.13.3) lib/enum.ex:4136: Enum.reduce_range/5
    (elixir 1.13.3) lib/enum.ex:2400: Enum.map/2
```

Elixir has a special _capture_ operator `&` which is used if you want to reference a regular _(non lambda)_ function. It has a special syntax that you have to follow in order to use it. That syntax is: `&Mod.fun/arity` where `Mod` is the module name, `fun` is the function name and `arity` is the amount of argument that this function is taking. The module name can be omitted though `&fun/arity`
```elixir
iex(1)> Enum.map(1..3, fn v -> to_string(v) end)
["1", "2", "3"]
iex(2)> Enum.map(1..3, &Kernel.to_string/1)
["1", "2", "3"]
iex(3)> Enum.map(1..3, &to_string/1)
["1", "2", "3"]
```

Similar to named functions, anonymous function can have multiple bodies, where the body is chosen based on pattern matching
```elixir
iex(1)> my_fun = fn
...(1)> [] -> "empty list"
...(1)> [_] -> "list with 1 element"
...(1)> [_ | _] -> "list with at least 1 element"
...(1)> end
#Function<42.3316493/1 in :erl_eval.expr/6>
iex(2)> my_fun([])
"empty list"
iex(3)> my_fun([1])
"list with 1 element"
iex(4)> my_fun([1, 2])
"list with at least 1 element"
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

Bare in mind that this is the same as doing. You don't need the variable in the upper example.
```elixir
def hello(language) do
  if (language == "spanish") do
    "hola"
  end
end
```

## Unless expression
The _unless_ expression is basically an opposite `if`, where the negative statement goes first and then the positive.
```elixir
def hello(language) do
  unless language == "english" do
    "hola"
  else 
    "hello"
  end
end
```
Don't overuse the _unless_ expression though. Whenever it makes sense go for it, but otherwise don't try to use it where an _if_ makes more sense for reading the code.

## Cond expressions
The _cond_ expression is what you are looking for the cases where you need an `else if` branch. In `cond` you can have as many conditions as you'll like and usually ends with a default case. _(similar to how switch works in other languages)_

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

**TBA**