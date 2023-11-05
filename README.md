# Printplaat

## User documentation

User documentation can be found in the [doc](doc) folder.
Below a list of user documentation.

- [Different components](doc/components.md)

## Dependencies

- Dub (Optional for aarch64/Apple Silicon)
- DMD (except for aarch64/Apple Silicon)
- LDC2 (for aarch64/Apple Silicon)
- CMake
- G++
- SDL2 development headers & library
- SDL2_image development headers & library
- SDL2_ttf development headers & library
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

## Notes

https://dev.to/noah11012/using-sdl2-scaling-and-moving-an-image-pj

```
Label. w: 42, h: 29
Tweaker. w: 87, h: 29
Clicker. w: 73, h: 29
```