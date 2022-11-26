- [Module attributes](#module-attributes)
  - [As annotations](#as-annotations)
    - [The `@moduledoc` annotation](#the-moduledoc-annotation)
    - [The `@doc` annotation](#the-doc-annotation)
  - [Adding examples to docs](#adding-examples-to-docs)
    - [The `@spec` annotation](#the-spec-annotation)
  - [Annotations as constants](#annotations-as-constants)

# Module attributes

## As annotations

### The `@moduledoc` annotation
The `@moduledoc` annotation is used to provide documentation about a module. It's written right below the module name and it should describe what this module is about.

```elixir
defmodule Math do
  @moduledoc "Provides utility functions for arithmetic operations."
end
```

This module doc can later be seen in the iex shell by calling `h Math`.
```elixir
iex> h Math
                                   Math                                   

Provides utility functions for arithmetic operations.
```

If the documentation of the module should span multiple lines then the docs should be surrounded by three quotation marks.
```elixir
defmodule Math do
  @moduledoc """
  Provides utility functions for arithmetic operations.

  More in depth explanation of what this module includes...
  """
end
```

### The `@doc` annotation
The `@doc` annotation is used to write documentation about a function. It is written just before the first clause of a function.

```elixir
defmodule Math do
  @moduledoc """
  Provides utility functions for arithmetic operations.

  More in depth explanation of what this module includes...
  """


  @doc """
  Adds two numbers together
  """
  def add(a, b) do
    a + b
  end
end
```

The docs can be examined in the iex shell by calling `h Math.add`.

```elixir
iex> h Math.add
                              def add(a, b)                               

Adds two numbers together
```


## Adding examples to docs

Inside both `@moduledoc` and `@doc` annotations, there is a way to add examples section, that could show examples of how the function is used.

The tabulation is critical in order to the examples to show accordingly in the iex shell. The code must be indented with 3 tabulations (_6 spaces_).
```elixir
defmodule Math do
  @moduledoc """
  Provides utility functions for arithmetic operations.

  More in depth explanation of what this module includes...
  """

  @doc """
  Adds two numbers together

  ## Examples
      iex> add(1, 2)
      3
  """
  def add(a, b) do
    a + b
  end
end
```

Viewing the docs of the function in the iex shell
```elixir
iex> h Math.add
                              def add(a, b)                               

Adds two numbers together

## Examples

    iex> add(1, 2)
    3
```

### The `@spec` annotation
The `@spec` annotation is used to specify types for arguments and result to a function. All the different types of specifications that are available can be checked out in the [Type-specs Hex docs](https://hexdocs.pm/elixir/1.12/typespecs.html)


Specifications are declared above the first clause of a function and below the `@doc` annotation of that function. 
This is the schema `@spec <function-name>(arg_1_type(), arg_2_type()) :: return_type()`. Where `<function-name>` is the name of the function, `arg_1_type()` and `arg_2_type()` are type specifications for the first and second argument to the function and `return_type()` is a type specification for the type of the result value. Each input argument to the function should have its own type specification.

```elixir
defmodule Math do
  @moduledoc """
  Provides utility functions for arithmetic operations.

  More in depth explanation of what this module includes...
  """

  @doc """
  Adds two numbers together

  ## Examples
      iex> add(1, 2)
      3
  """
  @spec add(number(), number()) :: number()
  def add(a, b) do
    a + b
  end
end
```

When displaying the docs of the function, the specification is now visible too
```elixir
iex> h Math.add
                              def add(a, b)                               

  @spec add(number(), number()) :: number()

Adds two numbers together

## Examples

    iex> add(1, 2)
    3
```

## Annotations as constants
Another way to use annotations is to create constant values. A constant value is created by adding an `@` sign before the name of the constant that will point to the specified value.

```elixir
defmodule Math do
  @pi 3.14
end
```

Constants cannot be computed, they can only be a constant value. If two constants with the same name are declared in a module, the value of the latter will be used.
