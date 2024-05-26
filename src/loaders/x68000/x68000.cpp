// --------------------------------------------------
// Loader for Atari files

// --------------------------------------------------
// Includes
#include "../loaders.h"
#include "x68000.h"

namespace X68000
{

#include "../../depackers/68000/x68000/depacker_X68000.h"
#include "../../depackers/68000/x68000/depacker_no_user_X68000.h"
#include "../../depackers/68000/x68000/depacker_absolute_X68000.h"
#include "../../depackers/68000/x68000/depacker_absolute_no_user_X68000.h"
#include "../../depackers/68000/x68000/relocator_X68000.h"
#include "../../depackers/68000/x68000/entry_point_X68000.h"

#define CODE_SIZE 0
#define DATA_SIZE 1
#define BSS_SIZE 2
#define RELOC_SIZE 3
#define SYM_SIZE 4

#pragma pack(push)
#pragma pack(1)
struct x68k_header
{
    unsigned short magic;           // 0 4855
    unsigned char reserved1;        // 2 0
    unsigned char loadmode;         // 3 0 = normal 
                                    // 1 = minimal memory
                                    // 2 = high address
    unsigned long base;             // 4 base address (0)
    unsigned long entrypoint;       // 8
    unsigned long size[5];          // 12 code, data, bss, reloc, symbols
	unsigned long db_line;	        // 32 size of debugging info (line #)
	unsigned long db_syms;	        // 36 size of debugging info (symbol)
	unsigned long db_str;	        // 40 size of debugging info (string)
	unsigned long reserved2[4];	    // 44 0
	unsigned long bindlist;	        // 60 bind list offset
};                                  // 64/0x40 bytes
#pragma pack(pop)

unsigned char saved_flags;

// --------------------------------------------------
// Return the name of the file type
char *GetName()
{
    return "X68000 executable";
}

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
    x68k_header *ah = (x68k_header *) Mem;
    unsigned char *dest_mem;
    unsigned char *dest_mem_reloc;
    unsigned int *dwdest_mem;
    unsigned short *reloc_mem;
    int hunk_size;
    int file_size;
    int pos_reloc;
    int reloc_long;
    int reloc_size;
    unsigned short rel_dat;

    file_size = *Size;

    *Bss_Size = 0;
    if(swap_word(ah->magic) == 0x4855)
    {
        int codedata_size = (swap_dword(ah->size[CODE_SIZE]) +
                             swap_dword(ah->size[DATA_SIZE])
                            );
        int bss_size = swap_dword(ah->size[BSS_SIZE]);
        // Saved for later
        *Bss_Size = bss_size;
        hunk_size = codedata_size;
        saved_flags = ah->loadmode;

        // (Pass over any debug symbols)
        pos_reloc = codedata_size + sizeof(x68k_header);
        reloc_long = codedata_size;
        reloc_size = swap_dword(ah->size[RELOC_SIZE]);
 
        // Entry point patch at the end of the relocator code (add.l #x,a3)
        unsigned int *dwentry_point = (unsigned int *) (entry_point + 2);
        // Offset to the code entry point
        hunk_size += size_entry_point;

        if(reloc_size)
        {
            if(Do_Reloc)
            {
                dwentry_point[0] = swap_dword(swap_dword(ah->entrypoint) + size_entry_point);
                // We don't need the extra buffer for the relocations in that case
                dest_mem = (unsigned char *) malloc(hunk_size);
                memset(dest_mem, 0, hunk_size);
                *Size = hunk_size;
                // Copy the entry point patcher
                memcpy(dest_mem, entry_point, size_entry_point);
                // Do not copy bss stuff or the relocator
                memcpy(&dest_mem[size_entry_point], Mem + sizeof(x68k_header), codedata_size);
                dest_mem_reloc = &dest_mem[size_entry_point];
            }
            else
            {
                // some room to record the size of the section later
                reloc_size += 4;
                dwentry_point[0] = swap_dword(swap_dword(ah->entrypoint) + size_entry_point + size_relocator);
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
                // Copy the entry point patcher after the relocator
                memcpy(dest_mem + size_relocator, entry_point, size_entry_point);
                // Do not copy bss stuff
                memcpy(&dest_mem[size_relocator + size_entry_point], Mem + sizeof(x68k_header), codedata_size);
                dest_mem_reloc = &dest_mem[size_relocator + size_entry_point];
            }
        }
        else
        {
            dwentry_point[0] = swap_dword(swap_dword(ah->entrypoint) + size_entry_point);
            // There was no reloc...
            dest_mem = (unsigned char *) malloc(hunk_size);
            memset(dest_mem, 0, hunk_size);
            *Size = hunk_size;
            // Copy the entry point patcher
            memcpy(dest_mem, entry_point, size_entry_point);
            // Do not copy bss stuff or the relocator
            memcpy(&dest_mem[size_entry_point], Mem + sizeof(x68k_header), codedata_size);
            dest_mem_reloc = &dest_mem[size_entry_point];
        }

        // Save or process the reloc
        if(reloc_size)
        {
            // We're in pro mode so we relocate the file
            if(Do_Reloc)
            {
                reloc_mem = (unsigned short *) (Mem + pos_reloc);
                while(reloc_size > 0)
                {
                    rel_dat = swap_word(*reloc_mem);
                    if(rel_dat == 1)
                    {
                        reloc_long += swap_dword(*((unsigned int *) reloc_mem));
                        reloc_mem += 2;
                        reloc_size -= sizeof(int);
                    }
                    else
                    {
                        reloc_long += rel_dat;
                    }
                    dwdest_mem = (unsigned int *) &dest_mem_reloc[reloc_long];
                    dwdest_mem[0] = swap_dword(swap_dword(dwdest_mem[0]) + Reloc_Address);
                    reloc_mem += 1;
                    reloc_size -= sizeof(short);
                }
            }
            else
            {
                // Start of the reloc memory block
                reloc_mem = (unsigned short *) (Mem + pos_reloc);
                // We need to store the reloc infos at the end of the data
                memcpy(dest_mem + 4 + hunk_size, reloc_mem, reloc_size - 4);
                // Store the size of the reloc section
                dwdest_mem = (unsigned int *) &dest_mem[hunk_size];
                dwdest_mem[0] = swap_dword(reloc_size);
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
    x68k_header save_header;
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
    save_header.magic = swap_word(0x4855);
    // Make sure it's aligned because we will depack right after that
    // and the probs are accessed as words
    aligned_size = (depacker_size - pointers) + packed_size + 2;
    aligned_size &= 0xfffffffe;
    save_header.size[CODE_SIZE] = swap_dword(aligned_size);
    // (Depack into the bss + probs mem)
    save_header.size[BSS_SIZE] = swap_dword(bss_size);
    save_header.loadmode = swap_dword(saved_flags);

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
        char phony[4] = { 0, 0, 0, 0 };
        fwrite(phony, 1, aligned_size - ((depacker_size - pointers) + packed_size), out);
    }
}

}
