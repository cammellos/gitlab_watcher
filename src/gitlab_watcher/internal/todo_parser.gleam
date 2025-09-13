import gleam/dynamic/decode
import gleam/json

pub type ActivityType {
  ReviewRequested
}

pub type User {
  User(
    id: Int,
    username: String,
    name: String,
    avatar_url: String,
    web_url: String,
  )
}

pub type Project {
  Project(id: Int, name: String)
}

pub type Activity {
  Activity(
    activity_type: ActivityType,
    author: User,
    url: String,
    body: String,
    project: Project,
  )
}

fn project_decoder() -> decode.Decoder(Project) {
  {
    use id <- decode.field("id", decode.int)
    use name <- decode.field("name", decode.string)
    decode.success(Project(id:, name:))
  }
}

fn user_decoder() -> decode.Decoder(User) {
  {
    use username <- decode.field("username", decode.string)
    use id <- decode.field("id", decode.int)
    use name <- decode.field("name", decode.string)
    use avatar_url <- decode.field("avatar_url", decode.string)
    use web_url <- decode.field("web_url", decode.string)
    decode.success(User(name:, username:, id:, avatar_url:, web_url:))
  }
}

fn activity_decoder() -> decode.Decoder(Activity) {
  {
    use action_name <- decode.field("action_name", decode.string)
    use author <- decode.field("author", user_decoder())
    use target_url <- decode.field("target_url", decode.string)
    use body <- decode.field("body", decode.string)
    use project <- decode.field("project", project_decoder())

    let activity_type = case action_name {
      "review_requested" -> ReviewRequested
      _ -> ReviewRequested
    }

    decode.success(Activity(
      activity_type: activity_type,
      author: author,
      url: target_url,
      body: body,
      project: project,
    ))
  }
}

pub fn parse(json_string: String) -> Result(Activity, json.DecodeError) {
  json.parse(from: json_string, using: activity_decoder())
}
