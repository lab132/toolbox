toolbox
=======

An assortment of useful things such as third-party libraries and the like.

One of the use-cases for the toolbox is to provide binaries to other projects. You create a environment variable `LAB132_TOOLBOX_DIR` on your system that points to the root of the toolbox installation. Then an external project (such as lab132/krepel) will find the toolbox and pull necessary binaries from there. In order for this to work, you will have to build the binaries in the toolbox before external projects can use it. See below for some instructions.

# Build

Requirements:

- CMake 3.2 or later

Platforms:

| OS             | Build System           |
| :------------- | :--------------------- |
| Windows 10 x64 | Visual Studio 2015 x64 |

# Libraries

Library binaries are always built to `bin/` and `lib/` folders in the root of the respective projects. E.g. for ezEngine version `rev858`, the binary directories are `ezEngine-rev858/bin` and `ezEngine-rev858/lib`.

_Tip for Visual Studio users: You can make use of `Build -> Batch Build...` to build multiple configurations._

## ezEngine

Use CMake on the ezEngine path (e.g. `ezEngine-rev858`) to generate a build system (e.g. Visual Studio), and execute the target `lab132Toolbox` there. It will automatically build all ezEngine targets relevant for the toolbox.

## glew

Use CMake on the glew path (e.g. `glew-1.12.0`) to generate a build system (e.g. Visual Studio) and execute the target `lab132Toolbox` there. It will automatically build all glew targets relevant for the toolbox.

## Catch

There is nothing to build since Catch is a header-only library.
