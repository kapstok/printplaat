#include <iostream>
#include "SDL.h"
#include "SDL2/SDL_image.h"

int main(int argc, char* argv[]) {
	if (SDL_Init(SDL_INIT_VIDEO) < 0) {
		std::cout << "Error SDL2 Initialization : " << SDL_GetError();
		return 1;
	}

	SDL_Window* window = NULL;//SDL_CreateWindow("First program", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 800, 600, SDL_WINDOW_OPENGL);
	if (window == NULL) {
		std::cout << "Error window creation";
		// return 3;
	}

	SDL_Renderer* renderer = NULL;//SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
	SDL_CreateWindowAndRenderer(800, 600, 0, &window, &renderer);
	if (renderer == NULL) {
		std::cout << "Error renderer creation";
		return 4;
	}

	if (IMG_Init(IMG_INIT_PNG) == 0) {
		std::cout << "Error SDL2_image Initialization";
		return 2;
	}

	SDL_Surface* lettuce_sur = IMG_Load("lettuce.png"); // 410x300 pixels (WxH)
	if (lettuce_sur == NULL) {
		std::cout << "Error loading image: " << IMG_GetError();
		return 5;
	}

	SDL_Texture* lettuce_tex = SDL_CreateTextureFromSurface(renderer, lettuce_sur);
	if (lettuce_tex == NULL) {
		std::cout << "Error creating texture";
		return 6;
	}

	SDL_FreeSurface(lettuce_sur);

	#define ubyte unsigned char
	int hex = 0xffafaa;
	ubyte a = 0xff;
	ubyte r, g, b;
        r = (hex & 0xFF0000) >> 16;
    	g = (hex & 0x00FF00) >> 8;
    	b = hex & 0x0000FF;
    SDL_SetRenderDrawColor(renderer, r, g, b, a);
	
	SDL_RenderClear(renderer);
	SDL_Rect rect = {0,0,200,200};
	SDL_RenderCopy(renderer, lettuce_tex, NULL, &rect);
	SDL_RenderPresent(renderer);

	while (true) {
		SDL_Event e;
		if (SDL_PollEvent(&e)) {
			if (e.type == SDL_QUIT) {
				break;
			}
		}
	}

	SDL_DestroyTexture(lettuce_tex);
	SDL_DestroyRenderer(renderer);
	SDL_DestroyWindow(window);
	IMG_Quit();
	SDL_Quit();

	return 0;
}