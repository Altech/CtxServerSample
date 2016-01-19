defmodule CtxServerSample.TestServer do
  use CtxServer

  alias CtxServerSample.User
  alias CtxServerSample.Item

  def start_link(name) do
    CtxServer.start_link(__MODULE__, name, name: name)
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
        p "You are @#{User.find_by_id(user_id).screen_name}"
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
          input type: "text", name: "screen_name"
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
    screen_name = params["screen_name"]
    password = params["password"]
    new = params["new"] == "true"
    success = if new do
      !!User.create(screen_name, password)
    else
      User.check_password(screen_name, password)
    end
    if success do
      user_id = User.find_by_screen_name(screen_name).id
      {:reply, {"Successed to login with @#{screen_name}", user_id}, state}
    else
      {:reply, {"Failed to login with @#{screen_name}", nil}, state}
    end
  end

  def handle_call({:get, :items}, _, state) do
    use Eml.HTML
    dom = html do
      table do
        tr do
          th "Title"
          th "Description"
          th "Price"
        end
        for item <- Item.first(20) do
          tr do
            td item.title
            td item.description
            td "#{item.price/100}$"
          end
        end
      end
    end
    {:reply, dom |> Eml.compile, state}
  end
end
