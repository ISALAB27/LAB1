#include<stdio.h>
#include<stdlib.h>

#define NT 11 // number of coeffs
#define NB 13 // number of bits
#define NB_APPROXIMATION 0

const int b[NT]={-1, -52, -102,260,1125,1630,1125,260,-102,-52,-1}; /// b array

/// Perform fixed point filtering assming direct form I
///\param x is the new input sample
///\return the new output sample
int myfilter(int x)
{
    static int sx[NT]; /// x shift register
    static int sy[NT-1]; /// y shift register
    static int first_run = 0; /// for cleaning shift registers
    int i; /// index
    int y; /// output sample

    /// clean the buffers
    if (first_run == 0)
    {
        first_run = 1;
        for (i=0; i<NT; i++)
            sx[i] = 0;
    }

    /// shift and insert new sample in x shift register
    for (i=NT-1; i>0; i--)
        sx[i] = sx[i-1];
    sx[0] = x;

    /// make the convolution
    /// Moving average part
    y = 0;
    for (i=0; i<NT; i++) {



        y += ((sx[i]>> NB_APPROXIMATION)*(b[i]>> NB_APPROXIMATION)); // PER NB_APPROXIMATION >6

        //y += ((sx[i]>> NB_APPROXIMATION)*(b[i]>> NB_APPROXIMATION)) >> (NB -2*NB_APPROXIMATION -1); // PER NB_APPROXIMATION <=6
    }

    y = y << (-NB+2*NB_APPROXIMATION+1); // PER NB_APPROXIMATION >6

    return y;
}

int main (int argc, char **argv)
{
    FILE *fp_in;
    FILE *fp_out;

    int x;
    int y;

    /// check the command line
    if (argc != 3)
    {
        printf("Use: %s <input_file> <output_file>\n", argv[0]);
        exit(1);
    }
    printf("%s",argv[1]);
    /// open files
    fp_in = fopen(argv[1], "r");
    if (fp_in == NULL)
    {
        printf("Error: cannot open %s\n",argv[1]);
        exit(2);
    }
    fp_out = fopen(argv[2], "w");

    /// get samples and apply filter
    fscanf(fp_in, "%d", &x);
    do{
        y = myfilter(x);
        fprintf(fp_out,"%d\n", y);
        fscanf(fp_in, "%d", &x);
    } while (!feof(fp_in));

    fclose(fp_in);
    fclose(fp_out);

    return 0;

}
