/* levbv.c
 *
 * Copyright (C) 2020-2022, Helmut Wollmersdorfer, all rights reserved.
 *
 * see file LICENSE in the distribution
*/

#ifdef __cplusplus
extern "C" {
#endif

#include <stdio.h>
#include <limits.h>
#include <time.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>

#include "levbv.h"

#include "utf8.h"
#include "utf8.c"

// width of type bv_bits in bits, mostly 64 bits
static const uint64_t width = _LEVBV_WIDTH;

/***** Hashi *****/

typedef struct {
    uint32_t *ikeys;
    bv_bits *bits;
} Hashi;


inline void hashi_setpos (Hashi *hashi, uint32_t key, uint32_t pos) {
    int index = 0;
    while ( hashi->ikeys[index]
           && ((uint32_t)hashi->ikeys[index] != key) ) {
        index++;
    }
    if (hashi->ikeys[index] == 0) {
        hashi->ikeys[index] = key;
    }
    hashi->bits[index] |= 0x1ull << (pos % _LEVBV_WIDTH);
}


inline uint64_t hashi_getpos (Hashi *hashi, uint32_t key) {
    int index = 0;
    while ( hashi->ikeys[index]
           && ((uint32_t)hashi->ikeys[index] != key) ) {
        index++;
    }
    return hashi->bits[index];
}

/************************/

static const char allBytesForUTF8[256] = {
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
    3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4,5,5,5,5,6,6,6,6
};

/************************/



/***********************/

static const uint64_t masks[64] = {
  //0x0000000000000000,
  0x0000000000000001ull,0x0000000000000003ull,0x0000000000000007ull,0x000000000000000full,
  0x000000000000001full,0x000000000000003full,0x000000000000007full,0x00000000000000ffull,
  0x00000000000001ffull,0x00000000000003ffull,0x00000000000007ffull,0x0000000000000fffull,
  0x0000000000001fffull,0x0000000000003fffull,0x0000000000007fffull,0x000000000000ffffull,
  0x000000000001ffffull,0x000000000003ffffull,0x000000000007ffffull,0x00000000000fffffull,
  0x00000000001fffffull,0x00000000003fffffull,0x00000000007fffffull,0x0000000000ffffffull,
  0x0000000001ffffffull,0x0000000003ffffffull,0x0000000007ffffffull,0x000000000fffffffull,
  0x000000001fffffffull,0x000000003fffffffull,0x000000007fffffffull,0x00000000ffffffffull,
  0x00000001ffffffffull,0x00000003ffffffffull,0x00000007ffffffffull,0x0000000fffffffffull,
  0x0000001fffffffffull,0x0000003fffffffffull,0x0000007fffffffffull,0x000000ffffffffffull,
  0x000001ffffffffffull,0x000003ffffffffffull,0x000007ffffffffffull,0x00000fffffffffffull,
  0x00001fffffffffffull,0x00003fffffffffffull,0x00007fffffffffffull,0x0000ffffffffffffull,
  0x0001ffffffffffffull,0x0003ffffffffffffull,0x0007ffffffffffffull,0x000fffffffffffffull,
  0x001fffffffffffffull,0x003fffffffffffffull,0x007fffffffffffffull,0x00ffffffffffffffull,
  0x01ffffffffffffffull,0x03ffffffffffffffull,0x07ffffffffffffffull,0x0fffffffffffffffull,
  0x1fffffffffffffffull,0x3fffffffffffffffull,0x7fffffffffffffffull,0xffffffffffffffffull,
};

#ifndef _LEVBV_LOW_CHARS
    #define _LEVBV_LOW_CHARS 128
#endif

// utf-8 to UCS-4 wrapper for dist_hybrid
int dist_utf8_ucs (char * a, uint32_t alen, char * b, uint32_t blen) {

    uint32_t a_ucs[(alen+1)*4];
    uint32_t b_ucs[(blen+1)*4];
    int a_chars;
    int b_chars;
    // int u8_toucs(u_int32_t *dest, int sz, char *src, int srcsz)
    a_chars = u8_toucs(a_ucs, (alen+1)*4, a, alen);
    b_chars = u8_toucs(b_ucs, (blen+1)*4, b, blen);

    int diff;
    diff = dist_hybrid(a_ucs, a_chars, b_ucs, b_chars);

    return diff;
}


// use uni codepoints as uint32_t key
// or ascii table
int dist_hybrid (const uint32_t *a, int alen, const uint32_t *b, int blen) {

    int amin = 0;
    int amax = alen-1;
    int bmin = 0;
    int bmax = blen-1;

if (1) {
    while (amin <= amax && bmin <= bmax && a[amin] == b[bmin]) {
        amin++;
        bmin++;
    }
    while (amin <= amax && bmin <= bmax && a[amax] == b[bmax]) {
        amax--;
        bmax--;
    }
}

    // if one of the sequences is a complete subset of the other,
    // return difference of lengths.
    if ((amax < amin) || (bmax < bmin)) { return abs(alen - blen); }

    int m = amax-amin + 1;


    // for codepoints in the low range we use fast table lookup
    int low_chars = _LEVBV_LOW_CHARS;
    static bv_bits posbits[_LEVBV_LOW_CHARS] = { 0 };
    uint64_t i;

    for (i=0; i < low_chars; i++) { posbits[i] = 0; }

    int ascii_chars = 0;
    for (i=0; i < m; i++) {
        if (a[i+amin] < low_chars) {
            posbits[(unsigned int)a[i+amin]] |= 0x1ull << i;
            ascii_chars++;
        }
    }

    // for codepoints in the high range we use sequential search
    int uni_chars = m - ascii_chars;

    Hashi hashi;
    uint32_t ikeys[uni_chars+1]; // static ikeys[64+1] ??
    bv_bits bits[uni_chars+1]; // static ikeys[64+1] ??
    hashi.ikeys = ikeys;
    hashi.bits  = bits;

    //int32_t i;
    for (i=0; i <= uni_chars; i++) {
        hashi.ikeys[i] = 0;
        hashi.bits[i]  = 0;
    }

    for (i=0; i < m; i++) {
        if (a[i+amin] >= low_chars) {
            hashi_setpos (&hashi, a[i+amin], i);
        }
    }

    int diff = m;
    bv_bits mask = 1 << (m - 1);
    bv_bits VP   = masks[m - 1];
    bv_bits VN   = 0;

    int n = bmax-bmin +1;

    bv_bits y;
    for (i=0; i < n; i++){
        if (b[i+bmin] < _LEVBV_LOW_CHARS) {
            y = posbits[(unsigned int)b[i+bmin]];
        }
        else {
            y = hashi_getpos (&hashi, b[i+bmin]);
        }
        bv_bits X  = y | VN;
        bv_bits D0 = ((VP + (X & VP)) ^ VP) | X;
        bv_bits HN = VP & D0;
        bv_bits HP = VN | ~(VP|D0);
        X  = (HP << 1) | 1;
        VN = X & D0;
        VP = (HN << 1) | ~(X | D0);
        if (HP & mask) { diff++; }
        if (HN & mask) { diff--; }
    }
    return diff;

}

#define MAX_LEVENSHTEIN_STRLEN	16384

#define Min(x, y) ((x) < (y) ? (x) : (y))

int
dist_simple( const uint32_t *a, int alen, const uint32_t *b, int blen ) {

    int amin = 0;
    int amax = alen-1;
    int bmin = 0;
    int bmax = blen-1;

if (0) {
    while (amin <= amax && bmin <= bmax && a[amin] == b[bmin]) {
        amin++;
        bmin++;
    }
    while (amin <= amax && bmin <= bmax && a[amax] == b[bmax]) {
        amax--;
        bmax--;
    }
}

    // if one of the sequences is a complete subset of the other,
    // return difference of lengths.
    if ((amax < amin) || (bmax < bmin)) { return abs(alen - blen); }

    int m = amax - amin + 1;
    int n = bmax - bmin + 1;

	int i, j;

    int distance;

	/*
	if (m > MAX_LEVENSHTEIN_STRLEN ||
		n > MAX_LEVENSHTEIN_STRLEN)
	{
      // croak("argument exceeds the maximum length of %d bytes", MAX_LEVENSHTEIN_STRLEN);
        ereport(ERROR,
				(errcode(ERRCODE_INVALID_PARAMETER_VALUE),
				 errmsg("levenshtein argument exceeds maximum length of %d characters",
						MAX_LEVENSHTEIN_STRLEN)));
    }
    */

	/* Previous and current rows of notional array. */
	// char *name = malloc (strlen (str1) + strlen (str2) + 1);
	// if (name == 0)
    // fatal ("virtual memory exceeded");

    int *prev = malloc(2 * (n + 1) * sizeof(int));
	//int *prev_alloc;
	int *curr;
	int *temp;
	//prev = (int *) malloc(2 * (n + 1) * sizeof(int));
	curr = prev + (n + 1);

	for (j = 0; j <= n; j++) { prev[j] = j; }

	for ( i = 1; i <= m; i++) {

		curr[0] = i;

        for ( j = 1; j <= n; j++) {
		    int			ins;
		    int			del;
		    int			sub;

		    ins = curr[j - 1] + 1;
		    del = prev[j] + 1;
		    sub = prev[j - 1] + ((a[amin + i-1] == b[bmin + j-1]) ? 0 : 1);

		    /* Take the one with minimum cost. */
		    curr[j] = Min(ins, del);
		    curr[j] = Min(curr[j], sub);
		}

		/* Swap current row with previous row. */
		temp = curr;
		curr = prev;
		prev = temp;
	}

	/*
	 * Because the final value was swapped from the previous row to the
	 * current row, that's where we'll find it.
	 */
	distance = prev[n];

    if(prev) { free(prev); }

    return distance;
}

int
dist_mixed( const uint32_t *a, int alen, const uint32_t *b, int blen ) {

    int amin = 0;
    int amax = alen-1;
    int bmin = 0;
    int bmax = blen-1;

if (1) {
    while (amin <= amax && bmin <= bmax && a[amin] == b[bmin]) {
        amin++;
        bmin++;
    }
    while (amin <= amax && bmin <= bmax && a[amax] == b[bmax]) {
        amax--;
        bmax--;
    }
}
    // if one of the sequences is a complete subset of the other,
    // return difference of lengths.
    if ((amax < amin) || (bmax < bmin)) { return abs(alen - blen); }

if ( 1 && ((amax - amin) < width) ) {

    int m = amax-amin + 1;
    // for codepoints in the low range we use fast table lookup
    int low_chars = _LEVBV_LOW_CHARS;
    static bv_bits posbits[_LEVBV_LOW_CHARS] = { 0 };
    uint64_t i;

    for (i=0; i < low_chars; i++) { posbits[i] = 0; }

    int ascii_chars = 0;
    for (i=0; i < m; i++) {
        if (a[i+amin] < low_chars) {
            posbits[(unsigned int)a[i+amin]] |= 0x1ull << i;
            ascii_chars++;
        }
    }

    // for codepoints in the high range we use sequential search
    int uni_chars = m - ascii_chars;

    Hashi hashi;
    uint32_t ikeys[uni_chars+1]; // static ikeys[64+1] ??
    bv_bits bits[uni_chars+1]; // static ikeys[64+1] ??
    hashi.ikeys = ikeys;
    hashi.bits  = bits;

    //int32_t i;
    for (i=0; i <= uni_chars; i++) {
        hashi.ikeys[i] = 0;
        hashi.bits[i]  = 0;
    }

    for (i=0; i < m; i++) {
        if (a[i+amin] >= low_chars) {
            hashi_setpos (&hashi, a[i+amin], i);
        }
    }

    int diff = m;
    bv_bits mask = 1 << (m - 1);
    bv_bits VP   = masks[m - 1];
    bv_bits VN   = 0;

    int n = bmax-bmin +1;

    bv_bits y;
    for (i=0; i < n; i++){
        if (b[i+bmin] < _LEVBV_LOW_CHARS) {
            y = posbits[(unsigned int)b[i+bmin]];
        }
        else {
            y = hashi_getpos (&hashi, b[i+bmin]);
        }
        bv_bits X  = y | VN;
        bv_bits D0 = ((VP + (X & VP)) ^ VP) | X;
        bv_bits HN = VP & D0;
        bv_bits HP = VN | ~(VP|D0);
        X  = (HP << 1) | 1;
        VN = X & D0;
        VP = (HN << 1) | ~(X | D0);
        if (HP & mask) { diff++; }
        if (HN & mask) { diff--; }
    }
    return diff;
} // end hybrid
else {

    int m = amax - amin + 1;
    int n = bmax - bmin + 1;

	int i, j;

    int distance;

	/*
	if (m > MAX_LEVENSHTEIN_STRLEN ||
		n > MAX_LEVENSHTEIN_STRLEN)
	{
      // croak("argument exceeds the maximum length of %d bytes", MAX_LEVENSHTEIN_STRLEN);
        ereport(ERROR,
				(errcode(ERRCODE_INVALID_PARAMETER_VALUE),
				 errmsg("levenshtein argument exceeds maximum length of %d characters",
						MAX_LEVENSHTEIN_STRLEN)));
    }
    */

	/* Previous and current rows of notional array. */
	// char *name = malloc (strlen (str1) + strlen (str2) + 1);
	// if (name == 0)
    // fatal ("virtual memory exceeded");

    int *prev = malloc(2 * (n + 1) * sizeof(int));
	//int *prev_alloc;
	int *curr;
	int *temp;
	//prev = (int *) malloc(2 * (n + 1) * sizeof(int));
	curr = prev + (n + 1);

	for (j = 0; j <= n; j++) { prev[j] = j; }

	for ( i = 1; i <= m; i++) {

		curr[0] = i;

        for ( j = 1; j <= n; j++) {
		    int			ins;
		    int			del;
		    int			sub;

		    ins = curr[j - 1] + 1;
		    del = prev[j] + 1;
		    sub = prev[j - 1] + ((a[amin + i-1] == b[bmin + j-1]) ? 0 : 1);

		    /* Take the one with minimum cost. */
		    curr[j] = Min(ins, del);
		    curr[j] = Min(curr[j], sub);
		}

		/* Swap current row with previous row. */
		temp = curr;
		curr = prev;
		prev = temp;
	}

	/*
	 * Because the final value was swapped from the previous row to the
	 * current row, that's where we'll find it.
	 */
	distance = prev[n];

    if(prev) { free(prev); }

    return distance;
  } // end simple
}


#ifdef __cplusplus
}
#endif
