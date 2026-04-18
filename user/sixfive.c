#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

void process_file(char* path) {
	int fd = open(path, O_RDONLY);
	if (fd < 0) {
		fprintf(2, "File Read Error\n");
		exit(-1);
	}
	char buf;
	const char* sep = " -\r\t\n./,";
	char flag = 1;
	char num_reads = 0;
	int num = 0;
	while (read(fd, &buf, 1) != 0) {
		if (strchr(sep, buf) != 0) {
			// Reading Numbers
			if (num_reads && flag) {
				if (num % 6 == 0 || num % 5 == 0) {
					fprintf(1, "%d\n", num);
				}
				num = 0;
			}
			num_reads = 0;
			flag = 1;  // get sep
		} else {
			if ('0' <= buf && buf <= '9') {
				num_reads = 1;
				num = num * 10 + buf - '0';
			} else {
				flag = 0;
			}
		}
	}
	if (flag && num_reads) {
		if (num % 6 == 0 || num % 5 == 0) {
			fprintf(1, "%d\n", num);
		}
	}
}

int main(int argc, char* argv[]) {
	if (argc < 2) {
		fprintf(2, "Usage: sixfive file...\n");
		exit(1);
	}
	for (int i = 1; i < argc; i++) {
		process_file(argv[i]);
	}
	exit(0);
}
