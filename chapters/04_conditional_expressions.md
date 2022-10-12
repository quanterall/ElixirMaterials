- [If](#if)
  - [Exercises](#exercises)
- [Unless](#unless)
- [Cond](#cond)
  - [Exercises](#exercises-1)
- [Case](#case)
  - [Exercises](#exercises-2)
- [With](#with)
- [Guards](#guards)
  - [Where can guards be used?](#where-can-guards-be-used)
  - [Defining your own guards](#defining-your-own-guards)

## If
If expressions are a little bit different in the sense that there is no `else if`. It's either true or not. The only thing you have to remember that is different from what you are probably used to is that they are actually expressions so they return a value and you have to be careful sometimes with that.

Lets see an example:
```elixir
def hello(language) do
  if language == "spanish" do
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
    if language == "spanish" do
      "hola"
    end

  this_value_might_be_nil
end
```

In this example, we are binding the variable `this_value_might_be_nil` to the result of the `if`, but since the `if` doesn't have an `else` case, when the `language` that is passed is not "spanish" the result will be `nil`.

Bare in mind that this is the same as doing. You don't need the variable in the upper example.
```elixir
def hello(language) do
  if language == "spanish" do
    "hola"
  end
end
```

### Exercises

1. Make a function `odd/1` that takes a number and returns `true` if the number is odd
2. Make a function `even/1` that takes a number and returns `fales` if the number is even
3. Make a function `calculate/2` that takes two numbers and
   1. if both are `even` it will add them together
   2. if both are `odd` it will subtract the second from the first one
   3. if the first is `even` and the second is `odd` it will multiply them
   4. if the first is `odd` and the second is `even` it will divide them
   5. Example:
      1. calculate(8, 4) -> 12
      2. calculate(7, 3) -> 4
      3. calculate(4, 3) -> 12
      4. calculate(7, 4) -> 1.75

## Unless
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

## Cond
The _cond_ expression is the closest you can get to an `else if` branch. With `cond` you can have as many conditions as you like and usually ends with a default `true` case. The default `true` case is for when all other branches are `false` (basically the `else` branch).

```elixir
def hello(language, name) do
  # Since everything in Elixir is an expression, we can bind the result of the `cond` to a variable
  greeting = cond do
    language == :spanish -> "hola"    # if
    language == :french -> "bonjour"  # else if
    true -> "hello"                    # else
  end

  "#{greeting} #{name}"
end
```

If you do not provide a default `true` branch and all other cases return `false` the `cond` will raise an Exception. Make sure you always specify a `true` branch in the cond expression.

```elixir
iex(1)> cond do
...(1)>   1 == 2 -> 1
...(1)>   1 == 3 -> 1
...(1)> end
** (CondClauseError) no cond clause evaluated to a truthy value

iex(2)> cond do
...(2)>   1 == 2 -> 1
...(2)>   1 == 3 -> 1
...(2)>   true -> "catch all clause"
...(2)> end
"catch all clause"
```

### Exercises

1. Make the `calculate/2` task using `cond`.

## Case
The `case` expression is used when we want to handle multiple possible pattern matches. Depending on which pattern match matches it will execute the code in that block.

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
You can have as many patterns as you wish. Always think through the order of the patterns. A pattern match can go from vague to extremely strict. Try to strive for going from strict to vague patterns. This way you'll make sure you don't end up in a situation where the more general pattern actually matches a value that should have been caught in a later clause.

In this scenario we wouldn't really care which pattern goes before which, because they don't overlap. 
```elixir
case expression do
  {:ok, value} -> value
  :error -> "Error"
end
```

Here is an example of when they overlap.
```elixir
case expression do
  {:ok, [elem]} -> elem
  {:ok, list} -> list
  {:ok, []} -> "empty" # This will never execute because the above clause matches the same pattern.
end
```

Bare in mind that you should make sure that you handle all the possible cases in your patterns. If you do not and end up with value that does not match in any of the given pattens, the `case` will raise an Exception:
```elixir
iex(1)> case 10 do
...(1)> 1 -> 1
...(2)> 2 -> 2
...(2)> end
** (CaseClauseError) no case clause matching: 10
```

In these situations you can add a pattern that catches everything, which could be either a variable (if you care about the value), or an underscore `_` if you don't:
```elixir
case expression do
  1 -> 1
  2 -> 2
  n -> n
end

case expression do
  1 -> 1
  2 -> 2
  _ -> "The number is neither 1 nor 2"
end
```

The `case` expression can be represented with functions holding different pattern matches in the arguments.
For example the following `case` can be represented with functions clauses:
```elixir
def num(n) do
  case n do
    1 -> 1
    2 -> 2
    _ -> "The number is neither 1 nor 2"
  end
end

def num_(1), do: 1
def num_(2), do: 2
def num_(_), do: "The number is neither 1 nor 2"
```

### Exercises

1. Make the `calculate/2` task using `case`.
2. Write a `language_hello/1` function that takes a language as an argument, and based on the language it will return the way to say "hello" in that language. Languages to support: _spanish_, _english_, _japanese_ and _french_.
3. 

## With
The `with` expression is a combination of multiple nested `case` expressions. It is very useful to reduce clutter in your code and follow the "happy" path of your logic. Let's give an example

You could write a logic like so, with 2 `case` expressions:
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


We can simplify this logic using the `with` expression:
```elixir
with success_pattern1 <- condition1,
     success_pattern2 <- condition2 do
  # do something here
end
```

In this example the `with` expression is not handling the different errors _(unsuccessful pattern matches)_ that each condition might result to. It's just propagating it as the result of the `with`. 

If we'd like to alter what the `with` expression is going to return for each of those errors, we can add an `else` clause:
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

## Guards
Guards are a way to provide additional binary checks to your function. Not all expressions are allowed in guard clauses. Yet they can be very helpful to _guard_ your function from being called.

This might sound confusing, so let's see an example:

```elixir
# If we pass an odd number the guard will fail, therefore
# Elixir will attempt the next function in line.
def even?(num) when rem(num, 2) == 0 do
  true
end

def even?(_) do
  false
end
```
As you can notice guards are added using the `when` clause, just before the `do`

You can have multiple guards using `and` and `or`, the same way you can do in an `if` statement.
```elixir
def even?(num) when is_integer(num) and rem(num, 2) == 0 do
  true
end

def even?(_) do
  false
end

def number?(num) when is_integer(num) or is_float(num) do
  true
end

def number?(_) do
  false
end
```

### Where can guards be used?
They can be used in variety of constructs. Such like `case`, `for`, `with` etc.
You can used them in lambda functions as well. 

Guards in a lambda function
```elixir
iex(1)> my_fun = fn 
...(1)>   num when num < 10 -> "Less than 10"
...(1)>   num when num >= 10 and num <= 99 -> "Between 10 and 99"
...(1)>   num when num >= 100 and num < 999 -> "Between 100 and 999"
...(1)>   _ -> "More than 1000"
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
  def my_function(number) when (is_integer(number) or is_float(number)) and rem(number, 2) == 0 do
    # do stuff
  end
end
```
Instead of having these 3 guards, we can combine the checks in a custom guard and use it instead

```elixir
defmodule MyModule do
  defguard is_even_number(value) when (is_integer(value) or is_float(value)) and rem(value, 2) == 0

  def my_function(value) when is_even_number(value) do
    # do stuff
  end

  def my_function(_) do 
    raise(ArgumentError, "Argument should be an even number")
  end
end
```