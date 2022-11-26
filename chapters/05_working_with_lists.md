- [Working with lists](#working-with-lists)
  - [List comprehension](#list-comprehension)
    - [Nested `for`](#nested-for)
    - [Filtering out values](#filtering-out-values)
    - [The :uniq option](#the-uniq-option)
    - [The :into option](#the-into-option)
    - [The :reduce option](#the-reduce-option)
    - [Exercises](#exercises)
  - [List comprehension alternatives](#list-comprehension-alternatives)
    - [Enum.map/2](#enummap2)
    - [Enum.filter/2](#enumfilter2)
    - [Enum.reduce/3](#enumreduce3)
    - [Enum.each/2](#enumeach2)
    - [Exercises](#exercises-1)
  - [Why to avoid the `for` comprehension](#why-to-avoid-the-for-comprehension)

# Working with lists

## List comprehension
`For` is a list comprehension construct that can be used to iterate and transform enumerables. 

A simple example would be to have a list of numbers and double the value of each number.
```elixir
iex> list = [1, 2, 3, 4]
iex> for n <- list do
iex>   n * 2
iex> end
[2, 4, 6, 8]
```

Bear in mind that as with every other expression in Elixir, the value that the variable `list` is pointing to has not changed.

```elixir
iex> list
[1, 2, 3, 4]
```

In order to capture the result to the variable `list` a rebinding needs to occur.

```elixir
iex> list = for n <- list do # <- From here on, `list` will point to the result of the expression
iex>   n * 2
iex> end
iex> list
[2, 4, 6, 8]
```

If the list comprehension is short in code, the shorthand `, do:` can be used.
```elixir
iex> for n <- 1..10, do: n ** 2 # <- Return all numbers from 1 to 10 to the power of 2
[1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
```

### Nested `for`

List expressions can be nested into each other to perform nested iterations on multiple collections.
```elixir
iex> for x <- [1, 2], y <- [3, 4] do
iex>   x * y
iex> end
[3, 4, 6, 8]
```

### Filtering out values

Filters in list comprehensions can be used to filter out / remove a value from the iteration and they are written before the `do` keyword. They must evaluate to `truthy` values (everything except `nil` or `false`). If the filter produces a `falsy` value, the current element is discarded.
```elixir
iex> for n <- [1, 2, 3, 4], rem(n, 2) == 0 do 
iex>   n
iex> end
[2, 4]
```

More than one filter can be declared, where each filter is separated by a comma.
```elixir
iex> for n <- [1, "string", 2, :atom, 3, 4], is_integer(n), rem(n, 2) == 0 do
iex>   n
iex> end
[2, 4]
```

When working with nested list comprehensions, filters can either be written at the end, or can go after each corresponding comprehension. _Of course filters should declared after the corresponding comprehension._

Here both list expressions are valid in terms of syntax.
```elixir
iex> for x <- [1, 2, 3, 4, :five], y <- [:one, 10, 20], is_integer(x), is_integer(y) do
iex>   x * y
iex> end
[10, 20, 20, 40, 30, 60, 40, 80]
iex> for x <- [1, 2, 3, 4, :five], is_integer(x), y <- [:one, 10, 20], is_integer(y) do
iex>   x * y
iex> end
[10, 20, 20, 40, 30, 60, 40, 80]
```

`Guard` clauses can also be used in conjunction with filters
```elixir
iex> for n when is_integer(n) <- [:zero, 1, 2, 3, 4, 5], rem(n, 2) do
iex>   n ** 2
iex> end
[1, 4, 9, 16, 25]
```

`Pattern matching` is also a valid way to filter out values that don't match the pattern on the left side of the arrow `<-`. 
In the example below, the numbers will be filtered out since they don't match the pattern
```elixir
iex> for {key, value} <- [1, 2, 3, {:name, "John"}, {:fav_color, :blue}, {:height, 178}] do
iex>   {key, value}
iex> end
[name: "John", fav_color: :blue, height: 178]
```

Results from filters can be assigned to variables which can then be used in the body of the list comprehension. 

In the example below the construction is of the pattern `{child, parent}`
```elixir
iex> family_tree = [{:"John junior", :"John"}, {:"Mia", :"John"}, {:"John", :"John senior"}, {:"John senior", nil}]
iex> for {child, parent} <- family_tree, grandparent = family_tree[parent] do
iex>  {child, grandparent}
iex> end
["John junior": :"John senior", Mia: :"John senior"]
```

_PS: Don't forget that atoms can be wrapped in parenthesis. Therefore all values above are atoms, because they are denoted with the `:` symbol at the front._

If we want to have all grandparent relations as the result, this filter can be moved to the body, so that it doesn't filter out members of the family that don't have a grandparent.
```elixir
iex> for {child, parent} <- family_tree do 
iex>   grandparent = family_tree[parent]
iex>   {child, grandparent}
iex> end
[
  "John junior": :"John senior",
  Mia: :"John senior",
  John: nil,
  "John senior": nil
]
```

### The :uniq option
The `:uniq` option can be used to discard repeating values

```elixir
iex> for n <- [1, 2, 2, 1, 3, 4, 4], uniq: true do
iex>   n * 2
iex> end
[2, 4, 6, 8]
```

### The :into option
The `:into` option can be used to change the resulting collection. By default, the result will always be a list, but that could be changed with the `:into` option.

An example would be to construct a single string out of list of strings. This is not particularly good since the result has a hanging space at the end.
```elixir
iex> for word <- ["apple", "strawberry", "kiwi", "banana"], into: "" do
iex>   "#{word} "
iex> end
"apple strawberry kiwi banana "
```

Another, a bit more useful, way to use the `:into` option would be to turn the result into a map. In order to do so, the return value for each iteration must be a tuple with two elements, where the first element will be the key and the second element will be the value.

In this example we construct the multiplication table, where the keys are a tuple containing the numbers that are being multiplied and the value is their result.
```elixir
iex> multiplication_table = for x <- 1..9, y <- 1..9, into: %{} do 
iex>   {{x, y}, x*y}
iex> end
iex> multiplication_table[{7, 5}]
35
```

Bear in mind that if the keys are repeating and they overlap, the last value will be the one that is stored in the resulting map.

```elixir
iex> for {key, value} <- [{1, 10}, {2, 200}, {3, 30}, {1, 100}, {2, 20}], into: %{} do
iex>   {key, value}
iex> end
%{1 => 100, 2 => 20, 3 => 30}
```

### The :reduce option
With the `:reduce` option, you specify an initial accumulator value, which is potentially updated on each iteration of the list comprehension. The initial value of the accumulator can be of any type. Through each iteration, the list comprehension provides access to the current value of the accumulator. The result of the `do` block is going to be the new value of the accumulator for the next iteration.

The syntax is the following: 
```
for <value> <- <enumerable>, reduce: <initial-accumulator> do
  <current-accumulator> -> <new-accumulator>
end
```

An example of using the accumulation would be to get the total sum of all numbers in a list.
```elixir
iex> for n <- [1, 2, 3, 4, 5], reduce: 0 do 
iex>   acc -> acc + n 
iex> end
15
```


Since the `:reduce` option gives access to the accumulator, there is a way to fix the issue that was present the example for the `:into` option. Now we can make sure that when keys are repeating, the larger value will be used.
```elixir
iex> for {key, value} <- [{1, 10}, {2, 200}, {3, 30}, {1, 100}, {2, 20}], reduce: %{} do 
iex>   acc -> Map.update(acc, key, value, &(if &1 > value do &1 else value end))
iex> end
```

### Exercises
1. Write a list comprehension that when provided a list of values will return a list containing only the numbers. 
  Example: input: `[1, "2", :atom, 5]` output: `[1, 5]`
1. Create a Scrabble scoring system. Create a structure that holds player names and all their words they have accumulated throughout the game. Decide what structure you will use to represent the players and their words. Based on their words, calculate which of the players is the winner.
  The scoring is as follows:
  ```
  0 Points - Blank tile.
  1 Point - A, E, I, L, N, O, R, S, T and U.
  2 Points - D and G.
  3 Points - B, C, M and P.
  4 Points - F, H, V, W and Y.
  5 Points - K.
  8 Points - J and X.
  10 Points - Q and Z.
  ```
1. Create a function that determines whether a provided sentence is a [pangram](https://en.wikipedia.org/wiki/Pangram).
  ```elixir
  iex> pangram?("The quick brown fox jumps over the lazy dog")
  true
  iex> pangram?("hello world")
  false
  ```
1. Create a function that takes a string and return an encrypted version of that string using the [ROT13](https://en.wikipedia.org/wiki/ROT13) rotation cypher.
  ```elixir
  iex> encrypt("hello world")
  "uryyb jbeyq"
  iex> encrypt("(hello, world?!)")
  "(uryyb, jbeyq?!)"
  ```
1. Create a function that takes a string and a rotation cypher as a second parameter where the cypher can be `ROT` + `<key>`, where `<key>` can range from `1` to `25` (basically denoting what is the offset of the substitution letter).

**Notes**
- Validate your `ROT-13` algorithm [here](https://rot13.com/)

## List comprehension alternatives
Most often than not you'll see function from the Enum module used instead of the `for` comprehension. While the `for` comprehension is capable of all these functionalities, its scope is too broad. In contrast each function of the Enum module has a very specific use case.

### Enum.map/2
`Enum.map/2` is a mapping function for applying a function over each element in an enumerable.

```elixir
iex> Enum.map(1..10, &(&1 + 1))
[2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
```

`Enum.map/2` shines with its clear behavior and predictable output. 

### Enum.filter/2
`Enum.filter/2` is a filtering function, that applies a conditional function over each element, if the condition produces false, the element will be filtered out of the enumerable.

```elixir
iex> Enum.filter(1..10, &(rem(&1, 2) == 0))
[2, 4, 6, 8, 10]
```


Similar to `Enum.map/2`, `Enum.filter/2` has a predictable outcome and is very clear in its intentions.

### Enum.reduce/3
`Enum.reduce/3` is a function that takes an enumerable, initial state and a reducer function, iterates through each element in the enumerable and produces a final state as a result. On each iteration, the given function will take the current value and current state and return the new state for the next iteration.

A reducer is a pure function that takes the current state, an element and an action and returns the next state.

```elixir
iex> Enum.reduce(1..10, 0, fn number, accumulator -> number + accumulator end)
55
```

A shorter version would be
```elixir
iex> Enum.reduce(1..10, 0, &(&1 + &2))
55
```

There is an `Enum.reduce/2` version of the function, that does not take a starting value for the accumulator. It uses the first element of the provided enumerable as its initial value, which means that the iteration starts from the second element.
```elixir
iex> Enum.reduce(1..10, &(&1 + &2))
55
```

While `Enum.reduce/3` might require a little bit more to grasp, it has clear use cases and provides just the necessary elements to fulfil them.

### Enum.each/2
`Enum.each/2` is an iterative function over an enumerable, that does not produce a result out of the function application. It always returns the atom `:ok` to represent the end of its execution. It is primarily used to execute some action for each element, where there is no output.

```elixir
iex> Enum.each(1..10, &IO.inspect/1)
1
2
3
4
5
6
7
8
9
10
:ok
```

`Enum.each/2` is a very simple function with predictable outcome and clear use case.

### Exercises

Redo all exercises from the list comprehension section, but this time use only function from the Enum module when (ie `Enum.map/2`, `Enum.filter/2`, `Enum.reduce/3`, etc.)

## Why to avoid the `for` comprehension
The `for` comprehension is a "jack of all trades". It can be used in almost any scenario and while that might sound as an upside, in reality it might even be a downside. This means that when you come across a `for` comprehension in a codebase you don't have an immediate understanding of what it's doing. In contrast, all function from the `Enum` module that are used as alternatives have a very specific use case and generally give some idea of what is happening. Generally it is a good idea to go for functions from the `Enum` module. There might be an argument that in some situations the `for` comprehension is more elegant, but I believe those are rare.