- [Range](#range)
- [Keyword List](#keyword-list)
  - [Accessing fields](#accessing-fields)
  - [Exercises](#exercises)
- [Maps](#maps)
  - [Creating Maps](#creating-maps)
  - [Accessing fields](#accessing-fields-1)
  - [Updating values](#updating-values)
  - [Exercises](#exercises-1)
- [Struct](#struct)
  - [Updating values](#updating-values-1)
  - [Default values](#default-values)
  - [Required fields](#required-fields)
  - [Exercises](#exercises-2)


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

Internally ranges are represented as structs that have the fields: `first`, `last` and `step`
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

Pattern match is another viable way to pull out the components
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

Ranges can be constructed via the `Range` module which can also be used to check the size via `Range.size/1`
```elixir
iex(1)> range = Range.new(2, 10, 2)
2..10//2
iex(2)> Range.size(range)
5
iex(3)> Range.size(Range.new(1, 1_000_000))
1000000
```

Since `Range` is implemented as an Enumerable, another viable option for pulling the size is through the `Enum.count/1` function
```elixir
iex(1)> Enum.count(Range.new(1, 1_000_000))
1000000
```

**NB** _Ranges are really small in footprint, so even a million number range will be small_

## Keyword List
A keyword list is a special type of list where each element is a tuple of 2 elements and the first element of each tuple _(also called a `key`)_ must be an atom. The second element _(also called a `value`)_ can be of any type.
```elixir
iex(1)> [{:pretty, true}, {:range, 90}, {:format, :json}]
[pretty: true, range: 90, format: :json] # <-- The result looks different, but that is just syntax sugar
iex(2)> [pretty: true, range: 90, format: :json] # <-- Elixir allows to write it this way as well
[pretty: true, range: 90, format: :json]
```
Both structures yield the same result, just the syntax is different. If you map on a keyword list each element will be a tuple.

**NB** _Don't forget that you are dealing with a list here. The lookup operation is still an O(n) operation._

As stated above, the `key` of a Keyword list **must** be an atom
```elixir
iex(1)> Keyword.keyword?([{"pretty", true}])
false
iex(2)> Keyword.keyword?([{:pretty, true}])
true
iex(3)> Keyword.keyword?([pretty: true])
true
```

Keys can be repeated and the key-value pairs are ordered the way they are passed in.
```elixir
iex(1)> repeating_keys = [range: 30, range: 80]
[range: 30, range: 80]
```

### Accessing fields
There are few ways to access elements in a keyword list, but there is one thing to remember. When attempting to get a single value under a given key, you will always get the first value, and any other values under the same key will be silently ignored.

1. Using the _[Access behavior](https://hexdocs.pm/elixir/Access.html)_ 
    ```elixir
    iex(1)> keyword = [pretty: true, range: 90, format: :json]
    [pretty: true, range: 90, format: :json]
    iex(2)> keyword[:format] # <-- Access by key
    :json
    ```
2. Using the `Keyword.get/2`, `Keyword.get/3`
    ```elixir
    iex(1)> keyword = [pretty: true, range: 90, format: :json]
    iex(2)> Keyword.get(keyword, :format) # <-- Using the Keyword.get/2 function
    :json
    iex(3)> Keyword.get(keyword, :path)
    nil
    iex(4)> Keyword.get(keyword, :path, ".")
    "."
    ```
3. Using the `Keyword.get_values/2` for pulling multiple values of the same key
    ```elixir
    iex(3)> keyword = [range: 30, range: 80]
    [range: 30, range: 80]
    iex(5)> Keyword.get(keyword, :range) # <-- Pulls the first key
    30
    iex(6)> Keyword.get_values(keyword, :range) # <-- Pulls all values using that key
    [30, 80]
    ```
4. Using pattern matching, although not really a preferred method, since it requires all keys to be  specified in the same order
    ```elixir
    iex(1)> [pretty: pretty, range: range] = [pretty: true, range: 90, format: :json]
    ** (MatchError) no match of right hand side value: [pretty: true, range: 90, format: :json]
    iex(2)> [pretty: pretty, format: format, range: range] = [pretty: true, range: 90, format: :json]
    ** (MatchError) no match of right hand side value: [pretty: true, range: 90, format: :json]
    iex(3)> [pretty: pretty, range: range, format: format] = [pretty: true, range: 90, format: :json]
    [pretty: true, range: 90, format: :json]
    ```

### Exercises
1. Write a function that takes a string as the first parameter and returns the first letter as a character. The function should take an optional options as a second parameter, which specifies whether to return that character uppercased or not.
    ```elixir
    iex(1)> func("hello")
    'h'
    iex(1)> func("hello", [upper: true])
    'H'
    iex(1)> func("Hello")
    'H'
    iex(1)> func("Hello", [upper: false])
    'h'
    ```
2. To the previous function, add a new option called `:repeat` that would specify how many times to repeat the first letter.
    ```elixir
    iex(1)> func("hello", repeat: 3)
    'hhh'
    iex(2)> func("hello")
    'h'
    iex(3)> func("hello", upper: true, repeat: 3)
    'HHH'
    ```
    
## Maps

Maps are a key/value based structure, where keys point to values. Keys in Maps are indexed, meaning that you have direct access _O(1) operation_ to a value. Use them when you need indexing of multiple values.

There are few things to remember about maps:
1. Keys must be unique and can be of any type
2. Values do not need to be unique and can be of any type
3. Maps do not guarantee the order of their contents despite appearing to do so. This is happening because the implementation for maps is dependent on the size of entries.
   1. When the entries are `<= 32` then Maps are implemented as an ordered Keyword list
   2. When the entries are `> 32` then Maps are implemented as [Hash arrayed map trie](https://en.wikipedia.org/wiki/Hash_array_mapped_trie)

### Creating Maps

Maps can be declared in two ways.
1. With a literal form
    ```elixir
    iex(1)> %{} # <-- Empty map
    %{}
    iex(2)> %{"key" => "value"} # <-- Map with one key 
    %{"key" => "value"}
    iex(3)> %{"key" => "value", 1 => :atom} # <-- Map with different key/value types
    %{"key" => "value", 1 => :atom}
    iex(4)> %{:key => "value"} # <-- Map with keys of atoms defined in the using the general `=>` arrow
    %{key: "value"}
    iex(5)> %{key: "value"} # <-- Syntax sugar for writing maps when keys are only atoms
    %{key: "value"}
    ```
2. Using the `Map.new` function
    ```elixir
    iex(1)> keyword_list = [a: 1, b: 2]
    [a: 1, b: 2]
    iex(2)> Map.new(keyword_list)
    %{a: 1, b: 2}
    ```

### Accessing fields

Maps can be accessed in a few different ways
1. Using the Access behavior
    ```elixir
    iex(1)> map = %{:a => 1, "b" => 2, [1] => 10}
    %{:a => 1, [1] => 10, "b" => 2}
    iex(2)> map[:a]
    1
    iex(3)> map["b"]
    2
    iex(4)> map[[1]]
    10
    iex(5)> map["non_existing_field"] # <-- Accessing a key that does not exist returns nil
    nil
    ```
2. Using a dot `.` if the key is an atom
    ```elixir
    iex(1)> map = %{a: 1, b: 2}
    %{a: 1, b: 2}
    iex(2)> map.a
    1
    iex(3)> map.non_existing_field # <-- Accessing a key that does not exist raises an Exception
    ** (KeyError) key :non_existing_field not found in: %{a: 1, b: 2}
    ```
3. With a pattern match
    ```elixir
    iex(1)> map = %{a: 1, b: 2}
    %{a: 1, b: 2}
    iex(2)> %{a: a} = map
    %{a: 1, b: 2}
    iex(3)> a
    1
    ```
4. Using `Map.get/2`
    ```elixir
    iex(1)> map = %{a: 1, b: 2}
    %{a: 1, b: 2}
    iex(2)> Map.get(map, :a)
    1
    ```

### Updating values

Modifying Maps can happen in a two ways.
1. Using the `|` symbol with the following recipe `%{<map> | <listing_of_key_value_pairs>}`
    ```elixir
    iex(1)> map = %{a: 1, b: 2, c: 3}
    %{a: 1, b: 2, c: 3}
    iex(2)> %{map | b: 3, c: 4} # <-- One or more keys can be listed
    %{a: 1, b: 3, c: 4}
    iex(3)> map # <-- Notice that the value in the `map` variable is not changed
    %{a: 1, b: 2, c: 3}
    iex(4)> map = %{map | b: 3, c: 4} # <-- In order to change the value a rebind should be done
    %{a: 1, b: 3, c: 4}
    iex(5)> %{map | d: 4} # <-- Cannot update/insert keys that are not present in the map
    ** (KeyError) key :d not found in: %{a: 1, b: 3, c: 3}
    (stdlib 4.0.1) :maps.update(:d, 4, %{a: 1, b: 3, c: 3})
    (stdlib 4.0.1) erl_eval.erl:309: anonymous fn/2 in :erl_eval.expr/6
    (stdlib 4.0.1) lists.erl:1355: :lists.foldl_1/3
    ```
2. Using tha `Map.update/4` function
    ```elixir
    iex(1)> map = %{a: 1, b: 2, c: 3}
    %{a: 1, b: 2, c: 3}
    iex(2)> Map.update(map, :a, 10, fn key -> key * 20 end) # <-- Can update existing keys
    %{a: 20, b: 2, c: 3}
    iex(3)> Map.update(map, :d, 10, fn key -> key * 20 end) # <-- Can insert new keys
    %{a: 1, b: 2, c: 3, d: 10}
    iex(4)> map # <-- Again, map is not changed
    %{a: 1, b: 2, c: 3}
    ```


### Exercises
1. Represent a small company workforce using maps which should hold the following information:
   1. First name
   2. Last name
   3. Age
   4. Department (can be one of the following values: ["sales", "IT", "operations", "marketing"])
   5. Years of experience
   6. Salary
2. Write the following helping function
   1. Function for promoting employees with salaries under specified amount
   ```elixir
    iex> promote(<company-representation>, 3000, 5000) # all employees with salaries <= 3000 are promoted to 5000
   ```
   2. Function for moving an employee from one department to another
   ```elixir
    iex> move(<company-representation>, "Peter Smith", "sales") # Moving "Peter Smith" to the "sales" department
   ```
   3. Function for pulling all employees from a specific department whose salary is in specified range
   ```elixir
    iex> employees_with_salary_in(<company-representation>, "sales", 2000, 3000)
    # All employees from "sales" with salary between 2000-3000
   ```
   4. Function for firing an employee based on their name.
   ```elixir
    iex> fire(<company-representation>, "Peter Smith") # From now on "Peter Smith" is no longer in the company
   ```

## Struct 
Struct is an extension built on top of `Map` that provides compile-time checks and default values. When creating a Struct a set of keys are defined which are the only attributes this Struct can have. `Struct`s are perfect for scenarios where only a specific set of keys are necessary.

A `Struct` is defined using the `defstruct` macro which takes a keyword list, where each element is a key/field and its corresponding default value. They can only be defined inside of a module and take the name of the module as their name.

**NB** Only one `Struct` per module is allowed.

In the example below, we are defining a User that has the keys `name` (with the default value "Peter") and `age` (with the default value 46)
```elixir
iex> defmodule User do
...>   defstruct [name: "Peter", age: 46]
...> end
```

If we want to be purists we can write it like so. _Remember than when defining keyword lists, the tuples brackets and the list brackets can be omitted like the example above_
```elixir
iex> defmodule User do
...>   defstruct [{:name, "Peter"}, {:age, 46}]
...> end
```

**NB** If default value is not provided for a specific key/field, the default value will be `nil`.


`Struct` can be created like so. _The created `Struct` is defined in the code above._
```elixir
iex> %User{} # <-- Creating an empty User struct
%User{age: 27, name: "John"}
```

The pattern for creating a struct is `%<module_name>{}`. Without specifying a module name (where a Struct is defined), a map will be created.

```elixir
iex> user = %{name: "Philip", age: 25} # <-- This is just a Map
%{name: "Philip", age: 25}
iex> user_struct = %User{name: "Roger"} # <-- Defining a User struct
%User{age: 46, name: "Roger"}
```

A `Struct` underneath is just a `Map` with an additional `__struct__` key defining the name of the struct.

```elixir
iex> %User{} == %{__struct__: User, name: "Peter", age: 46}
true
iex> %{__struct__: struct_name} = %User{} # <-- We can pull out the name of a Struct
%User{age: 46, name: "Peter"}
iex> struct_name
User
```

### Updating values

An update operation on the values of a `Struct` works the same way as it does on `Map`
```elixir
iex> user = %User{name: "Tom", age: 64}
%User{age: 64, name: "Tom"}
iex> %User{user | age: 54}
%User{age: 54, name: "Tom"}
iex> %User{user | age: 54, name: "Thomas"} # <-- Updating more than one field
%User{age: 54, name: "Thomas"}
iex> user # <-- NB: The value hasn't changed, because we haven't rebound the variable
%User{age: 64, name: "Tom"}
```

The advantage of a `Struct` over a `Map` is that the keys/fields are locked. There is no way to add or remove keys/fields from a `Struct`. This means that when you operate with specific `Struct`, you can rely on the fact that there are a set of keys/fields.

The example below fails and raises a `KeyError` exception, because the field `height` does not exist in the `User` struct.
```elixir
iex> %User{height: 1.78} # <-- Cannot create a User struct with an undefined    key/field
** (KeyError) key :height not found
    expanding struct: User.__struct__/1
    iex:28: (file)
```

`Struct`s allow pattern matching on their names.
```elixir
iex> %struct_name{} = user
%User{age: 64, name: "Tom"}
iex> struct_name
User
iex> %_{} = user # <-- Assign Struct name to `_` just to verify that a variable is in fact a Struct
%User{age: 64, name: "Tom"}
```

### Default values
If default values are not specified when defining a `Struct`, the value `nil` is assumed.

```elixir
iex> defmodule Car do
...>   defstruct [:brand]
...> end
```

Creating an empty `Car` will mean that the value for `brand` will be `nil`
```elixir
iex> %Car{}
%Car{brand: nil}
```

When defining a `Struct` a combination of explicit default values and implicit `nil` values is allowed, as long as all the keys/fields with the implicit `nil` value are defined first
```elixir
iex> defmodule Car do
...>   defstruct [:brand, type: :sedan]
...> end
```

Doing it in reverse order will raise a syntax error
```elixir
iex> defmodule Car do
...>   defstruct [type: :sedan, :brand]
...> end
** (SyntaxError) iex:1:26: unexpected expression after keyword list. Keyword lists must always come last in lists and maps. Therefore, this is not allowed:

    [some: :value, :another]
    %{some: :value, another => value}

Instead, reorder it to be the last entry:

    [:another, some: :value]
    %{another => value, some: :value}

Syntax error after: ','
    |
  1 |   defstruct [type: :sedan, :brand]
    |
```

But there is a caveat. If the `Struct` fields are defined with the full form of keyword lists, keys/fields with implicit default values can be defined at the end.
```elixir
iex> defmodule Car do
...>   defstruct [{:type, :sedan}, :brand]
...> end
```

### Required fields
`Struct`s can have required fields to be filled in upon creation. This can be achieved by providing the module attribute `@enforce_keys`.

```elixir
iex> defmodule Country do
...>   @enforce_keys [:name]
...>   defstruct [:name, :population_count]
...> end
```

You cannot create a `Struct` without providing all the keys specified in the `@enforce_keys` module attribute
```elixir
iex> %Country{}
** (ArgumentError) the following keys must also be given when building struct Country: [:name]
    expanding struct: Country.__struct__/1
    iex:45: (file)
```

Enforcing keys provides a simple compile-time guarantee to aid developers when building structs. It is not enforced on updates and it does not provide any sort of value-validation.

### Exercises
1. Create a Struct to accompany the employee from the first exercise in the `Map` section.
2. Create a Struct for a company that will hold the name of the company and all the employees. Incorporate that struct to be used in the functions created in the `Map` exercise.