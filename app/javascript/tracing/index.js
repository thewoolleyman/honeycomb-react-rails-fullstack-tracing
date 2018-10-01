'use strict';

export function getClientTimestampOffset(callback) {
  const reqStart = performance.now();
  fetch('/server_timestamp.json')
    .then(response => response.json())
    .then(json => {
      // a rough approximation of client timestamp offset, accounting for latency, so
      // that full-stack timestamps will be accurate
      const serverTimestamp = json.server_timestamp;
      const reqEnd = performance.now();
      const latency = reqEnd - reqStart;
      const adjustedServerTimestamp = serverTimestamp * 1 + (latency / 2);
      const clientTimestamp = Date.now();
      const clientTimestampOffset = Math.round(clientTimestamp - adjustedServerTimestamp);
      callback(clientTimestampOffset);
    });
}

function randomId() {
  // buffer is an ArrayBuffer
  const buffer = new Uint8Array(15);
  window.crypto.getRandomValues(buffer);
  return Array.prototype.map.call(buffer, x => ('00' + x.toString(16)).slice(-2)).join('');
}
