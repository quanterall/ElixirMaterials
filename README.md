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
  - [Named Functions](#named-functions)
  - [Guards](#guards)
    - [Where can guards be used?](#where-can-guards-be-used)
    - [Defining your own guards](#defining-your-own-guards)
  - [Chaining functions](#chaining-functions)
  - [If expressions](#if-expressions)
  - [Unless expressions](#unless-expressions)
  - [Cond expressions](#cond-expressions)
  - [Case expressions](#case-expressions)
  - [With expression](#with-expression)
  - [Concurrency](#concurrency)
    - [Creating a process](#creating-a-process)
    - [Message passing](#message-passing)

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
iex(1)> 1 +
...(1)> 1 +
...(1)> 1 +
...(1)> 2
5
```

In the `iex shell` you can see the documentation of every function by just calling `h` in front of the function for which you want to see the docs (if there are any).
```elixir
iex(1)> h Enum.at

                def at(enumerable, index, default \\ nil)                 

  @spec at(t(), index(), default()) :: element() | default()

Finds the element at the given index (zero-based).

Returns default if index is out of bounds.

A negative index can be passed, which means the enumerable is enumerated
once and the index is counted from the end (for example, -1 finds the
last element).

## Examples

    iex> Enum.at([2, 4, 6], 0)
    2
    
    iex> Enum.at([2, 4, 6], 2)
    6
    
    iex> Enum.at([2, 4, 6], 4)
    nil
    
    iex> Enum.at([2, 4, 6], 4, :none)
    :none
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
A range is an abstraction that allows you to represent a sequence of zero, one or many, ascending or descending integers. Ranges are always inclusive and they may have a custom step.
```elixir
iex(1)> 1..3
1..3
```
It looks kind of strange. When we type it out, the result is exactly what we wrote. So can we work with ranges? Well ranges are treated as an enumerable, therefore you can use it with all functions from the `Enum` module. You can even create a list of the range.
```elixir
iex(1)> Enum.to_list(1..3)
[1, 2, 3]
iex(2)> Enum.map(1..3, fn v -> v + 1 end)
[2, 3, 4]
```
As you can see, after going through the `Enum.map` function the range has converted to a list. Keep in mind that _range_ is not a separate type in Elixir, it's just representation of a range of numbers.

You can have a range with a custom step as well
```elixir
iex(1)> Enum.to_list(1..10//2)
[1, 3, 5, 7, 9]
iex(2)> Enum.to_list(20..100//20)
[20, 40, 60, 80, 100]
```

You can have a negative step as well
```elixir
iex(1)> Enum.to_list(100..10//-20)
[100, 80, 60, 40, 20]
```

Internally ranges are represented as structs
```elixir
iex(1)> range = 10..100//20
10..100//20
iex(2)> range.first
10
iex(3)> range.last
100
iex(4)> range.step
20
```
Or you could just pattern match the structure like so
```elixir
iex(1)> range = 10..100//20
10..100//20
iex(2)> first..last//step = range
10..100//20
iex(3)> first
10
iex(4)> last
100
iex(5)> step
20
```

Useful to know is that there is a `Range` module and we can use it to construct a range or get it's size through the `Range.size/1` function.
```elixir
iex(1)> range = Range.new(2, 10, 2)
2..10//2
iex(2)> Range.size(range)
5
iex(3)> Range.size(Range.new(1, 1_000_000))
1000000
```

Although since `Range` is implemented as an Enumerable, you could just as well call `Enum.count` to get the size
```elixir
iex(1)> Enum.count(Range.new(1, 1_000_000))
1000000
```

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

## Named Functions

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

A function can be set as _private_ by defining it with `defp` instead of `def`. This means that this function cannot be used outside the scope of the Module in which is defined.

## Guards
Guards are a way to provide additional binary checks to your function. Not all expressions are allowed in guard clauses. Yet they can be very helpful to _guard_ your function from being called.

This might sound confusing, so let's see an example:

```elixir
# If we pass an odd number the guard will fail, therefore
# Elixir will attempt the next function in line.
def even?(num) when rem(num, 2) do
  :even
end

def even?(_) do
  :odd
end
```
As you can notice guards are added using the `when` clause, just before the `do`

You can have multiple guards using `and` and `or`, the same way you can do in an `if` statement.
```elixir
def even?(num) when num > 10 and rem(num, 2) do
  :even
end

def even?(_) do
  :odd
end
```

### Where can guards be used?
They can be used in variety of constructs. Such like `case`, `for`, `with` etc.
You can used them in lambda functions as well. 

Guards in a lambda function
```elixir
iex(1)> my_fun = fn 
...(1)> num when num < 10 -> "Less than 10"
...(1)> num when num >= 10 and num <= 99 -> "Between 10 and 99"
...(1)> num when num >= 100 and num < 999 -> "Between 100 and 999"
...(1)> _ -> "More than 1000"
...(1)>end
```

Guards in a case expression
```elixir
case number do
  num when num < 10 -> "Less than 10"
  num when num >= 10 and num <= 99 -> "Between 10 and 99"
  num when num >= 100 and num < 999 -> "Between 100 and 999"
  _ -> "More than 1000"
end
```

### Defining your own guards
You might find yourself using the same multiple guards in multiple functions. To alleviate this issue you can create your own custom guard that will combine these checks in one single guard.

```elixir
defmodule MyModule do
  def my_function(number) when is_integer(number) and rem(number, 2) == 0 do
    # do stuff
  end
end
```
Instead of having these 2 guards, we can combine the checks in a custom guard and use it instead

```elixir
defmodule MyModule do
  defguard is_even(value) when is_integer(value) and rem(value, 2) == 0

  def my_function(value) when is_even(value) do
    # do stuff
  end
end
```

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

## Unless expressions
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
The _cond_ expression is what you are looking for the cases where you need an `else if` branch. In `cond` you can have as many conditions as you like and usually ends with a default _(true)_ case. _(similar to how switch works in other languages)_

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

If you do not provide a default _(true)_ branch/case and end up where all other cases return `false` the `cond` will throw an Exception at you. So it's important to always keep a default _true_ branch/case.

```elixir
iex(1)> cond do
...(1)> 1 == 2 -> 1
...(1)> 1 == 3 -> 1
...(1)> end
** (CondClauseError) no cond clause evaluated to a truthy value

iex(2)> cond do
...(2)> 1 == 2 -> 1
...(2)> 1 == 3 -> 1
...(2)> true -> "oh well.."
...(2)> end
"oh well.."
```

## Case expressions
The _case_ expression is used when we want to handle multiple possible pattern matches and depending on which pattern match matches it will execute the code in that block.

The syntax goes as follows:
```elixir
case expression do
  pattern_1 ->
    ...
  pattern_2 ->
    ...
  ...
end
```
You can have as many patterns as you wish. The important think to consider here is the order of the patterns. Since a pattern match can either be vague or strict you should always go from strict to vague patterns.

```elixir
case expression do
  {:ok, value} -> value
  {:error} -> "Error"
end
```
In this scenario we wouldn't really care which pattern goes before which, because they don't overlap. Here is an example of when they overlap.

```elixir
case expression do
  {:ok, [elem]} -> elem
  {:ok, list} -> list
  {:ok, []} -> "empty"
end
```

Here the second pattern actually matches for empty list as well, therefore the 3rd pattern `{:ok, []}` will never be reached. A more valid order would be the following:
```elixir
case expression do
  {:ok, []} -> "empty"
  {:ok, [elem]} -> elem
  {:ok, list} -> list
end
```
This way we go from as strict as we can go to more and more vague patterns.

Bare in mind that you should make sure that you handle all the possible cases in your patterns. If you do not, and end up with value that does not match in any of the given pattens, the case will throw an exception:
```elixir
iex(1)> case 10 do
...(1)> 1 -> 1
...(2)> 2 -> 2
...(2)> end
** (CaseClauseError) no case clause matching: 10
```

In these situations you can add a pattern that catches everything, which could be either a variable (if you care about the value), or an underscore `_` if you don't:
```elixir
case 10 do
  1 -> 1
  2 -> 2
  n -> n
end

case 10 do
  1 -> 1
  2 -> 2
  _ -> "The number is neither 1 or 2"
end
```

The `case` expression can be represented with functions holding different pattern matches in the arguments.
For example the following `case` can be represented with these functions:
```elixir
def num(n) do
  case n do
    1 -> 1
    2 -> 2
    _ -> "The number is neither 1 or 2"
  end
end

def num_(1), do: 1
def num_(2), do: 2
def num_(_), do: "The number is neither 1 or 2"
```
Depending on the situation, having the pattern match in the function arguments can be more descriptive. Use your judgement to determine in which scenario which approach you'll take.

## With expression
The `with` expression is a combination of multiple nested `case` expressions. It is very useful to reduce clutter in your code and follow the "happy" path of your logic. Let's give an example

You could write a logic like so, with 2 `case` expressions
```elixir
case condition1 do
  success_pattern ->
    case condition2 do
      success_pattern ->
        # do something here
      error_pattern ->
        # some error
    end
  error_pattern ->
    # some error
end
```

As you can see it doesn't look very clean when you nest 2 `case` expressions and it gets worse with each additional nested `case`.
We can simplify this logic using `with`
```elixir
with success_pattern1 <- condition1,
     success_pattern2 <- condition2 do
  # do something here
end
```

In this example the `with` expression is not handling the different errors _(unsuccessful pattern matches)_ that each condition might result to. It's just propagating it as the result of the `with`. If we'd like to alter what the `with` expression is going to return for each of those errors, we can add an `else` clause like so:
```elixir
with success_pattern1 <- condition1,
     success_pattern2 <- condition2 do
  # do something here
else
  error_pattern1 ->
    # some error
  error_pattern2 ->
    # some error
end
```

## Concurrency
This section is about the primitives that Elixir/Erlang exposes for dealing with processes. In Elixir processes are really light weight. It takes only a couple of microseconds to create a single process and its initial memory footprint is a few kilobytes. For that reason Elixir/Erlang are famous for starting millions of processes without much of a sweat. (_The theoretical limit imposed by the BEAM VM is 134 million_).

_In BEAM a process is a concurrent thread of execution. Two processes run concurrently and may even run in parallel of at least two CPU cores are available. BEAM processes are handled by the VM, which uses it's own scheduler to manage their concurrent execution. By default BEAM uses as many schedulers as there are CPU cores available. For example, if you have 4 core machine, it will start 4 schedulers. A scheduler is in charge of the interchangeable execution of the processes. Meaning that the scheduler is responsible for making sure that each process get its fare share of execution time. When the time slot which has been granted for a process is over, the running process is  and the next one takes over. That principle is then repeated for each process until all of them finish their execution. Because of the way the BEAM schedulers work, there isn't a possibility for a process to hang the whole VM, because when it's time is up, it will be preempted and the next process will get some execution time. Meaning, one bad process cannot ruin a whole system._

BEAM processes are completely isolated. They don't share memory or state and a crash of one process does not affect the rest that are running. Each process handles it's own state and when a process dies the state dies with it. Because of this isolation in order for the processes to communicate with each other they send messages between themselves. 


### Creating a process
In order to create a simple process we can use the `Kernel.spawn/1` function which takes a function with 0 arguments. The function that you pass to `Kernel.spawn/1` is the one that will be executed in a separate process (i.e the process that is started by the `Kernel.spawn/1` function). That process is short lived and as soon as the execution of the function that you passed is over, the process will die.

```elixir
iex(1)> spawn(fn -> IO.inspect("hello world") end)
#PID<0.109.0>
"hello world"
```
The returned value of the `Kernel.spawn/1` function is this _#PID<0.109.0>_ which is called `pid` or (process id). The `pid` is basically an address that points to a specific process. Used as a way to reference a process.

We can check that the process has died using the `Process.alive?/1` function, but we have to take a hold on the pid that is returned by the `Kernel.spawn/1` function
```elixir
iex(1)> pid = spawn(fn -> IO.inspect("hello world") end)
#PID<0.109.0>
"hello world"
iex(2)> Process.alive?(pid)
false
```

For a more concrete example let's say simulate a function that take some time to execute. (_We can simulate this via the `Process.sleep/1` function_)
```elixir
iex(1)> long_task = fn id ->
...(1)>   Process.sleep(2_000)
...(1)>   "#{id} has finished"
...(1)> end
#Function<42.3316493/1 in :erl_eval.expr/6>
```

When we execute the function it takes it 2 seconds to return the result (_which is what we are expecting_)
```elixir
iex(2)> long_task.(1)
"1 has finished"
```

If we decide to run multiple of these what we'll see is that the first one has to finish in order for the second to start executing and so forth. When we execute the following code it takes it 10 seconds to return the result (_Again this makes absolute sense since we started 5 tasks where each one takes 2 seconds to finish_).
```elixir
iex(3)> Enum.map(1..5, fn id -> long_task.(id) end)
["1 has finished", "2 has finished", "3 has finished",
 "4 has finished", "5 has finished"]
```

So let's create an function that would run this long task in a separate process. (_Here we are using `IO.inspect/1` in order to get the result printed in the terminal. Later we'll look into how processes can send information between each other._) 
```elixir
iex(4)> async_long_task = fn id ->
...(4)>   spawn(fn -> IO.inspect(long_task.(id)) end)
...(4)> end
#Function<42.3316493/1 in :erl_eval.expr/6>
iex(5)> async_long_task.(1)
#PID<0.133.0>
"1 has finished"
```
Here it takes us again 2 seconds in order to get the result printed on the screen. Which at this point is no different than the synchronous long task, but let's see what happens when we call multiple of these.
```elixir
iex(5)> Enum.map(1..5, fn id -> async_long_task.(id) end)
[#PID<0.123.0>, #PID<0.124.0>, #PID<0.125.0>, #PID<0.126.0>,
 #PID<0.127.0>]
"1 has finished"
"2 has finished"
"3 has finished"
"4 has finished"
"5 has finished"
```

This only took 2 seconds to complete. This is because we started 5 processes which wre running concurrently and therefore finishing at the same time. As we stated earlier processes are completely isolated and independent of each other. We don't get access to the results that were produced by the processes which works perfectly fine when we don't care about them.


### Message passing
As we have already mentioned, processes are completely isolated from each other and don't share memory. In Elixir processes communicate via messages. In order for process A to make process B do something, it needs to send a message. Each process has a so called `mailbox`. When process A send a message to process B, a new message appears in the `mailbox` of process B. Processes can read messages from their `mailboxes` at any time. Messages are of type `term`, meaning you can send any type of data. Because processes can't share memory, a message is deep-copied when it's sent. This is done so that process A may die at any point in time, even if process B hasn't yet read the message from the `mailbox`. The process `mailbox` is a FIFO queue limited only by the available memory. When processes read messages from the queue, they are consumed in order of arrival.

**NB:** A message can only be removed from the `mailbox` (_the queue_) by consuming it. There is no way to unsent a message or delate a message from the `mailbox`.

Sending a message to a process is done using the `Kernel.send/2` function.
```elixir
iex(1)> terminal_pid = self()
#PID<0.107.0>
iex(2)> spawn(fn -> send(terminal_pid, "Hello from #{inspect(self())}") end)
#PID<0.139.0>
```

There are a few things to unwrap in this example. First we used `Kernel.send/0` function in order to obtain the pid of the shell (_Keep in mind that the terminal is a process on it's own_). We need that pid, because we want to send a message from a brand new process to the process of the shell. Then we spawn a new process and inside it's function we call `send/2` where we specify that the receiver of the message is the `terminal_pid` and we want to send a message `Hello from {pid_of_the_caller}`. As you may notice, inside the function we again call `self/0` but this time this call will yield the pid of the spawned process (in our case that is `#PID<0.139.0>`, as we can see from the result of the `spawn/1` function). Once this is called, the shell process receives a new message in it's `mailbox`.

In order to receive a message from the `mailbox` of a process we need to use the `receive do` block. Which as the name implies is used to receive messages.

```elixir
iex(3)> receive do
...(3)>   message -> "Received message: #{message}"
...(3)> end
"Received message: Hello from #PID<0.139.0>"
```

The `receive do` block works almost the same way as the `case do` block. We can implement multiple pattern matches in order to handle various types of incoming messages. In our case we'll do a simple _match all_ pattern and just return a string with the message.

```elixir
iex(4)> spawn(fn -> send(terminal_pid, {:message, "Hello World", self()}) end)
#PID<0.160.0>
iex(3)> receive do
...(3)>   {:message, message, sender} -> "Received message from [#{inspect(sender)}]: #{message}"
...(3)> end
"Received message from [#PID<0.162.0>]: Hello World"
```

If there are no message left in the `mailbox` of a process the `receive do` block will wait indefinitely for a new message to arrive. This means that the process in which you called the `receive do` block will hang (_until a new message arrives_).

```elixir
iex(1)> receive do
...(1)>   message -> message
...(1)> end # <---- Here the shell will hang if there are no messages left in the mailbox
```

In order to overcome this problem we can attach a time frame to the `receive do` block. After that time has passed it can do something else.

```elixir
iex(1)> receive do
iex(1)>   message -> message
iex(1)> after
iex(1)>   5_000 -> "Mailbox is empty"
iex(1)> end # <--- Result will be visible after 5 seconds, the mailbox of the shell process is empty
"Mailbox is empty"
```

The `receive do` block reads only one message at a time. It was already mentioned that messages in the process `mailbox` are stored in a queue. But this doesn't mean that you are supposed to consume them in that order. When `receive do` is trying to read messages from the queue, it will play them in their order through the patten match that was specified. If the first message passes the pattern match, that message will be read. If it doesn't match `receive do` will try with the next one and so forth until it either finds a message that passes or reaches the end. If there is an `after` block when it reaches the end, it will execute the code inside it.

Let's see how this works out
```elixir
iex(1)> shell_pid = self()
#PID<0.107.0>
iex(2)> spawn(fn -> send(shell_pid, "first message") end)
#PID<0.110.0>
iex(3)> spawn(fn -> send(shell_pid, {:msg, "second message"}) end)
#PID<0.112.0>
iex(4)> receive do
...(4)>   {:msg, msg} -> msg
...(4)> end
"second message"
```

As you can see we read the second message in the queue, because the first one didn't match the pattern in the `receive do` block. The first message is still unhandled, so it remains in the `mailbox` waiting to be processed. We can read it if we do a "catch all" pattern match.

```elixir
iex(5)> receive do
...(5)>   msg -> msg
...(5)> end
"first message"
```

**NB** Messages keep their order in the queue, even if they don't match the specified pattern. They will always be executed in order, yet the message that will be read is the first one that matched the given pattern. Messages remain in the `mailbox` until they are processed or the process dies.

Now we can change the code we did for `async_long_task` to actually send the response back to the caller.
```elixir
iex(1)> long_task = fn id ->
...(1)>   Process.sleep(2_000)
...(1)>   "#{id} has finished"
...(1)> end
#Function<42.3316493/1 in :erl_eval.expr/6>
iex(2)> async_long_task = fn id -> 
...(2)>   caller = self() # <- Here we are taking the pid of the 'caller', which in our case is the shell
...(2)>   spawn(fn -> send(caller, {:result, long_task.(id)}) end)
...(2)> end
#Function<42.3316493/1 in :erl_eval.expr/6>
iex(3)> Enum.each(1..5, fn num -> async_long_task.(num) end) # <- Here we are calling `async_long_task/1` 5 times
:ok # <- This means that all the tasks have been called and now we can start consuming the results
iex(4)> reader = fn -> # <- We'll do a utility function that calls `receive do` for ease of use
...(4)>   receive do
...(4)>     {:result, data} -> data
...(4)>   end
...(4)> end
#Function<43.3316493/0 in :erl_eval.expr/6>
iex(5)> Enum.map(1..5, fn _ -> reader.() end) # <- We can use `Enum.map` here to read the results
["1 has finished", "2 has finished", "3 has finished",
 "4 has finished", "5 has finished"]
```

**NB** An important note to be made is that `self/0` returns the pid of the process in which it is called. So make sure you are calling it in the correct process. In the example above we had to make sure to call `self/0` outside the `spawn/1` function in order to take the pid of the shell and not the pid of the process which will be started by calling `spawn/0`.


The processes that we created so far were short lived processes. They start, they do their job and then they die. They don't hold and state and therefore we cannot do a lot of interesting things with such a process. Holding state is essential to have some meaningful logic. In order to do that with processes we have to make sure to keep the process alive after it finishes it's task. 

What we could do to accomplish this would be to have a `receive do` block that would wait for a message to come with some instructions on what to do, and after the job is done, to call `receive do` block again in order to wait for another message with instructions to come. The process will be kept alive because it's waiting for a message and will stay there until a message arrives. Writing this down in the shell would to too cumbersome, so let's write an Elixir module (that would be a file that ends with an `.ex` extension).

```elixir
defmodule TodoServer do
  # Starts a process and calls `loop/1` inside, which recursively will hold the process alive
  def start() do
    spawn(fn -> loop([]) end)
  end

  # Here is the looping logic that will keep this process alive. The loop function calls the 
  # `receive do` block and after it executes the necessary task it takes the result,
  # which in our case is the new state and calls `loop/1` again.
  defp loop(state) do
    new_state = receive do 
      {:add, todo} -> [%{id: length(state) + 1, name: todo} | state]
      {:remove, id} -> Enum.filter(state, fn %{id: todo_id} -> id !== todo_id end)
      :show -> IO.inspect(state)
    end

    # Call `loop/1` again to keep the process going
    loop(new_state)
  end
end
```
We have 3 actions that are available through the TodoServer. 
1. Add a todo
2. Remove a todo
3. Show all todos

Let's see how this code works in action
```elixir
iex(1)> TodoServer.start() # <- We forgot to bind the pid to a variable
#PID<0.520.0>
iex(2)> todo_server = pid(0, 520, 0) # <- We can always create a pid using the `pid/3` function
#PID<0.520.0>
iex(3)> Process.alive?(todo_server) 
true
iex(4)> send(todo_server, {:add, "mop the floors"})
{:add, "mop the floors"}
iex(5)> send(todo_server, {:add, "clean the dust"})
{:add, "clean the dust"}
iex(5)> send(pid, :show)
[${id: 2, name: "clean the dust"}, %{id: 1, name: "mop the floors"}]
:show
iex(6)> send(pid, :unknown) # <- Sending an unknown message to the process won't cause issues
:unknown                    # <- The message will stay in the message box and never be processed
```