#include "kernel/types.h"
#include "kernel/fcntl.h"
#include "user/user.h"
#include "kernel/riscv.h"

#define DATASIZE (2 * 2048)
#define ATTEMPT 32

int main(int argc, char* argv[]) {
	// Your code here.
	for (int x = 0; x < ATTEMPT; x++) {
		char* p = sbrk(DATASIZE);
		char t = p[0];
		p[0] = 0;
		p[0] = t;
		char target[] = "This may help.";
		int l = strlen(target);
		for (int i = 0; i < DATASIZE - l; i++) {
			if (p[i] != 'T') continue;
			int ok = 1;
			for (int j = 0; j < l; j++) {
				if (p[i + j] != target[j]) {
					ok = 0;
					break;
				}
			}
			if (ok == 1) {
				printf("%s\n", p + i + 16);
				exit(0);
			}
		}
	}
	exit(1);
}
