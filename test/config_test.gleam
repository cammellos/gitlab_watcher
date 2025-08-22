import envoy
import gitlab_watcher/internal/config
import gleam/result

pub fn config_test() {
  let config =
    config.Config(
      token: "test-token",
      url: "test-url",
      username: "test-username",
    )
  assert config.token == "test-token"
  assert config.url == "test-url"
}

pub fn from_env_returns_an_error_when_token_not_present_test() {
  let actual_config = config.from_env()

  assert result.is_error(actual_config)
  assert actual_config == Error(config.MissingToken)
}

pub fn from_env_returns_an_error_when_username_not_present_test() {
  envoy.set("GITLAB_WATCHER_TOKEN", "token")

  let actual_config = config.from_env()

  assert result.is_error(actual_config)
  assert actual_config == Error(config.MissingUsername)
}

pub fn from_env_returns_ok_when_username_and_token_are_present_with_default_url_test() {
  envoy.set("GITLAB_WATCHER_TOKEN", "token")
  envoy.set("GITLAB_WATCHER_USERNAME", "cammellos")

  let actual_config_result = config.from_env()

  assert result.is_ok(actual_config_result)

  let actual_config = result.unwrap(actual_config_result, empty_config())

  assert "token" == actual_config.token
  assert "cammellos" == actual_config.username
  assert "https://gitlab.com" == actual_config.url
}

pub fn from_env_returns_ok_when_username_and_token_are_present_with_custom_url_test() {
  envoy.set("GITLAB_WATCHER_TOKEN", "token")
  envoy.set("GITLAB_WATCHER_USERNAME", "cammellos")
  envoy.set("GITLAB_WATCHER_URL", "https://test-gitlab.com")

  let actual_config_result = config.from_env()

  assert result.is_ok(actual_config_result)

  let actual_config = result.unwrap(actual_config_result, empty_config())

  assert "token" == actual_config.token
  assert "cammellos" == actual_config.username
  assert "https://test-gitlab.com" == actual_config.url
}

fn empty_config() -> config.Config {
  config.Config(token: "", url: "", username: "")
}
