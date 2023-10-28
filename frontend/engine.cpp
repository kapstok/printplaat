#include <SDL.h>
#include <cmath>

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
    }

    // Destructor
    ~Framework(){
        SDL_DestroyRenderer(renderer);
        SDL_DestroyWindow(window);
        SDL_Quit();
    }

    void draw_circle(int center_x, int center_y, int radius_){
        // Setting the color to be RED with 100% opaque (0% trasparent).
        SDL_SetRenderDrawColor(renderer, 255, 0, 0, 255);

        // Drawing circle
        for(int x=center_x-radius_; x<=center_x+radius_; x++){
            for(int y=center_y-radius_; y<=center_y+radius_; y++){
                if((std::pow(center_y-y,2)+std::pow(center_x-x,2)) <= std::pow(radius_,2)){
                    SDL_RenderDrawPoint(renderer, x, y);
                }
            }
        }

        // Show the change on the screen
        SDL_RenderPresent(renderer);
    }

    void drawGrid(int rows, int columns, int x, int y) {
        SDL_Rect rect;
        rect.x = (600 / columns) * x + 1;
        rect.y = (600 / rows) * y + 1;
        rect.w = 600 / columns;
        rect.h = 600 / rows;

        SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
        //SDL_RenderDrawRect(renderer, &rect);
        SDL_RenderFillRect(renderer, &rect);
    }

    SDL_Renderer *renderer = NULL;      // Pointer for the renderer

private:
    int height;     // Height of the window
    int width;      // Width of the window
    SDL_Window *window = NULL;      // Pointer for the window
};

Framework* fw;

// void start() {
// SDL_Renderer *renderer = NULL;      // Pointer for the renderer
//     int height;     // Height of the window
//     int width;      // Width of the window
//     SDL_Window *window = NULL;      // Pointer for the window
//         SDL_Init(SDL_INIT_VIDEO);       // Initializing SDL as Video
//         SDL_CreateWindowAndRenderer(width, height, 0, &window, &renderer);
//         SDL_SetRenderDrawColor(renderer, 0, 0, 0, 0);      // setting draw color
//         SDL_RenderClear(renderer);      // Clear the newly created window
//         SDL_RenderPresent(renderer);    // Reflects the changes done in the
//                                         //  window.
//     SDL_Event event;    // Event variable

//     // Below while loop checks if the window has terminated using close in the
//     //  corner.
//     while(!(event.type == SDL_QUIT)){
//         SDL_Delay(10);  // setting some Delay
//         SDL_PollEvent(&event);  // Catching the poll event.
//     }
// }

void init() {
//int main(int argc, char * argv[]) {

    // Creating the object by passing Height and Width value.
    fw = new Framework(600, 600);
}

void draw(int row, int column, int x, int y) {
    // Calling the function that draws circle.
    //fw.draw_circle(200, 100, 50);
    fw->drawGrid(row, column, x, y);
}

void render() {
    SDL_RenderPresent(fw->renderer);
    SDL_Event event;    // Event variable

    // Below while loop checks if the window has terminated using close in the
    //  corner.
    while(!(event.type == SDL_QUIT)){
        SDL_Delay(10);  // setting some Delay
        SDL_PollEvent(&event);  // Catching the poll event.
    }

    delete fw;
}

void foo();

int main() {
    foo();
    return 0;
}
