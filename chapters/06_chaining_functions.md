# Pipe `|>` operator
The `|>` operator is used for chaining expressions. It works by passing the value/expression on the left side of the pipe operator as the first argument to the function call on the right side. 

`<value/expression> |> <function call>`

This means that when piping to a function that takes for example 3 arguments, since the first argument is coming from the pipeline, only the second and the third need to be passed.

`func(arg1, arg2, arg3)` is equivalent to `arg1 |> func(arg2, arg3)` 

This chaining can be dune as many times as needed

`<value/expression> |> <function call> |> <function call> |> <function call>`

```elixir
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
|> Enum.filter(&(rem(&1, 2) == 0))
|> Enum.map(&(&1 * 2))
```

This translates to

```elixir
Enum.map(Enum.filter([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], &(rem(&1, 2) == 0)), &(&1 * 2))
```

The pipe operator can pipe only to a function call. So, when it comes to piping to an anonymous function, make sure that the function is called.

```elixir
anon_function = fn str -> "#{str} world" end
"hello" |> anon_function.()
```

An alternative approach would be to use the `Kernel.then/1` function.

```elixir
anon_function = fn a -> a + 1 end
"hello" |> then(anon_function)
```

Conditional expressions can also be piped into/out of

```elixir
10
|> Kernel.rem(2)
|> Kernel.==(0)
|> if do
  :even
else
  :odd
end
|> case do
  :even -> "even"
  :odd -> "odd"
end
```

When using the pipe operator is good practice to pipe all the function call, not only part of them.

**Don't**
```elixir
Enum.filter([1, 2, 3, 4, 5], &(rem(&1, 2) == 0)) |> Enum.map(&(&1 * 2))
```

**Do**
```elixir
[1, 2, 3, 4, 5] 
|> Enum.filter(&(rem(&1, 2) == 0)) 
|> Enum.map(&(&1 * 2))
```