/*
 * Zombie Process Prevention Demo
 * Demonstrates how to prevent zombie processes using wait()/waitpid()
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

#define NUM_CHILDREN 5

int main() {
    pid_t pid;
    int status;
    int i;
    
    printf("=========================================\n");
    printf("    ZOMBIE PROCESS PREVENTION DEMO      \n");
    printf("=========================================\n\n");
    printf("Parent Process PID: %d\n\n", getpid());
    
    // Create multiple child processes
    printf("Creating %d child processes...\n", NUM_CHILDREN);
    printf("-----------------------------------------\n");
    
    for (i = 0; i < NUM_CHILDREN; i++) {
        pid = fork();
        
        if (pid < 0) {
            // Fork failed
            perror("Fork failed");
            exit(1);
        } else if (pid == 0) {
            // Child process
            printf("  Child %d (PID: %d) started, will run for %d seconds\n", 
                   i + 1, getpid(), i + 1);
            
            // Simulate some work
            sleep(i + 1);
            
            printf("  Child %d (PID: %d) terminating...\n", i + 1, getpid());
            exit(i);  // Exit with different status for each child
        }
        // Parent continues to create more children
    }
    
    // Parent process: Wait for all children to prevent zombies
    printf("\nParent waiting for children to terminate...\n");
    printf("-----------------------------------------\n");
    
    int children_remaining = NUM_CHILDREN;
    
    while (children_remaining > 0) {
        // Wait for any child to terminate
        pid = waitpid(-1, &status, 0);
        
        if (pid > 0) {
            if (WIFEXITED(status)) {
                printf("  Cleaned up child PID: %d (exit status: %d)\n", 
                       pid, WEXITSTATUS(status));
            } else if (WIFSIGNALED(status)) {
                printf("  Cleaned up child PID: %d (killed by signal: %d)\n", 
                       pid, WTERMSIG(status));
            }
            children_remaining--;
        }
    }
    
    printf("\n=========================================\n");
    printf("           ALL CHILDREN CLEANED         \n");
    printf("=========================================\n");
    printf("All %d child processes have been properly\n", NUM_CHILDREN);
    printf("cleaned up. No zombie processes remain.\n");
    printf("=========================================\n");
    
    return 0;
}
