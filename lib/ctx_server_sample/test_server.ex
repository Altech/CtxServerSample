defmodule CtxServerSample.TestServer do
  use CtxServer

  alias CtxServerSample.User
  alias CtxServerSample.Item

  def start_link(name) do
    CtxServer.start_link(__MODULE__, name, name: name)
  end

  def handle_call({method, request_path, params, session_params}, _, _) do
    html = handle_call({method, request_path}, {params, session_params})
    {:reply, html, nil}
  end

  def render(name, vars \\ []) do
    vars = for {k,v} <- vars, into: %{}, do: {k,v}
    apply(CtxServerSample.Templates, name, [vars]) |> Eml.compile
  end

  # # Request Handling

  def handle_call({"GET", "/"}, {_, session_params}) do
    user_id = session_params.user_id
    screen_name = user_id && User.find_by_id(user_id).screen_name
    render :root, links: ~w[login logout items], screen_name: screen_name
  end

  def handle_call({"GET", "/login"}, _) do
    render :login_get
  end

  def handle_call({"POST", "/login"}, {params, _}) do
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
    render :login_post, screen_name: screen_name, user_id: user_id
  end

  def handle_call({"GET", "/items"}, _) do
    render :items, items: Item.first(20)
  end
end
