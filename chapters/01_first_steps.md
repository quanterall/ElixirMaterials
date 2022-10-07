
- [Installing Elixir](#installing-elixir)
- [Working with the shell](#working-with-the-shell)
- [Setting up an Elixir project](#setting-up-an-elixir-project)
  - [Creating a new Elixir application](#creating-a-new-elixir-application)
  - [Interacting with an Elixir application](#interacting-with-an-elixir-application)
- [Exercises](#exercises)


## Installing Elixir
This [link](https://elixir-lang.org/install.html) is a good starting place. It shows a variety of different ways to install Elixir / Erlang on differed operating systems and distributions. For linux I would recommend to use [asdf](https://thinkingelixir.com/install-elixir-using-asdf/). Currently I'm using Erlang version `25.0.1` and Elixir version `1.13.4-otp-25`.

## Working with the shell
Elixir as many other languages has an interactive shell where you can immediately jump into trying stuff in Elixir. Basically writing code and getting some results back.

To launch Elixir's shell just type `iex` in your terminal (_on Windows machines you might need to use `iex.bat`_):
```elixir
$ iex
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

In the `iex shell` you can see the documentation of every function by just calling `h` in front of the function for which you want to see the docs (if there are any).
```elixir
iex(1)> h Enum.at

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

## Setting up an Elixir project
Mix is the build tool that ships with Elixir and provides tasks for creating, compiling and testing Elixir application. It manages application dependencies and more. Here we won't go in depth about each component of an Elixir application, but we'll go through the basics of:

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
Inside `my_app`, there is an `lib` directory where our code will go. By default `mix` creates a file called `my_app.ex`, which is named on our application.

### Interacting with an Elixir application
To start an Elixir application just call `iex -S mix` while inside of your Elixir project. In our case make sure that you are inside the directory `/my_app`.

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

To call our `hello` function which is defined in our `MyApp` module inside `my_app.ex`.
```elixir
iex(1)> MyApp.hello()
:world
```

This follows the `<module_name>.<function_name>()` pattern.

What if we want to make a change the `hello` function return `:hello_world` instead? First we make the change in the code and then we have to recompile our app. While in the repl, we can recompile the application by calling the `recompile` function.

```elixir
iex(3)> recompile
Compiling 1 file (.ex)
:ok
iex(4)> MyApp.hello()
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