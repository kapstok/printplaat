#include <SDL.h>
#include <SDL2/SDL_ttf.h>

#include "engine.hpp"
#include "palette.h"
#include "properties.hpp"

Engine* engine;
SDL_Event event;

// This should be all the functions that the Printplaat D code could call.

void init(int color, int width, int height) {
    engine = new Engine(color, width, height);
}

void drawRect(int x, int y, int width, int height) {
    engine->drawRect(x, y, width, height);
}

void fillRect(int x, int y, int width, int height) {
    engine->fillRect(x, y, width, height);
}

void fillCircle(int x, int y, int radius) {
    engine->drawCircle(x, y, radius);
}

void stampComponents() {
    engine->stampComponents();
}

void setColor(int hex, int a) {
    ubyte r, g, b;
    hexToRgb(hex, &r, &g, &b);
    SDL_SetRenderDrawColor(engine->renderer, r, g, b, a);
}

// Processes new changes on GUI.
// Returns 1 if quit signal is fired (CTRL-C from terminal).
// Returns 1 if user closes window.
short tick() {
    SDL_Delay(10);
    SDL_PollEvent(&event);

    if (event.type == SDL_QUIT) {
        delete engine;
        return 1;
    }

    return 0;
}

void redraw() {
    SDL_RenderPresent(engine->renderer);
}

void createButton(int x, int y, int* w, int* h, int hex, char* text) {
    Button btn = Button(engine, x, y, w, h, hex, text);
}

int createComponent(const char* path, int x, int y, int w, int h) {
    Component* component = new Component(path, engine->renderer, x, y, w, h);

    if (!component->isValid()) {
        delete component;
        return -1;
    }

    return engine->addComponent(component);
}

void resetComponents() {
    engine->resetComponents();
}

void getFontWidthAndHeight(int* width, int* height, char* text) {
    TTF_SizeUTF8(engine->font, text, width, height);
}

const char* openProperties(const char* data) {
    PropertiesWin window = PropertiesWin(data);
    return window.getData();
}