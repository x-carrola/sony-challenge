#pragma once

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

FILE *openFile(char *filename);
bool runCommandAndGetOutput(char *command);
