#include "properties.hpp"

#include <SDL.h>
#include <iostream>
#include "palette.h"

PropertiesWin::PropertiesWin(const char* data) {
    this->data = data;

    SDL_CreateWindowAndRenderer(200, 800, 0, &this->window, &this->renderer);
    	if (this->renderer == NULL) {
		std::cout << "Error renderer creation" << std::endl;
	}

    SDL_RenderClear(this->renderer);
    ubyte r, g, b;
    hexToRgb(0xF7E1D3, &r, &g, &b);
    SDL_SetRenderDrawColor(this->renderer, r, g, b, 0xff);
    fillRect(0, 0, 200, 800);
    SDL_RenderPresent(this->renderer);
}

PropertiesWin::~PropertiesWin() {
	SDL_DestroyRenderer(this->renderer);
	SDL_DestroyWindow(this->window);
}

void PropertiesWin::fillRect(int x, int y, int w, int h) {
	SDL_Rect rect = {x,y,w,h};
	SDL_RenderFillRect(this->renderer, &rect);
}

void PropertiesWin::drawCircle(int center_x, int center_y, int radius) {
    for(int x=center_x-radius; x<=center_x+radius; x++){
        for(int y=center_y-radius; y<=center_y+radius; y++){
            if((std::pow(center_y-y,2)+std::pow(center_x-x,2)) <= std::pow(radius,2)){
                SDL_RenderDrawPoint(renderer, x, y);
            }
        }
    }
}

void PropertiesWin::drawRect(int x, int y, int w, int h) {
    SDL_Rect rect = {x,y,w,h};
    SDL_RenderDrawRect(renderer, &rect);
}

const char* PropertiesWin::getData() {
    int leftClick = 1;
    int mouseState[3];
    while (!tick()) {
        mouseState[0] = SDL_GetMouseState(&mouseState[1], &mouseState[2]);
		if (mouseState[0] == leftClick) std::cout << "Left clicked" << std::endl;
    }

    return this->data;
}

// Processes new changes on GUI.
// Returns 1 if quit signal is fired (CTRL-C from terminal).
// Returns 2 if user closes window.
short PropertiesWin::tick() {
    SDL_Delay(10);
    SDL_PollEvent(&event);

    if (event.type == SDL_QUIT) {
        return 1;
    } else if (event.type == SDL_WINDOWEVENT) {
        if (event.window.event == SDL_WINDOWEVENT_CLOSE) {
            return 2;
        }
    }

    return 0;
}
