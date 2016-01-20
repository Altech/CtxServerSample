defmodule CtxServerSample.HTTPServer do
  use CtxServer

  alias CtxServerSample.Models.User
  alias CtxServerSample.Models.Item

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

  context :any do
    def handle({"GET", "/"}, _params) do
      screen_name = current_user && current_user.screen_name
      render :root, links: ~w[login logout items], screen_name: screen_name
    end

    def handle({"GET", "/login"}, _params) do
      render :login_get
    end

    def handle({"POST", "/login"}, params) do
      screen_name = params["screen_name"]
      password = params["password"]
      new = params["new"] == "true"
      success = if new do
        !!User.create(screen_name, password)
      else
        User.check_password(screen_name, password)
      end
      user_id = if success do
        User.find_by_screen_name(screen_name).id
      else
        nil
      end
      if success do
        put_session(:user_id, user_id)
      end
      render :login_post, screen_name: screen_name, user_id: user_id
    end

    def handle({"GET", "/logout"}, _) do
      delete_session(:user_id)
      render :logout
    end

    def handle({"GET", "/items"}, _) do
      render :items, items: Item.first(20)
    end
  end

  context login: true do
    def handle({"POST", "/purchase"}, params) do
      "Purchased #{Item.find_by_id(params["item_id"]).title}!"
    end
  end
   
  context login: false do
    def handle({"POST", "/purchase"}, _) do
      "Please login before purchase"
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
