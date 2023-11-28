# Build Directory

> This folder is used to build the Desktop (Electron) Version of the Shiny
> Application using Inno with the compile.iss and other various assets and 
> dependencies in this folder.

The primary scripts used to build the setup executable are under `scripts`:

- `build_installer.R`
- `build_installer_job.R`

After successfully running, the derived/bundled installer setup executable
build artifact will be output to the `installer` folder and should be included 
with any GitHub releases as an asset.

Note that these desktop applications will only work on Windows as they are 
compiled using Inno Setup.