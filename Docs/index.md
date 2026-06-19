Pynode Documentation 

Welcome to Pynode.

Pynode is a browser-native Python development platform built on Pyodide. It enables developers to run Python directly inside modern web browsers without requiring a traditional backend server.

The project began as a collection of utilities and examples for Pyodide integration but is evolving into a complete Python IDE, notebook environment, AI workspace, and application platform.

⸻

Features

Python in the Browser

Execute Python code directly in the browser using WebAssembly-powered Python runtimes.

JavaScript Interoperability

Seamlessly call JavaScript from Python and Python from JavaScript.

Filesystem Access

Work with local files and directories through the File System Access API and virtual filesystem layers.

OPY Project Format

Package complete Python projects into portable .opy archives.

AI-Powered Development

Use integrated AI tools for code generation, debugging, documentation, and project assistance.

Notebook Environment

Create interactive notebooks combining Python code, markdown, charts, and visual outputs.

Web4AI Integration

Connect local browser execution with cloud-based AI and automation services.

⸻

Architecture

Browser
│
├── Monaco Editor
├── Pyodide Runtime
├── Python Packages
├── OPY Filesystem
├── AI Assistant
├── Terminal
└── IndexedDB Storage

⸻

Documentation Sections

Getting Started

* Installation
* Quick Start
* First Python Program
* Running Examples

Core Concepts

* Runtime
* Filesystem
* Python Execution
* JavaScript Interoperability
* Package Management

OPY Format

* Specification
* Project Structure
* Import and Export
* Dependency Management

IDE

* Editor
* Terminal
* File Explorer
* Debugging

Notebook

* Cells
* Markdown
* Visualization
* Data Science Workflows

AI Features

* Code Completion
* Refactoring
* Documentation Generation
* Local Models

Plugins

* Plugin Architecture
* Plugin Development
* Marketplace

API Reference

* Runtime API
* Filesystem API
* Editor API
* Plugin API

⸻

Example

print("Hello from Pynode")
const result = await pynode.run(`
print("Hello World")
`);

⸻

Project Goals

* Browser-native Python execution
* Open development platform
* AI-first workflow
* Portable project format
* Educational and professional use
* Extensible plugin ecosystem

⸻

Roadmap

Version 1.0

* Python runtime
* File explorer
* Terminal
* Monaco editor
* OPY project format

Version 2.0

* Notebook support
* AI assistant
* Package manager
* Git integration

Version 3.0

* Collaboration
* Cloud sync
* Plugin marketplace
* Agent framework

⸻

License

Pynode is released under the MIT License.

See the LICENSE file for additional information.
