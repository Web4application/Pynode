# .opy (OverPy) documentation

This document explains the purpose and usage of `.opy` example files in this
repository (referred to as "OverPy" in the repo metadata). `.opy` files are
examples that show how to wire browser APIs with Pyodide runtime code, including
File System Access integration, permission handling, and Python<->JavaScript
interop patterns.

## Purpose

- Provide runnable examples for integrating Pyodide in browser contexts.
- Demonstrate safe and compatible patterns for the File System Access API,
  pyodide.mountNativeFS(), and persisting data with nativefs.syncfs().
- Show recommended error handling and normalization of browser API return
  shapes across different browsers.

## Typical file structure

A `.opy` example is JavaScript (or module) code demonstrating a flow. Typical
concerns shown in these examples:

- Don't rely on top-level await being available in all embed contexts: wrap
  asynchronous flows in an async function.
- The File System Access API may return different shapes (a string like
  "granted" or a PermissionStatus object). Normalize this before checking.
- Verify that Pyodide-provided helpers (e.g. `mountNativeFS`) exist in your
  Pyodide build before calling them.
- Use `pyodide.runPython(...)` for short Python snippets; prefer calling
  pre-defined Python entrypoints for larger code.

## Example: mountAndWrite (from files.opy)

```javascript
// Files.opy example (mountAndWrite)
async function mountAndWrite() {
  try {
    const dirHandle = await showDirectoryPicker();

    // requestPermission may return a string or a PermissionStatus object
    let permissionStatus = await dirHandle.requestPermission({ mode: "readwrite" });
    if (permissionStatus && typeof permissionStatus === "object" && "state" in permissionStatus) {
      permissionStatus = permissionStatus.state;
    }

    if (permissionStatus !== "granted") {
      throw new Error("readwrite access to directory not granted");
    }

    // mountNativeFS is a convenience helper in some pyodide builds
    const nativefs = await pyodide.mountNativeFS("/mount_dir", dirHandle);

    // Run short Python snippets via pyodide
    pyodide.runPython(`import os; print(os.listdir('/mount_dir'))`);

    pyodide.runPython(`with open('/mount_dir/new_file.txt', 'w') as f:\n  f.write('hello')`);

    // Persist changes to the underlying storage (IndexedDB / native FS)
    if (nativefs && typeof nativefs.syncfs === "function") {
      await nativefs.syncfs();
    } else {
      console.warn("nativefs.syncfs() not available — ensure pyodide.mountNativeFS returns expected API");
    }

    return { ok: true };
  } catch (err) {
    console.error("Filesystem operation failed:", err);
    return { ok: false, error: String(err) };
  }
}

// Usage: call from an async context: await mountAndWrite();
```

## How it works (conceptual)

1. showDirectoryPicker() yields a directory handle guarded by browser permission
   policies.
2. requestPermission({mode: 'readwrite'}) returns either a string or a
   PermissionStatus object depending on browser API shape; normalized to a
   string before checks.
3. pyodide.mountNativeFS mounts the directory handle into the Emscripten VFS
   at a chosen path (e.g. `/mount_dir`). The exact helper function name and
   behavior may vary by Pyodide version; check your version's API.
4. pyodide.runPython executes Python code using the Pyodide runtime with the
   global interpreter environment. For larger or repeated code, provide a
   Python entrypoint and call it from JS instead.
5. nativefs.syncfs writes changes back to persistent storage (IndexedDB or the
   underlying native FS). This call is async and must be awaited.

## Browser compatibility and caveats

- File System Access API is not implemented uniformly across browsers. Chrome
  and Chromium-based browsers have broad support; Firefox and Safari have
  limited or no support for showDirectoryPicker() or requestPermission.
- Top-level await in scripts is only available when the script is a module or
  the environment supports it. To be broadly compatible, wrap flows in async
  functions and call them from an async context.
- Pyodide versions change APIs over time. Examples using `mountNativeFS` assume
  that the current Pyodide build provides such helper — if not present, call
  into Emscripten FS methods directly or adapt to your pyodide build.

## Best practices

- Prefer explicit Python entrypoints rather than evaluating large dynamic
  strings with `pyodide.runPython` to improve readability and error handling.
- When evaluating code and returning structured results to JS, ensure a
  predictable return format (e.g., always return [extra_info|null, result|null]
  or a stable object with `error` property on failure).
- Always handle user-denied permissions and provide clear UI feedback.
- Do not unpickle untrusted data in the browser without strict validation.

## Troubleshooting

- "ModuleNotFoundError" after writing a .py file: call `importlib.invalidate_caches()`
  before importing, as the Python import machinery needs to refresh its cache.
- Changes not persisting in IndexedDB: ensure you call `pyodide.FS.syncfs()` or
  the helper's `nativefs.syncfs()` to flush the in-memory FS to persistent
  storage.
- Permission checks failing across browsers: log the raw `requestPermission`
  return value to inspect whether it is a string or an object; normalize by
  reading `.state` when present.

## References

- Pyodide docs: https://pyodide.org
- Emscripten FS API: https://emscripten.org/docs/api_reference/Filesystem-API.html
- File System Access API (WICG): https://wicg.github.io/file-system-access/

## Suggested additions to the repo

- A small example page (e.g., examples/nativefs.html) that loads Pyodide and
  demonstrates `mountAndWrite` end-to-end in a secure context.
- A test harness (manual or automated via Playwright) that runs the example
  in Chromium to validate the flow and persist changes.

--
Generated by repository automation: adds docs explaining .opy examples and
recommended patterns for Pyodide + File System Access integration.
