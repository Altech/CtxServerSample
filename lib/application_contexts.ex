defmodule ApplicationContexts do
  use CtxServer.ContextDSL

  defcontext :content_type, scope: :local

  defcontext :current_user, scope: :global, priority: :sender

  defcontext :login do
    !!context(:current_user)
  end

  defcontext :language do
    if context(:current_user) do
      "en" # context(:current_user).language
    else
      "ja"
    end
  end
end
