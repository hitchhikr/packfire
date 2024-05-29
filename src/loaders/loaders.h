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
    FILE_X68000,
    FILE_NDS
};

unsigned int get_aligned_size(unsigned int len, unsigned int width);
unsigned int get_aligned_address(unsigned int len, unsigned int width);
unsigned int swap_dword(unsigned int len);
unsigned short swap_word(unsigned short len);

#include "atari/atari.h"
#include "x68000/x68000.h"
#include "nds/nds.h"

#endif
