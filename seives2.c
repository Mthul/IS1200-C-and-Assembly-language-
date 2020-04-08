
// Labb 2, uppgift 3

#include <stdio.h>
#include <math.h>
#include <stdlib.h>

#define COLUMNS 6     // definierar COLUMNS till värde 6


int count = 0;	// initialize counter for number printing to 0
void print_number(int n) {	// void function does things but does not explicitly return something // tar in ett argument n men returnerar inget värde

	printf("%10d",n);	// print the number, 10 as it's what done below, space for characters?

	count++;			// every time we print, increase count by 1 to be able to keep track of the tabel

	if (count % COLUMNS == 0) {	// if value of counter / COLUMNS yields no remainder
		printf("\n");			        // force newline and continue printing
	}
}
// seives algoritm för primtal,
void print_sieves(int n) {

	int i, j;                        // definierar i och j
	char numbers[n+1];              // deffinierar en char som erhåller integers

	int previous = 0, count = 0;        // start värden

	for (i = 0; i <= n; i++) {	 // set all indexes in numbers[] to 1, denoting true
								              // meaning the index i is a prime number
		numbers[i] = 1;			     // this is the start state, will be modified below
	}

	for (i = 2; i < (int) sqrt(n); i++) {	// do for every i >= 2 below the root of n

		if (numbers[i]) {	// if numbers[i] != 0 then do

			for (j = i*i; j <= n; j += i) {	// for all j = i^2, i^2+i, i^2+2i, i^2+3i, below n

	/* set */
				numbers[j] = 0;	// set numbers[j] to false (zero)
								// meaning the index j is not a prime number
			}
		}
	}

	// print the numbers
	for (i = 2; i <= n; i++) {

		if (numbers[i] != 0) {	// if a given i is set to true in numbers, print it

			print_number(i);

			if (i - previous == 4) { // if i - previous yields 4 add 1 to counter
				count++;
			}

			previous = i;	// set previous to current i before exting iteration
		}
	}

	printf("\n\nThis many occurences of B-A == 4: %d\n\n", count);
}

// 'argc' contains the number of program arguments, and
// 'argv' is an array of char pointers, where each
// char pointer points to a null-terminated string.
int main(int argc, char *argv[]) {

	if(argc == 2) {
		print_sieves(atoi(argv[1]));
	}
	else {
		printf("Please state an interger number.\n");
	}

	return 0;
}
