class HoneycombTracingMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request_path = env.fetch('REQUEST_PATH')
    Thread.current[:trace_id] = new_tracing_id
    with_span(request_path) do
      @app.call(env)
    end
  end
end
