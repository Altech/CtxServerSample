defmodule ApplicationContexts do
  use CtxServer.ContextDSL

  defcontext :content_type, scope: :local

  defcontext :current_user, scope: :global, priority: :sender

  defcontext :login do
    !!context(:current_user)
  end

  defcontext :language do
    if context(:current_user) do
      context(:current_user).language
    else
      "en"
    end
  end

  defcontext :country do
    if context(:current_user) do
      context(:current_user).country
    else
      "ja"
    end
  end
end
