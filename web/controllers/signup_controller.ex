defmodule HexWeb.SignupController do
  use HexWeb.Web, :controller

  def show(conn, _params) do
    render_show(conn, User.build(%{}))
  end

  def create(conn, params) do
    case Users.add(params["user"]) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "A confirmation email has been sent, you will have access to your account shortly")
        |> put_flash(:custom_location, true)
        |> redirect(to: "/")
      {:error, changeset} ->
        render_show(conn, changeset)
    end
  end

  def confirm(conn, %{"username" => username, "key" => key}) do
    success = Users.confirm(username, key) == :ok
    title = if success, do: "Email confirmed", else: "Failed to confirm email"

    conn
    |> put_status(success_to_status(success))
    |> render("confirm.html", [
      title: title,
      success: success
    ])
  end

  defp render_show(conn, changeset) do
    render conn, "show.html", [
      title: "Sign up",
      container: "container page signup",
      changeset: changeset
    ]
  end
end
