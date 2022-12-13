## What is a `Supervisor`
A `Supervisor` is a process which supervises other processes, which are often referred to as _child processes_, and the `Supervisor` as their parent. The `Supervisor`s main job is to watch over its children and make sure that all of them are running. If some of the child processes dies, it's the `Supervisor` job to restart those processes and make they are running again.

These relationships between a `Supervisor` and its children creates a hierarchical structure called _Supervision tree_. _Supervision trees_ provide fault tolerance and encapsulate all the processes that are running in an application. Usually in an application there is one `Supervisor` at the top and all other processes are connected to it. Those other processes can be a `GenServer`, another `Supervisor` or some other processes. Since the `Supervisor` is just a process it can be attached as a _child_ to another `Supervisor`.

So you could have a system that looks like so:
```
                  |---------Supervisor_A--------|
                  |              |              |
            Supervisor_B     GenServer_A    GenServer_B
            |          |
     GenServer_C     GenServer_D
```


## Attaching children to `Supervisor`
Each process that is attached to a `Supervisor` is considered its _child_. Each _child_ needs to provide _child specifications_ that describe how the `Supervisor` should _starts_, _shuts down_ and _restarts_ it.

In its full form the _child specification_ is a map which can hold up to 6 fields:
- `:id` (**required**): Gives unique identifier for the process by which the `Supervisor` will refer to it (defaults to the module name of the process, which usually is a `GenServer`). If such identifier is already used by another process the `Supervisor` will refuse to initialize this process.;
- `:start` (**required**): A tuple of MFA structure used to describe how the child should be invoked (MFA stands for Module Function Arguments);
- `:restart` (**optional**): An atom describing when to restart a terminated child. Defaults to `:permanent`, which means that the `Supervisor` will always restart this child;
- `:type` (**optional**): Specifies whether the child process is a `:worker` or a `:supervisor`, where a `:worker` is a process that handles some logic (usully a `GenServer`) and a `:supervisor` is just a `Supervisor` process. Defaults to `:worker`;
- `:shutdown` (**optional**): An atom or integer describing how to terminate the child process. The integer value describes how much time will the `Supervisor` wait for the child process to handle a graceful shutdown process (this is only if the child process handles a graceful shutdown, if not, it will be terminated immediately). The atom value can either by `:infinity`, which means that the `Supervisor` will wait as long as it has to, or `:brutally_kill` which will terminate the child process immediately. Defaults to `5_000` for a child of type `:worker` and `:infinity` for child of type `:supervisor`.

A simple _child specification_ looks like this:
```elixir
# Describing all the children of the Supervisor
children = [
  %{
    id: Stack,
    start: {Stack, :start_link, [[:hello_world]]}
  }
]
```

Additionally `Supervisor` allows for a simpler way to describe child processes. A two element sized tuple, describing the module name and the arguments provided to a `start_link` function that should be described in the given module.
```elixir
# Describing all the children of the Supervisor
children = [
  {Stack, [:hello_world]}
]
```
This specification is calling `Stack.start_link([:hello_world])`

An even simpler way would be just to describe the module name, without any arguments.
```elixir
# Describing all the children of the Supervisor
children = [
  Stack
]
```
This is actually translated to:
```elixir
# Describing all the children of the Supervisor
children = [
  {Stack, []}
]
```
Which means that it's calling `Stack.start_link([])`

## Restart strategy
The main goal of the `Supervisor` is to monitor over all its children and make sure that if some of them die unexpectedly they will be restarted appropriately. Restart strategies describe how the child processes should be restarted. There are three strategies:
- `:one_for_one`: If a process dies, the `Supervisor` will restart only the dead process;
- `:rest_for_one`: If a process dies, the `Supervisor` will restart the dead process and all processes that were started after it (meaning, all processes described after it in the children list);
- `:one_for_all`: If a process dies, the `Supervisor` will restart all process (in the order they are described in the children list);

## Setting up a `Supervisor`
The `Supervisor`, much like the `GenServer` can be described in a module with few simple lines.

Let's say that we have this simple `GenServer` process.
```elixir
defmodule Stack do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def pop() do
    GenServer.call(__MODULE__, :pop)
  end

  def push(value) do
    GenServer.cast(__MODULE__, {:push, value})
  end

  ## Callbacks

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  @impl true
  def handle_cast({:push, head}, tail) do
    {:noreply, [head | tail]}
  end
end
```

Now setting up a `Supervisor` process that will look after the `Stack` process:
```elixir
defmodule MyApp.Supervisor do
  # Automatically defines child_spec/1
  use Supervisor

  def start_link(init_arg \\ []) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    # Describing all the children of the Supervisor
    children = [
      {Stack, [:apple]} # Calling Stack.start_link([:apple])
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
```

Now when the `GenServer` process dies, the `Supervisor` will make sure to restart it with the provided initial arguments:
```elixir
iex> MyApp.Supervisor.start_link()
{:ok, #PID<0.261.0>}
iex> Stack.pop()
:apple
iex> Stack.pop()
19:52:59.703 [error] GenServer Stack terminating
** (FunctionClauseError) no function clause matching in Stack.handle_call/3
    (app 0.1.0) lib/app.ex:16: Stack.handle_call(:pop, {#PID<0.259.0>, [:alias | #Reference<0.4100405182.2229075971.184828>]}, [])
    (stdlib 4.1.1) gen_server.erl:1149: :gen_server.try_handle_call/4
    (stdlib 4.1.1) gen_server.erl:1178: :gen_server.handle_msg/6
    (stdlib 4.1.1) proc_lib.erl:240: :proc_lib.init_p_do_apply/3
Last message (from #PID<0.259.0>): :pop
State: []
Client #PID<0.259.0> is alive
iex(3)> Stack.pop() # The `GenServer` has been restarted
:apple
```

## Exercises
1. Setup a `Supervisor` process for the `GenServer` processes created from the exercises of the `GenServer` chapter.