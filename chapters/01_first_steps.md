
- [Installing Elixir](#installing-elixir)
- [Working with the shell](#working-with-the-shell)
  - [For Windows](#for-windows)
- [Basics to get started](#basics-to-get-started)
  - [Elixir naming conventions](#elixir-naming-conventions)
  - [Defining module/function](#defining-modulefunction)
  - [Returning result from a function](#returning-result-from-a-function)
  - [IDE Setup](#ide-setup)
    - [VScode](#vscode)
- [Setting up an Elixir project](#setting-up-an-elixir-project)
  - [Creating a new Elixir application](#creating-a-new-elixir-application)
  - [Interacting with an Elixir application](#interacting-with-an-elixir-application)
- [Exercises](#exercises)


## Installing Elixir
This [link](https://elixir-lang.org/install.html) is a good starting place. It shows a variety of different ways to install Elixir / Erlang on differed operating systems and distributions. For linux I would recommend to use [asdf](https://thinkingelixir.com/install-elixir-using-asdf/). Currently I'm using Erlang version `25.0.1` and Elixir version `1.13.4-otp-25`.

## Working with the shell
Elixir as many other languages has an interactive shell where you can immediately jump into trying stuff in Elixir. Basically writing code and getting some results back.

To launch Elixir's shell just type `iex` in your terminal.

### For Windows
To run the `iex` shell on Windows there are couple of notes to take. If you are using the Command Prompt (aka CMD), then you'll be able to enter the shell with the `iex` command. Although on PowerShell or anything other than the CMD, you'll need to use `iex.bat`. Furthermore if you want to have auto completion you'll need to open the Erlang shell GUI with happens via either `iex --werl` or `iex.bat --werl` depending if you are using CMD or not.

```elixir
$> iex
Interactive Elixir (1.13.3) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)>
```

Running `iex` starts an instance of the `BEAM` VM _(BEAM is a virtual machine on which Erlang runs. Elixir also runs on BEAM)_ and then starts an interactive Elixir shell inside it.

In the interactive shell you can enter an expression and the shell will return it's result. 
For example:
```elixir
iex(1)> 1 + 1
2
```

With some explanations:
```elixir
iex(1)> 1 + 1 <-- This is the expression we've entered
2 <-- This is the result
iex(2) <-- The shell immediately gives us the next row to enter a new expression
```

**NOTE** Everything is Elixir is an expression that returns a value. This includes not only function calls, but also constructs like `if` block and many other which you'll learn more about later on.

You don't need to write everything on one line in the shell. The shell is smart enough to understand that if you hit `Enter` and the expression is not finished it will continue on the same row.
```elixir
iex(1)> 1 +
...(1)> 1 +
...(1)> 1 +
...(1)> 2
5
```

In the `iex shell` you can see the documentation of every module/function by just calling `h` in front of the module/function for which you want to see the docs (if there are any). That would be `h <module>.<function>` for pulling function docs or `h <module>` for pulling module docs.
```elixir
iex(1)> h Enum

                                  Enum                                   

Provides a set of algorithms to work with enumerables.

In Elixir, an enumerable is any data type that implements the Enumerable
protocol. Lists ([1, 2, 3]), Maps (%{foo: 1, bar: 2}) and Ranges (1..3)
are common data types used as enumerables:

    iex> Enum.map([1, 2, 3], fn x -> x * 2 end)
    [2, 4, 6]
    
    iex> Enum.sum([1, 2, 3])
    6
    
    iex> Enum.map(1..3, fn x -> x * 2 end)
    [2, 4, 6]
    
    iex> Enum.sum(1..3)
    6
    
    iex> map = %{"a" => 1, "b" => 2}
    iex> Enum.map(map, fn {k, v} -> {k, v * 2} end)
    [{"a", 2}, {"b", 4}]

However, many other enumerables exist in the language, such as MapSets
and the data type returned by File.stream!/3 which allows a file to be
traversed as if it was an enumerable.

The functions in this module work in linear time. This means that, the
time it takes to perform an operation grows at the same rate as the
length of the enumerable. This is expected on operations such as
Enum.map/2. After all, if we want to traverse every element on a list,
the longer the list, the more elements we need to traverse, and the
longer it will take.

This linear behaviour should also be expected on operations like
count/1, member?/2, at/2 and similar. While Elixir does allow data types
to provide performant variants for such operations, you should not
expect it to always be available, since the Enum module is meant to work
with a large variety of data types and not all data types can provide
optimized behaviour.

Finally, note the functions in the Enum module are eager: they will
traverse the enumerable as soon as they are invoked. This is
particularly dangerous when working with infinite enumerables. In such
cases, you should use the Stream module, which allows you to lazily
express computations, without traversing collections, and work with
possibly infinite collections. See the Stream module for examples and
documentation.
```

The shell has autocompletion. _For Windows autocompletion works only if the shell has been started with the `--werl` option_
```elixir
iex(2)> Enum. # <-- Press `Tab` to get this output
EmptyError           OutOfBoundsError     all?/1               
all?/2               any?/1               any?/2               
at/2                 at/3                 chunk_by/2           
chunk_every/2        chunk_every/3        chunk_every/4        
chunk_while/4        concat/1             concat/2             
count/1              count/2              count_until/2        
count_until/3        dedup/1              dedup_by/2           
drop/2               drop_every/2         drop_while/2         
each/2               empty?/1             fetch!/2             
fetch/2              filter/2             find/2               
find/3               find_index/2         find_value/2         
find_value/3         flat_map/2           flat_map_reduce/3    
frequencies/1        frequencies_by/2     group_by/2           
group_by/3           intersperse/2        into/2               
into/3               join/1               join/2               
map/2                map_every/3          map_intersperse/3    
map_join/2           map_join/3           map_reduce/3         
max/3                max_by/2             max_by/4             
member?/2            min/3                min_by/2             
min_by/4             min_max/1            min_max/2            
min_max_by/2         min_max_by/4         product/1            
random/1             reduce/2             reduce/3             
reduce_while/3       reject/2             reverse/1            
reverse/2            reverse_slice/3      scan/2               
scan/3               shuffle/1            slice/2              
slice/3              slide/3              sort/1               
sort/2               sort_by/2            sort_by/3            
split/2              split_while/2        split_with/2         
sum/1                take/2               take_every/2         
take_random/2        take_while/2         to_list/1            
uniq/1               uniq_by/2            unzip/1              
with_index/1         with_index/2         zip/1                
zip/2                zip_reduce/3         zip_reduce/4         
zip_with/2           zip_with/3 
```

Pulling documentation for a function
```elixir
iex(3)> h Enum.at

                def at(enumerable, index, default \\ nil)                 

  @spec at(t(), index(), default()) :: element() | default()

Finds the element at the given index (zero-based).

Returns default if index is out of bounds.

A negative index can be passed, which means the enumerable is enumerated
once and the index is counted from the end (for example, -1 finds the
last element).

## Examples

    iex> Enum.at([2, 4, 6], 0)
    2
    
    iex> Enum.at([2, 4, 6], 2)
    6
    
    iex> Enum.at([2, 4, 6], 4)
    nil
    
    iex> Enum.at([2, 4, 6], 4, :none)
    :none
```

## Basics to get started
### Elixir naming conventions
There are a few naming conventions.
1. Module names are using `PascalCase`. This is a hard requirement, you cannot create a module in any other casing. `PascalCase` is reserved only for writing module names.
2. For everything else use `snake_case`.

### Defining module/function
Modules are defined with the keyword `defmodule` and follow this structure
```elixir
defmodule PascalCasedModuleName do
  # Functions go here
end
```

Functions are defined with the keyword `def` and follow this structure
```elixir
# Of course you can accept multiple arguments separated by a comma
def snake_case_function_name() do 
  # Function logic goes here
end
```

There is a short notation for writing functions. Beware when you use this notation. Usually it's used if the function logic does not go above 1 line. If your function is formatted to the second line after formatting, just use the normal function definition.
```elixir
def snake_case_function_name(), do: # Function logic goes here
```

New lines in a function are delimited by a new line. If (for some strange reason) want to have multiple expressions on the same line you can achieve this by delimiting each expression with a semicolon `;`. But if you have correctly setup Elixir, you probably have the default Elixir formatter, which will automatically put these expressions in their separate lines.

```elixir
def my_function() do
  number = 1; number === 1
end
```

### Returning result from a function
In most languages you might be familiar with the `return` keyword to mark when a function should return some value. Elixir does not have it nor does it have an equivalent. In Elixir functions the result is the very last expression in the function. If you function ends with an `if` expression, the result of the function will be the result of the `if` expression. There is no "early return" that you can do in Elixir, so the way code is written might be a little bit different from what you might be used to.

### IDE Setup
#### VScode
For [vscode]() the recommended extensions are the following:
1. [ElixirLS](https://marketplace.visualstudio.com/items?itemName=JakeBecker.elixir-ls) this extension provides code highlight, code autocompletion and code formatting. 

In order to setup the **ElixirLS** extension correctly, always open your `vscode` from the terminal. First go to the folder where the project is and then run `code .` which will start `vscode` and load the current directory.

Linux
```bash
$> cd ./home/user/projects/elixir/my_app
$> code .
```

Windows
```bash
PS C:\Users\35989> cd .\Desktop\projects\my_app
PS C:\Users\35989\Desktop\projects\my_app>
```

Once you have your `vscode` open in the directory of the project. You can make sure that `ElixirLS` is working correctly by doing the following:
1. Open the terminal `` Ctr+` `` 
2. Go to `OUTPUT` section in the terminal action bar
3. In the dropdown on the far right (in the terminal), select `ElixirLS`. If an `ElixirLS` option does not appear, make sure you have an `.ex` file open.
4. The output should not have any errors and probably look something similar to this
```
Started ElixirLS v0.11.0
Elixir version: "1.13.4 (compiled with Erlang/OTP 25)"
Erlang version: "25"
ElixirLS compiled with Elixir 1.11.4 and erlang 22
MIX_ENV: test
MIX_TARGET: host
Compiling 1 file (.ex)
Generated my_app app
[Info  - 7:55:30 PM] Compile took 3034 milliseconds
[Info  - 7:55:30 PM] [ElixirLS Dialyzer] Checking for stale beam files
[Info  - 7:55:30 PM] [ElixirLS WorkspaceSymbols] Indexing...
[Info  - 7:55:30 PM] [ElixirLS Dialyzer] Found 7 changed files in 17 milliseconds
[Info  - 7:55:30 PM] [ElixirLS WorkspaceSymbols] Module discovery complete
[Info  - 7:55:30 PM] [ElixirLS WorkspaceSymbols] 24 callbacks added to index
[Info  - 7:55:30 PM] [ElixirLS Dialyzer] Analyzing 7 modules: [Collectable, Enumerable, IEx.Info, Inspect, List.Chars, MyApp, String.Chars]
[Info  - 7:55:30 PM] [ElixirLS WorkspaceSymbols] 168 modules added to index
[Info  - 7:55:32 PM] [ElixirLS Dialyzer] Analysis finished in 2439 milliseconds
[Info  - 7:55:32 PM] Dialyzer analysis is up to date
[Info  - 7:55:32 PM] [ElixirLS WorkspaceSymbols] 385 types added to index
[Info  - 7:55:33 PM] [ElixirLS Dialyzer] Writing manifest...
[Info  - 7:55:33 PM] [ElixirLS Dialyzer] Done writing manifest in 1259 milliseconds.
[Info  - 7:55:35 PM] [ElixirLS WorkspaceSymbols] 4075 functions added to index
```

Another helpful think that you could do is to setup `vscode` to automatically run the formatter each time you save your file. This can be accomplished like so:
1. Go to `File -> Preferences -> Settings` or `Ctr+,`
2. In the search bar at the top write `save`
3. You will be transferred to a page that has the option to enable formatting on save. 
4. Select the checkbox and you are done

## Setting up an Elixir project
Mix is the build tool that ships with Elixir and provides tasks for creating, compiling and testing Elixir application. It manages application dependencies and more. Here we won't go in depth about each component of an Elixir application, but we'll go through the basics.

### Creating a new Elixir application
Creating a new Elixir application is as easy as running `mix new my_app`.

This should be the output when running the command.
```elixir
$ mix new my_app
* creating README.md
* creating .formatter.exs
* creating .gitignore
* creating mix.exs
* creating lib
* creating lib/my_app.ex
* creating test
* creating test/test_helper.exs
* creating test/my_app_test.exs

Your Mix project was created successfully.
You can use "mix" to compile it, test it, and more:

    cd my_app
    mix test

Run "mix help" for more commands.
```
Inside `my_app`, there is an `lib` directory where our code will go. By default `mix` creates a file called `my_app.ex`, which is named on our application. Inside this file there is a sample function called `hello()`.

The default created module will look like so
```elixir
defmodule MyApp do
  @moduledoc """
  Documentation for `MyApp`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> MyApp.hello()
      :world

  """
  def hello do
    :world
  end
end

```

### Interacting with an Elixir application
To start an Elixir application just call `iex -S mix` while inside of your Elixir project. In our case make sure that you are inside the directory `/my_app`.

**On Windows** for PowerShell or any other terminal other than the Command Prompt /CMD/, you'll need to use `iex.bat -S mix` instead of `iex -S mix`.

If you are not in the correct directory you might see this error
```
$ iex -S mix
Erlang/OTP 25 [erts-13.0.1] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [jit:ns]

** (Mix) "mix" with no arguments must be executed in a directory with a mix.exs file
```

If everything goes well you should be seeing this output
```elixir
my_app$ iex -S mix
Erlang/OTP 25 [erts-13.0.1] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [jit:ns]

Compiling 1 file (.ex)
Generated my_app app
Interactive Elixir (1.13.4) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)>
```

This means that we are now in the Elixir shell where our application is compiled and accessible.

To call the `hello` function which is defined in our `MyApp` module inside `my_app.ex`.
```elixir
iex(1)> MyApp.hello()
:world
```

The module and function have defined documentation
```elixir
iex(2)> h MyApp

                                  MyApp                                  

Documentation for MyApp.
iex(3)> h MyApp.hello

                               def hello()                               

Hello world.

## Examples

    iex> MyApp.hello()
    :world
```

This follows the `<module_name>.<function_name>()` pattern.

What if we want to make a change the `hello` function return `:hello_world` instead? First we make the change in the code and then we have to recompile our app. While in the repl, we can recompile the application by calling the `recompile` function.

```elixir
iex(4)> recompile
Compiling 1 file (.ex)
:ok
iex(5)> MyApp.hello()
:hello_world
```

## Exercises

0. Create an Elixir application
1. Try to figure these out on your own.
   1. Make a function `add/2` that takes 2 numbers and adds them together
   2. Make a function `multiply/2` that takes 2 numbers and multiplies them
   3. Make a function `subtract/2` that takes 2 numbers and subtracts the second from the first one

PS. You can use common symbols for the arithmetics.

PS2. The `/2` in the name of the function signifies the amount of arguments the function is accepting. We'll look more into this later on in the course.