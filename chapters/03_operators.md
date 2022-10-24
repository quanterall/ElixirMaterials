- [Arithmetic operators](#arithmetic-operators)
- [List operators](#list-operators)
  - [Concatenation `++` operator](#concatenation--operator)
  - [Subtraction `--` operator](#subtraction----operator)
  - [Membership `in` / `not in` operators](#membership-in--not-in-operators)
- [String operators](#string-operators)
  - [Concatenation `<>` operator](#concatenation--operator-1)
  - [Text-based match `=~` operator](#text-based-match--operator)
- [General Operators](#general-operators)
  - [Boolean relaxed `&&` operator](#boolean-relaxed--operator)
  - [Boolean strict `and` operator](#boolean-strict-and-operator)
  - [Boolean relaxed `||` operator](#boolean-relaxed--operator-1)
  - [Boolean strict `or` operator](#boolean-strict-or-operator)
  - [Boolean relaxed `!` operator](#boolean-relaxed--operator-2)
  - [Boolean strict `not` operator](#boolean-strict-not-operator)
  - [Exercises](#exercises)
- [Comparison operators](#comparison-operators)
- [Capture `&` operator](#capture--operator)
  - [Referencing a function](#referencing-a-function)
  - [Creating an anonymous function](#creating-an-anonymous-function)
  - [Exercises](#exercises-1)
- [Match `=` operator](#match--operator)
    - [Exercises](#exercises-2)
  - [The pin operator](#the-pin-operator)


## Arithmetic operators
Elixir covers the basic operators:
| Arithmetic operator | description |
| --- | --- |
| `+` | Addition |
| `-` | Subtraction |
| `*` | Multiplication |
| `/` | Division (floating) |
| `**` | Power |

 For integer division the `div/2` function is used and for calculating remainders the `rem/2` function.

```elixir
iex(1)> 1 + 1
2
iex(2)> 2 - 1
1
iex(3)> 2 * 2
4
iex(4)> 3 / 2
1.5
iex(5)> 4 / 2
2.0
iex(6)> div(3, 2)
1
iex(7)> div(4, 2)
2
iex(8)> rem(8, 2)
0
iex(9)> rem(3, 2)
1
iex(10)> 2 ** 8
256
```

## List operators

### Concatenation `++` operator
The `++` operator is used for concatenation of lists
```elixir
iex(1)> [1, 2, 3] ++ [4, 5]
[1, 2, 3, 4, 5]
```

### Subtraction `--` operator
The `--` operator is used for list subtraction
```elixir
iex(1)> [1, 2, 3] -- [2]
[1, 2]
```

### Membership `in` / `not in` operators
The `in` operator is used for checking if an element in present in a list.
```elixir
iex(1)> 1 in [1, 2, 3]
true
iex(2)> 4 in [1, 2, 3]
false
```

The `not in` operator is used for checking if an element is absent from a list
```elixir
iex(1)> 1 not in [1, 2, 3]
false
iex(2)> 4 not in [1, 2, 3]
true
```

_Both `in` and `not in` are actually macros which translate to the function `Enum.member?/2`. Therefore called the membership operators._

## String operators

### Concatenation `<>` operator
The `<>` operator is used for concatenation of strings
```elixir
iex(1)> "hello" <> " world"
"hello world"
```

### Text-based match `=~` operator
`=~` is used for regex and string matching. 

`left ~= right` where the `right` is the regex pattern/string which is being matched against the `left` value. If the `right` value regex, the operator will return `true` if the regex pattern matches the string in the `left` value. If the `right` value is a string, the operator will return `true` if the `left` value contains the `right` value.

Regex is denoted like so: `~r/{pattern}/`
```elixir
iex(1)> "hello world" =~ "hello"
true
iex(2)> "hello world" =~ ~r/^world$/
false
iex(3)> "world" =~ ~r/^world$/
true
iex(4)> "132" =~ ~r/^[0-9]*$/
true
iex(4)> "132a" =~ ~r/^[0-9]*$/
false
```


## General Operators
### Boolean relaxed `&&` operator
Provides a short-circuit operator that evaluates and returns the second expression only if the first one evaluates to a truthy value (that is, it is neither false nor nil). Returns the first expression otherwise.

```elixir
iex(1)> true && false
false
iex(2)> nil && true # <-- Short-circuit and returns nil
nil
iex(3)> Enum.empty?([]) && List.first([1])
1
```

### Boolean strict `and` operator
Provides a short-circuit operator that evaluates and returns the second expression only if the first one is `true`. Return `false` otherwise.

The first expression should always evaluate to a `boolean` value. If not a `BadBooleanError` is going to be raised.
```elixir
iex(1)> true and true
true
iex(2)> true and false
false
iex(3)> true and 77
77
iex(4)> false and "this is not evaluated" # <-- Short-circuit and returns false
false
iex(5)> nil and true
** (BadBooleanError) expected a boolean on left-side of "and", got: nil
```

### Boolean relaxed `||` operator
Provides a short-circuit operator that evaluates and returns the second expression only if the first one evaluates to a falsy value (that is, it is either nil or false). Returns the first expression otherwise.

```elixir
iex(1)> nil || true
true
iex(2)> 50 || true # <-- Short-circuit and returns nil
50
iex(3)> Enum.empty?([]) || List.first([1]) # <-- Short-circuit and returns true
true
```

### Boolean strict `or` operator
Provides a short-circuit operator that evaluates and returns the second expression only if the first one is `false`. Return `true` otherwise.

The first expression should always evaluate to a `boolean` value. If not a `BadBooleanError` is going to be raised.
```elixir
iex(1)> false or 77
77
iex(2)> true or "this is not evaluated"
true
iex(3)> nil or true
** (BadBooleanError) expected a boolean on left-side of "or", got: nil
```

### Boolean relaxed `!` operator
Used to determine if value is **not** true. It can be used with any values (not just booleans) and returns `true` if value is `false` or `nil`, otherwise it returns `false`
```elixir
iex(1)> !true
false
iex(2)> !false
true
iex(3)> !"hello"
false
iex(4)> !nil
false
iex(5)> !Enum.empty?([1])
true
iex(6)> !List.first([]) # <-- Evaluates to nil
true
```

### Boolean strict `not` operator
Used to determine if value is **not** true. It can be used only with booleans and returns `true` if value is `false`, otherwise it returns `false`.

If a non boolean value is used it raises an `ArgumentError` exception.
```elixir
iex(1)> not true
false
iex(2)> not false
true
iex(3)> not Enum.empty?([1])
true
iex(4)> not List.first([]) # <-- Evaluates to nil
** (ArgumentError) argument error
    :erlang.not(nil)
```

### Exercises

1. Write a function that takes two numbers and a list and returns true only if both numbers are in the list.
2. Write a function that takes two lists and validates that each element in the second list is present in the first list.

Notes
1. [`Enum.all?`](https://hexdocs.pm/elixir/1.12/Enum.html#all?/2)

## Comparison operators
Elixir supports all the general comparison operators:
| Operator | Description |
| --- | --- |
| == | equal to |
| === | strict equal to (checks types as well) |
| != | not equal to |
| !== | strict not equal to (checks types as well) |
| < | less than |
| > | greater than |
| <= | less than or equal to |
| >= | greater than or equal to |

Checking strict vs non strict comparison
```elixir
iex(1)> 1 == 1.0
true
iex(2)> 1 === 1.0
false
```

## Capture `&` operator
The capture operator `&` captures or creates an anonymous function. It can be used in variety of cases.

### Referencing a function
Most commonly the capture operator `&` is used to capture or in other terms, reference a function with given name, arity and module, like so `&<Module>.<function_name>/<arity>` _(the arity is the amount of arguments the function is taking)_. This could be a function in your project or an Elixir function.

For functions that have multiple definitions with different arity, the provided arity is going to determine which one of them is being referenced.
For example to capture `String.capitalize/2` one would write `&String.capitalize/2` and  `String.capitalize/1` is captured via `&String.capitalize/1`.

The result of a capture is a reference to the function. Similar to what a result is for writing an anonymous function.
```elixir
iex(1)> capitalize = &String.capitalize/1
&String.capitalize/1
iex(2)> capitalize.("hello")
"Hello"
```

The module name can be omitted if the function that is being referenced is defined in the same module or is imported
```elixir
defmodule MyApp do
  def double(num), do: num * 2

  def double_values_in_list(list) do
    # Here you could write &MyApp.double/1, but it is not necessary, because the function is defined in the module in which it is being used.
    Enum.map(list, &double/1)
  end
end
```

Perfect usage for function reference is when a function requires another function as an argument. One way to provide the needed functionality would be to write an anonymous function, but if there is a function that has the needed functionality, one simply needs to reference that function.

If it was necessary to capitalize each string in a list of strings we can do the following
```elixir
iex(1)> Enum.map(["hello", "world"], fn str -> String.capitalize(str) end) # <-- Without using capture
["Hello", "World"]
iex(2)> Enum.map(["hello", "world"], &String.capitalize/1) # <-- Directly capturing the logic for capitalization
["Hello", "World"]
```

Another way to capture a function is to use `Function.capture/3`. This style can be used if you want to programmatically capture/reference a function.
```elixir
iex(1)> capitalize = Function.capture(String, :capitalize, 1)
&String.capitalize/1
```

### Creating an anonymous function
The capture operator `&` can be used to create an anonymous function, where placeholders like `&1`, `&2`, etc. can be provided as potential arguments.
```elixir
iex(1)> add = &(&1 + &2)
&:erlang.+/2
iex(2)> add.(1, 2)
3
```
In this example `&(&1 + &2)` is equivalent to `fn (num1, num2) -> num1 + num2 end`.

The capture operator can take an arbitrary amount of placeholders.
```elixir
iex(1)> func = &(&1 + 10 * &2 - 100 / &3) # <-- Imagine this is some meaningful calculation
#Function<40.3316493/3 in :erl_eval.expr/6>
iex(2)> func.(10, 20, 30)
206.66666666666666
```

The capture operator can be used to partially apply a function. 
```elixir
iex(1)> double = &(&1 * 2)
#Function<42.3316493/1 in :erl_eval.expr/6>
iex(2)> double.(10)
20
```

Partial application can be used on a captured function as well.
```elixir
iex(1)> take_five = &Enum.take(&1, 5)
#Function<42.3316493/1 in :erl_eval.expr/6>
iex(2)> take_five([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
[1, 2, 3, 4, 5]
iex(3)> tuple_first = &Kernel.elem(&1, 0)
#Function<42.3316493/1 in :erl_eval.expr/6>
iex(4)> tuple_first.({1, 2, 3, 4})
1
```

The parenthesis of the capture operator can be omitted when constructing tuples and lists.
```elixir
iex(1)> tuple_2 = &{&1, &2}
#Function<41.3316493/2 in :erl_eval.expr/6>
iex(2)> tuple_2.(1, 2)
{1, 2}
iex(3)> list_2 = &[&1, &2]
#Function<41.3316493/2 in :erl_eval.expr/6>
iex(4)> list_2.(1, 2)
[1, 2]
iex(5)> build_list = &[&1 | &2]
#Function<41.3316493/2 in :erl_eval.expr/6>
iex(6)> build_list.(1, [2, 3, 4, 5])
[1, 2, 3, 4, 5]
```

The only restrictions when using the capture operator `&` to create a function are:
1. You should have at least one placeholder. When no placeholders are specified it raises a `CompileError`
  ```elixir
  iex(1)> &(1 + 2)
  ** (CompileError) iex:54: invalid args for &, expected one of:

  * &Mod.fun/arity to capture a remote function, such as &Enum.map/2
  * &fun/arity to capture a local or imported function, such as &is_atom/1
  * &some_code(&1, ...) containing at least one argument as &1, such as &List.flatten(&1)

  Got: 1 + 2
  ```
2. You can have only one expression. Attempting to use multiple results in `CompileError`
  ```elixir
  iex(1)> &(&1; &2)
  ** (CompileError) iex:54: invalid args for &, block expressions are not allowed, got: &1 
  &2
  ```

### Exercises
All exercises should be done using the capture `&` operator
1. Write a function that takes a number makes it to the power of 2
  ```elixir
  iex(1)> func.(5)
  25
  ```
3. Write a function that takes two arguments and returns the result of their multiplication
  ```elixir
  iex(1)> func.(3, 5)
  15
  ```
3. Write a function that takes a list of numbers and returns only the even ones. (Use the partial application)
  ```elixir
  iex(1)> func.([1, 2, 3, 4, 5])
  [2, 4]
  iex(2)> func.([3, 7])
  []
  ```
4. Write a function that takes a number or a string, if a number is passed it should return `{:ok, <number>}` otherwise `{:error, <string>}`
  ```elixir
  iex(1)> func.(1)
  {:ok, 1}
  iex(2)> func.("hmm something is wrong")
  {:error, "hmm something is wrong"}
  ```

**Notes**
1. [`Enum.filter/2`](https://hexdocs.pm/elixir/1.12/Enum.html#filter/2)
2. [`is_integer/1`](https://hexdocs.pm/elixir/1.12/Kernel.html#is_integer/1)

## Match `=` operator
The match operator `=` works by matching the right side to the pattern on the left side.
`pattern = value`. If the pattern matches the value then the match is successful, otherwise it raises a `MatchError`. The return value of the match operator is the value on the right side.

```elixir
iex(1)> 1 = 1
1
iex(2)> 2 = 1
** (MatchError) no match of right hand side value: 1
iex(3)> [1, 2] = [1, 2]
[1, 2]
```

The pattern on the left can also include variables. When there is a variable in the pattern, the variable will obtain the value on the right side.

```elixir
iex(1)> a = 1
1
iex(2)> a
1
iex(3)> [a, b, c] = [1, 2, 3]
[1, 2, 3]
iex(4)> a
1
iex(5)> b
2
iex(6)> c
3
```

Variables and strict values can be combined together in a pattern as well.

```elixir
iex(1)> [a, b, 3] = [[1, 2], {:atom, "string"}, 3]
[[1, 2], {:atom, "string"}, 3]
iex(2)> a
[1, 2]
iex(3)> b
{:atom, "string"}
```

Variables match only once in the same pattern match. If the same variable is used multiple times in the same pattern match, all subsequent usages are trying to match to the same value that was matched the first time.

```elixir
iex(1)> [a, a, b] = [1, 1, 2]
[1, 1, 2]
iex(2)> a
1
iex(3)> b
2
iex(4)> [a, a, b] = [1, 2, 3]
** (MatchError) no match of right hand side value: [1, 2, 3]
```

Patterns can be as deep as needed and can be as broad or as specific as needed. The main point is to make sure to match the "shape" of the value on the right side.

```elixir
iex(1)> [[1, a], {b, c}, 3] = [[1, 2], {:atom, "string"}, 3]
[[1, 2], {:atom, "string"}, 3]
iex(2)> a
2
iex(3)> b
:atom
iex(4)> c
"string"
```

Underscores can be used to mark that something should be there, yet you don't care for the value to bind it to a variable.

```elixir
iex(1)> [[_, a], _, _] = [[1, 2], {:atom, "string"}, 3] # <-- This pattern cares to capture only the second element of the inner list. Everything else is layed out only for the match to happen.
[[1, 2], {:atom, "string"}, 3]
iex(2)> a
2
```

With lists it's not necessary to map our the whole list in order to make a pattern.

If we care to match only on the first element of a list we could use the `|` operator to separate the head and the tail.
```elixir
iex(1)> [head | tail] = [1, 2, 3, 4]
[1, 2, 3, 4]
iex(2)> head
1
iex(3)> tail
[2, 3, 4]
iex(4)> [[_, a] | _] = [[1, 2], {:atom, "string"}, 3]
[[1, 2], {:atom, "string"}, 3]
iex(5)> a
2
iex(6)> [_, {b, _} | _] = [[1, 2], {:atom, "string"}, 3] # <-- Remember that continuous subsequent elements can be taken from a list with a comma `,` between each element.
[[1, 2], {:atom, "string"}, 3]
iex(7)> b
:atom
```

The match operator is happening not only when we use the `=` operator. When we define function the arguments are also executing a pattern match operation.
```elixir
# A pattern is used in place for a variable name to get the passed value
def head([h | _]) do
  h
end

def tail([_ | t]) do
  t
end

# A pattern match can be used in conjunction with a full variable match as well.
# Here we are validating that the passed argument should be a list with at least one element inside.
def head_and_list([h | _] = list) do
  {h, list}
end

def tail_and_list([_ | t] = list) do
  {t, list}
end
```

There is a problem with the above functions. What if we pass an empty list? What happens is that the function raises an `FunctionClauseError`.

```elixir
iex(1)> App.head_and_list([]) # <-- `App` is the module where the function is defined
** (FunctionClauseError) no function clause matching in App.head_and_list/1
```

Since we want to get the first element of a list it makes sense to require it to not be empty, yet this error message is not expressing that clearly. 
Before we start looking into some conditional expressions, what Elixir allows us to do is defining multiple function clauses. This means that you can write the same function multiple times with different number of arguments, or the same amount of arguments but different argument pattern matches.

```elixir
# In this scenario it wouldn't matter if we put this function clause first or second. But there are circumstances where this makes a difference, so be careful. You wouldn't want to put a more broad pattern match before a more specific one.
def head_and_list([]) do
  # Don't think much about what is happening here, we'll take another look at rasing/throwing exception in the following chapters.
  # What is important here is that we'll raise an exception that now gives some meaningful information back to the caller
  raise(ArgumentError, "Cannot pull out head out of an empty list")
end

def head_and_list([h | _] = list) do
  {h, list}
end
```

Calling it after the change
```elixir
iex(1)> App.head_and_list([])
** (ArgumentError) Cannot pull out head out of an empty list
```

While we are on the topic of defining multiple functions clauses, let's see how this works for anonymous functions.
```elixir
iex(1)> head = fn [] -> raise(ArgumentError, "Empty list"); [h | _] -> h end # <-- Separate clauses with semi colon
#Function<42.3316493/1 in :erl_eval.expr/6>
iex(2)> head = fn # <-- Or just have each clause on a separate line
...(2)>   [] -> raise(ArgumentError, "Empty list") 
...(2)>   [h | _] -> h
...(2)> end
#Function<42.3316493/1 in :erl_eval.expr/6>
```

#### Exercises

1. Write a pattern match to capture:
   1. The atom from the given values
   2. The value `10`
   3. Both the atom and the value `10`
   4. The first name, last name, and the last job of Value #5
2. Write a function that takes one argument and makes sure it's a list with at minimum 2 elements
3. Write a function that takes one argument and makes sure it's a list with exactly 2 elements
4. Write a function that takes one argument and makes sure it's a list with at minimum 2 equal elements
5. Write a function that takes one argument and makes sure it's a list with exactly 2 equal elements
6. Write a function that takes three arguments. The first one is a string, the next two represent characters that should be replaced. For example `"hello"` to become `"hewwo"` you need to specify that all `'l'`s should be replaced with `'w'`s.
   1. Utilize strings to specify the character to be replaced and replacer
   2. Utilize characters/ascii values _(Remember what characters essentially are)_

**Notes**
1. [`String.graphemes/1`](https://hexdocs.pm/elixir/1.12/String.html#graphemes/1)
2. [`List.to_string/1`](https://hexdocs.pm/elixir/1.12/List.html#to_string/1)
3. [`String.to_charlist/1`](https://hexdocs.pm/elixir/1.12/String.html#to_charlist/1)


Values:
1. `[{[:quanterall], 2, 10}, 2]`
2. `{"hello", [10, {[:quanterall]}]}`
3. `[1, {{1}, [1, [{:quanterall, "hello"}]]}, 10]`
4. `{[], [1, {{10}, 2, [1, [0, :quanterall, 35, 67]]}]}`
5. `{{:first_name, "Ivan"}, {:last_name, "Petrov"}, {:age, 43}, {:jobs, [{:mechanic, "The best workers OOD"}, {:doctor, "HealUs OOD"}]}, {:eye_color, "blue"}, {:hair_color, "brown"}}`

### The pin operator
The `^` operator is used to access an already bound variable in a match clause.

```elixir
iex(1)> a = 1
1
iex(2)> [^a, b | _] = [1, 2, 3] # <-- Here `^a` is the same as just writing 1. Think of it as an alias to the value
[1, 2, 3]
iex(3)> b
2
iex(4)> [_, ^a | _] = [1, 2, 3] # <-- This fails because the match pattern tries to match 1 to 2
** (MatchError) no match of right hand side value: [1, 2, 3]
iex(5)> [^c | _] = [1, 2, 3] # <-- Raises a match error if the pin operator is used with a nonexisting variable in the current code block
** (MatchError) no match of right hand side value: [1, 2, 3]
```
