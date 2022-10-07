- [Maps](#maps)
- [Keyword List](#keyword-list)
- [Range](#range)

## Maps

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

## Keyword List
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

## Range
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