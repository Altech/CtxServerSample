defmodule CtxServerSample.HTTPServer do
  use CtxServer

  alias CtxServerSample.Models.User
  alias CtxServerSample.Models.Item
  alias CtxServerSample.Models.Purchase

  # # Public Interface

  def start_link(name) do
    CtxServer.start_link(__MODULE__, name, name: name)
  end

  def handle_call({method, request_path, params, session}, _, _) do
    Process.put(:session_instructions, [])
    switch_context(:current_user, User.find_by_id(session.user_id))
    html = handle({method, request_path}, params)
    instructions = Enum.reverse(List.wrap(Process.get(:session_instructions)))
    {:reply, {html, instructions}, nil}
  end

  # # Request Handlers

  context login: true do
    def handle({"GET", "/register"}, _) do
      "You are alreadly logined with @#{current_user.screen_name}"
    end

    def handle({"GET", "/login"}, _) do
      "You are alreadly logined with @#{current_user.screen_name}"
    end

    def handle({"GET", "/logout"}, _) do
      delete_session(:user_id)
      render :logout
    end

    def handle({"POST", "/purchase"}, params) do
      {:ok, purchase} = Purchase.insert(current_user.id, String.to_integer(params["item_id"]))
      "Purchased #{Item.find_by_id(params["item_id"]).title}!"
    end
  end

  context login: false do
    def handle({"GET", "/register"}, _) do
      render :register_get
    end

    def handle({"GET", "/login"}, _) do
      render :login_get
    end

    def handle({"POST", "/login"}, params) do
      IO.puts "Check:#{User.check_password(params["screen_name"], params["password"]) }"
      user = if User.check_password(params["screen_name"], params["password"]) do
               User.find_by_screen_name(params["screen_name"])
             end
      if user do
        put_session(:user_id, user.id)
      end
      render :login_post, user: user
    end

    def handle({"POST", "/register"}, params) do
      res = User.insert(params["screen_name"], params["password"], language: params["language"], country: params["country"])
      user = case res do
               {:ok, user} ->
                 put_session(:user_id, user.id)
                 user
               {:error, _} -> nil
             end
      render :register_post, user: user
    end

    def handle({"POST", "/purchase"}, _) do
      "<html>Please <a href='login'>login</a> before purchase</html>"
    end
  end

  context :any do
    def handle({"GET", "/"}, _) do
      screen_name = current_user && current_user.screen_name
      render :root, links: ~w[login logout register items], screen_name: screen_name
    end

    def handle({"GET", "/items"}, _) do
      render :items, items: Item.first(20)
    end
  end

  # # Web Application Utilities

  defp render(name, vars \\ []) do
    vars = for {k,v} <- vars, into: %{}, do: {k,v}
    apply(CtxServerSample.Templates, name, [vars]) |> Eml.compile
  end

  defp put_session(key, value) do
    list = List.wrap(Process.get(:session_instructions))
    Process.put(:session_instructions, [{:put_session, [key, value]}|list])
  end

  defp delete_session(key) do
    list = List.wrap(Process.get(:session_instructions))
    Process.put(:session_instructions, [{:delete_session, [key]}|list])
  end

  defp current_user do
    context(:current_user)
  end
end
