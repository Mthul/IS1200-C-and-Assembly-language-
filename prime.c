/*
 prime.c
 By David Broman.
 Last modified: 2015-09-15
 This file is in the public domain.
 Edited by Magnus Thulin in 2020

*/
#include <stdio.h>
#include <stdlib.h>

int is_prime(int n)
{

  int i = 0;

	if (n == 1 || n == 0)  // om n == 0 eller 1 returnera 0
		return 0;

		for (i = 2; i <= n/2; i++) {		// loopar fårn 2 till n/2,
			if (n%i == 0) { // om n har en rest på noll efter division på n är det inget primtal
			return 0;
		}
	}
	return 1;  // n är ett printal


}
// för att testa olika värden kan man bara ändra på talen inom is_prime() kommandon
// programmet kör main funktionen först, där man sedan kallar på is_prime med dess argument int n
int main(void)
{
	printf("%d\n", is_prime(11));  // 11 is a prime.      Should print 1.
	printf("%d\n", is_prime(383)); // 383 is a prime.     Should print 1.
	printf("%d\n", is_prime(987)); // 987 is not a prime. Should print 0.
	printf("%d\n", is_prime(10000));// is not a prime
}
