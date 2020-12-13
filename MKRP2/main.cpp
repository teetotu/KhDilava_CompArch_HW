#include <unistd.h>
#include "iostream"
#include <chrono>
#include <semaphore.h>
#include <thread>

sem_t s_forks[5];

void startThinking(int i) {
    int secs = 1 + (rand() % 5);
    printf("Философ %d начал думать (%d сек)\n", i, secs);
    sleep(secs);
}

void startEating(int i) {
    int leftFork;
    int rightFork;

    int secs = 1 + (rand() % 5);

    leftFork = i == 4 ? 0 : i;
    rightFork = i == 4 ? i : i + 1;

    printf("%d-й философ берет левую вилку \n", i);
    sem_wait(&s_forks[leftFork]);

    printf("%d-й философ берет правую вилку \n", i);
    sem_wait(&s_forks[rightFork]);

    printf("%d-й философ начал есть (%d сек) \n", i, secs);
    sleep(secs);

    sem_post(&s_forks[leftFork]);
    sem_post(&s_forks[rightFork]);
}
namespace sc = std::chrono;
void startWork(int i) {
    sc::steady_clock::time_point start = sc::steady_clock::now();
    while (true) {
        startThinking(i);
        startEating(i);
        if (sc::steady_clock::now() - start > sc::seconds(30)) break;
    }
}

int main() {
    srand(time(NULL));
    std::thread philosophers[5];

    for (int i = 0; i < 5; i++) {
        philosophers[i] = std::thread(startWork, i);
    }

    for (auto &phil: philosophers) phil.join();

    return 0;
}
