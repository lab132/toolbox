# toolbox
An assortment of useful things such as third-party libraries and the like.

# ezEngine
Use CMake to generate a build system and execute the target `ezEngine_CopyToKrepel`. It will automatically build all set `KR_EZ_TARGETS`.

It uses the environment variable `KREPEL_DIR` to find the directory in which krepel lives in, which is where the stuff will be copied to.

_Tip for Visual Studio users: You can make use of `Build -> Batch Build...` to build multiple configurations at once._
