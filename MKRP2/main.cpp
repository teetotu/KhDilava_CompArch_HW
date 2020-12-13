#include <unistd.h>
#include "iostream"
#include<chrono>
#include <semaphore.h>
#include <thread>

sem_t s_forks[5];

void think(int i) {
    int secs = 1 + (rand() % 5);
    printf("Философ %d начал думать (%d сек)\n", i, secs);
    sleep(secs);
}

void eat(int i) {
    int leftFork;
    int rightFork;

    if (i == 4) {
        leftFork = 0;
        rightFork = i;
    } else {
        leftFork = i;
        rightFork = i + 1;
    }

    printf("%d-й философ берет левую вилку \n", i);
    sem_wait(&s_forks[leftFork]);

    printf("%d-й философ берет правую вилку \n", i);
    sem_wait(&s_forks[rightFork]);
    int secs = 1 + (rand() % 5);
    printf("%d-й философ начал есть (%d сек) \n", i, secs);
    sleep(secs);

    sem_post(&s_forks[leftFork]);
    sem_post(&s_forks[rightFork]);
}

void simulation(int i) {
    std::chrono::steady_clock::time_point start = std::chrono::steady_clock::now();
    while (true) {
        think(i);
        eat(i);
        if (std::chrono::steady_clock::now() - start > std::chrono::seconds(30)) {
            break;
        }
    }
}

int main() {
    srand(time(NULL));
    std::thread philosophers[5];

    for (int i = 0; i < 5; i++) {
        philosophers[i] = std::thread(simulation, i);
    }

    for (auto &phil: philosophers) phil.join();

    return 0;
}
