// Common/String.cpp

#ifdef _WIN32
#include "StringConvert.h"
#else
#include <ctype.h>
#endif

#include "String.h"


#ifdef _WIN32

#ifndef _UNICODE

wchar_t MyCharUpper(wchar_t c)
{
  if (c == 0)
    return 0;
  wchar_t *res = CharUpperW((LPWSTR)(unsigned int)c);
  if (res != 0 || ::GetLastError() != ERROR_CALL_NOT_IMPLEMENTED)
    return (wchar_t)(unsigned int)res;
  const int kBufferSize = 4;
  char s[kBufferSize];
  int numChars = ::WideCharToMultiByte(CP_ACP, 0, &c, 1, s, kBufferSize, 0, 0);
  ::CharUpperA(s);
  ::MultiByteToWideChar(CP_ACP, 0, s, numChars, &c, 1);
  return c;
}

wchar_t MyCharLower(wchar_t c)
{
  if (c == 0)
    return 0;
  wchar_t *res = CharLowerW((LPWSTR)(unsigned int)c);
  if (res != 0 || ::GetLastError() != ERROR_CALL_NOT_IMPLEMENTED)
    return (wchar_t)(unsigned int)res;
  const int kBufferSize = 4;
  char s[kBufferSize];
  int numChars = ::WideCharToMultiByte(CP_ACP, 0, &c, 1, s, kBufferSize, 0, 0);
  ::CharLowerA(s);
  ::MultiByteToWideChar(CP_ACP, 0, s, numChars, &c, 1);
  return c;
}

wchar_t * MyStringUpper(wchar_t *s)
{
  if (s == 0)
    return 0;
  wchar_t *res = CharUpperW(s);
  if (res != 0 || ::GetLastError() != ERROR_CALL_NOT_IMPLEMENTED)
    return res;
  AString a = UnicodeStringToMultiByte(s);
  a.MakeUpper();
  return MyStringCopy(s, (const wchar_t *)MultiByteToUnicodeString(a));
}

wchar_t * MyStringLower(wchar_t *s)
{ 
  if (s == 0)
    return 0;
  wchar_t *res = CharLowerW(s);
  if (res != 0 || ::GetLastError() != ERROR_CALL_NOT_IMPLEMENTED)
    return res;
  AString a = UnicodeStringToMultiByte(s);
  a.MakeLower();
  return MyStringCopy(s, (const wchar_t *)MultiByteToUnicodeString(a));
}

#endif

inline int ConvertCompareResult(int r) { return r - 2; }

int MyStringCollate(const wchar_t *s1, const wchar_t *s2)
{ 
  int res = CompareStringW(
        LOCALE_USER_DEFAULT, SORT_STRINGSORT, s1, -1, s2, -1); 
  #ifdef _UNICODE
  return ConvertCompareResult(res);
  #else
  if (res != 0 || ::GetLastError() != ERROR_CALL_NOT_IMPLEMENTED)
    return ConvertCompareResult(res);
  return MyStringCollate(UnicodeStringToMultiByte(s1), 
        UnicodeStringToMultiByte(s2));
  #endif
}

#ifndef _WIN32_WCE
int MyStringCollate(const char *s1, const char *s2)
{ 
  return ConvertCompareResult(CompareStringA(
    LOCALE_USER_DEFAULT, SORT_STRINGSORT, s1, -1, s2, -1)); 
}

int MyStringCollateNoCase(const char *s1, const char *s2)
{ 
  return ConvertCompareResult(CompareStringA(
    LOCALE_USER_DEFAULT, NORM_IGNORECASE | SORT_STRINGSORT, s1, -1, s2, -1)); 
}
#endif

int MyStringCollateNoCase(const wchar_t *s1, const wchar_t *s2)
{ 
  int res = CompareStringW(
        LOCALE_USER_DEFAULT, NORM_IGNORECASE | SORT_STRINGSORT, s1, -1, s2, -1); 
  #ifdef _UNICODE
  return ConvertCompareResult(res);
  #else
  if (res != 0 || ::GetLastError() != ERROR_CALL_NOT_IMPLEMENTED)
    return ConvertCompareResult(res);
  return MyStringCollateNoCase(UnicodeStringToMultiByte(s1), 
      UnicodeStringToMultiByte(s2));
  #endif
}

#else

inline int NormalizeCompareResult(int res)
{
  if (res < 0) return -1;
  if (res > 0) return 1;
  return 0;
}

/*
inline wchar_t MyCharUpper(wchar_t c)
  { return towupper(c); }
*/
wchar_t MyCharUpper(wchar_t c)
{
  return toupper(c);
}

int MyStringCollateNoCase(const wchar_t *s1, const wchar_t *s2)
{ 
  while (true)
  {
    wchar_t c1 = *s1++;
    wchar_t c2 = *s2++;
    wchar_t u1 = MyCharUpper(c1);
    wchar_t u2 = MyCharUpper(c2);

    if (u1 < u2) return -1;
    if (u1 > u2) return 1;
    if (u1 == 0) return 0;
  }
}

#endif

int MyStringCompare(const char *s1, const char *s2)
{ 
  while (true)
  {
    unsigned char c1 = (unsigned char)*s1++;
    unsigned char c2 = (unsigned char)*s2++;
    if (c1 < c2) return -1;
    if (c1 > c2) return 1;
    if (c1 == 0) return 0;
  }
}

int MyStringCompare(const wchar_t *s1, const wchar_t *s2)
{ 
  while (true)
  {
    wchar_t c1 = *s1++;
    wchar_t c2 = *s2++;
    if (c1 < c2) return -1;
    if (c1 > c2) return 1;
    if (c1 == 0) return 0;
  }
}
