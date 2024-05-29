// LzmaAlone.cpp

#include "Common/MyWindows.h"
#include "Common/MyInitGuid.h"
#include <shlwapi.h>

#include <stdio.h>

#if defined(_WIN32) || defined(OS2) || defined(MSDOS)
#include <fcntl.h>
#include <io.h>
#define MY_SET_BINARY_MODE(file) _setmode(_fileno(file),O_BINARY)
#else
#define MY_SET_BINARY_MODE(file)
#endif

#include "Common/StringConvert.h"
#include "Common/StringToInt.h"

#include "7zip/Common/FileStreams.h"

#include "7zip/Compress/LZMA/LZMAEncoder.h"

// Loaders
#include "loaders/loaders.h"

char tempName[MAX_PATH + 1];
char tempName2[MAX_PATH + 1];
char tempName_strip[MAX_PATH + 1];

int do_reloc = FALSE;
int Reloc_Address;
int Bss_Size;

int have_input;
int have_output;
int force_binary_file;
int dont_restore_user = FALSE;
char inputName[MAX_PATH];
char outputName[MAX_PATH];

static void PrintHelp()
{
    printf("\nUsage: PackFire [Switches] <Input file> [Output file]\n\n");
    printf("         Switches: -b Output packed raw binary data only.\n");
    printf("                   -a<address> Depack executable at given hexadecimal address.\n");
    printf("                   -u Don't restore user level and interruptions after depacking.\n");
}

static void PrintHelpAndExit(const char *s)
{
    printf("\n%s\n", s);
    PrintHelp();
    throw -1;
}

static void IncorrectCommand()
{
    PrintHelpAndExit("Incorrect command");
}

static void WriteArgumentsToStringList(int numArguments, const char *arguments[], UStringVector &strings)
{
    for(int i = 1; i < numArguments; i++)
    {
        strings.Add(MultiByteToUnicodeString(arguments[i]));
    }
}

TYPE Get_File_Type(const char *FileName, int Size)
{
    TYPE result = FILE_UNK;
    char *result_name = "BINARY";
    FILE *out;
    unsigned char *mem_block = (unsigned char *) malloc(Size);
    unsigned char *new_mem_block = NULL;
    if(mem_block)
    {
        FILE *in = fopen(FileName, "rb");
        if(in)
        {
            fread(mem_block, 1, Size, in);
            fclose(in);

            new_mem_block = ATARI::Check(mem_block, &Size, &Bss_Size, do_reloc, Reloc_Address);
            if(new_mem_block)
            {
                result = FILE_ATARI;
                result_name = ATARI::GetName();
            }
            else
            {
                new_mem_block = X68000::Check(mem_block, &Size, &Bss_Size, do_reloc, Reloc_Address);
                if(new_mem_block)
                {
                    result = FILE_X68000;
                    result_name = X68000::GetName();
                }
                else
                {
                    Bss_Size = 0;
                    new_mem_block = NDS::Check(mem_block, &Size);
                    if(new_mem_block)
                    {
                        result = FILE_NDS;
                        result_name = NDS::GetName();
                    }
                }
            }
        }

	    printf("Packing %s file... ", result_name);

        if(!new_mem_block) new_mem_block = mem_block;
        out = fopen(tempName_strip, "wb");
        if(out)
        {
            fwrite(new_mem_block, 1, Size, out);
            free(new_mem_block);
            fclose(out);
        }
        if(new_mem_block != mem_block)
        {
            free(mem_block);
        }
    }
    // Alien file
    if(result == FILE_UNK) result = FILE_BINARY;
    return(result);    
}

int Get_File_Size(const char *FileName)
{
	FILE *FileHandle = NULL;
	int FileSize = 0;

	FileHandle = fopen(FileName, "rb");
	if(FileHandle)
    {
		fseek(FileHandle, 0, SEEK_END);
		FileSize = ftell(FileHandle);
		fseek(FileHandle, 0, SEEK_SET);
		fclose(FileHandle);
	}
	return(FileSize);
}

unsigned int get_aligned_size(unsigned int len, unsigned int width)
{
   unsigned int align_size = ((len + width) & ~width) - len;
   align_size = (len + align_size);
   return(align_size);
}

unsigned int get_aligned_address(unsigned int len, unsigned int width)
{
   return(len & ~width);
}

unsigned int swap_dword(unsigned int len)
{
   return(
   (((BYTE) (len >> 24))) |
   (((BYTE) (len >> 16)) << 8) |
   (((BYTE) (len >> 8)) << 16) |
   (((BYTE) (len & 0xff)) << 24)
   );
}

unsigned short swap_word(unsigned short len)
{
   return(
   (((BYTE) (len >> 8))) |
   (((BYTE) (len & 0xff)) << 8)
   );
}

// --------------------------------------------------
void Save_Binary(FILE *out,
                 unsigned char *mem_block,
                 int unpacked_size,
                 int packed_size,
                 unsigned int code
                )
{
    unpacked_size = swap_dword(unpacked_size);
    fwrite(&unpacked_size, 1, 4, out);
	fwrite(&code, 1, 4, out);
    fwrite(mem_block, 1, packed_size, out);
}

int main2(int n, const char *args[])
{
	int i;

    printf("PackFire v1.5 (%s)\n", __DATE__);
    printf("Written by hitchhikr of Neural^Rebels\n");

	if(n < 2)
    {
		PrintHelp();
		return 0;
	}
    printf("\n");

	GetModuleFileName(NULL, tempName, MAX_PATH);
	GetModuleFileName(NULL, tempName2, MAX_PATH);
	GetModuleFileName(NULL, tempName_strip, MAX_PATH);
	PathRemoveFileSpec(tempName);
	PathRemoveFileSpec(tempName2);
	PathRemoveFileSpec(tempName_strip);
	strcat(tempName, "\\pack.tmp");
	strcat(tempName2, "\\pack2.tmp");
	strcat(tempName_strip, "\\pack2.strip");

	CInFileStream *inStreamSpec = 0;
	CMyComPtr<ISequentialInStream> inStream;
	CMyComPtr<ISequentialOutStream> outStream;

    char *follow_switch;
    have_output = FALSE;
    have_input = FALSE;
    force_binary_file = FALSE;
    for(i = 1; i < n; i++)
    {
        if(args[i][0] == '-')
        {
            const char *swi = &args[i][1];
            while(*swi)
            {
                switch(*swi++)
                {
                    case 'b':
                    case 'B':
                        force_binary_file = TRUE;
                        break;
                    case 'u':
                    case 'U':
                        dont_restore_user = TRUE;
                        break;
                    case 'a':
                    case 'A':
                        do_reloc = TRUE;
                        Reloc_Address = strtol(swi, &follow_switch, 16);
                        swi = follow_switch;
                        break;
                    default:
                        printf("Unknown switch.\n");
                        return 0;
                }
            }
        }
        else
        {
            if(!have_input)
            {
		        sprintf(inputName, "%s", args[i]);
                have_input = TRUE;
            }
            else
            {
                if(have_output)
                {
                    printf("Argument error.\n");
                    return 0;
                }
		        sprintf(outputName, "%s", args[i]);
                have_output = TRUE;
            }
        }
    }
    
    if(!have_input)
    {
        printf("No file specified.\n");
        return 0;
    }
    if(!have_output)
    {
        sprintf(outputName, "%s", inputName);
    }

	int Input_Size = Get_File_Size(inputName);

    if(!Input_Size)
    {
	    printf("\nCan't open input file: %s.\n", (const char *) inputName);
		return 1;
    }
    
    int File_Type = Get_File_Type(inputName, Input_Size);

	inStreamSpec = new CInFileStream;
	inStream = inStreamSpec;
    if(!inStreamSpec->Open(tempName_strip))
    {
	    printf("\nCan't open input file: %s.\n", (const char *) tempName);
		return 1;
    }

	COutFileStream *outStreamSpec = new COutFileStream;
	outStream = outStreamSpec;
	if(!outStreamSpec->Create(GetSystemString(tempName2), true))
    {
	    printf("\nCan't open output file: %s.\n", (const char *)(outputName));
		return 1;
    }

    UInt64 fileSize;

	NCompress::NLZMA::CEncoder *encoderSpec =  new NCompress::NLZMA::CEncoder;
	CMyComPtr<ICompressCoder> encoder = encoderSpec;

	UInt32 dictionary = 1 << 23;

	UInt32 posStateBits = 0;
	UInt32 litContextBits = 0;
	UInt32 litPosBits = 0;
	UInt32 algorithm = 2;
	UInt32 numFastBytes = 255;

    PROPID propIDs[] =
    {
		NCoderPropID::kDictionarySize,
		NCoderPropID::kPosStateBits,
		NCoderPropID::kLitContextBits,
		NCoderPropID::kLitPosBits,
		NCoderPropID::kAlgorithm,
		NCoderPropID::kNumFastBytes
    };
	const int kNumProps = sizeof(propIDs) / sizeof(propIDs[0]);

    PROPVARIANT properties[kNumProps];
    for(int p = 0; p < 6; p++)
    {
        properties[p].vt = VT_UI4;
    }
    properties[0].ulVal = UInt32(dictionary);
    properties[1].ulVal = UInt32(posStateBits);
    properties[2].ulVal = UInt32(litContextBits);
    properties[3].ulVal = UInt32(litPosBits);
    properties[4].ulVal = UInt32(algorithm);
    properties[5].ulVal = UInt32(numFastBytes);
    
	if(encoderSpec->SetCoderProperties(propIDs, properties, kNumProps) != S_OK)
    {
	    IncorrectCommand();
    }

	inStreamSpec->File.GetLength(fileSize);

	// Write file size
	for(i = 0; i < 4; i++)
    {
		Byte b = Byte(fileSize >> (8 * i));
		if(outStream->Write(&b, sizeof(b), 0) != S_OK)
        {
			printf("Write error.\n");
			return 1;
		}
    }

	HRESULT result = encoder->Code(inStream, outStream, 0, 0, 0);
	if(result == E_OUTOFMEMORY)
    {
		printf("can't allocate memory.\n");
		return 1;
    }

	// Close the files
	inStream = NULL;
	outStream = NULL;

    DeleteFile(tempName_strip);
    DeleteFile(tempName);

	// Correct the header of the file
	FILE *Post_File;
	BYTE Pad_Byte = 0;
	int Pad_Length;
	int Total_Packed_Datas_Size;

	Post_File = fopen(GetOemString(tempName2), "rb");	
	if(Post_File)
    {
		int Post_File_Size;
		fseek(Post_File, 0, SEEK_END);
		Post_File_Size = ftell(Post_File);
		fseek(Post_File, 0, SEEK_SET);

 		Pad_Length = (((Post_File_Size - 1) & 0xfffffffc) + 4) - (Post_File_Size - 1);
		Total_Packed_Datas_Size = Pad_Length + (Post_File_Size - 1);
		if(Pad_Length < 0) Pad_Length = 0;
		BYTE *Post_Mem = (BYTE *) malloc(Post_File_Size);
		if(Post_Mem)
        {
			fread(Post_Mem, 1, Post_File_Size, Post_File);
			fclose(Post_File);

			DeleteFile(tempName2);

			Post_File = fopen(outputName, "wb");

			if(Post_File)
            {
                switch(File_Type)
                {
                    case FILE_BINARY:
                        Save_Binary(Post_File,
                                    Post_Mem + 9,
                                    (*((unsigned int *) Post_Mem)),
                                    Post_File_Size - 9,
                                    *((unsigned int *) (Post_Mem + 5))
                                   );
                        break;
                    case FILE_ATARI:
                        ATARI::Save_Lzma(Post_File,
                                         Post_Mem + 9,
                                         (*((unsigned int *) Post_Mem)),
                                         Bss_Size,
                                         Post_File_Size - 9,
                                         *((unsigned int *) (Post_Mem + 5)),
                                         do_reloc,
                                         dont_restore_user,
                                         Reloc_Address,
                                         force_binary_file
                                        );
                        break;
                    case FILE_X68000:
                        X68000::Save_Lzma(Post_File,
                                          Post_Mem + 9,
                                          (*((unsigned int *) Post_Mem)),
                                          Bss_Size,
                                          Post_File_Size - 9,
                                          *((unsigned int *) (Post_Mem + 5)),
                                          do_reloc,
                                          dont_restore_user,
                                          Reloc_Address,
                                          force_binary_file
                                         );
                        break;
                    case FILE_NDS:
                        NDS::Save_Lzma(Post_File,
                                       Post_Mem + 9,
                                       (*((unsigned int *) Post_Mem)),
                                       Post_File_Size - 9,
                                       *((unsigned int *) (Post_Mem + 5)),
                                       force_binary_file
                                      );
                        break;
                }
                fclose(Post_File);
				free(Post_Mem);
			}
            else
            {
				free(Post_Mem);
				printf("can't open output file %s.\n", (const char *) outputName);
				return 1;
			}
		}
        else
        {
		    fclose(Post_File);
			DeleteFile(tempName2);
			printf("not enough memory.\n");
			return 1;
		}
	}
    else
    {
		printf("can't open output file %s.\n", (const char *) outputName);
		return 1;
	}

	printf("done.\n");

	int Output_Size = Get_File_Size(outputName);

	printf("\n");
	printf("     Input     Output       Gain       %%\n");
	printf("----------------------------------------\n");
	printf("%10d %10d", Input_Size, Output_Size);
	printf(" %10d   %.02f\n", Input_Size - Output_Size,
                              (((float) (Input_Size - Output_Size)) * 100.0f) / (float) Input_Size);
	return 0;
}

int main(int n, const char *args[])
{
	try
    {
		return main2(n, args);
	}
	catch(const char *s)
    {
		printf("\nError: %s\n", s);
		return 1;
	}
	catch(...)
    {
		printf("\nError\n");
		return 1; 
	}
}
