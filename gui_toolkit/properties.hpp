#pragma once

#include <SDL.h>

class PropertiesWin {
    public:
        PropertiesWin(const char* data);
        ~PropertiesWin();
        void fillRect(int x, int y, int w, int h);
        void drawCircle(int center_x, int center_y, int radius);
        void drawRect(int x, int y, int w, int h);
        const char* getData();

        SDL_Renderer* renderer;
    private:
        short tick();

        SDL_Window* window;
        SDL_Event event;
        const char* data;
};