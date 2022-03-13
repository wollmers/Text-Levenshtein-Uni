// https://dr-rost.medium.com/detect-memory-leaks-on-macos-4cf257529aa
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    char *p = (char *) malloc(12);
    p = 0; // the leak is here
    printf("Hello, leak!\n");
    return 0;
}
