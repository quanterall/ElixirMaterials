
- [Concurrency](#concurrency)
  - [Creating a process](#creating-a-process)
  - [Message passing](#message-passing)
  - [Exercises](#exercises)
  - [Setting up a long lived process](#setting-up-a-long-lived-process)

# Concurrency

This section is about the primitives that Elixir/Erlang exposes for dealing with processes. In Elixir processes are really light weight. It takes only a couple of microseconds to create a single process and its initial memory footprint is a few kilobytes. For that reason Elixir/Erlang are famous for starting millions of processes without much of a sweat. (_The theoretical limit imposed by the BEAM VM is 134 million_).

In BEAM a process is a concurrent thread of execution. Two processes run concurrently and may even run in parallel of at least two CPU cores are available. BEAM processes are handled by the VM, which uses it's own scheduler to manage their concurrent execution. By default BEAM uses as many schedulers as there are CPU cores available. For example, if you have 4 core machine, it will start 4 schedulers. A scheduler is in charge of the interchangeable execution of the processes. Meaning that the scheduler is responsible for making sure that each process get its fare share of execution time. When the time slot which has been granted for a process is over, the running process is  and the next one takes over. That principle is then repeated for each process until all of them finish their execution. Because of the way the BEAM schedulers work, there isn't a possibility for a process to hang the whole VM, because when it's time is up, it will be preempted and the next process will get some execution time. Meaning, one bad process cannot ruin a whole system.

BEAM processes are completely isolated. They don't share memory or state and a crash of one process does not affect the rest that are running. Each process handles it's own state and when a process dies the state dies with it. Because of this isolation in order for the processes to communicate with each other they send messages between themselves. 

## Creating a process
The simplest way to execute some piece of code in a separate process is by using the `spawn/1` function which takes a function with no arguments. The function passed to `spawn/1` is the one that will be executed in a separate process (i.e the process that is started by the `spawn/1` function). That process is short lived and as soon as the execution of the function that you passed is over, the process will die.

```elixir
iex(1)> spawn(fn -> IO.inspect("hello world") end)
#PID<0.109.0>
"hello world"
```
The returned value of the `spawn/1` function is _#PID<0.109.0>_ which is called `pid` (shorthand for process id). The `pid` is basically an address that points to a specific process, used as a way to reference a process.

`Process.alive?/1` can be used to verify that the process has died after finishing the execution of the function, but we have to take a hold on the `pid` that is returned by the `spawn/1` function.
```elixir
iex(1)> pid = spawn(fn -> IO.inspect("hello world") end)
#PID<0.109.0>
"hello world"
iex(2)> Process.alive?(pid)
false
```

For a more concrete example let's simulate a function that take some time to execute. (_We can simulate this via the `Process.sleep/1` function_)
```elixir
iex> long_task = fn id ->
...>   Process.sleep(2_000)
...>   "#{id} has finished"
...> end
#Function<42.3316493/1 in :erl_eval.expr/6>
```

When we execute the function it takes it 2 seconds to return the result
```elixir
iex> long_task.(1)
"1 has finished"
```

If we run multiple of these what we'll see is that the first one has to finish in order for the second to start executing and so forth. The following code takes 10 seconds to return the result. This makes absolute sense since we started 5 tasks where each one takes 2 seconds to finish.
```elixir
iex> Enum.map(1..5, fn id -> long_task.(id) end)
["1 has finished", "2 has finished", "3 has finished",
 "4 has finished", "5 has finished"]
```

Now let's create a function that would run this long task in a separate process. We are reusing the `long_task/1` function that is already defined above. To get the result from the process we'll use `IO.inspect/1` to print out the information on the terminal. Later we'll look into how processes can send information between each other.
```elixir
iex> async_long_task = fn id ->
...>   spawn(fn -> IO.inspect(long_task.(id)) end)
...> end
#Function<42.3316493/1 in :erl_eval.expr/6>
iex> async_long_task.(1)
#PID<0.133.0>
"1 has finished"
```
Here it takes us again 2 seconds in order to get the result printed on the screen. Which at this point is no different than the synchronous long task, but let's see what happens when we call multiple of these.
```elixir
iex> Enum.map(1..5, fn id -> async_long_task.(id) end)
[#PID<0.123.0>, #PID<0.124.0>, #PID<0.125.0>, #PID<0.126.0>,
 #PID<0.127.0>]
"1 has finished"
"2 has finished"
"3 has finished"
"4 has finished"
"5 has finished"
```

This only took 2 seconds to complete. This is because we started 5 processes which wre running concurrently and therefore finishing at the same time. As we stated earlier processes are completely isolated and independent of each other. We don't get access to the results that were produced by the processes which works perfectly fine when we don't care about them.


## Message passing
Processes are completely isolated from each other and don't share memory, so the only way to share information between each other is via messages. In order for `process A` to make `process B` do something or send some information, it needs to send a message. Each process has a so called `mailbox`. When `process A` send a message to `process B`, a new message appears in the `mailbox` of `process B`. Processes can read messages from their `mailboxes` at any time. Messages are of type `term`, which means that any data type can be send as a message. 

Because processes can't share memory, a message is deep-copied when it's sent. This means that even if `process A` dies before `process B` reads it's message, the message wont be lost. It will stay in the `mailbox` of `process B` until it is read. The process `mailbox` is a FIFO queue limited only by the available memory. When processes read messages from the queue, they are consumed in order of arrival.

Think of the mailbox as a queue, where message arrive to the left and are read from the right. So first `Message1` will be read, then `Message2` and finally `Message3`.
```
Message3 -> Message2 -> Message1
```

If a new message `Message4` arrives, it will go to the left of `Message3`. And maybe `Message1` and `Message2` have been consumed.
```
Message4 -> Message3
```

**NB:** A message can only be removed from the `mailbox` (_the queue_) by consuming it. There is no way to unsent a message or delate a message from the `mailbox`.

Sending a message to a process is done using the `send/2` function.
```elixir
iex> terminal_pid = self()
#PID<0.107.0>
iex> spawn(fn -> send(terminal_pid, "Hello from #{inspect(self())}") end)
#PID<0.139.0>
```

There are a few things to unwrap in this example. First we used `send/0` function in order to obtain the pid of the shell (_Keep in mind that the terminal is a process on it's own_). We need that pid, because we want to send a message from a brand new process to the process of the shell. Then we spawn a new process and inside it's function we call `send/2` where we specify that the receiver of the message is the `terminal_pid` and we want to send a message `Hello from {pid_of_the_caller}`. As you may notice, inside the function we again call `self/0` but this time this call will yield the pid of the spawned process (in our case that is `#PID<0.139.0>`, as we can see from the result of the `spawn/1` function). Once this is called, the shell process receives a new message in it's `mailbox`.

In order to receive a message from the `mailbox` of a process we need to use the `receive do` block. Which as the name implies is used to receive messages.

```elixir
iex> result = receive do
...>   message -> "Received message: #{message}"
...> end
"Received message: Hello from #PID<0.139.0>"
iex> result
"Received message: Hello from #PID<0.139.0>"
```

The `receive do` block works almost the same way as the `case do` block. It allows for multiple pattern matches in order to handle various types of incoming messages. 
In the example above a simple _match all_ pattern is used to capture the incoming message. A string is returned as a result of the `receive do` block.


A more preferable way to do this would be to send the message with a simple structure, so that it would be easier to pattern match on this particular message.
The messages that are send between processes should be easily distinguishable from one another. 
It comes in handy later when there is the need to read the message box and match on the different messages, since most probably those different messages will have different purpose.
```elixir
iex> spawn(fn -> send(terminal_pid, {:message, "Hello World", self()}) end)
#PID<0.160.0>
iex> receive do
...>   {:message, message, sender} -> "Received message from [#{inspect(sender)}]: #{message}"
...> end
"Received message from [#PID<0.162.0>]: Hello World"
```

If there are no message left in the `mailbox` of a process the `receive do` block will wait indefinitely for a new message to arrive. 
This means that the process in which you called the `receive do` block will hang (_until a new message arrives_).

```elixir
iex> receive do
...>   message -> message
...> end # <---- Here the shell will hang if there are no messages left in the mailbox
```

<!-- In order to overcome this problem we can attach a time frame to the `receive do` block. After that time has passed it can do something else. -->
To allow the `receive do` block to finish without reading a message, you must add the `after` section.
It allows to specify a time to wait for a new message. This time is only waited if the `mailbox` is empty. 
Once the time runs over, it will execute the provided logic.

```elixir
iex> receive do
iex>   message -> message
iex> after
iex>   5_000 -> "Mailbox is empty"
iex> end # <--- Result will be visible after 5 seconds, since the mailbox of the shell process is empty
"Mailbox is empty"
```

The `receive do` block read only one message at a time. And while the messages in the `mailbox` are kept in some sort of a queue, reading them might not return them in order. When a `receive do` block is called, it will read only one message, but that one message needs to match one of the specified patterns.
If the pattern is specific enough, it might not match all messages in the `mailbox` and it might only match the very last message that was send. If that is the case, then that is the message that the `receive do` block is going to read.
It will still replay the messages in order of arrival, but it will read the first message that matches the provided pattern matches.

Let's see how this works out
```elixir
iex> shell_pid = self()
#PID<0.107.0>
iex> spawn(fn -> send(shell_pid, "first message") end)
#PID<0.110.0>
iex> spawn(fn -> send(shell_pid, {:msg, "second message"}) end)
#PID<0.112.0>
iex> :erlang.process_info(shell_pid, :messages) # <-- Check the messages in the mailbox of a process
{:messages, ["first message", {:msg, "second message"}]}
iex> receive do
...>   {:msg, msg} -> msg
...> end
"second message"
```

As you can see we read the second message in the queue, because the first one didn't match the pattern in the `receive do` block. 
The first message is still unhandled, so it remains in the `mailbox` waiting to be processed. We can read it if we do a _catch all_ pattern match.

```elixir
iex> receive do
...>   msg -> msg
...> end
"first message"
```

**NB** Messages keep their order in the queue, even if they don't match the specified pattern. They will always be executed in order, yet the message that will be read is the first one that matched the given pattern. Messages remain in the `mailbox` until they are processed or the process dies.

Now we can change the code we did for `async_long_task` to actually send the response back to the caller.
```elixir
iex> long_task = fn id ->
...>   Process.sleep(2_000)
...>   "#{id} has finished"
...> end
#Function<42.3316493/1 in :erl_eval.expr/6>
iex> async_long_task = fn (id, receiver) ->
...>   spawn(fn -> send(receiver, {:result, long_task.(id)}) end)
...> end
#Function<42.3316493/1 in :erl_eval.expr/6>
iex> terminal_pid = self()
#PID<0.107.0>
iex> Enum.each(1..5, fn num -> async_long_task.(num, terminal_pid) end) # <- Here we are calling `async_long_task/1` 5 times
:ok # <- This means that all the tasks have been called and now we can start consuming the results
iex> reader = fn -> # <- We'll do a utility function that calls `receive do` for ease of use
...>   receive do
...>     {:result, data} -> data
...>   end
...> end
#Function<43.3316493/0 in :erl_eval.expr/6>
iex> Enum.map(1..5, fn _ -> reader.() end) # <- We can use `Enum.map` here to read the results
["1 has finished", "2 has finished", "3 has finished",
 "4 has finished", "5 has finished"]
```

**NB** An important note to be made is that `self/0` returns the pid of the process in which it is called. So make sure you are calling it in the correct process. In the example above we had to make sure to call `self/0` outside the `spawn/1` function in order to take the pid of the shell and not the pid of the process which will be started by calling `spawn/0`.

## Exercises
1. Create a `process A` that upon receiving a message holding the value `ping` send back a message to the sender with a value holding the message `pong`. After `process A` send a `ping` message to `process B`, `processA` should be expecting a message holding the value `pong` and information on who send that message _(It's necessary to differentiate `pong` messages coming back from multiple processes, although it this exercise we are working with only one process.)_.
This should look something like this:
1. `process B` sends a message with `ping` to `process A` 
2. `process A` receives the message and send back a message to `process B` with the message `pong`
3. `process B` should have a message in it's mailbox holding the value `pong` alongside information on who sent that message

**Notes**
`Process B` in the first task could be played by the shell process.


## Setting up a long lived process

The processes that we created so far were short lived processes. They start, they do their job and then they die. They don't hold and state and therefore we cannot do a lot of interesting things with such a process. Holding state is essential to have some meaningful logic. In order to do that with processes we have to make sure to keep the process alive after it finishes it's task. 

What we could do to accomplish this would be to have a `receive do` block that would wait for a message to come with some instructions on what to do, and after the job is done, to call `receive do` block again in order to wait for another message with instructions to come. The process will be kept alive because it's waiting for a message and will stay there until a message arrives. Writing this down in the shell would to too cumbersome, so let's write an Elixir module (that would be a file that ends with an `.ex` extension).

```elixir
defmodule TodoServer do
  defmodule Todo do
    defstruct [:id, :name]
  end

  # Starts a process and calls `loop/1` inside, which recursively will hold the process alive
  def start() do
    spawn(fn -> loop([]) end)
  end

  # Here is the looping logic that will keep this process alive. The loop function calls the 
  # `receive do` block and after it executes the necessary task it takes the result,
  # which in our case is the new state and calls `loop/1` again.
  defp loop(state) do
    new_state = receive do 
      {:add, todo} -> [%Todo{id: random_id(), name: todo} | state]
      {:remove, id} -> Enum.filter(state, fn %Todo{id: todo_id} -> id !== todo_id end)
      :show -> IO.inspect(state)
    end

    # Call `loop/1` again to keep the process going
    loop(new_state)
  end

  defp random_id, do: trunc(:random.uniform * 1_000_000)
end
```
We have 3 actions that are available through the TodoServer. 
1. Add a todo
2. Remove a todo
3. Show all todos

Let's see how this code works in action
```elixir
iex> TodoServer.start() # <- We forgot to bind the pid to a variable
#PID<0.520.0>
iex> todo_server = pid(0, 520, 0) # <- We can always create a pid using the `pid/3` function
#PID<0.520.0>
iex> Process.alive?(todo_server) 
true
iex> send(todo_server, {:add, "mop the floors"})
{:add, "mop the floors"}
iex> send(todo_server, {:add, "clean the dust"})
{:add, "clean the dust"}
iex> send(todo_server, :show)
[${id: 2, name: "clean the dust"}, %{id: 1, name: "mop the floors"}]
:show
iex> send(todo_server, :unknown) # <- Sending an unknown message to the process won't cause issues
:unknown                    # <- The message will stay in the message box and never be processed
```