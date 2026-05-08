# MIT 6.S081 / 6.1810 xv6 Labs

Branch overview for my MIT 6.S081 / 6.1810 Operating System Engineering xv6 lab work.

## Branch Overview

| Branch | Status | Lab Area | Work Summary |
| --- | --- | --- | --- |
| [`util`](../../tree/util) | Done | Unix utilities | Added xv6 user programs including `sleep`, `sixfive`, `memdump`, and `find`; extended `find` with `-exec` behavior using `fork`, `exec`, and `wait`. |
| [`syscall`](../../tree/syscall) | Done | System calls | Added syscall plumbing across user stubs, syscall numbers, dispatch, and kernel handlers; explored syscall tracing/interposition and process-level kernel state. |
| [`pgtbl`](../../tree/pgtbl) | Done | Page tables | Implemented `USYSCALL`, `vmprint`, and superpage support across page-table and allocator code. |
| `traps` | Planned | Trap handling | Add user-level alarm handling with `sigalarm` / `sigreturn` and reason through RISC-V trap entry/return paths. |
| `cow` | Planned | Copy-on-write fork | Replace eager `fork` memory copying with COW mappings, write-fault handling, and physical-page reference counting. |
| `net` | Planned | Networking | Complete E1000 receive-path support and UDP delivery through `ip_rx`, `bind`, and `recv`. |
| `lock` | Planned | Kernel concurrency | Reduce lock contention in the memory allocator and block cache; add/readapt locking strategies for multicore execution. |
| `fs` | Planned | File system | Add large-file support and symbolic links in the xv6 file system. |
| `mmap` | Planned | Virtual memory / files | Add `mmap` and `munmap` with VMA tracking, lazy page faults, and file-backed memory mappings. |

## Technical Themes

- Kernel/user boundary: syscall declarations, user stubs, dispatch tables, and kernel handlers.
- Virtual memory: page-table traversal, PTE flags, user-visible shared pages, superpages, and fault-driven allocation.
- Process state: per-process metadata, trapframes, and address-space bookkeeping.
- File and device interfaces: xv6 user programs, directory traversal, file-backed memory, and network packet delivery.
- Concurrency: allocator and cache locking under multicore stress tests.

## How To Inspect

```sh
git clone https://github.com/aeilot/MIT6.S081-2025fall.git
cd MIT6.S081-2025fall
git checkout pgtbl
make qemu
```

Each lab branch contains the complete xv6 source tree for that assignment.

## References

- [MIT 6.1810 Fall 2025 lab list](https://pdos.csail.mit.edu/6.1810/2025/)
- [xv6, a simple Unix-like teaching operating system](https://pdos.csail.mit.edu/6.1810/2025/xv6.html)
- [xv6 lab source repository](git://g.csail.mit.edu/xv6-labs-2025)
