#include <SDL2/SDL.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
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

void noix_de_coco(int *x, int *y, Arena mat, const Serpent *s) {
    *x = 0;
    *y = 0;
    while (mat[*x][*y] != VIDE || appartient(s, *x, *y)) {
        *x = rand() % ARENA_W;
        *y = rand() % ARENA_H;
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

    srand(time(NULL));
    int coco_x;
    int coco_y;
    noix_de_coco(&coco_x, &coco_y, mat, s);

    bool run = true;

    while (run) {
        init_arena(mat);
        mur_enceinte(mat);
        place_serpent(s, mat);
        mat[coco_x][coco_y] = COCO;
        draw_arena(renderer, mat);
        SDL_RenderPresent(renderer);

        SDL_Delay(200);
        SDL_Event event;
        while (SDL_PollEvent(&event) != 0) {
            if (event.type == SDL_KEYDOWN) {
                fprintf(stderr, "Touche pressée : %c \n", event.key.keysym.sym); 
            }
            switch (event.key.keysym.sym) {
                case 'q':
                    s->direction = LEFT;
                    break;
                case 'z':
                    s->direction = UP;
                    break;
                case 'd':
                    s->direction = RIGHT;
                    break;
                case 's':
                    s->direction = DOWN;
                    break;
                case 'x':
                    run = false;
                    break;
            }
        }
        int x = prochain_x(s);
        int y = prochain_y(s);
        if (appartient(s, x, y) || mat[x][y] == WALL) {
            printf("Perdu !!! \n");
            run = false;
        } else if (x == coco_x && y == coco_y) {
            printf("Miam \n");
            grandir(s);
            noix_de_coco(&coco_x, &coco_y, mat, s);
        } else {
            avancer(s);
        }
    }

    destroy_serpent(s);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(fenetre);
    SDL_Quit();

    return EXIT_SUCCESS;
}
