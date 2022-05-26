#include <stdio.h>

#include "io.h"

int main() {
  printf("Hello world!\n");

  runCommandAndGetOutput("ls");

  return 0;
}