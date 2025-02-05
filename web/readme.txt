We must update `drift_worker.js` and `sqlite3.wasm` manually.
Releases can be found at:
worker: https://github.com/simolus3/drift/releases
wasm: https://github.com/simolus3/sqlite3.dart/releases

Note: For some reason, if we compile the web worker from source, it's over 1 MB large.
But, the release version is a fraction of that.
