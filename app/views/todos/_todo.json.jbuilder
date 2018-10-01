json.extract! todo, :id, :key, :text, :created_at, :updated_at
json.url todo_url(todo, format: :json)
