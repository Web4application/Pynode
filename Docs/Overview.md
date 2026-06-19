Using the files.opy native FS example

Overview
The files.opy example demonstrates mounting a user-selected directory (via the File System Access API)
into Pyodide so Python code can read/write files. It also shows how to persist changes using syncfs.

Minimal usage
1. Serve the page from HTTPS/localhost.
2. Include Pyodide (see https://pyodide.org).
3. Call the example from an async context:

async function mountAndWrite() {
  try {
    const dirHandle = await showDirectoryPicker();
    let permissionStatus = await dirHandle.requestPermission({ mode: "readwrite" });
    // Normalize PermissionStatus objects vs strings
    if (permissionStatus && typeof permissionStatus === "object" && "state" in permissionStatus) {
      permissionStatus = permissionStatus.state;
    }
    if (permissionStatus !== "granted") {
      throw new Error("readwrite access to directory not granted");
    }
    const nativefs = await pyodide.mountNativeFS("/mount_dir", dirHandle);
    pyodide.runPython(`
      import os
      print(os.listdir('/mount_dir'))
    `);
    pyodide.runPython(`
      with open('/mount_dir/new_file.txt', 'w') as f:
        f.write("hello")
    `);
    if (nativefs && typeof nativefs.syncfs === "function") {
      await nativefs.syncfs();
    } else {
      console.warn("nativefs.syncfs() not available — verify pyodide version");
    }
    return { ok: true };
  } catch (err) {
    console.error("Filesystem operation failed:", err);
    return { ok: false, error: String(err) };
  }
}
// Example usage:
// await mountAndWrite();

Browser compatibility
- File System Access API: well supported in Chromium-based browsers (Chrome, Edge). Limited or absent in Firefox and Safari.
- Always design for graceful fallback: if the API or permission is unavailable, provide an alternative (e.g., input file upload, server-based storage).

Security notes
- The example writes files to a local directory chosen by the user; do NOT automatically read arbitrary file paths.
- When sending data between server and client, avoid insecure serialization (pickle) for untrusted data.
