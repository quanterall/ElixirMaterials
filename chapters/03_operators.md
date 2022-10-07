- [Arithmetic operators](#arithmetic-operators)
- [List operators](#list-operators)
- [String operators](#string-operators)
- [General Operators](#general-operators)
  - [Boolean && operator](#boolean--operator)
  - [Boolean "and" operator](#boolean-and-operator)
  - [Boolean || operator](#boolean--operator-1)
  - [Boolean or operator](#boolean-or-operator)
  - [! operator](#-operator)
  - ["not" operator](#not-operator)
- [Comparison operators](#comparison-operators)
- [Special operators](#special-operators)
  - [The match operator](#the-match-operator)
    - [Exercises](#exercises)
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
The `++` operator is used for concatenation of lists
```elixir
iex(1)> [1, 2, 3] ++ [4, 5]
[1, 2, 3, 4, 5]
```

The `--` operator is used for list subtraction
```elixir
iex(1)> [1, 2, 3] -- [2]
[1, 2]
```

The `in` operator is used for checking if a value in present in a list.
```elixir
iex(1)> 1 in [1, 2, 3]
true
iex(2)> 4 in [1, 2, 3]
false
```

The `not in` operator is the opposite of the `in` operator
```elixir
iex(1)> 1 not in [1, 2, 3]
false
iex(2)> 4 not in [1, 2, 3]
true
```

_Both `in` and `not in` are actually macros which translate to the function `Enum.member?/2`_

## String operators
The `<>` operator is used for concatenation of strings
```elixir
iex(1)> "hello" <> " world"
"hello world"
```

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
### Boolean && operator
Provides a short-circuit operator that evaluates and returns the second expression only if the first one evaluates to a truthy value (that is, it is neither false nor nil). Returns the first expression otherwise.

```elixir
iex(1)> true && false
false
iex(2)> nil && true # <-- Short-circuit and returns nil
nil
iex(3)> Enum.empty?([]) && List.first([1])
1
```

### Boolean "and" operator
Provides a short-circuit operator that evaluates and returns the second expression only if the first one is `true`. Return `false` otherwise.

The first expression should always evaluate to a `boolean` value. If not a `BadBooleanError` is going to be raised.
```elixir
iex(1)> true && true
true
iex(2)> true && false
false
iex(3)> true && 77
77
iex(4)> false && "this is not evaluated"
false
iex(5)> nil and true
** (BadBooleanError) expected a boolean on left-side of "and", got: nil
```

### Boolean || operator
Provides a short-circuit operator that evaluates and returns the second expression only if the first one evaluates to a falsy value (that is, it is either nil or false). Returns the first expression otherwise.

```elixir
iex(1)> nil || true
true
iex(2)> 50 || true # <-- Short-circuit and returns nil
50
iex(3)> Enum.empty?([]) || List.first([1]) # <-- Short-circuit and returns true
true
```

### Boolean or operator
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

### ! operator
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
iex(5)> !List.first([]) # <-- Evaluates to nil
true
iex(6)> !Enum.empty?([1])
true
```

### "not" operator
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

## Special operators
### The match operator
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
