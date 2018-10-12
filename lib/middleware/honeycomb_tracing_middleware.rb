require 'json'

class HoneycombTracingMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request_path = env.fetch('REQUEST_PATH')
    trace_id = env['HTTP_X_TRACING_TRACE_ID']
    span_id = env['HTTP_X_TRACING_SPAN_ID']
    if trace_id
      Thread.current[:span_id] = span_id
    end
    Thread.current[:request_id] = trace_id || new_tracing_id
    with_span(request_path) do
      @app.call(env)
    end
  end
end
