

#include <stdio.h>
#include <stdlib.h>

int
read_int()
{
    char tmp[12];
    fgets(tmp, 12, stdin);
    return atoi(tmp);
}

int*
read_array(int nn)
{
    int* xs = (int*)malloc(nn * sizeof(int));
    for (int ii = 0; ii < nn; ++ii) {
        xs[ii] = read_int();
    }
    return xs;
}

void
print_array(int* xs, int nn)
{
    for (int ii = 0; ii < nn; ++ii) {
        printf("%d ", xs[ii]);
    }
    printf("\n");
}

int*
gnome_sort(int* xs, int nn)
{
    int* ys = malloc(nn * sizeof(int));
    for (int ii = 0; ii < nn; ++ii) {
        ys[ii] = xs[ii];
    }

    int ii = 0;
    while (ii < nn) {
        if (ii == 0 || ys[ii] >= ys[ii - 1]) {
            ii++;
        }
        else {
            int tt = ys[ii];
            ys[ii] = ys[ii - 1];
            ys[ii - 1] = tt;
            ii--;
        }
    }

    return ys;
}

int
main(int argc, char* argv[])
{
    int nn = read_int();
    int* xs = read_array(nn);
    int* ys = gnome_sort(xs, nn);
    print_array(xs, nn);
    print_array(ys, nn);
    free(xs); // No need to free in ASM for HW03.
    free(ys);
    return 0;
}


