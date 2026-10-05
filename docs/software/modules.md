---
tags: [software, modules]
---

# Modules

Software is provided through [Lmod](https://lmod.readthedocs.io/) environment modules.

## Everyday commands

```bash
module avail                  # list available modules
module avail gromacs          # filter by name
module spider gromacs         # search all modules, including hidden dependencies
module load <name>            # load a module
module list                   # show what is loaded
module unload <name>          # unload one module
module purge                  # unload everything
module show <name>            # what a module sets
```

## Names

Most application and library modules are named `<package>/<version>-<compiler>`, for example
`hdf5/1.14.3-gcc-13.3.0` (built with GCC 13.3.0).

If you omit the version, Lmod loads the one marked `(D)` in `module avail`.
For example, `module load openmpi` loads `openmpi/5.0.10-gcc-13.3.0`.

Pages: [Compilers and libraries](libraries.md), [Software overview](index.md).

<!-- TODO: using modules inside batch scripts -->
