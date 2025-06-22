#include <SDL2/SDL.h>
#include <stdio.h>
#include <stdlib.h>
#include "options.h"

typedef int Arena[ARENA_W][ARENA_H];

/* Construit une arène entièrement vide */
void init_arena(Arena mat) {
    for (int x = 0; x < ARENA_W; x++) {
        for (int y = 0; y < ARENA_H; y++) {
            mat[x][y] = VIDE;
        }
    }
}

void draw_arena(SDL_Renderer *renderer, Arena mat) {
    SDL_SetRenderDrawColor(renderer, 100, 100, 100, 255);
    SDL_RenderClear(renderer);
    for (int x = 0; x < ARENA_W; x++) {
        for (int y = 0; y < ARENA_H; y++) {
            SDL_Rect bloc = {10 + x * B_SIZE, 10 + y * B_SIZE, B_SIZE, B_SIZE};
            // Fond
            switch (mat[x][y]) {
                case VIDE:
                    SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
                    break;

                case SNAKE:
                    SDL_SetRenderDrawColor(renderer, 0, 200, 0, 255);
                    break;

                case WALL:
                    SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
                    break;

                case COCO:
                    SDL_SetRenderDrawColor(renderer, 165, 42, 42, 255);
                    break;

                default:
                    SDL_SetRenderDrawColor(renderer, 255, 0, 0, 255);
            }
            SDL_RenderFillRect(renderer, &bloc);

            // Contour
            SDL_SetRenderDrawColor(renderer, 75, 75, 75, 255);
            SDL_RenderDrawRect(renderer, &bloc);
        }
    }

}

int main(int argc, char * argv[]) {
    SDL_Init(SDL_INIT_VIDEO);
    SDL_Window *fenetre = SDL_CreateWindow("Snake974", WIN_X, WIN_Y, WIN_W, WIN_H, 0);
    SDL_Renderer *renderer = SDL_CreateRenderer(fenetre, -1, SDL_RENDERER_ACCELERATED);

    Arena mat;
    init_arena(mat);
    mat[3][5] = WALL; // Pour tester
    mat[6][6] = SNAKE; // Toujours pour tester
    mat[6][7] = SNAKE;
    mat[6][8] = SNAKE;
    mat[15][2] = COCO;
    draw_arena(renderer, mat);

    SDL_RenderPresent(renderer);

    SDL_Delay(5000); // Attendre 5 sec

    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(fenetre);
    SDL_Quit();

    return EXIT_SUCCESS;
}
