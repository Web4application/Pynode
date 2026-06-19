const dirHandle = await showDirectoryPicker();
const permissionStatus = await dirHandle.requestPermission({
  mode: "readwrite",
});

if (permissionStatus !== "granted") {
  throw new Error("readwrite access to directory not granted");
}

const nativefs = await pyodide.mountNativeFS("/mount_dir", dirHandle);

pyodide.runPython(`
  import os
  print(os.listdir('/mount_dir'))
`);
// nativefs is the returned from: await pyodide.mountNativeFS('/mount_dir', dirHandle)
pyodide.runPython(`
  with open('/mount_dir/new_file.txt', 'w') as f:
    f.write("hello");
`);

// new_file.txt does not exist in native file system

await nativefs.syncfs();

// new_file.txt will now exist in native file system
