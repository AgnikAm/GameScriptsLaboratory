local lapis = require("lapis")
local app = lapis.Application()
local db = require("lapis.db")
local json_params = require("lapis.application").json_params
local capture_errors_json = require("lapis.application").capture_errors_json

local Category = require("models.category")
local Product  = require("models.product")

-- Helpers
local function to_table(obj)
  if type(obj) == 'table' and obj.__class then
    local out = {}
    for k,v in pairs(obj) do out[k]=v end
    return out
  end
  return obj
end

app:get("/categories", capture_errors_json(function(self)
  local rows = db.select("* from categories order by id desc")
  return { json = { data = rows } }
end))

app:post("/categories", json_params(capture_errors_json(function(self)
  local name = self.params.name
  if not name then
    return { status = 400, json = { errors = { "missing name" } } }
  end
  local id = db.insert("categories", {
    name = name,
    description = self.params.description or ngx.null
  })
  local created = Category:find(id)
  return { status = 201, json = { data = to_table(created) } }
end)))

app:get("/categories/:id", capture_errors_json(function(self)
  local id = tonumber(self.params.id)
  local row = Category:find(id)
  if not row then
    return { status = 404, json = { errors = { "not found" } } }
  end
  return { json = { data = to_table(row) } }
end))

app:put("/categories/:id", json_params(capture_errors_json(function(self)
  local id = tonumber(self.params.id)
  local row = Category:find(id)
  if not row then
    return { status = 404, json = { errors = { "not found" } } }
  end
  db.update("categories", { name = self.params.name or row.name, description = self.params.description or row.description }, { id = id })
  local updated = Category:find(id)
  return { json = { data = to_table(updated) } }
end)))

app:delete("/categories/:id", capture_errors_json(function(self)
  local id = tonumber(self.params.id)
  local row = Category:find(id)
  if not row then
    return { status = 404, json = { errors = { "not found" } } }
  end
  db.delete("categories", { id = id })
  return { json = { data = { id = id, deleted = true } } }
end)))

app:get("/products", capture_errors_json(function(self)
  local rows = db.select("select p.*, c.name as category_name from products p left join categories c on p.category_id = c.id order by p.id desc")
  return { json = { data = rows } }
end))

app:post("/products", json_params(capture_errors_json(function(self)
  local name = self.params.name
  local price = tonumber(self.params.price)
  if not name or price == nil then
    return { status = 400, json = { errors = { "missing name or price" } } }
  end
  local pid = db.insert("products", {
    name = name,
    description = self.params.description or ngx.null,
    price = price,
    category_id = tonumber(self.params.category_id) or ngx.null
  })
  local created = Product:find(pid)
  return { status = 201, json = { data = to_table(created) } }
end)))

app:get("/products/:id", capture_errors_json(function(self)
  local id = tonumber(self.params.id)
  local row = Product:find(id)
  if not row then
    return { status = 404, json = { errors = { "not found" } } }
  end
  return { json = { data = to_table(row) } }
end))

app:put("/products/:id", json_params(capture_errors_json(function(self)
  local id = tonumber(self.params.id)
  local row = Product:find(id)
  if not row then
    return { status = 404, json = { errors = { "not found" } } }
  end
  local price = self.params.price and tonumber(self.params.price) or row.price
  db.update("products", {
    name = self.params.name or row.name,
    description = (self.params.description ~= nil) and self.params.description or row.description,
    price = price,
    category_id = (self.params.category_id ~= nil) and tonumber(self.params.category_id) or row.category_id
  }, { id = id })
  local updated = Product:find(id)
  return { json = { data = to_table(updated) } }
end)))

app:delete("/products/:id", capture_errors_json(function(self)
  local id = tonumber(self.params.id)
  local row = Product:find(id)
  if not row then
    return { status = 404, json = { errors = { "not found" } } }
  end
  db.delete("products", { id = id })
  return { json = { data = { id = id, deleted = true } } }
end)))

return app
