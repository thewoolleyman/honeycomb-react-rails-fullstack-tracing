# Based on https://github.com/honeycombio/examples/tree/master/ruby-wiki-tracing

# Generate a new unique identifier for our spans and traces. This can be any
# unique string -- Zipkin uses hex-encoded base64 ints, as we do here; other
# folks may prefer to use their UUID library of choice.
def new_tracing_id
  rand(2 ** 63).to_s(16)
end

# This wrapper takes a span name, some optional metadata, and a block; then
# emits a "span" to Honeycomb as part of the trace begun in the RequestTracer
# middleware.
#
# The special sauce in this method is the definition / resetting of thread
# local variables in order to correctly propagate "parent" identifiers down
# into the block.
def with_span(name, metadata=nil)
  id = new_tracing_id

  start = Time.new
  # Field keys to trigger Honeycomb's tracing functionality on this dataset
  # defined at:
  # https://www.honeycomb.io/docs/working-with-data/tracing/send-trace-data/#manual-tracing
  data = {
    name: name,
    id: id,
    traceId: Thread.current[:request_id],
    serviceName: "rails",
  }

  # Capture the calling scope's span ID, then restore it at the end of the
  # method.
  parent_span_id = Thread.current[:span_id]
  if parent_span_id
    # We have a parent ID, so this is not the root span.
    data[:parentId] = parent_span_id
  end

  # Set the current span ID before invoking the provided block, then capture
  # the return value to return after emitting the Honeycomb event.
  Thread.current[:span_id] = id

  ret = yield

  data[:durationMs] = (Time.new - start)*1000
  if metadata
    data.merge!(metadata)
  end

  # NOTE: Don't forget to set the timestamp to `start` -- because spans are
  # emitted at the *end* of their execution, we want to be doubly sure that
  # our manually-emitted events are timestamped with the time that the work
  # (the span's actual execution) really begun.
  send_event(data, start)

  ret
ensure
  Thread.current[:span_id] = parent_span_id
end

def send_event(data, timestamp)
  writekey = ENV.fetch('HONEYCOMB_WRITEKEY') unless ENV['DISABLE_HONEYCOMB'] # to start rails without internet
  libhoney_client = Libhoney::Client.new(
    writekey: writekey,
    dataset: ENV.fetch('HONEYCOMB_DATASET', 'rails-fullstack-tracing')
  )
  ev = libhoney_client.event
  ev.timestamp = timestamp
  ev.add(data)
  ev.send
end
