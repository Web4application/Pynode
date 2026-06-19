pyodide.runPython(`
  from pathlib import Path

  Path("/hello.txt").write_text("hello world!")
`);

let file = pyodide.FS.readFile("/hello.txt", { encoding: "utf8" });
console.log(file); // ==> "hello world!"

# Writing to the file system

let data = "hello world!";
pyodide.FS.writeFile("/hello.txt", data, { encoding: "utf8" });
pyodide.runPython(`
  from pathlib import Path

  print(Path("/hello.txt").read_text())
`);
