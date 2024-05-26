// --------------------------------------------------
// Loader for Atari files
#ifndef _ATARI_H_
#define _ATARI_H_

namespace ATARI
{

// --------------------------------------------------
// Functions
unsigned char *Check(unsigned char *Mem,
                     int *Size,
                     int *Bss_Size,
                     int Do_Reloc,
                     int Reloc_Address);
void Save_Lzma(FILE *out,
               unsigned char *mem_block,
               int unpacked_size,
               int packed_size,
               int Orig_Bss_Size,
               unsigned int code,
               int do_reloc,
               int restore_user,
               int Reloc_Address,
               int Raw_Data
              );
}

#endif
