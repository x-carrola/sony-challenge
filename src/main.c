#include <stdio.h>

#include "io.h"

int main() {
  printf("Hello world!\n");

  // Kernel exploits
  runCommandAndGetOutput("bash scripts/les.sh");

  return 0;
}