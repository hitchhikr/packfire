// --------------------------------------------------
// Loader for Nintendo DS files
#ifndef _NDS_H_
#define _NDS_H_

namespace NDS
{

// --------------------------------------------------
// Functions
char *GetName();
unsigned char *Check(unsigned char *Mem,
                     int *Size);
void Save_Lzma(FILE *out,
               unsigned char *mem_block,
               int unpacked_size,
               int packed_size,
               unsigned int code,
               int Raw_Datas
              );
}

#endif
