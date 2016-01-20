defmodule CtxServerSample.HTTPServerUtils do
  defmacro save_session_instructions(do: proc) do
    quote do
      Process.put(:session_instructions, [])
      html = if true do
        unquote(proc)
      end
      instructions = Enum.reverse(List.wrap(Process.get(:session_instructions)))
      {html, instructions}
    end
  end

  def render(name, vars \\ []) do
    vars = for {k,v} <- vars, into: %{}, do: {k,v}
    apply(CtxServerSample.Templates, name, [vars]) |> Eml.compile
  end

  def put_session(key, value) do
    list = List.wrap(Process.get(:session_instructions))
    Process.put(:session_instructions, [{:put_session, [key, value]}|list])
  end

  def delete_session(key) do
    list = List.wrap(Process.get(:session_instructions))
    Process.put(:session_instructions, [{:delete_session, [key]}|list])
  end
end
