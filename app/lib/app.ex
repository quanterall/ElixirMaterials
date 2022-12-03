defmodule App do
  use GenServer

  def start do
    GenServer.start(__MODULE__, [], name: __MODULE__)
  end

  def ping do
    GenServer.call(__MODULE__, :ping)
  end

  def ping2 do
    GenServer.call(__MODULE__, :ping_2)
  end

  @impl true
  def init(args), do: {:ok, args}

  @impl true
  def handle_call(:ping_2, from, state) do
    {:reply, :pong, state, 3_000}
  end

  @impl true
  def handle_call(:ping, from, state) do
    Process.send_after(self(), {:reply, from, :pong}, 1_000)
    # {:reply, :pong, state}
    {:noreply, state}
  end

  @impl true
  def handle_info({:reply, from, message}, state) do
    # IO.inspect("I received some message #{inspect(msg)}")
    GenServer.reply(from, message)
    {:noreply, state}
  end

  @impl true
  def handle_info(catch_all, state) do
    IO.inspect("I received some message #{inspect(catch_all)}")
    {:noreply, state}
  end
end
