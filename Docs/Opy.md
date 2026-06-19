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
