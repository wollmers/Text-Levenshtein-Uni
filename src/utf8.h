#ifdef __cplusplus
extern "C" {
#endif

#include <stdarg.h>

/* convert UTF-8 data to wide character */
int u8_toucs(u_int32_t *dest, int sz, char *src, int srcsz);

#ifdef __cplusplus
}
#endif
