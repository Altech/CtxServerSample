defmodule CtxServerSample.TestServer do
  use CtxServer

  def start_link(name) do
    CtxServer.start_link(__MODULE__, name, name: name)
  end

  defmacro debug_info(request) do
    quote do
      {name, arity} = __ENV__.function
      """
      CALL: #{name}/#{arity}
        request: #{inspect unquote(request)},
        contexts: #{inspect CtxServer.Contexts.current}
      """
    end
  end

  context login: true, payment: :normal do
    def handle_cast(request, state) do
      IO.puts debug_info(request)
      {:noreply, state}
    end

    def handle_call(request, _, state) do
      {:reply, debug_info(request), state}
    end
  end

  context login: true, payment: :abnormal do
    def handle_cast(request, state) do
      IO.puts debug_info(request)
      {:noreply, state}
    end

    def handle_call(request, _, state) do
      {:reply, debug_info(request), state}
    end
  end

  def handle_cast(request, state) do
    IO.puts debug_info(request)
    {:noreply, state}
  end

  def handle_call(request, from, state) do
    {:reply, debug_info(request), state}
  end
end


quote do
  # CtxServer.switch_context :login, true
  {:ok, pid} = CtxServer.start(CtxServerSample.TestServer, [])
  CtxServer.Contexts.update login: true, payment: :normal
  CtxServer.cast(pid, :foo)
  CtxServer.call(pid, :foo)
end
