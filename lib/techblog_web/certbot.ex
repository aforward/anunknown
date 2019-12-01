defmodule TechblogWeb.Certbot do
  @behaviour SiteEncrypt

  def https_keys(), do: SiteEncrypt.https_keys(config())

  def base_folder(:prod), do: "/etc/ssl/certs/certbot/techblog"
  def base_folder(_), do: Application.app_dir(:techblog, "priv") |> Path.join("certbot")

  def cert_folder(:prod), do: "/etc/ssl/certs/cert/techblog"
  def cert_folder(_), do: Application.app_dir(:techblog, "priv") |> Path.join("cert")

  @impl SiteEncrypt
  def config() do
    %{
      run_client?: unquote(Mix.env() != :test),
      ca_url: Application.get_env(:techblog, :acme_server) |> ca_url(),
      domain: Application.get_env(:techblog, :domain),
      extra_domains: Application.get_env(:techblog, :extra_domains) |> String.split(";"),
      email: Application.get_env(:techblog, :email),
      base_folder: Application.get_env(:techblog, :acme_server) |> base_folder(),
      cert_folder: Application.get_env(:techblog, :acme_server) |> base_folder(),
      renew_interval: :timer.hours(24 * 10),
      log_level: :info
    }
  end

  @impl SiteEncrypt
  def handle_new_cert() do
    :ok
  end

  defp ca_url(:local), do: {:local_acme_server, %{adapter: Plug.Cowboy, port: 4002}}
  defp ca_url(:stage), do: "https://acme-staging-v02.api.letsencrypt.org/directory"
  defp ca_url(:prod), do: "https://acme-v02.api.letsencrypt.org/directory"
  defp ca_url(url), do: url
end
