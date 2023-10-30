#include "palette.h"

// Gives r,g and b proper values based on hex
void hexToRgb(int hex, ubyte* r, ubyte* g, ubyte* b) {
    *r = (hex & 0xFF0000) >> 16;
    *g = (hex & 0x00FF00) >> 8;
    *b = hex & 0x0000FF;
}