# Something very important
std.Build.StandartOptimizeOptions(.{});
Doesn't pass optimize correctly to the dependencies!
Use b.option(bool, "optimize", ...) or set it manually.  

# Work in progress!
# What this repository is
It's an example on how to work with the zig game engine that i'm making.
Here is an engine: [link](https://github.com/Freziyt223/HEAT-Game-Engine)

# For now this engine can:
- Print to console,
- Print colourful text to console(if terminal supports colour),
- Has proper init, update and deinit functions,
- Multithreading queue,
- Stage multiple update function with specific tick-rates(uses queue),

# This project's requirements
**Remark**
Make sure to clean up .zig-cache time to time because it can grow a lot in space.
Enabling strip doesn't generate pdb file so it may save you some space.
- Zig version 0.15.X
- 30 kb for source code
(Tested on windows 11 x64)
- With dependencies:
    - In Debug mode it takes:
        - 1871 kb for Executable 
        - 5788 kb for PDB file
    - In ReleaseFast/Safe mode it takes:
        - 668 kb for Executable
        - 4824 kb for PDB file
    - In ReleaseSmall mode it takes:
        - 372 kb for Executable
        - 4824 kb for PDB file
  
- With no unrequired dependencies:
    - In Debug mode it takes:
        - 1045 kb for Executable 
        - 2208 kb for PDB file
    - In ReleaseFast/Safe mode it takes:
        - 188 kb for Executable
        - 1272 kb for PDB file
    - In ReleaseSmall mode it takes:
        - 31 kb for Executable
        - 1272 kb for PDB file