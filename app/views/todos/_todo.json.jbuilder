json.extract! todo, :id, :text, :created_at, :updated_at
json.url todo_url(todo, format: :json)
