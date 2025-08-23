import gitlab_watcher/internal/todo_parser
import simplifile

pub fn parse_review_requested_correctly_returns_an_activity_test() {
  let assert Ok(review_requested_json) =
    simplifile.read("./test/fixtures/review_requested.json")

  let assert Ok(activity) = todo_parser.parse(review_requested_json)

  assert activity.activity_type == todo_parser.ReviewRequested
  assert activity.url == "activity-url"
  assert activity.body == "activity-body"

  assert activity.project.id == 2
  assert activity.project.name == "project-name"

  assert activity.author.name == "author-name"
  assert activity.author.username == "author.username"
  assert activity.author.avatar_url == "avatar-url"
  assert activity.author.web_url == "web-url"
  assert activity.author.id == 3
}
