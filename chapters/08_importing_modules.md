- [Alias](#alias)
  - [Custom alias](#custom-alias)
  - [Scope](#scope)
  - [Multiple](#multiple)
- [Import](#import)
  - [Filter import](#filter-import)
  - [Scope](#scope-1)
- [Require](#require)
  - [Custom naming](#custom-naming)


In Elixir you don't necessarily need to import outside modules. All public function are accessible from anywhere by specifying the full module name.

In general the pattern is the following `<AppName>.<PathToModule>.<ModuleName>.function(args)`.
As an example if there is a project called `App` with the following directory structure

- app
  - models
    - user
      - Utils.ex

And inside the `Utils.ex` the module is named like so
```elixir
defmodule App.Models.User.Utils do
  # ...
end
```

Accessing the `Utils` module would be like so: `App.Models.User.Utils`, where `Models.User` is describing the path to the module. The root `app` folder is referenced by the app named, in this case `App`.

## Alias

`alias` allows you to create aliases for any given module name. It's primarily used to shorted a module name.

Pattern: `alias <full-module-name>`

When using the above pattern, the last part of the module name (_the text after the last dot_) will be used as the alias.

```elixir
defmodule App.MyModule do
  # Assuming there is a module named like so 
  # Remember that dots are representing the path to the module

  alias App.Models.User.Utils

  # From here on every time `Utils` is used, it will represent `App.Models.User.Utils`
end
```

### Custom alias

If a specific alias name is necessary, there is a second pattern that allows that.

Pattern: `alias <full-module-name>, as: <preferred-shorthand>`

Using custom names for aliases is useful if there are module than one module that finish on the same word.

```elixir
defmodule App.MyModule do
  # Assuming there is a module named like so 
  # Remember that dots are representing the path to the module

  alias App.Models.User.Utils, as: UserUtils
  alias App.Models.Post.Utils, as: PostUtils

  # From here on every time `UserUtils` is used, it will refer to `App.Models.User.Utils`
  # From here on every time `PostUtils` is used, it will refer to `App.Models.Post.Utils`
end
```

### Scope

Aliases are **lexically scoped** which means that setting alias inside a function definition will make the alias valid only in the function block.

```elixir
defmodule App.MyModule do
  # Assuming there is a module named like so 
  # Remember that dots are representing the path to the module

  def login(arg1, arg2) do
    alias App.Models.User.Utils
    # Inside this function `Utils` will refer to `App.Models.Post.Utils`

  end
end
```

### Multiple

If there are multiple modules coming from the same path we could alias each one on separate line

```elixir
alias App.Models.User
alias App.Models.Post
```

Multiple modules can be aliased on the same like if they have common path.

```elixir
alias App.Models.{User, Post}
```

## Import
Imports macros, function from another module, without having the need to specify the module name when using the function from the imported module. This means that function from imported module can be called as if they were specified in the `Kernel` module which is automatically imported in every module.

```elixir
defmodule App.MyModule do
  import Enum

  ## Function from the module List can be called without specifying the module name. (e.g. map/2, filter/2, etc.)
end
```

### Filter import

The `import` keyword allows to import only specific subset of the module.

```elixir
import List, only: :functions
import List, only: :macros
import Kernel, only: :sigils
```

Only specific set of function can be imported

```elixir
import Enum, only: [map: 2, filter: 2, reduce: 3] ## Import only said 3 functions
import Enum, except: [reduce: 2] ## Import all function but Enum.reduce/2
```

### Scope

Similar to `alias`, `import` has lexical scope, which means they can be used in function and not spill out.

```elixir
def my_function do
  import Kernel, except: [spawn: 1]
  import App.Modules.Monster, only: [spawn: 1]

  spawn("alien") ## Will call the function in App.Modules.Monster
end
```


## Require

It's used to require the macros of a specified module.

Trying to call a macro function without requiring it will result in an exception

```elixir
iex> Integer.is_even(2)
** (UndefinedFunctionError) function Integer.is_even/1 is undefined or private. However there is a macro with the same name and arity. Be sure to require Integer if you intend to invoke this macro
    (elixir 1.13.4) Integer.is_even(2)
```

```elixir
iex> require Integer
Integer
iex> Integer.is_even(2)
true
```

### Custom naming

Similar to `alias`, `require` allows to specify custom name of the module you'd like to require.

```elixir
iex> require Integer, as: Int
Integer
iex> Int.is_even(2)
true
```