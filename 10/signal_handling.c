/*
 * Signal Handling Demo
 * Demonstrates parent-child signal communication and handling
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/wait.h>

volatile sig_atomic_t keep_running = 1;
volatile sig_atomic_t sigterm_received = 0;
volatile sig_atomic_t sigint_received = 0;

// Signal handler for SIGTERM
void handle_sigterm(int sig) {
    sigterm_received = 1;
    printf("\n[Parent] Received SIGTERM (signal %d)\n", sig);
    printf("[Parent] Handling SIGTERM: Preparing for graceful shutdown...\n");
}

// Signal handler for SIGINT
void handle_sigint(int sig) {
    sigint_received = 1;
    keep_running = 0;
    printf("\n[Parent] Received SIGINT (signal %d)\n", sig);
    printf("[Parent] Handling SIGINT: Initiating immediate shutdown...\n");
}

int main() {
    pid_t parent_pid = getpid();
    pid_t child1_pid, child2_pid;
    
    printf("=========================================\n");
    printf("       SIGNAL HANDLING DEMO             \n");
    printf("=========================================\n\n");
    printf("Parent Process PID: %d\n\n", parent_pid);
    
    // Set up signal handlers in parent
    struct sigaction sa_term, sa_int;
    
    sa_term.sa_handler = handle_sigterm;
    sigemptyset(&sa_term.sa_mask);
    sa_term.sa_flags = 0;
    sigaction(SIGTERM, &sa_term, NULL);
    
    sa_int.sa_handler = handle_sigint;
    sigemptyset(&sa_int.sa_mask);
    sa_int.sa_flags = 0;
    sigaction(SIGINT, &sa_int, NULL);
    
    // Create first child - sends SIGTERM after 5 seconds
    child1_pid = fork();
    
    if (child1_pid < 0) {
        perror("Fork failed for child 1");
        exit(1);
    } else if (child1_pid == 0) {
        // Child 1 process
        printf("[Child 1] PID: %d - Will send SIGTERM to parent in 5 seconds\n", getpid());
        sleep(5);
        printf("[Child 1] Sending SIGTERM to parent (PID: %d)\n", parent_pid);
        kill(parent_pid, SIGTERM);
        exit(0);
    }
    
    // Create second child - sends SIGINT after 10 seconds
    child2_pid = fork();
    
    if (child2_pid < 0) {
        perror("Fork failed for child 2");
        exit(1);
    } else if (child2_pid == 0) {
        // Child 2 process
        printf("[Child 2] PID: %d - Will send SIGINT to parent in 10 seconds\n", getpid());
        sleep(10);
        printf("[Child 2] Sending SIGINT to parent (PID: %d)\n", parent_pid);
        kill(parent_pid, SIGINT);
        exit(0);
    }
    
    printf("\n[Parent] Running indefinitely, waiting for signals...\n");
    printf("-----------------------------------------\n");
    
    int counter = 0;
    
    // Parent runs indefinitely until SIGINT is received
    while (keep_running) {
        sleep(1);
        counter++;
        printf("[Parent] Running... (%d seconds)\n", counter);
        
        if (sigterm_received && !sigint_received) {
            printf("[Parent] Continuing after SIGTERM (graceful mode)\n");
            sigterm_received = 0;  // Reset flag
        }
    }
    
    // Graceful shutdown
    printf("\n-----------------------------------------\n");
    printf("[Parent] Performing graceful shutdown...\n");
    
    // Wait for child processes
    int status;
    waitpid(child1_pid, &status, WNOHANG);
    waitpid(child2_pid, &status, WNOHANG);
    
    printf("[Parent] Cleanup complete.\n");
    printf("\n=========================================\n");
    printf("         GRACEFUL EXIT COMPLETE         \n");
    printf("=========================================\n");
    
    return 0;
}
