#pragma once

#include <SDL.h>

void svg_process_M(float x, float y);
void svg_process_C(SDL_Renderer* renderer, float x1, float y1, float x2, float y2, float x, float y);
void svg_process_c(SDL_Renderer* renderer, float dx1, float dy1, float dx2, float dy2, float dx, float dy);
void svg_process_s(int x, int y);