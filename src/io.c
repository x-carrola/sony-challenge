#include "io.h"

FILE *openFile(char *filename) {

}

bool runCommandAndGetOutput(char *command) {
  FILE *file_ptr;
  char output[1035];

  file_ptr = popen(command, "r");
  if (NULL == file_ptr) {
    printf("Failed to run command\n");
    return false;
  }

  while (fgets(output, sizeof(output), file_ptr) != NULL) {
    printf("%s", output);
  }

  /* close */
  pclose(file_ptr);
}