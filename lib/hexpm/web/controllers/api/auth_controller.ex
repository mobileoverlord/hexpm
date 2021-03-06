defmodule Hexpm.Web.API.AuthController do
  use Hexpm.Web, :controller

  plug :required_params, ["domain"]
  plug :authorize

  def show(conn, %{"domain" => domain} = params) do
    key = conn.assigns.key
    user = conn.assigns.current_user
    resource = params["resource"]

    if Key.verify_permissions?(key, domain, resource) do
      if User.verify_permissions?(user, domain, resource) do
        send_resp(conn, 204, "")
      else
        error(conn, {:error, :auth})
      end
    else
      error(conn, {:error, :domain})
    end
  end
end
