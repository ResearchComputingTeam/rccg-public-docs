---
tags: [software, libraries]
---

# Libraries

Spack-built libraries, all compiled with GCC 13.3.0 (module suffix `-gcc-13.3.0`).

| Module | Provides |
|---|---|
| `openblas/0.3.26-gcc-13.3.0` | BLAS and LAPACK |
| `netlib-scalapack/2.2.0-gcc-13.3.0` | ScaLAPACK |
| `hdf5/1.14.3-gcc-13.3.0` | HDF5 |
| `netcdf-c/4.9.2-gcc-13.3.0` | NetCDF (C) |
| `netcdf-fortran/4.6.1-gcc-13.3.0` | NetCDF (Fortran) |
| `parallel-netcdf/1.12.3-gcc-13.3.0` | Parallel NetCDF |
| `zlib-ng/2.1.6-gcc-13.3.0` | zlib |
| `libpng/1.6.39-gcc-13.3.0` | PNG |
| `jasper/2.0.32-gcc-13.3.0` | JPEG-2000 |
| `m4/1.4.19-gcc-13.3.0` | m4 macro processor |
| `amd/aocl` (5.3.0) | AMD optimized math libraries |

Load one:

```bash
module load openblas/0.3.26-gcc-13.3.0
```

More on modules: [Modules](modules.md).

<!-- TODO: compile and link flags set by each module -->
