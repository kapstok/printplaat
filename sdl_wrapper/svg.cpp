#include "svg.h"

#include <SDL.h>
#include <math.h>

struct point {
    float x, y;
};

point lastPosition;

// simple linear interpolation between two points
// Original algorithm. Source: https://www.cubic.org/docs/bezier.htm
void lerp(point& dest, const point& a, const point& b, const float t) {
    dest.x = a.x + (b.x-a.x)*t;
    dest.y = a.y + (b.y-a.y)*t;
}

// evaluate a point on a bezier-curve. t goes from 0 to 1.0
// Original algorithm. Source: https://www.cubic.org/docs/bezier.htm
void bezier(point &dest, const point& a, const point& b, const point& c, const point& d, const float t) {
    point ab,bc,cd,abbc,bccd;
    lerp(ab, a,b,t);           // point between a and b (green)
    lerp(bc, b,c,t);           // point between b and c (green)
    lerp(cd, c,d,t);           // point between c and d (green)
    lerp(abbc, ab,bc,t);       // point between ab and bc (blue)
    lerp(bccd, bc,cd,t);       // point between bc and cd (blue)
    lerp(dest, abbc,bccd,t);   // point on the bezier-curve (black)
}

// Source: https://stackoverflow.com/a/24105779
// Source: https://github.com/Acry/SDL2-Curves/blob/fcfc4e661465658269c0351b4ea30355eb940566/src/2.c#L105
void svg_process_C(SDL_Renderer* renderer, float x1, float y1, float x2, float y2, float x, float y) {
    point a = lastPosition;
    point b = {x1, y1};
    point c = {x2, y2};
    point d = {x, y};

    for (int i = 0; i < 1000; ++i) {
        point p;
        float t = static_cast<float>(i)/999.0;
        bezier(p, a, b, c, d, t);
        SDL_RenderDrawPoint(renderer, roundf(p.x), roundf(p.y));
    }
}

void svg_process_M(float x, float y) {
    lastPosition = {x, y};
}

// Source: https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/d
// WIP
void svg_process_c(SDL_Renderer* renderer, float dx1, float dy1, float dx2, float dy2, float dx, float dy) {
    point a = lastPosition;
    point b = {lastPosition.x + dx1, lastPosition.y + dy1};
    point c = {dx1 + dx2, dy1 + dy2};
    point d = {dx2 + dx, dy2 + dy};

    for (int i = 0; i < 1000; ++i) {
        point p;
        float t = static_cast<float>(i)/999.0;
        bezier(p, a, b, c, d, t);
        SDL_RenderDrawPoint(renderer, roundf(p.x), roundf(p.y));
    }
}

// WIP
void svg_process_s(int x, int y) {

}