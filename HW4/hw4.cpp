// omp_parallel.cpp
// compile with: /openmp
#include <iostream>
#include <algorithm>
#include <omp.h>
#include <string>
#include <time.h>

const int height = 1024, width = 1024;
int numberOfThreads = 8;
int groupThatFoundTheTreasure;

omp_lock_t myLock;

int island[height][width] = { 0 };

static int begin = 0;

int x, y;

bool found = false;

void CheckBlockOfLand(int row) {
	for (int i = 0; i <= width; ++i) {
		if (island[row][i] == 1) {
			x = found ? x : row;
			y = found ? y : i;
			found = true;
			groupThatFoundTheTreasure = omp_get_thread_num();
		}
	}

	row += numberOfThreads;

	if (!found && row < 1024 - numberOfThreads)
	{
		CheckBlockOfLand(row);
	}
}


int main() {
	omp_init_lock(&myLock);

	std::cout << "Enter the number of threads" << std::endl;
	try {
		std::string line;
		std::cin >> line;
		numberOfThreads = std::stoi(line);
		if (numberOfThreads < 1)
			throw std::exception();
	}
	catch (std::exception) {
		std::cout << "Incorrect input data format" << std::endl;
		return 0;
	}
	srand(time(0));
	int rnd1 = rand() % height, rnd2 = rand() % width;
	island[rnd1][rnd1] = 1;

#pragma omp parallel for
	for (int t = 0; t < numberOfThreads; t++)
	{
		CheckBlockOfLand(t);
	}

	if (found)
	{
		std::cout << "The treasure was found at x = " << x << " y = " << y << std::endl;
	}

	return 0;
}