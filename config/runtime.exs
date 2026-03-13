# config/runtime.exs
import Config

if config_env() == :prod do

  database_url = System.get_env("DATABASE_URL") || raise "environment
  variable DATABASE_URL is missing."

  phx_server = System.get_env("PHX_SERVER") || "false"
  secret_key_base = System.get_env("SECRET_KEY_BASE") || raise
  "SECRET_KEY_BASE is missing!"

  port = String.to_integer(System.get_env("PORT") || "8080")
  host = System.get_env("PHX_HOST") || "smartlock.fly.dev"

  config :smartlock, Smartlock.Repo,
         url: database_url,
         socket_options: [:inet6],
         ssl: [
           verify: :verify_peer,
           cacertfile: "/etc/ssl/certs/prod-ca-2021.crt",
           server_name_indication: ~c"db.faveiilgziagqsxmgixe.supabase.co",
           customize_hostname_check: [
             match_fun: :public_key.pkix_verify_hostname_match_fun(:https)
           ]
         ]

  config :smartlock, SmartlockWeb.Endpoint,
         url: [host: host, port: 443],
         http: [ip: {0, 0, 0, 0}, port: port],
         server: phx_server == "true",
         secret_key_base: secret_key_base


end