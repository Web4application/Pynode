// Wrap the FS flow in an async function so top-level await is not required
async function mountAndWrite() {
  try {
    const dirHandle = await showDirectoryPicker();

    // The return type can be either a string like "granted" or a PermissionStatus object.
    let permissionStatus = await dirHandle.requestPermission({ mode: "readwrite" });

    // Normalize PermissionStatus to a string for robust checking
    if (permissionStatus && typeof permissionStatus === "object" && "state" in permissionStatus) {
      permissionStatus = permissionStatus.state;
    }

    if (permissionStatus !== "granted") {
      throw new Error("readwrite access to directory not granted");
    }

    // Mount native FS; ensure the pyodide version you use supports mountNativeFS
    const nativefs = await pyodide.mountNativeFS("/mount_dir", dirHandle);

    // Run small Python snippets safely
    pyodide.runPython(`
      import os
      print(os.listdir('/mount_dir'))
    `);

    pyodide.runPython(`
      with open('/mount_dir/new_file.txt', 'w') as f:
        f.write("hello")
    `);

    // Persist changes to IndexedDB/native FS
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

// Example usage (call from an async context):
// await mountAndWrite();
