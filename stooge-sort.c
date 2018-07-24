

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

void
stooge_helper(int* xs, int ii, int jj)
{
    if (xs[ii] > xs[jj]) {
        int tt = xs[ii];
        xs[ii] = xs[jj];
        xs[jj] = tt;
    }

    if (jj - ii + 1 > 2) {
        int kk = (jj - ii + 1) / 3;
        stooge_helper(xs, ii, jj - kk);
        stooge_helper(xs, ii + kk, jj);
        stooge_helper(xs, ii, jj - kk);
    }
}

int*
stooge_sort(int* xs, int nn)
{
    int* ys = malloc(nn * sizeof(int));
    for (int ii = 0; ii < nn; ++ii) {
        ys[ii] = xs[ii];
    }

    stooge_helper(ys, 0, nn - 1);
    return ys;
}

int
main(int argc, char* argv[])
{
    int nn = read_int();
    int* xs = read_array(nn);
    int* ys = stooge_sort(xs, nn);
    print_array(xs, nn);
    print_array(ys, nn);
    free(xs); // No need to free in ASM for HW03.
    free(ys);
    return 0;
}


