defmodule CtxServerSample.Templates do
  use Eml
  use Eml.HTML

  require CtxServerSample.Templates.Macro
  CtxServerSample.Templates.Macro.eval_eml
end
