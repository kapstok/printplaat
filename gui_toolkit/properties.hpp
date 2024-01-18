#pragma once

#include <SDL.h>
#include <SDL2/SDL_ttf.h>

class PropertiesWin {
    public:
        PropertiesWin(const char* data, const char* winTitle, TTF_Font* font);
        ~PropertiesWin();
        void fillRect(int x, int y, int w, int h);
        void drawCircle(int center_x, int center_y, int radius);
        void drawRect(int x, int y, int w, int h);
        char* getData();

        SDL_Renderer* renderer;
    private:
        short tick();
        void drawElements(TTF_Font* font);
        char* requestSelection();
        char* commitData();

        SDL_Window* window;
        SDL_Event event;
        const char* data;
};