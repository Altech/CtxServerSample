defmodule CtxServerSample.Templates.Macro do
  defmacro eval_eml do
    ast = for path <- Path.wildcard(__DIR__ <> "/*.eml") do
      {:ok, code} = File.read(path)
      {dom, _} = Code.eval_string("""
      quote do
        #{code}
      end
      """, [], __ENV__)

      name = String.to_atom(hd(String.split(Path.basename(path), ".")))
      quote do
        def unquote(name)(vars) do
          unquote(dom)
        end
      end
    end
    IO.puts Macro.to_string(ast)
    ast
  end
end
