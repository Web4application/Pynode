# Pynode

Pynode provides helpers and examples for running Python in the browser via Pyodide,
including filesystem integration, JS/Python interop, and common pitfalls.

This repository contains documentation and small utilities demonstrating:
- mounting native file systems (File System Access API) into Pyodide
- safe patterns for evaluating Python code from JavaScript
- how to register JS modules for import from Python
- guidance and FAQ content adapted from Pyodide references

Quick start
1. Open an HTTP server to serve this repo (some browser APIs require a secure context).
2. Include Pyodide in your page (see https://pyodide.org for current instructions).
3. Use the examples in DOCUMENTATION.md:
   - Check file: DOCUMENTATION.md for full FAQ and usage examples.
   - Use `files.opy` for a sample native FS mounting flow.
   - Use `Config.pyodide` as an example of wrapping run/eval functions.

License
This repository is published under the MIT License. See LICENSE for full text.
