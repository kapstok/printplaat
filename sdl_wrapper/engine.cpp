// Consider this as the 'main' file of the library.

#include <SDL.h>
#include <SDL2/SDL_ttf.h>
#include <cmath>
#include <iostream>

#include "palette.h"

class Framework {
public:
    // Contructor which initialize the parameters.
    Framework(int height_, int width_): height(height_), width(width_){
        SDL_Init(SDL_INIT_VIDEO);       // Initializing SDL as Video
        SDL_CreateWindowAndRenderer(width, height, 0, &window, &renderer);
        SDL_SetRenderDrawColor(renderer, 0, 0, 0, 0);      // setting draw color
        SDL_RenderClear(renderer);      // Clear the newly created window
        SDL_RenderPresent(renderer);    // Reflects the changes done in the
                                        //  window.

        if (TTF_Init() < 0) {
            std::cout << "TTF init went wrong";
        } else {
            sans = TTF_OpenFont("Lato-Light.ttf", 24);
        }
    }

    // Destructor
    ~Framework() {
        TTF_CloseFont(sans);
        SDL_DestroyRenderer(renderer);
        SDL_DestroyWindow(window);
        TTF_Quit();
        SDL_Quit();
    }

    void drawCircle(int center_x, int center_y, int radius_){
        // Drawing circle
        for(int x=center_x-radius_; x<=center_x+radius_; x++){
            for(int y=center_y-radius_; y<=center_y+radius_; y++){
                if((std::pow(center_y-y,2)+std::pow(center_x-x,2)) <= std::pow(radius_,2)){
                    SDL_RenderDrawPoint(renderer, x, y);
                }
            }
        }
    }

    void drawRect(int x, int y, int w, int h) {
        SDL_Rect rect = {x,y,w,h};
        SDL_RenderDrawRect(renderer, &rect);
    }

    void fillRect(int x, int y, int w, int h) {
        SDL_Rect rect = {x,y,w,h};
        SDL_RenderFillRect(renderer, &rect);
    }

    SDL_Renderer *renderer = NULL;      // Pointer for the renderer
    TTF_Font* sans = NULL;

private:
    int height;     // Height of the window
    int width;      // Width of the window
    SDL_Window *window = NULL;      // Pointer for the window
};

class Button {
    public:
    Button(Framework* fw, int x, int y, int* width, int* height, int hex, char* text) {
        ubyte r, g, b;
        hexToRgb(hex, &r, &g, &b);
        TTF_SizeUTF8(fw->sans, text, width, height);

        SDL_Color color = {r,g,b};
        msg = TTF_RenderText_Blended(fw->sans, text, color);
        texture = SDL_CreateTextureFromSurface(fw->renderer, msg);

        SDL_Rect rect = {x, y, *width, *height};
        SDL_RenderCopy(fw->renderer, texture, 0x0, &rect);
    }

    ~Button() {
        SDL_FreeSurface(msg);
        SDL_DestroyTexture(texture);

    }

    private:
        SDL_Surface* msg;
        SDL_Texture* texture;
};

Framework* fw;
SDL_Event event;

void init(int width, int height) {
    fw = new Framework(width, height);
}

void drawRect(int x, int y, int width, int height) {
    fw->drawRect(x, y, width, height);
}

void fillRect(int x, int y, int width, int height) {
    fw->fillRect(x, y, width, height);
}

void fillCircle(int x, int y, int radius) {
    fw->drawCircle(x, y, radius);
}

void setColor(int hex, int a) {
    ubyte r, g, b;
    hexToRgb(hex, &r, &g, &b);
    SDL_SetRenderDrawColor(fw->renderer, r, g, b, a);
}

// Processes new changes on GUI.
// Returns 1 if user closes window.
short tick() {
    SDL_Delay(10);
    SDL_PollEvent(&event);

    if (event.type == SDL_QUIT) {
        delete fw;
        return 1;
    }

    return 0;
}

void redraw() {
    SDL_RenderPresent(fw->renderer);
}

void createButton(int x, int y, int* w, int* h, int hex, char* text) {
    Button btn = Button(fw, x, y, w, h, hex, text);
}