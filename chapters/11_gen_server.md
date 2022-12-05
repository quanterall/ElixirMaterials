- [What is a `GenServer`](#what-is-a-genserver)
- [Starting a `GenServer`](#starting-a-genserver)
- [Main `GenServer` callbacks](#main-genserver-callbacks)
  - [`init`](#init)
  - [`handle_call`](#handle_call)
  - [`handle_cast`](#handle_cast)
  - [`handle_info`](#handle_info)
  - [Setting up client side for `GenServer`](#setting-up-client-side-for-genserver)
- [Exercises](#exercises)

## What is a `GenServer`
Working with processes is one of the main drive to use the BEAM via Elixir/Erlang. While working with processes is straight forward, there are a few aspects that overlap most of the times. So having a generic way to deal with / setup a process is really helpful. Having a generic interface to operate with processes makes for a simpler codebase with one way of doing things.d

A `GenServer` process provides just that. It's a generic way to describe a process and implement all the necessary features one might need, by using the set of standard set of interface functions that the `GenServer` exposes. At it's core a `GenServer` is just an Elixir process and can be used to keep/modify state, execute synchronous/asynchronous code.

## Starting a `GenServer`
`GenServer` can be started with one of the following functions `GenServer.start/3` or `GenServer.start_link/3`. Both accept the same arguments. The difference is that `GenServer.start/3` will start the `GenServer` as a standalone process, where as `GenServer.start_link/3` will link it to the process that started it, creating a parent-child like relationship. When processes are linked together, if one fails that failure will propagate to its parent and so forth. This means that the parent will be aware that a child process has failed and have the opportunity to do something about it.

`GenServer` start functions accept three parameters:
- The first argument is the module where the `GenServer` is defined.
- The second argument is the initial argument (state) of the `GenServer`.
- The final argument is options, which is optional by itself. There are a few options that can be passed, but one of the most used ones is the `:name` option. It allows us to name the `GenServer`, so that we can refer to it by name instead by `pid`. A standard practice is to name the `GenServer` with the module name.

## Main `GenServer` callbacks
There are total of 8 callbacks. This chapter is going to cover only the most used ones. The ones that you'll have to deal with most of the time while working with `GenServer`: `init`, `handle_call`, `handle_cast`, `handle_info`, `handle_continue`.

### `init`
The `init` callback is invoked when the `GenServer` is started, which could be done with either `GenServer.start/3` or `GenServer.start_link/3`. It takes one argument, which is the `initial state` that is passed as the second argument to `GenServer.start/3` or `GenServer.start_link/3`. The `GenServer` does not start until the `init` callback is executed. The very result of the `init` callback will be the initial state of the `GenServer`. There are different types of result value that could be used, but we'll focus on the simplest, which is the `{:ok, state}`. Which basically says, the `GenServer` will start with this initial state.

There might be a situation where the `GenServer` needs to be fed some information upon initialization. The `init` callback is the place where this should happen. It does not matter where the data comes from: database, api, another process, etc.

In this simple example, we are just taking the initial state and continue with it. No changes to the state are being made. This is perfectly normal scenario for a `init` callback in the situations when there are no necessary changes to the initial state of the `GenServer`.
```elixir
defmodule MyServer do
  use GenServer

  # ... some code above

  @impl true
  def init(initial_state) do
    {:ok, initial_state}
  end

  # ... some code below
end
```

### `handle_call`
Sending a synchronous request to the `GenServer` is done by calling `GenServer.call/3`. It takes three key parameters: the pid of the `GenServer`, the request itself and a possible timeout _(In short - how much to wait for a response. Since this is a synchronous call, it will block until it returns a response. The timeout is there to specify how long to wait for such response. By default it waits for 5 seconds, but if this is some long running operation, you might need to adjust that value.)_.

A simple `GenServer.call/3` might look like so
```elixir
iex> GenServer.call(some_pid, :ping) # <- Sending a sync :ping request to `some_pid`
...
```

The second parameter is basically any `term()`. It is the request that is being send to the `GenServer`. Much like in an API, in a `GenServer` there should be some code to handle a particular set of requests that the `GenServer` is exposing.

In order to handle a `GenServer.call/3` request, a `handle_call` callback should be implemented to handle a particular request in mind.

The `handle_call` callback accepts three arguments:
- The first one is the request itself. Usually the request should be send in a form that is easily distinguishable from another request by pattern matching. In the example above we are using an exact match for the request `:ping`. There could be no confusion on what this `handle_call` callback is handling. It could not handle any other incoming `GenServer.call/3` request, by the sole fact that it pattern matches only on a request that hold the value `:ping`;
- The second argument denotes who was the caller that made that request. Basically information about the process that made the `GenServer.call/3` call. In most circumstances this information is not needed, therefore the argument starts with an underscore, which is how are denoted arguments in Elixir that won't be used in the code;
- The third parameter is the current state of the `GenServer`. At the point in time of making this request, this is the value of state;

There are a few possible results that can be returned from a `handle_call` callback and you cannot deviate from them. We'll focus on one of them `{:reply, result, new_state}`. This is by far the most used result and that one you will come across most often. It is a three element sized tuple, where the first value will be `:reply`, the second value is the data that will be returned to the called of `GenServer.call/3` which matched on this particular `handle_call` and the third value is the new value of the state of the `GenServer`. 

At the end of each `handle_call` there is the possibility to change the state of the `GenServer`.

For example, to handle a `:ping` request, there must be a `handle_call` that handles that, which could be implemented as follows:
```elixir
defmodule MyServer do
  use GenServer

  # ... some code above

  @impl true
  def handle_call(:ping, _from, state) do
    {:reply, :pong, state}
  end

  # ... some code below
end
```

This callback is optional, although the server will fail if `GenServer.call/3` is called on it.
```elixir
iex> defmodule MyServer do
...>   use GenServer
...>   def init(state) do
...>     {:ok, state}
...>   end
...> end
{:module, MyServer,
 <<70, 79, 82, 49, 0, 0, 18, 136, 66, 69, 65, 77, 65, 116, 85, 56, 0, 0, 1,
   198, 0, 0, 0, 47, 15, 69, 108, 105, 120, 105, 114, 46, 77, 121, 83, 101,
   114, 118, 101, 114, 8, 95, 95, 105, 110, 102, 111, ...>>, {:init, 1}}
iex> GenServer.start(MyServer, [])
{:ok, #PID<0.117.0>}
iex> GenServer.call(pid(0, 117, 0), :ping)
15:39:12.464 [error] GenServer #PID<0.117.0> terminating
** (RuntimeError) attempted to call GenServer #PID<0.117.0> but no handle_call/3 clause was provided
    lib/gen_server.ex:779: MyServer.handle_call/3
    (stdlib 4.0.1) gen_server.erl:1146: :gen_server.try_handle_call/4
    (stdlib 4.0.1) gen_server.erl:1175: :gen_server.handle_msg/6
    (stdlib 4.0.1) proc_lib.erl:240: :proc_lib.init_p_do_apply/3
Last message (from #PID<0.107.0>): :ping
State: []
Client #PID<0.107.0> is alive

    (stdlib 4.0.1) gen.erl:256: :gen.do_call/4
    (elixir 1.13.4) lib/gen_server.ex:1027: GenServer.call/3
    (stdlib 4.0.1) erl_eval.erl:744: :erl_eval.do_apply/7
    (elixir 1.13.4) src/elixir.erl:296: :elixir.recur_eval/3
    (elixir 1.13.4) src/elixir.erl:274: :elixir.eval_forms/3
    (iex 1.13.4) lib/iex/evaluator.ex:310: IEx.Evaluator.handle_eval/3
    (iex 1.13.4) lib/iex/evaluator.ex:285: IEx.Evaluator.do_eval/3
    (iex 1.13.4) lib/iex/evaluator.ex:274: IEx.Evaluator.eval/3
** (exit) exited in: GenServer.call(#PID<0.117.0>, :ping, 5000)
    ** (EXIT) an exception was raised:
        ** (RuntimeError) attempted to call GenServer #PID<0.117.0> but no handle_call/3 clause was provided
            lib/gen_server.ex:779: MyServer.handle_call/3
            (stdlib 4.0.1) gen_server.erl:1146: :gen_server.try_handle_call/4
            (stdlib 4.0.1) gen_server.erl:1175: :gen_server.handle_msg/6
            (stdlib 4.0.1) proc_lib.erl:240: :proc_lib.init_p_do_apply/3
    (elixir 1.13.4) lib/gen_server.ex:1030: GenServer.call/3
```

Attempting to make a call request that does not have a callback will terminate the `GenServer`.
```elixir
iex> defmodule MyServer do
...>   use GenServer
...>
...>   def init(state) do
...>     {:ok, state}
...>   end
...> 
...>  def handle_call(:ping, _from, state) do
...>    {:reply, :pong, state}
...>  end
...> end
{:module, MyServer,
 <<70, 79, 82, 49, 0, 0, 17, 20, 66, 69, 65, 77, 65, 116, 85, 56, 0, 0, 1, 193,
   0, 0, 0, 47, 15, 69, 108, 105, 120, 105, 114, 46, 77, 121, 83, 101, 114, 118,
   101, 114, 8, 95, 95, 105, 110, 102, 111, ...>>, {:handle_call, 3}}
iex> GenServer.start(MyServer, [])
{:ok, #PID<0.117.0>}
iex> GenServer.cast(pid(0, 117, 0), :pong)
16:15:00.915 [error] GenServer Server terminating
** (FunctionClauseError) no function clause matching in Server.handle_call/3
    iex:23: Server.handle_call(:pong, {#PID<0.107.0>, [:alias | #Reference<0.1564902804.2461859841.254964>]}, [])
    (stdlib 4.0.1) gen_server.erl:1146: :gen_server.try_handle_call/4
    (stdlib 4.0.1) gen_server.erl:1175: :gen_server.handle_msg/6
    (stdlib 4.0.1) proc_lib.erl:240: :proc_lib.init_p_do_apply/3
Last message (from #PID<0.107.0>): :pong
State: []
Client #PID<0.107.0> is alive
```

### `handle_cast`
Sending a asynchronous request to a `GenServer` is done by calling `GenServer.cast/2`. Those requests are handled by `handle_cast` callbacks. Cast requests do not return a result to the caller (being asynchronous). `GenServer.cast/2` accepts only two arguments: the `pid` of the `GenServer` that is being called and the request itself.

A simple cast request will look like so:
```elixir
iex> GenServer.cast(stack_pid, {:push, 1})
:ok
```

To handle cast request you must implement the appropriate `handle_cast` callback. 

The `handle_cast` callback accepts two arguments:
- The request itself, differentiated by pattern match;
- The current value of the state of the `GenServer`;

Example of handling a cast request with the purpose of adding a new element to a Server that represents a Stack:
```elixir
defmodule MyServer do
  use GenServer

  # ... some code above

  @impl true
  def handle_cast({:push, element}, state) do
    # Notice that the state will be changed after this cast request is executed.
    {:noreply, [element | state]} 
  end

  # ... some code below
end
```

The callback is optional, although similar to `handle_call` the server will terminate if `GenServer.cast/2` is being called on `GenServer` that does not implement a single `handle_cast`.

```elixir
iex> defmodule MyServer do
...>   use GenServer
...>
...>   def init(state) do
...>     {:ok, state}
...>   end
...>
...> end
{:module, MyServer,
 <<70, 79, 82, 49, 0, 0, 18, 136, 66, 69, 65, 77, 65, 116, 85, 56, 0, 0, 1,
   198, 0, 0, 0, 47, 15, 69, 108, 105, 120, 105, 114, 46, 77, 121, 83, 101,
   114, 118, 101, 114, 8, 95, 95, 105, 110, 102, 111, ...>>, {:init, 1}}
iex> GenServer.start(MyServer, [])
{:ok, #PID<0.117.0>}
iex> GenServer.cast(pid(0, 117, 0), :ping)
16:07:47.107 [error] GenServer Server terminating
** (RuntimeError) attempted to cast GenServer Server but no handle_cast/2 clause was provided
    lib/gen_server.ex:824: Server.handle_cast/2
    (stdlib 4.0.1) gen_server.erl:1120: :gen_server.try_dispatch/4
    (stdlib 4.0.1) gen_server.erl:1197: :gen_server.handle_msg/6
    (stdlib 4.0.1) proc_lib.erl:240: :proc_lib.init_p_do_apply/3
Last message: {:"$gen_cast", :hi}
State: []
```

Attempting to make a cast request that does not have a callback will terminate the `GenServer`.
```elixir
iex> defmodule MyServer do
...>   use GenServer
...>
...>   def init(state) do
...>     {:ok, state}
...>   end
...> 
...>  def handle_cast({:add, element}, state) do
...>    {:noreply, [element | state]}
...>  end
...> end
{:module, MyServer,
 <<70, 79, 82, 49, 0, 0, 17, 20, 66, 69, 65, 77, 65, 116, 85, 56, 0, 0, 1, 193,
   0, 0, 0, 47, 15, 69, 108, 105, 120, 105, 114, 46, 77, 121, 83, 101, 114, 118,
   101, 114, 8, 95, 95, 105, 110, 102, 111, ...>>, {:handle_cast, 2}}
iex> GenServer.start(MyServer, [])
{:ok, #PID<0.117.0>}
iex> GenServer.cast(pid(0, 117, 0), {:remove, 1})
16:25:25.005 [error] GenServer #PID<0.249.0> terminating
** (FunctionClauseError) no function clause matching in MyServer.handle_cast/2
    iex:25: MyServer.handle_cast({:remove, 1}, [])
    (stdlib 4.0.1) gen_server.erl:1120: :gen_server.try_dispatch/4
    (stdlib 4.0.1) gen_server.erl:1197: :gen_server.handle_msg/6
    (stdlib 4.0.1) proc_lib.erl:240: :proc_lib.init_p_do_apply/3
Last message: {:"$gen_cast", {:remove, 1}}
State: []
```

### `handle_info`
The `handle_info` callback is handling all other messages that are send to the `GenServer`. For example it's completely valid to send a message to a `GenServer` with the `send/2` function. But that message cannot be handled with neither `handle_call` nor `handle_cast`. These "regular" message are all handled by `handle_info`. Similar to `handle_cast`, the `handle_info` callback does not return a response back to the caller.

The `handle_info` callback is similar to `handle_cast` in terms of inputs and the possible outputs are exactly the same. 

It takes two arguments:
- The message that was sent. 
- The current state of the `GenServer`.

A simple `handle_info` callback that handles a message could look like so:
```elixir
defmodule MyServer do
  use GenServer

  # ... some code above

  @impl true
  def handle_info(message, state) do
    IO.inspect("Irregular message incoming: #{inspect(message)}")

    {:noreply, state}
  end

  # ... some code below

end
```

The `handle_info` callback is not necessary. If not implemented, a received message will be logged as an error, but it will not terminate the `GenServer`.


### Setting up client side for `GenServer`

While it is perfectly valid to use the `GenServer` functions every time you need to start or communicate with a `GenServer` usually in a `GenServer` module some "api" functions are specified, which are used to expose the possible request. This means that for each different request there would be a function that calls this request. Later, instead of using the `GenServer` functions to communicate, you could use the functions that your module now exposes as an API.

Here is an example of a server that gives a greeting in a given language and stores how many times each greeting was being called.
```elixir
defmodule Greet do
  use GenServer

  def start() do
    # The first parameter is the module. __MODULE__ is alias for the name of the current module (i.e. MyServer)
    # Additionally we name the server with the name of the module, so we could refer to the GenServer by name instead of `pid`
    GenServer.start(__MODULE__, [], name: __MODULE__)
  end

  def greet(language) do
    GenServer.call(__MODULE__, {:greet, language})
  end

  def amount_of_greets(language) do
    GenServer.call(__MODULE__, {:count, language})
  end

  @impl true
  def init(_state) do
    # We start with 0 for each language. These number will be accumulated with each greeting call
    {:ok, %{english: 0, german: 0, spanish: 0, french: 0}}
  end

  @impl true
  def handle_call({:greet, language}, _from, state) do
    {result, new_state} =
      case language do
        :english -> {"hello", %{state | english: state.english + 1}}
        :german -> {"hallo", %{state | german: state.german + 1}}
        :spanish -> {"hola", %{state | spanish: state.spanish + 1}}
        :french -> {"bonjour", %{state | french: state.french + 1}}
      end

    {:reply, result, new_state}
  end

  @impl true
  def handle_call({:count, language}, _from, state) do
    count =
      case language do
        :english -> state.english
        :german -> state.german
        :spanish -> state.spanish
        :french -> state.french
      end

    {:reply, count, state}
  end
end
```

## Exercises
1. Create a `GenServer` that acts like a Stack. It should implement the following functionalities:
   1. Request to push new elements to the stack. (The stack will be represented by the state of the `GenServer`);
   2. Request to return the current state of the Stack;
   3. Request to remove (aka pop) elements from the Stack;
2. Create a cashing server with `GenServer` that will pull repository for a specified user from github (_A cashing server is supposed to execute some request and cache it's response. The next time the same request is being called, instead of making the request the server should pull the cached response from a previous call._). The API needed to pull github repository information for a user is outlined [here](https://docs.github.com/en/rest/repos/repos?apiVersion=2022-11-28#get-a-repository). 
The response from github is quite large, pull only these fields: "name", "url", "private", "description"
The functionality should follow this simple steps:
   1. Check if the request has already been made (is there a cached response of this request);
   2. If there is a cached response, return the cached response;
   3. If there isn't a cached response (meaning this request hasn't been made before), the server should execute the request, store the response in the cache (aka. in the state of the `GenServer`) and return the response back to the caller;

**Notes**
1. To make HTTP requests you need to use a library. A good fit is [HTTPoison](https://github.com/edgurgel/httpoison). To add a dependency to your Elixir application, open `mix.exs` file and add the dependency for `httpoison` in the `deps` list. Like so:
```elixir
def deps do
  [
    {:httpoison, "~> 1.8"}
  ]
end
```

