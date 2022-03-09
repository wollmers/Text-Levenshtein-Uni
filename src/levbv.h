#ifdef __cplusplus
extern "C" {
#endif

#ifndef _LEVBV_H
#define _LEVBV_H

#include <stdint.h>

#ifdef __x86_64__
    #if SIZE_MAX == 0xFFFFFFFF
        typedef uint32_t bv_bits;
        #define _LEVBV_WIDTH 32
    #else
        typedef uint64_t bv_bits;
        #define _LEVBV_WIDTH 64
    #endif
#else
    typedef uint32_t bv_bits;
    #define _LEVBV_WIDTH 32
#endif

int dist_utf8_ucs (char * a, uint32_t alen, char * b, uint32_t blen );
int dist_hybrid (const uint32_t *a, int alen, const uint32_t *b, int blen) ;
int dist_simple( const uint32_t *a, int alen, const uint32_t *b, int blen );
int dist_mixed( const uint32_t *a, int alen, const uint32_t *b, int blen );


#endif

#ifdef __cplusplus
}
#endif
