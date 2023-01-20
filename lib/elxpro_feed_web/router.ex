defmodule ElxproFeedWeb.Router do
  use ElxproFeedWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ElxproFeedWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ElxproFeedWeb do
    pipe_through :browser

    live "/cars", CarLive.Index, :index
    live "/cars/new", CarLive.Index, :new
    live "/cars/:id/edit", CarLive.Index, :edit

    live "/cars/:id", CarLive.Show, :show
    live "/cars/:id/show/edit", CarLive.Show, :edit
    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", ElxproFeedWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:elxpro_feed, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ElxproFeedWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
