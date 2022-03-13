/* levtest.c
 *
 * Copyright (C) 2020-2022, Helmut Wollmersdorfer, all rights reserved.
 *
*/

#ifndef _LEVBV_TEST
#define _LEVBV_TEST
#endif

#include <stdio.h>
#include <limits.h>
#include <time.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>

#include "levbv.h"
#include "levbv.c"

int main (void) {
    clock_t tic;
    clock_t toc;
    double elapsed;
    double total = 0;
    double rate;

    int bench_on = 1;

    uint64_t count;
    uint64_t megacount;
    uint32_t iters     = 1000000;
    uint32_t megaiters = 1;

    // m=10, n=11, llcs=7, sim=0.667
    //char ascii_str1[] = "Choerephon";
    //char ascii_str2[] = "Chrerrplzon";
    //uint32_t ascii_len1 = strlen(ascii_str1);
    //uint32_t ascii_len2 = strlen(ascii_str2);

    // [ſhoereſhoſ] m: 10, [Choerephon] n: 10 -> 3
    //char utf_str1[] = "Choerephon";
    //char utf_str2[] = "ſhoereſhoſ";

    char utf_str1[] = "Choerephon";
    char utf_str2[] = "Chrerrplzon";

    //char utf_str1[] = "Choerephon";
    //char utf_str2[] = "Chſerſplzon";

    int utf_len1 = strlen(utf_str1);
    int utf_len2 = strlen(utf_str2);

    // convert to ucs
    uint32_t a_ucs[(utf_len1+1)*4];
    uint32_t b_ucs[(utf_len2+1)*4];
    int a_chars;
    int b_chars;

    a_chars = u8_toucs(a_ucs, (utf_len1+1)*4, utf_str1, utf_len1);
    b_chars = u8_toucs(b_ucs, (utf_len2+1)*4, utf_str2, utf_len2);

    int int_size = sizeof(int);
    printf("sizeof(int): %u \n\n", int_size);

    int distance;
    // int distance2;

    //distance = dist_asci (ascii_str1, ascii_len1, ascii_str2, ascii_len2);
    //printf("[dist_asci]     distance: %u expect: 4\n", distance);

    distance = dist_utf8_ucs (utf_str1, utf_len1, utf_str2, utf_len2);
    printf("[dist_utf8_ucs] distance: %u expect: 4\n", distance);

    //distance = dist_uni(a_ucs, a_chars, b_ucs, b_chars);
	//printf("[dist_uni]      distance: %u expect: 4\n", distance);

	distance = dist_mixed(a_ucs, a_chars, b_ucs, b_chars);
	printf("[dist_mixed]    distance: %u expect: 4\n\n", distance);

	char utf_str1_l52[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXY";
	char utf_str2_l52[] =  "bcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int utf_len1_l52 = strlen(utf_str1_l52);
    int utf_len2_l52 = strlen(utf_str2_l52);
    printf("strlen(utf_str1_l52): %u \n", utf_len1_l52);
    printf("strlen(utf_str2_l52): %u \n", utf_len2_l52);

    // convert to ucs
    uint32_t a_ucs_l52[(utf_len1_l52+1)*4];
    uint32_t b_ucs_l52[(utf_len2_l52+1)*4];
    int a_chars_l52;
    int b_chars_l52;

    a_chars_l52 = u8_toucs(a_ucs_l52, (utf_len1_l52+1)*4, utf_str1_l52, utf_len1_l52);
    b_chars_l52 = u8_toucs(b_ucs_l52, (utf_len2_l52+1)*4, utf_str2_l52, utf_len2_l52);
    printf("a_chars_l52: %u \n", a_chars_l52);
    printf("b_chars_l52: %u \n", b_chars_l52);


	distance = dist_mixed(a_ucs_l52, a_chars_l52, b_ucs_l52, b_chars_l52);
	printf("[dist_mixed_l52] distance: %u expect: 2\n\n", distance);

    /* ########## dist_utf8_ucs ########## */
if ( 1 && bench_on ) {
    tic = clock();

    megaiters = 20;

    for (megacount = 0; megacount < megaiters; megacount++) {
      for (count = 0; count < iters; count++) {
          distance = dist_utf8_ucs (utf_str1, utf_len1, utf_str2, utf_len2);
      }
    }

    toc = clock();
    elapsed = (double)(toc - tic) / (double)CLOCKS_PER_SEC;
    total += elapsed;
    rate    = (double)megaiters / (double)elapsed;

    printf("[dist_utf8_ucs] iters: %u M Elapsed: %f s Rate: %.1f (M/sec) %u\n",
        megaiters, elapsed, rate, distance);
}

    /* ########## dist_mixed ########## */
if ( 1 && bench_on ) {
    tic = clock();

    megaiters = 20;

    for (megacount = 0; megacount < megaiters; megacount++) {
      for (count = 0; count < iters; count++) {
          distance = dist_mixed(a_ucs, a_chars, b_ucs, b_chars);
      }
    }

    toc = clock();
    elapsed = (double)(toc - tic) / (double)CLOCKS_PER_SEC;
    total += elapsed;
    rate    = (double)megaiters / (double)elapsed;

    printf("[dist_mixed]    iters: %u M Elapsed: %f s Rate: %.1f (M/sec) %u\n",
        megaiters, elapsed, rate, distance);
}

    /* ########## dist_mixed_l52 ########## */
if ( 1 && bench_on ) {
    tic = clock();

    megaiters = 20;

    for (megacount = 0; megacount < megaiters; megacount++) {
      for (count = 0; count < iters; count++) {
          distance = dist_mixed(a_ucs_l52, a_chars_l52, b_ucs_l52, b_chars_l52);
      }
    }

    toc = clock();
    elapsed = (double)(toc - tic) / (double)CLOCKS_PER_SEC;
    total += elapsed;
    rate    = (double)megaiters / (double)elapsed;

    printf("[dist_mixed_l52] iters: %u M Elapsed: %f s Rate: %.1f (M/sec) %u\n",
        megaiters, elapsed, rate, distance);
}

    printf("Total: %f seconds\n", total);

    return 0;

}
