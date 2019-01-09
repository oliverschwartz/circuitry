#include <stdio.h>

/* Checks whether the combination of 3 side lengths
   (3, 4, 9) form a valid triangle. Stores 1 in 'valid'
   if so; if the lengths are invalid, 'valid' is -1 */ 
int main(void) {
    int valid = 1;
    int a = 3;
    int b = 4;
    int c = 9;

    if (!(a + b > c)) {
        valid = -1;
        printf("valid: %d\n", valid);
        return 0;
    }
    if (!(b + c > a)) {
        valid = -1;
        printf("valid: %d\n", valid);
        return 0;
    } 
    if (!(a + c > b)) {
        valid = -1;
        printf("valid: %d\n", valid);
        return 0;
    } 
}