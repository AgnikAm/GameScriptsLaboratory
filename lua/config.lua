local config = require("lapis.config")

config("development", {
  port = 8080,
  sqlite = {
    database = "dev.db"
  }
})
