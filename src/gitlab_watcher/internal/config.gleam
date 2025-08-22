import envoy

const gitlab_url = "https://gitlab.com"

pub type ConfigError {
  MissingToken
  MissingUsername
}

pub type Config {
  Config(token: String, url: String, username: String)
}

pub fn from_env() -> Result(Config, ConfigError) {
  let maybe_token = envoy.get("GITLAB_WATCHER_TOKEN")
  let maybe_url = envoy.get("GITLAB_WATCHER_URL")
  let maybe_username = envoy.get("GITLAB_WATCHER_USERNAME")

  case maybe_token, maybe_username, maybe_url {
    Error(_), _, _ -> Error(MissingToken)
    _, Error(_), _ -> Error(MissingUsername)
    Ok(token), Ok(username), Error(_) ->
      Ok(Config(token: token, username: username, url: gitlab_url))
    Ok(token), Ok(username), Ok(url) ->
      Ok(Config(token: token, username: username, url: url))
  }
}
