# Printplaat

## Dependencies

- Dub (Optional for aarch64/Apple Silicon)
- DMD (except for aarch64/Apple Silicon)
- LDC2 (for aarch64/Apple Silicon)
- CMake
- G++
- SDL2 development headers
- SDL2_TTF development headers
- Bash

## Running

```bash
dub run --force     # On any platform
./run-apple-silicon # On Macbooks with an M1 or M2 chip
```

## Troubleshooting

For Apple Silicon, when only `./run-apple-silicon` works,
one could try to [download](https://github.com/ldc-developers/ldc/releases/download/v1.35.0/ldc2-1.35.0-osx-arm64.tar.xz)
and install LDC2 and Dub binaries
([source](https://forum.dlang.org/post/wkzhhnhxbablkscprchm@forum.dlang.org))