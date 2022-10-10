- [If](#if)
  - [Exercises](#exercises)
- [Unless](#unless)
- [Cond](#cond)
  - [Exercises](#exercises-1)
- [Case](#case)
  - [Exercises](#exercises-2)
- [With](#with)

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
Don't overuse the _unless_ expression though. Whenever it makes sense go for it, but otherwise don't try to use it where an _if_ makes more sense for reading the code.

## Cond
The _cond_ expression is what you are looking for the cases where you need an `else if` branch. In `cond` you can have as many conditions as you like and usually ends with a default _(true)_ case. _(similar to how switch works in other languages)_

```elixir
def hello(language, name) do
  greeting = cond do
    language == "spanish" -> "hola"
    language == "french" -> "bonjour"
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

### Exercises

1. Make the `calculate/2` task using `cond`.

## Case
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

### Exercises

1. Make the `calculate/2` task using `case`.

## With
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