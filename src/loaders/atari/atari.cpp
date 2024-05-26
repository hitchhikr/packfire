// --------------------------------------------------
// Loader for Atari files

// --------------------------------------------------
// Includes
#include "../loaders.h"
#include "atari.h"

namespace ATARI
{

#include "../../depackers/atari/depacker.h"
#include "../../depackers/atari/depacker_no_user.h"
#include "../../depackers/atari/depacker_absolute.h"
#include "../../depackers/atari/depacker_absolute_no_user.h"
#include "../../depackers/atari/relocator.h"

#pragma pack(push)
#pragma pack(1)
struct st_header
{
    unsigned short branch;      // 0
    unsigned long code_size;    // 2
    unsigned long data_size;    // 6
    unsigned long bss_size;     // 10
    unsigned long sym_size;     // 14
    unsigned long res1;         // 18
    unsigned long prgflags;     // 22
    unsigned short absflags;    // 26
};

struct symbol
{
    unsigned long sym_name;
    unsigned long sym_name2;
    unsigned short flags;
    unsigned long offset;
};
#pragma pack(pop)

// Empty reloc 32 bit word
unsigned int footer[] =
{
   0
};

int saved_flags;

// --------------------------------------------------
// Check if the file is a suitable executable
// Return the parsed file or null
// (& modifies size argument to the real size of data to be packed)
unsigned char *Check(unsigned char *Mem,
                     int *Size,
                     int *Bss_Size,
                     int Do_Reloc,
                     int Reloc_Address)
{
    st_header *ah = (st_header *) Mem;
    unsigned char *dest_mem;
    unsigned int *dwdest_mem;
    unsigned char *reloc_mem;
    int hunk_size;
    int file_size;
    int pos_reloc;
    int reloc_long;
    int nbr_reloc;
    int i;
    int reloc_size;
    unsigned char rel_dat;

    file_size = *Size;

    *Bss_Size = 0;
    if(swap_word(ah->branch) == 0x601a && ah->res1 == 0)
    {
        int codedata_size = (swap_dword(ah->code_size) +
                             swap_dword(ah->data_size));
        int bss_size = swap_dword(ah->bss_size);
        // Saved for later
        *Bss_Size = bss_size;
        hunk_size = codedata_size;
        saved_flags = swap_dword(ah->prgflags);

        // (Pass over any debug symbols)
        pos_reloc = codedata_size + sizeof(st_header) + swap_dword(ah->sym_size);
        reloc_long = swap_dword(*((int *) (Mem + pos_reloc)));
        pos_reloc += 4;
        reloc_size = 0;
        reloc_mem = Mem + pos_reloc;
           
        // A long of 0 means no relocation section
        if(reloc_long)
        {
            // Number of relocs + First long 
            // Retrieve the real size of the reloc infos
            rel_dat = reloc_mem[0];
            nbr_reloc = 0;
            while(rel_dat)
            {
                reloc_size++;
                rel_dat = *++reloc_mem;
                if(reloc_mem >= (Mem + file_size)) break;
            }
        }

        // 4 = offset to the reloc infos
        if(reloc_size)
        {
            if(Do_Reloc)
            {
                // We don't need the extra buffer for the relocations in that case
                dest_mem = (unsigned char *) malloc(hunk_size);
                memset(dest_mem, 0, hunk_size);
                *Size = hunk_size;
                // Do not copy bss stuff or the relocator
                memcpy(dest_mem, Mem + sizeof(st_header), codedata_size);
            }
            else
            {
                reloc_size += 4 + 4;
                hunk_size += size_relocator;
                dest_mem = (unsigned char *) malloc(hunk_size + reloc_size);
                memset(dest_mem, 0, hunk_size + reloc_size);
                *Size = hunk_size + reloc_size;
                // Place the position of the reloc section at the front of the relocator code (move.l #x,d0)
                unsigned int *dwrelocator = (unsigned int *) (relocator + 2);
                // Offset to the reloc section at the start of the relocator
                dwrelocator[0] = swap_dword(hunk_size);
                // Copy the relocator before the code
                memcpy(dest_mem, relocator, size_relocator);
                // Do not copy bss stuff
                memcpy(&dest_mem[size_relocator], Mem + sizeof(st_header), codedata_size);
            }
        }
        else
        {
            // There was no reloc...
            dest_mem = (unsigned char *) malloc(hunk_size);
            memset(dest_mem, 0, hunk_size);
            *Size = hunk_size;
            // Do not copy bss stuff or the relocator
            memcpy(dest_mem, Mem + sizeof(st_header), codedata_size);
        }

        // Save or process the reloc
        if(reloc_long && reloc_size)
        {
            // We're in pro mode so we reloc the file
            if(Do_Reloc)
            {
                reloc_mem = Mem + pos_reloc;
                // Fix the first one
                dwdest_mem = (unsigned int *) &dest_mem[reloc_long];
                dwdest_mem[0] = swap_dword(swap_dword(dwdest_mem[0]) + Reloc_Address);
                for(i = 0; i < reloc_size; i++)
                {
                    // (We already got the first dword)
                    rel_dat = *reloc_mem++;
                    if(rel_dat == 1) reloc_long += 254;
                    else if(rel_dat & 1) break;
                    else
                    {
                        reloc_long += rel_dat;
                        dwdest_mem = (unsigned int *) &dest_mem[reloc_long];
                        dwdest_mem[0] = swap_dword(swap_dword(dwdest_mem[0]) + Reloc_Address);
                    }
                }
            }
            else
            {
                // Start of the reloc memory block
                reloc_mem = Mem + pos_reloc;
                // Convert 
                for(i = 0; i < reloc_size - 4 - 4; i++)
                {
                    // Convert the reloc data 256 byts jumps to 0
                    // So we avoid a cmp in the relocator
                    rel_dat = *reloc_mem;
                    if(rel_dat == 1) rel_dat = 0;
                    *reloc_mem++ = rel_dat;
                }

                reloc_mem = Mem + pos_reloc - 4;
                // We need to store the reloc infos at the end of the data
                memcpy(dest_mem + 4 + hunk_size, reloc_mem, reloc_size - 4);
                // Store the number of reloc data
                dwdest_mem = (unsigned int *) &dest_mem[hunk_size];
                dwdest_mem[0] = swap_dword((reloc_size - 4 - 4) - 1);
            }
        }
        return(dest_mem);
    }
    return(NULL);
}

// --------------------------------------------------
// Save file
void Save_Lzma(FILE *out,
               unsigned char *mem_block,
               int unpacked_size,
               int Orig_Bss_Size,
               int packed_size,
               unsigned int code,
               int Do_Reloc,
               int restore_user,
               int Reloc_Address,
               int Raw_Datas)
{
    st_header save_header;
    unsigned int *data_pos;
    unsigned char *use_depacker;
    unsigned int depacker_size;
    int aligned_size;

    int pointers = Do_Reloc ? 5 * 4: 4 * 4;
    if(Do_Reloc)
    {
        use_depacker = depacker_absolute;
        depacker_size = size_depacker_absolute;
        if(restore_user)
        {
            use_depacker = depacker_absolute_no_user;
            depacker_size = size_depacker_absolute_no_user;
        }
    }
    else
    {
        use_depacker = depacker;
        depacker_size = size_depacker;
        if(restore_user)
        {
            use_depacker = depacker_no_user;
            depacker_size = size_depacker_no_user;
        }
    }

    // Total size in memory
    unsigned int bss_size = Do_Reloc ? (Orig_Bss_Size + 15980) + 1:
                                       (unpacked_size + Orig_Bss_Size + 15980) + 1;
    bss_size &= 0xfffffffe;

    memset(&save_header, 0, sizeof(save_header));

    // Store the starting code
    data_pos = (unsigned int *) (swap_dword(((unsigned int *) use_depacker)[0]) +
                                (int) use_depacker);
    *data_pos = code;

    // Packed length
    data_pos = (unsigned int *) (swap_dword(((unsigned int *) use_depacker)[1]) +
                                (int) use_depacker);
    *data_pos = swap_dword((packed_size + 1) & 0xfffffffe);

    // Store the unpacked length in order to clear before depacking
    data_pos = (unsigned int *) (swap_dword(((unsigned int *) use_depacker)[2]) +
                                (int) use_depacker);
    *data_pos = swap_dword(unpacked_size);

    // Store the unpacked length boundary
    data_pos = (unsigned int *) (swap_dword(((unsigned int *) use_depacker)[3]) +
                                (int) use_depacker);
    *data_pos = swap_dword(unpacked_size);

    if(Do_Reloc)
    {
        // Dest address
        data_pos = (unsigned int *) (swap_dword(((unsigned int *) use_depacker)[4]) +
                                    (int) use_depacker);
        *data_pos = swap_dword(Reloc_Address);
    }

    // Fill the header with the infos
    save_header.branch = swap_word(0x601a);
    // Make sure it's aligned because we will depacker right after that
    // and the probs are access as words
    aligned_size = (depacker_size - pointers) + packed_size + 2;
    aligned_size &= 0xfffffffe;
    save_header.code_size = swap_dword(aligned_size);
    // (Depack into the bss + probs mem)
    save_header.bss_size = swap_dword(bss_size);
    save_header.prgflags = swap_dword(saved_flags);

    if(!Raw_Datas)
    {
        // Write the header
        fwrite(&save_header, 1, sizeof(save_header), out);
        // Write the Depacker
        fwrite(use_depacker + pointers, 1, (depacker_size - pointers), out);
    }
    else
    {
        // Unpacked size (68k = 3 2 1 0)
	    unpacked_size = swap_dword(unpacked_size);
        fwrite(&unpacked_size, 1, 4, out);
	    // Code (inverted) (68k = 5 6 7 8)
	    fwrite(&code, 1, 4, out);
    }

    // Write the compressed datas
	fwrite(mem_block, 1, packed_size, out);

    if(!Raw_Datas)
    {
        if((aligned_size = (depacker_size - pointers) + packed_size + 4) & 1)
        {
            char phony;
	        fwrite(&phony, 1, sizeof(char), out);
        }
    
        // End of file marker (no reloc)
        fwrite(footer, 1, sizeof(footer), out);
    }
}

}
