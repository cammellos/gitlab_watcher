import gleam/result

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
  let maybe_username = envoy.get("GITLAB_WATCHER_USERNAME")

  let url = result.unwrap(envoy.get("GITLAB_WATCHER_URL"), gitlab_url)

  case maybe_token, maybe_username {
    Error(_), _ -> Error(MissingToken)
    _, Error(_) -> Error(MissingUsername)
    Ok(token), Ok(username) ->
      Ok(Config(token: token, username: username, url: url))
  }
}
