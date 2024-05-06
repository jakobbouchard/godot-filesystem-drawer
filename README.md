# Godot FileSystem Drawer

A simple plugin for the Godot editor that moves the **FileSystem** dock to the bottom of the editor, similar to Unreal Engine's Asset Drawer. Click on the **FileSystem** button at the bottom of the window or use <kbd>Ctrl</kbd>+<kbd>Space</kbd> to open it. Inspired by [@newjoker6's plugin](https://github.com/newjoker6/Asset-Drawer/).

## Installation

> [!NOTE]
> Once the plugin is available on the [Asset Library](https://godotengine.org/asset-library/), installation will be a bit simpler.

- Download the [latest release](https://github.com/jakobbouchard/godot-filesystem-drawer/releases/latest)
- Extract the `addons` folder into your project
- Open the **Project Settings** (`Project → Project Settings...`) and go to the **Plugins** tab
- Enable **FileSystem Drawer**

## Settings

There are currently no dedicated settings menu, but by going into the `Project → Tools` menu, you can toggle between having the FileSystem at the bottom, or in the regular dock slots. This preference is then saved so that it doesn't get auto-docked on next startup. The settings file is global, and is saved alongside the Godot editor's own preference files, so it persists across projects.
