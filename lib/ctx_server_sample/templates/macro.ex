defmodule CtxServerSample.Templates.Macro do
  defmacro eval_eml do
    # [TODO] Mix doesn't new eml file, so currently we must recompile explicitly.
    for path <- Path.wildcard(__DIR__ <> "/*.eml") do
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
  end
end
