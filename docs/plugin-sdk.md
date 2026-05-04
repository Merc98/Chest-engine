# Plugin SDK Notes

This document defines a repository-level place for plugin documentation and examples.

## Folder layout

```text
plugins/
  README.md
  examples/
    sample-plugin/
      README.md
```

## Plugin documentation goals

A complete plugin guide should document:

- plugin entry points;
- required exported functions;
- supported calling conventions;
- how the host loads plugins;
- plugin lifecycle;
- access to memory scanning APIs;
- access to Lua APIs;
- supported build tools;
- example projects.

## Current status

This repository now includes a documentation placeholder and sample folder. The actual plugin API should be documented from the existing plugin-related source units before claiming support for specific exports.

Relevant unit names observed from the main project include:

```text
plugin
pluginexports
```

## Plugin README template

```md
# Plugin Name

## Purpose

Describe what the plugin adds.

## Build

Describe compiler/toolchain requirements.

## Install

Describe where the compiled plugin should be placed.

## Source references

List source files and exported functions verified in code.
```
