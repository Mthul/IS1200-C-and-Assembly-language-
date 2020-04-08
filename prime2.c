/*
 prime.c
 By David Broman.
 Last modified: 2015-09-15
 This file is in the public domain.
 Editad av Magnus Thulin
*/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#define COLUMNS 6  // definierar en COLUMN

// funktion för att identifiera primtal
int is_prime(int n){        //deff is_prime med int n som input
    int i = 0;                     // deff i = 0
    for (i = 2; i <=(n/2); i++){        // for-loop som adderar
        if(n % i == 0) {
           return 0;
        }
    }
  return 1;
}

// printa primtal i tabell format
int counter = 0;      // counter = 0, global variabel, räknare för antlet  kolumner
void print_number(int n) // print_number funktion
{
    printf("%10d",n);   // skapar utrymme där man kan fylla radem med nummer om önskas
    counter++;
    if (counter % COLUMNS == 0) {  //restterm efter Counter/Columns
        printf("\n"); //printar ny rad
    }
}
// Primtal loop som loppar genom alla tal i talet och skickar alla tal som är primtal till print_number funktionen
void print_primes(int n)
{
    //Mening att prnta alla primtal som finns inom det valda numret
    // with the following formatting. Note that
    // the number of columns is stated in the define
    // COLUMNS
    int i;
    for (i = 2; i < n; i++) { //så länge i<n så läggs 1 på i
        if (is_prime(i) == 1){     //kallar på primtal funktionen och loopar fram till att alla primtal har beräknats
            print_number(i); // skapar en ny rad
        }
    }
    printf("\n");
}

// 'argc' contains the number of program arguments, and
// 'argv' is an array of char pointers, where each , argv är en array med
// char pointer points to a null-terminated string.
int main(int argc, char *argv[])
{
    if(argc == 2)
        print_primes(atoi(argv[1]));  // atoi är en inbyggd funktion som omvandlar en sträng till en int
    else                              // kontroll för input va argument
        printf("Please state an interger number.\n");
    return 0;

}
