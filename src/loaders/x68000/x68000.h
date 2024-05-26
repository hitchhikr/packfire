// --------------------------------------------------
// Loader for X68000 files
#ifndef _X68000_H_
#define _X68000_H_

namespace X68000
{

// --------------------------------------------------
// Functions
char *GetName();
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
