defmodule CtxServerSample.TestServer do
  use CtxServer

  alias CtxServerSample.User
  alias CtxServerSample.Item

  def start_link(name) do
    CtxServer.start_link(__MODULE__, name, name: name)
  end

  def init(_) do
    User.init
    Item.init
    {:ok, nil}
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

  def handle_call({:get, :root, _, %{user_id: user_id}}, _, state) do
    use Eml.HTML
    links = ~w[login logout items]
    dom = html do
      ul do
        for link <- links do
          li do
            %Eml.Element{tag: :a, attrs: %{href: link}, content: link}
          end
        end
      end
      if user_id do
        p "You are @#{user_id}"
      end
    end
    {:reply, dom |> Eml.compile, state}
  end

  def handle_call({:get, :login, _}, _, state) do
    use Eml.HTML
    dom = html do
      form method: "POST", action: "login" do
        p do
          "User ID: "
          input type: "text", name: "user_id"
        end
        p do
          "Password: "
          input type: "password", name: "password"
        end
        p do
          "Register as a new user: "
          input type: "checkbox", name: "new", value: "true"
        end
        p do
          input type: "submit", value: "Submit"
        end
      end
    end
    {:reply, dom |> Eml.compile, state}
  end

  def handle_call({:post, :login, params}, _, state) do
    use Eml.HTML
    user_id = params["user_id"]
    password = params["password"]
    new = params["new"] == "true"
    success = if new do
      User.register_with_password(user_id, password)
    else
      User.login_with_password(user_id, password)
    end
    if success do
      {:reply, {"Successed to login with @#{user_id}", user_id}, state}
    else
      {:reply, {"Failed to login with @#{user_id}", user_id}, state}
    end
  end

  def handle_call({:get, :items}, _, state) do
    use Eml.HTML
    dom = html do
      ul do
        for [name, price] <- Item.all do
          li "#{name} #{price}$"
        end
      end
    end
    {:reply, dom |> Eml.compile, state}
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

  context :any do
    def handle_cast(request, state) do
      IO.puts debug_info(request)
      {:noreply, state}
    end

    def handle_call(request, from, state) do
      {:reply, debug_info(request), state}
    end
  end
end


quote do
  # CtxServer.switch_context :login, true
  {:ok, pid} = CtxServer.start(CtxServerSample.TestServer, [])
  CtxServer.Contexts.update login: true, payment: :normal
  CtxServer.cast(pid, :foo)
  CtxServer.call(pid, :foo)
end
