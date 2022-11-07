- [Working with lists](#working-with-lists)
  - [List comprehension](#list-comprehension)
    - [Nested `for`](#nested-for)
    - [Filtering out values](#filtering-out-values)
    - [The :uniq option](#the-uniq-option)
    - [The :into option](#the-into-option)
    - [The :reduce option](#the-reduce-option)
    - [Why to avoid the `for` comprehension](#why-to-avoid-the-for-comprehension)
    - [Exercises](#exercises)

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
iex> for x <- [1, 2], y <- [3, 4], do: x * y
[3, 4, 6, 8]
```

### Filtering out values

Filters in list comprehensions can be used to filter out / remove a value from the iteration and they are written before the `do` keyword. They must evaluate to `truthy` values (everything except `nil` or `false`). If the filter produces a `falsy` value, the current element is discarded.
```elixir
iex> for n <- [1, 2, 3, 4], rem(n, 2) == 0, do: n
[2, 4]
```

More than one filter can be declared, where each filter is separated by a comma.
```elixir
iex> for n <- [1, "string", 2, :atom, 3, 4], is_integer(n), rem(n, 2) == 0, do: n
[2, 4]
```

When working with nested list comprehensions, filters can either be written at the end, or can go after each corresponding comprehension. _Of course filters should declared after the corresponding comprehension._

Here both list expressions are valid in terms of syntax.
```elixir
iex> for x <- [1, 2, 3, 4, :five], y <- [:one, 10, 20], is_integer(x), is_integer(y), do: x * y
[10, 20, 20, 40, 30, 60, 40, 80]
iex> for x <- [1, 2, 3, 4, :five], is_integer(x), y <- [:one, 10, 20], is_integer(y), do: x * y
[10, 20, 20, 40, 30, 60, 40, 80]
```

`Guard` clauses can also be used in conjunction with filters
```elixir
iex> for n when is_integer(n) <- [:zero, 1, 2, 3, 4, 5], rem(n, 2), do: n ** 2
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
iex> for {child, parent} <- family_tree, grandparent = family_tree[parent], do: {child, grandparent}
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
<!-- With the `:uniq` option, the list comprehension can filter out unique values. -->
The `:uniq` option can be used to discard repeating values

```elixir
iex> for n <- [1, 2, 2, 1, 3, 4, 4], uniq: true, do: n * 2
[2, 4, 6, 8]
```

### The :into option
The `:into` option can be used to change the resulting collection. By default, the result will always be a list, but that could be changed with the `:into` option.

An example would be to construct a single string out of list of strings. This is not particularly good since the result has a hanging space at the end.
```elixir
iex> for word <- ["apple", "strawberry", "kiwi", "banana"], into: "", do: "#{word} "
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
iex> for {key, value} <- [{1, 10}, {2, 200}, {3, 30}, {1, 100}, {2, 20}], into: %{}, do: {key, value}
%{1 => 100, 2 => 20, 3 => 30}
```

### The :reduce option

<!-- When using the `:into` option to construct a map, there is this caveat that when there are repeating keys, the last of them is going to be the one used in the resulting map at the end of the list comprehension. The `:reduce` option allows the developer to custom tailor which keys are being added. -->

With the `:reduce` option, you specify an initial accumulator value, which is potentially updated on each iteration of the list comprehension. The initial value of the accumulator can be of any type. Through each iteration, the list comprehension provides access to the current value of the accumulator. The result of the `do` block is going to be the new value of the accumulator for the next iteration.

The syntax is the following: 
```
for <value> <- <enumerable>, reduce: <initial-accumulator> do
  <current-accumulator> -> <new-accumulator>
end
```
**NB** When using the `:reduce` option, the short version of the list comprehension `, do:` is not allowed.


A simple example
```elixir
iex> for n <- [1, 2, 3, 4, 5], reduce: 0 do acc -> acc + n end
15
```


Since the `:reduce` option gives access to the accumulator, there is a way to fix the issue that was present the example for the `:into` option. Now we can make sure that when keys are repeating, the larger value will be used.
```elixir
iex> for {key, value} <- [{1, 10}, {2, 200}, {3, 30}, {1, 100}, {2, 20}], reduce: %{} do 
iex>   acc -> Map.update(acc, key, value, &(if &1 > value do &1 else value end))
iex> end
```


### Why to avoid the `for` comprehension
The list comprehension in Elixir is a very powerful tool that can be used in variety of situations. It is basically a "jack of all trades", but that is it's drawback. When looking at a list comprehension implementation, while it may look cool, you might not be able to instantly understand what it is supposed to do. Maybe it's supposed to map over a list of values or maybe it is doing so, while filtering out some other values. It's the ambiguity that is not favored.

So what is the alternative? Pretty simple. Just use the function from the `Enum` module. Listing a few as example:
- `Enum.map` when there is a need to map over a list of values. 
- `Enum.filter` when there is a need to filter out some unneeded values.
- `Enum.reduce` when there is a need to reduce over a list of values to produce an accumulated result.
- `Enum.each` when you want to just call some logic for each of the values in the list, but no return value is needed.
- `Enum.uniq` when you need all the uniq values of a list.

**WARNING** Take this with a grain of salt. At the end it is just an opinion. What is important to remember is to try to use the approach of the team you are working in. Don't spill here and there list comprehension just because you like them. Alternatively if everyone on the team is comfortable with them, go ahead. Although, personally I would advice against that.

### Exercises
1. Write a list comprehension that when provided a list of values will return a list containing only the numbers. 
   Example: input: `[1, "2", :atom, 5]` output: `[1, 5]`