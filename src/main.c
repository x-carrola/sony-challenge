#include <stdio.h>

#include "io.h"

int main() {

  // Kernel vulnerabilities
  printf("----------------------------\n");
  printf("KERNEL VULNERABILITES\n");
  printf("----------------------------\n");
  runCommandAndGetOutput("bash scripts/1-kernel.sh");

  // Linux utilities
  printf("----------------------------\n");
  printf("LINUX UTILITIES VULNERABILITES\n");
  printf("----------------------------\n");
  runCommandAndGetOutput("bash scripts/2-linux-utilities.sh");

  // Processes
  printf("----------------------------\n");
  printf("PROCESSES\n");
  printf("----------------------------\n");
  runCommandAndGetOutput("bash scripts/3-processes.sh");

  // Services
  printf("----------------------------\n");
  printf("SERVICES\n");
  printf("----------------------------\n");
  runCommandAndGetOutput("bash scripts/4-services.sh");

  // Sockets
  printf("----------------------------\n");
  printf("SOCKETS\n");
  printf("----------------------------\n");
  runCommandAndGetOutput("bash scripts/5-sockets.sh");

  // Network
  printf("----------------------------\n");
  printf("NETWORK\n");
  printf("----------------------------\n");
  runCommandAndGetOutput("bash scripts/6-network.sh");

  // Users
  printf("----------------------------\n");
  printf("USERS\n");
  printf("----------------------------\n");
  runCommandAndGetOutput("bash scripts/7-users.sh");

  // Writable PATH abuses
  printf("----------------------------\n");
  printf("WRITABLE PATH ABUSES\n");
  printf("----------------------------\n");
  runCommandAndGetOutput("bash scripts/8-path.sh");

  return 0;
}