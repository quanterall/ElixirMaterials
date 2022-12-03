- [What is a `GenServer`](#what-is-a-genserver)
- [Main `GenServer` callbacks](#main-genserver-callbacks)
  - [`init`](#init)
  - [`handle_call`](#handle_call)
  - [`handle_cast`](#handle_cast)
  - [`handle_info`](#handle_info)
  - [`handle_continue`](#handle_continue)
- [How to create a `GenServer`](#how-to-create-a-genserver)

## What is a `GenServer`
Working with processes is one of the main drive to use the BEAM via Elixir/Erlang. While working with processes is straight forward, there are a few aspects that overlap most of the times. So having a generic way to deal with / setup a process is really helpful. Having a generic interface to operate with processes makes for a simpler codebase with one way of doing things.d

A `GenServer` process provides just that. It's a generic way to describe a process and implement all the necessary features one might need, by using the set of standard set of interface functions that the `GenServer` exposes. At it's core a `GenServer` is just an Elixir process and can be used to keep/modify state, execute synchronous/asynchronous code.

## Main `GenServer` callbacks
There are total of 8 callbacks. This chapter is going to cover only the most used ones. The ones that you'll have to deal with most of the times when you are working with `GenServer`.

### `init`

### `handle_call`

### `handle_cast`

### `handle_info`

### `handle_continue`

## How to create a `GenServer`
Let's create a simple `GenServer` for storing data like a stack, which would allow us to push and pop items in to/out of.

```elixir
defmodule Stack do
  use GenServer

  def start(initial_state \\ []) do
    GenServer.start(__MODULE__, initial_state)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:push, element}, state) do
    {:noreply, [element | state]}
  end

  @impl true
  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end
end
```

1. There is a problem with this implementation. There is an error that will cause the process to break at some point. Can you point out where the problem is and possibly when will this problem occur?