#define NK_INCLUDE_FIXED_TYPES
#define NK_INCLUDE_STANDARD_BOOL
#define NK_INCLUDE_COMMAND_USERDATA
#define NK_KEYSTATE_BASED_INPUT

#include <stdint.h>

extern void nuklear_assert_handler(const char*, const char*, int);
#define NK_ASSERT(condition) \
    do { \
        if (!(condition)) { \
            nuklear_assert_handler(#condition, __FILE__, __LINE__); \
        } \
    } while (0)

extern void nuklear_memset(void* dest, int c0, uint64_t size);
#define NK_MEMSET nuklear_memset

extern void* nuklear_memcpy(void* dest, const void* src, uint64_t size);
#define NK_MEMCPY nuklear_memcpy

extern float nuklear_inv_sqrt(float n);
#define NK_INV_SQRT nuklear_inv_sqrt

extern float nuklear_sin(float x);
#define NK_SIN nuklear_sin

extern float nuklear_cos(float x);
#define NK_COS nuklear_cos

extern float nuklear_atan(float x);
#define NK_ATAN nuklear_atan

extern float nuklear_atan2(float y, float x);
#define NK_ATAN2 nuklear_atan2

#define NK_IMPLEMENTATION
#include "nuklear.h"
