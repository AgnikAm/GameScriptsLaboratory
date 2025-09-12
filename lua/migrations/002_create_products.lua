local schema = require("lapis.db.schema")
local types = schema.types

schema.create_table("products", {
  {"id", "integer primary key autoincrement"},
  {"name", "varchar(255) not null"},
  {"description", "text"},
  {"price", "real not null"},
  {"category_id", "integer"}
})

schema.create_index("products", "category_id")
