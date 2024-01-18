#pragma once

#include <SDL.h>
#include <SDL2/SDL_ttf.h>
#include <vector>

// Components are rendered permanently
class Component {
    public:
        Component(const char* path, SDL_Renderer* renderer, int x, int y, int w, int h);
        ~Component();
        void stamp();
        bool isValid();
    private:
        SDL_Surface* surface;
        SDL_Texture* texture;
        SDL_Renderer* renderer;
        SDL_Rect rect;
};

class Engine {
    public:
        Engine(int color, int width, int height);
        ~Engine();
        void fillRect(int x, int y, int w, int h);
        void drawCircle(int center_x, int center_y, int radius);
        void drawRect(int x, int y, int w, int h);
        void stampComponents();
        int addComponent(Component* component);
        void removeComponent(int removeAt);
        void resetComponents();

        SDL_Renderer* renderer;
        SDL_Window* window;
        TTF_Font* font;
    private:
        std::vector<Component*> components = {};
};

// Buttons are rendered temporarily
// For now, they need to be recreated every time before redraw() is called.
class Button {
    public:
        Button(Engine* engine, int x, int y, int* width, int* height, int hex, char* text);
        ~Button();
    private:
        SDL_Surface* surface;
        SDL_Texture* texture;
};