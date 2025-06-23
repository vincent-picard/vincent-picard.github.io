#include <SDL2/SDL.h>
#include <stdio.h>
#include <stdlib.h>
#include "main.h"
#include "serpent.h"

/* Construit une arène entièrement vide */
void init_arena(Arena mat) {
    for (int x = 0; x < ARENA_W; x++) {
        for (int y = 0; y < ARENA_H; y++) {
            mat[x][y] = VIDE;
        }
    }
}

/* Construit un mur d'enceinte */
void mur_enceinte(Arena mat) {
    for (int x = 0; x < ARENA_W; x++) {
        mat[x][0] = WALL;
        mat[x][ARENA_H - 1] = WALL;
    }
    for (int y = 0; y < ARENA_H; y++) {
        mat[0][y] = WALL;
        mat[ARENA_W - 1][y] = WALL;
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

    Serpent *s = creer_serpent(3, 3, RIGHT);
    for (int k = 0; k < 5; k++) {
        grandir(s);
    }

    Arena mat;

    for (int k = 0; k < 8; k++) {
        init_arena(mat);
        mur_enceinte(mat);
        place_serpent(s, mat);
        draw_arena(renderer, mat);
        SDL_RenderPresent(renderer);

        SDL_Delay(500);
        avancer(s);
    }
    s->direction = DOWN;
    for (int k = 0; k < 3; k++) {
        init_arena(mat);
        mur_enceinte(mat);
        place_serpent(s, mat);
        draw_arena(renderer, mat);
        SDL_RenderPresent(renderer);

        SDL_Delay(500);
        avancer(s);
    }
    s->direction = LEFT;
    for (int k = 0; k < 8; k++) {
        init_arena(mat);
        mur_enceinte(mat);
        place_serpent(s, mat);
        draw_arena(renderer, mat);
        SDL_RenderPresent(renderer);

        SDL_Delay(500);
        avancer(s);
    }


    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(fenetre);
    SDL_Quit();

    return EXIT_SUCCESS;
}
