#ifndef _LOADERS_H_
#define _LOADERS_H_

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

enum TYPE
{
    FILE_UNK,
    FILE_BINARY,
    FILE_ATARI,
};

unsigned int get_aligned_size(unsigned int len, unsigned int width);
unsigned int get_aligned_address(unsigned int len, unsigned int width);
unsigned int swap_dword(unsigned int len);
unsigned short swap_word(unsigned short len);

#include "atari/atari.h"

#endif
