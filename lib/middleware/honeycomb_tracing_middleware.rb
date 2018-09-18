class HoneycombTracingMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request_path = env.fetch('REQUEST_PATH')
    trace_id = env['HTTP_X_TRACING_TRACE_ID']
    span_id = env['HTTP_X_TRACING_SPAN_ID']
    if trace_id
      # We have a trace ID from the client, so set its span_id to be the current parent span
      Thread.current[:span_id] = span_id
    end
    # Set the current trace's ID to the client's if we got one, otherwise start a new trace
    Thread.current[:trace_id] = trace_id || new_tracing_id
    with_span(request_path) do
      @app.call(env)
    end
  end
end
