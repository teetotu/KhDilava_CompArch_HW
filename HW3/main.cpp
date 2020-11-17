#include <iostream>
#include <algorithm>
#include <pthread.h>

const int height = 1024, width = 1024;

pthread_mutex_t mutex;

int island[height][width] = {0};

static int begin = 0;

int x, y;

bool found = false;

void CheckBlockOfLand(int row) {
    for (int i = 0; i < width; ++i) {
        if (found)
            break;
        if (island[row][i] == 1) {
            x = found ? x : row;
            y = found ? y : i;
            found = true;
        }
    }
}

void *func(void *param) {
    int tempBegin = 0;

    while (true) {

        pthread_mutex_lock(&mutex);
        tempBegin = begin;
        begin++;
        pthread_mutex_unlock(&mutex);

        CheckBlockOfLand(tempBegin);
        if (begin >= height) break;
    }
}

int main() {
    std::cout << "Enter the number of threads" << std::endl;
    std::string line;
    std::cin >> line;
    int numberOfThreads = std::stoi(line);

    srand(time(NULL));
    int rnd1 = rand() % height, rnd2 = rand() % width;
    island[rnd1][rnd2] = 1;

    pthread_mutex_init(&mutex, nullptr);

    pthread_t threads[numberOfThreads - 1];

    for (int i = 0; i < numberOfThreads - 1; ++i)
        pthread_create(&threads[i], NULL, func, 0);

    for (int i = 0; i < numberOfThreads - 1; ++i) {
        pthread_join(threads[i], NULL);
    }

    std::cout << "The treasure was found at x = " << x << " y = " << y << std::endl;

    return 0;
}