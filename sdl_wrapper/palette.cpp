#include "palette.h"

// int printplaat[3];// = {0xF7, 0xE1, 0xD3};
// int node[3];// = {0xBD, 0xD0, 0xC4};
// int toolbar[3];// = {0x82, 0x6F, 0x62};
// int item[3];// = {0xF8, 0xE2, 0xD4};
// int functionbar[3];// = {0x2E, 0x20, 0x16};

// Gives r,g and b proper values based on hex
void hexToRgb(int hex, int* r, int* g, int* b) {
    *r = (hex & 0xFF0000) >> 16;
    *g = (hex & 0x00FF00) >> 8;
    *b = hex & 0x0000FF;
}

// void initPalette() {
//     hexToRgb(0xF7E1D3, &printplaat[0], &printplaat[1], &printplaat[2]);
//     hexToRgb(0xBDD0C4, &node[0], &node[1], &node[2]);
//     hexToRgb(0x826F62, &toolbar[0], &toolbar[1], &toolbar[2]);
//     hexToRgb(0xF8E2D4, &item[0], &item[1], &item[2]);
// }