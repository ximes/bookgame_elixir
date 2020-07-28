defmodule BookGameWeb.Router do
  use BookGameWeb, :router
  use Pow.Phoenix.Router

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Public routes
  scope "/" do
    pipe_through :browser

    pow_routes()
    get "/", BookGameWeb.PageController, :index
  end

  # Protected routes
  scope "/", BookGameWeb do
    pipe_through [:browser, :protected]
  end
  
  # Other scopes may use custom stacks.
  # scope "/api", BookGameWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: BookGameWeb.Telemetry
    end
  end
end
