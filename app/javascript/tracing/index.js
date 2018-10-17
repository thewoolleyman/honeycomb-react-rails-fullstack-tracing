'use strict';

export async function getClientTimestampOffset() {
  const reqStart = performance.now();
  const response = await fetch('/server_timestamp.json');
  const json = await response.json();
  // a rough approximation of client timestamp offset, accounting for latency, so
  // that full-stack timestamps will be accurate
  const serverTimestamp = json.server_timestamp;
  const reqEnd = performance.now();
  const latency = reqEnd - reqStart;
  const adjustedServerTimestamp = serverTimestamp * 1 + (latency / 2);
  const clientTimestamp = Date.now();
  const clientTimestampOffset = Math.round(clientTimestamp - adjustedServerTimestamp);
  return clientTimestampOffset;
}

export function startTracingEvent(name, clientTimestampOffset, parentId) {
  let traceId = randomId();
  let spanId = randomId();
  let tracingEvent = {
    name: name,
    id: spanId,
    traceId: traceId,
    serviceName: "reactClient",
    timestamp: Date.now() + clientTimestampOffset,
  };
  if (parentId) {
    tracingEvent.parentId = parentId;
  }
  return tracingEvent;
}

export function finishTracingEvent(tracingEvent) {
  // TODO: add durationMs
  // TODO: Call server proxy method to submit event
  console.log('finishTracingEvent',tracingEvent);
}

function randomId() {
  // buffer is an ArrayBuffer
  const buffer = new Uint8Array(15);
  window.crypto.getRandomValues(buffer);
  return Array.prototype.map.call(buffer, x => ('00' + x.toString(16)).slice(-2)).join('');
}
