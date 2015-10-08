toolbox
=======

An assortment of useful things such as third-party libraries and the like.

_Tip for Visual Studio users: You can make use of `Build -> Batch Build...` to build multiple configurations._


Binaries
========

Binaries are always built to `bin/` and `lib/` folders in the root of the respective projects. E.g. for ezEngine version `rev858`, the binary directories are `ezEngine-rev858/bin` and `ezEngine-rev858/lib`.

ezEngine
--------

Use CMake on the ezEngine path (e.g. `ezEngine-rev858`) to generate a build system (e.g. Visual Studio), and execute the target `lab132Toolbox` there. It will automatically build all ezEngine targets relevant for the toolbox.

glew
----

Use CMake on the glew path (e.g. `glew-1.12.0`) to generate a build system (e.g. Visual Studio) and execute the target `lab132Toolbox` there. It will automatically build all glew targets relevant for the toolbox.

Catch
-----

There is nothing to build since Catch is a header-only library.


Installation
============

You can install all relevant files using the `lab132Toolbox`. Use CMake on the path `lab132Toolbox` to generate a build system (e.g. Visual Studio). In the CMake GUI, you can set the `CMAKE_INSTALL_PREFIX` to the location you want the toolbox projects installed to. Then use the generated guild system to execute the target `INSTALL`.
