#ifndef __COMMAN_H__
#define __COMMAN_H__

#include <cstdio>

#ifdef DEBUG
  #include <iostream>
  #define DPRINT(...) do { std::cout << __VA_ARGS__; } while(0)
#else
  #define DPRINT(...) ((void)0)
#endif

#endif // __COMMAN_H__
