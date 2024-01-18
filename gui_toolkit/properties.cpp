#include "properties.hpp"

#include <SDL.h>
#include <iostream>
#include "palette.h"
#include <string.h>

PropertiesWin::PropertiesWin(const char* data, const char* winTitle, TTF_Font* font) {
    this->data = data;

    SDL_CreateWindowAndRenderer(200, 800, 0, &this->window, &this->renderer);
    	if (this->renderer == NULL) {
		std::cout << "Error renderer creation" << std::endl;
	}
    SDL_SetWindowTitle(this->window, winTitle);

    SDL_RenderClear(this->renderer);
    ubyte r, g, b;
    hexToRgb(0xF7E1D3, &r, &g, &b);
    SDL_SetRenderDrawColor(this->renderer, r, g, b, 0xff);
    fillRect(0, 0, 200, 800);
    drawElements(font);
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

char* PropertiesWin::getData() {
    int leftClick = 1;
    int mouseState[3];
    short event;
    do {
        event = tick();
        if (event == 3) { 
            mouseState[0] = SDL_GetMouseState(&mouseState[1], &mouseState[2]);
		    if (mouseState[0] == leftClick) {
                if (mouseState[1] > 20 &&
                    mouseState[1] < 20 + 150 &&
                    mouseState[2] > 20 &&
                    mouseState[2] < 20 + 50) {
                        return requestSelection();
                }
            }
        }
    } while (event != 2);
    return commitData();
}

char* PropertiesWin::requestSelection() {
    char* output;

    if ((output = (char*) malloc(7 + strlen(this->data) + 1)) != NULL) {
        output[0] = '\0';
        strcat(output, "SELECT\n");
        strcat(output, this->data);
        return output;
    } else {
        return const_cast<char *>("");
    }
}

char* PropertiesWin::commitData() {
    char* output;

    if ((output = (char*) malloc(12 + strlen(this->data) + 1)) != NULL) {
        output[0] = '\0';
        strcat(output, "CHANGE DATA\n");
        strcat(output, this->data);
        return output;
    } else {
        return const_cast<char *>("");
    }
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
    } else if (event.type == SDL_MOUSEBUTTONDOWN) {
        return 3;
    }

    return 0;
}

void PropertiesWin::drawElements(TTF_Font* font) {
    ubyte r, g, b;

    // Draw select output button
    int width = 0;
    int height = 0;
    hexToRgb(0x826F62, &r, &g, &b);
    SDL_SetRenderDrawColor(this->renderer, r, g, b, 0xff);
    fillRect(20, 20, 150, 50);
    
    TTF_SizeUTF8(font, "Select output", &width, &height);
    hexToRgb(0xF8E2D4, &r, &g, &b);
    SDL_Color color = {r,g,b};

    SDL_Surface* surface = TTF_RenderText_Blended(font, "Select output", color);
    SDL_Texture* texture = SDL_CreateTextureFromSurface(this->renderer, surface);

    SDL_Rect rect = {25, 30, width, height};
    SDL_RenderCopy(this->renderer, texture, 0x0, &rect);
    SDL_FreeSurface(surface);
    SDL_DestroyTexture(texture);
}