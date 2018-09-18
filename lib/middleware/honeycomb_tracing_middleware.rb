require 'json'

class HoneycombTracingMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request_path = env.fetch('REQUEST_PATH')
    client_trace_events_json = env['HTTP_X_CLIENT_TRACE_EVENTS']
    if client_trace_events_json
      client_trace_events = JSON.parse(client_trace_events_json)
      tracing_id = nil
      Thread.current[:client_parent_span_id] = 'CLIENT_PARENT_SPAN_ID'
    end
    Thread.current[:request_id] = tracing_id || new_tracing_id
    with_span(request_path) do
      @app.call(env)
    end
  end
end
