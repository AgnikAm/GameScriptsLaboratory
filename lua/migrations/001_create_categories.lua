local schema = require("lapis.db.schema")
local types = schema.types

schema.create_table("categories", {
  {"id", "integer primary key autoincrement"},
  {"name", "varchar(255) not null"},
  {"description", "text"}
})
