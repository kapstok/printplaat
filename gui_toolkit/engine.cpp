#include <iostream>
#include <cmath>
#include <vector>
#include <SDL.h>
#include <SDL2/SDL_image.h>
#include <SDL2/SDL_ttf.h>

#include "engine.hpp"
#include "palette.h"
#include "properties.hpp"

#define GRID_SIZE 600
#define LINE_THICKNESS 4

Engine::Engine(int color, int width, int height) {
	if (SDL_Init(SDL_INIT_VIDEO) < 0) {
		std::cout << "Error SDL2 Initialization : " << SDL_GetError() << std::endl;
	}

	SDL_CreateWindowAndRenderer(width, height, 0, &this->window, &this->renderer);
	if (this->renderer == NULL) {
		std::cout << "Error renderer creation" << std::endl;
	}
	SDL_SetWindowTitle(this->window, "Printplaat");

	// IMG_Init should return a binary OR of flags.
	// IMG_INIT_PNG == 2
	if (IMG_Init(IMG_INIT_PNG) != 2) {
		std::cout << "Error SDL2_image Initialization" << std::endl;
	}

	if (TTF_Init() < 0) {
        std::cout << "TTF init went wrong" << std::endl;
    } else {
        this->font = TTF_OpenFont("rsc/Lato-Light.ttf", 24);
    }
	
	this->wireTexture = SDL_CreateTexture(
		this->renderer,
		SDL_PIXELFORMAT_RGBA8888,
		SDL_TEXTUREACCESS_STATIC,
		GRID_SIZE,
		GRID_SIZE
	);
	this->wireRect = {0, 0, GRID_SIZE, GRID_SIZE};

	SDL_RenderClear(renderer);
	SDL_RenderPresent(renderer);
}

Engine::~Engine() {
	this->resetComponents();
	SDL_DestroyRenderer(renderer);
	SDL_DestroyWindow(window);
	SDL_DestroyTexture(wireTexture);
	TTF_CloseFont(this->font);
	IMG_Quit();
	TTF_Quit();
	SDL_Quit();
}

void Engine::fillRect(int x, int y, int w, int h) {
	SDL_Rect rect = {x,y,w,h};
	SDL_RenderFillRect(this->renderer, &rect);
}

void Engine::drawCircle(int center_x, int center_y, int radius) {
    for(int x=center_x-radius; x<=center_x+radius; x++){
        for(int y=center_y-radius; y<=center_y+radius; y++){
            if((std::pow(center_y-y,2)+std::pow(center_x-x,2)) <= std::pow(radius,2)){
                SDL_RenderDrawPoint(renderer, x, y);
            }
        }
    }
}

void Engine::drawRect(int x, int y, int w, int h) {
    SDL_Rect rect = {x,y,w,h};
    SDL_RenderDrawRect(renderer, &rect);
}

void Engine::stampComponents() {
	for (Component* component : this->components) {
		if (component != NULL) {
			component->stamp();
		}
	}
}

int Engine::addComponent(Component* component) {
	int index = this->components.size();
	this->components.push_back(component);

	return index;
}

void Engine::removeComponent(int removeAt) {
	delete this->components[removeAt];
	this->components[removeAt] = NULL;
}

void Engine::resetComponents() {
	for (Component* component : this->components) {
		if (component != NULL) {
			delete component;
		}
	}

	this->components = {};
}


void Engine::stampWires() {
	SDL_RenderCopy(this->renderer, this->wireTexture, NULL, &this->wireRect);
}

void Engine::addWireLine(int startX, int startY, int endX, int endY) {
	SDL_SetRenderTarget(this->renderer, this->wireTexture);
	ubyte r, g, b;
    hexToRgb(0xBDD0C4, &r, &g, &b);
    SDL_SetRenderDrawColor(this->renderer, r, g, b, 0xff);

	if (startY > endY) { // It's a vertical line
		this->fillRect(startX, startY, LINE_THICKNESS, startY - endY);
	} else if (startY < endY) { // It's a vertical line
		this->fillRect(startX, startY, LINE_THICKNESS, startY - endY);
	} else if (startX > endX) { // It's a horizontal line
		this->fillRect(startX, startY, startX - endX, LINE_THICKNESS);
	} else if (startX < endX) { // It's a horizontal line
		this->fillRect(startX, startY, startX - endX, LINE_THICKNESS);
	} else {
		std::cout << "Something went wrong! start == end for a line" << std::endl;
	}

	SDL_SetRenderTarget(this->renderer, NULL);
}

void Engine::resetWires() {
	SDL_DestroyTexture(wireTexture);

	this->wireTexture = SDL_CreateTexture(
		this->renderer,
		SDL_PIXELFORMAT_RGBA8888,
		SDL_TEXTUREACCESS_STATIC,
		GRID_SIZE,
		GRID_SIZE
	);
}

Component::Component(const char* path, SDL_Renderer* renderer, int x, int y, int w, int h) {
	this->renderer = renderer;
	this->surface = IMG_Load(path);
		if (this->surface == NULL) {
		std::cout << "Error loading image: " << IMG_GetError() << std::endl;
	}

	this->texture = SDL_CreateTextureFromSurface(renderer, this->surface);
	if (this->texture == NULL) {
		std::cout << "Error creating texture" << std::endl;
	}

	this->rect = {x,y,w,h};
	this->stamp();
}

Component::~Component() {
	if (this->surface != NULL) {
		SDL_FreeSurface(this->surface);
	}

	if (this->texture != NULL) {
		SDL_DestroyTexture(this->texture);
	}
}

void Component::stamp() {
	SDL_RenderCopy(this->renderer, this->texture, NULL, &this->rect);
}

bool Component::isValid() {
	return this->surface != NULL;
}

Button::Button(Engine* engine, int x, int y, int* width, int* height, int hex, char* text) {
    ubyte r, g, b;
    hexToRgb(hex, &r, &g, &b);
    TTF_SizeUTF8(engine->font, text, width, height);

    SDL_Color color = {r,g,b};
    this->surface = TTF_RenderText_Blended(engine->font, text, color);
    this->texture = SDL_CreateTextureFromSurface(engine->renderer, this->surface);

    SDL_Rect rect = {x, y, *width, *height};
    SDL_RenderCopy(engine->renderer, texture, 0x0, &rect);
}

Button::~Button() {
    SDL_FreeSurface(this->surface);
    SDL_DestroyTexture(this->texture);
}