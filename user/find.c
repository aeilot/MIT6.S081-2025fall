#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"
#include "kernel/param.h"

int m_argc = 0;
char* cmd;
char* m_argv[MAXARG];

char* fmtname(char* path) {
	char* p;
	for (p = path + strlen(path); p >= path && *p != '/'; p--);
	p++;
	return p;
}

void exc(char* path) {
	if (m_argc == 0) {
		printf("%s\n", path);
		return;
	}
	int p = fork();
	if (p == 0) {
		if (m_argc == MAXARG) {
			fprintf(2, "command too long\n");
			exit(1);
		}
		m_argv[m_argc] = path;
		m_argv[m_argc + 1] = 0;
		exec(cmd, m_argv);
	} else if (p > 0) {
		wait(0);
	} else {
		fprintf(2, "fork failed\n");
	}
}

int find(char* path, char* dst) {
	char buf[512], *p;
	int fd;
	struct dirent de;
	struct stat st;
	int code = -1;

	if ((fd = open(path, O_RDONLY)) < 0) {
		fprintf(2, "find: cannot open %s\n", path);
		return code;
	}

	if (fstat(fd, &st) < 0) {
		fprintf(2, "find: cannot stat %s\n", path);
		close(fd);
		return code;
	}

	if (strcmp(fmtname(path), dst) == 0) {
		exc(path);
		code = 0;
	}

	if (st.type != T_DIR) {
		close(fd);
		return code;
	}

	if (strlen(path) + 1 + DIRSIZ + 1 > sizeof buf) {
		printf("find: path too long\n");
		close(fd);
		return code;
	}

	strcpy(buf, path);
	p = buf + strlen(buf);
	*p++ = '/';

	while (read(fd, &de, sizeof(de)) == sizeof(de)) {
		if (de.inum == 0)
			continue;
		memmove(p, de.name, DIRSIZ);
		p[DIRSIZ] = 0;
		if (!strcmp(de.name, ".") || !strcmp(de.name, "..")) {
			continue;
		}

		if (stat(buf, &st) < 0) {
			continue;
		}

		if (st.type == T_DIR) {
			code = find(buf, dst);
		} else if (!strcmp(de.name, dst)) {
			exc(buf);
			code = 0;
		}
	}

	close(fd);
	return code;
}

int main(int argc, char* argv[]) {
	int code = -1;

	if (argc < 2) {
		fprintf(2, "Usage: find path filename\n");
		exit(1);
	}

	if (argc > 3) {
		if (argc < 5 || strcmp(argv[3], "-exec") != 0) {
			fprintf(2, "Usage: find path filename -exec cmd ...\n");
			exit(1);
		}
		m_argc = argc - 4;
		if (m_argc + 1 >= MAXARG) {
			fprintf(2, "find: too many exec arguments\n");
			exit(1);
		}

		cmd = argv[4];
		memcpy(m_argv, argv + 4, (argc - 4) * sizeof(char*));
		m_argv[m_argc + 1] = 0;
	}

	if (argc == 2)
		code = find(".", argv[1]);
	else
		code = find(argv[1], argv[2]);

	if (code == -1) {
		printf("Cannot find the target...\n");
	}

	exit(0);
}
