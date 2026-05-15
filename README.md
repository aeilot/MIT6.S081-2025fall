# MIT 6.S081 / 6.1810 xv6 Labs

Progress tracker for my MIT 6.S081 / 6.1810 Operating System Engineering xv6 lab work.

`main` is the tracking branch. Completed lab work lives on the corresponding lab branch.

## Branch Overview

| Branch | Status | Updated | Lab Area | Work Summary |
| --- | --- | --- | --- | --- |
| [`util`](../../tree/util) | Done | 2026-04-20 | Unix utilities | Added xv6 user programs including `sleep`, `sixfive`, `memdump`, and `find`; extended `find` with `-exec` behavior using `fork`, `exec`, and `wait`. |
| [`syscall`](../../tree/syscall) | Done | 2026-05-06 | System calls | Added syscall plumbing across user stubs, syscall numbers, dispatch, and kernel handlers; explored syscall tracing/interposition and process-level kernel state. |
| [`pgtbl`](../../tree/pgtbl) | Done | 2026-05-08 | Page tables | Implemented `USYSCALL`, `vmprint`, and superpage support across page-table and allocator code. |
| [`traps`](../../tree/traps) | Done | 2026-05-13 | Trap handling | Implemented backtrace support and user-level alarm handling with `sigalarm` / `sigreturn` across trapframe and timer-interrupt paths. |
| [`cow`](../../tree/cow) | Done | 2026-05-15 | Copy-on-write fork | Replaced eager `fork` memory copying with shared COW mappings, write-fault page breaks, `copyout` COW handling, and physical-page reference counting. |
| `net` | Planned | Not started | Networking | Complete E1000 receive-path support and UDP delivery through `ip_rx`, `bind`, and `recv`. |
| `lock` | Planned | Not started | Kernel concurrency | Reduce lock contention in the memory allocator and block cache; add/readapt locking strategies for multicore execution. |
| `fs` | Planned | Not started | File system | Add large-file support and symbolic links in the xv6 file system. |
| `mmap` | Planned | Not started | Virtual memory / files | Add `mmap` and `munmap` with VMA tracking, lazy page faults, and file-backed memory mappings. |

## Progress Log

- 2026-05-15: Finished `cow`, including COW fork mappings, write-fault handling, `copyout` support, and physical-page reference counts.
- 2026-05-13: Finished `traps`, including backtrace and alarm handling.
- 2026-05-08: Finished `pgtbl`, including `USYSCALL`, `vmprint`, and superpages.
- 2026-05-06: Finished `syscall`, including syscall plumbing and tracing-related work.
- 2026-04-20: Finished `util`, including user utilities and `find -exec`.

## Technical Themes

- Kernel/user boundary: syscall declarations, user stubs, dispatch tables, and kernel handlers.
- Virtual memory: page-table traversal, PTE flags, user-visible shared pages, superpages, copy-on-write fork, and fault-driven allocation.
- Process state: per-process metadata, trapframes, and address-space bookkeeping.
- File and device interfaces: xv6 user programs, directory traversal, file-backed memory, and network packet delivery.
- Concurrency: allocator and cache locking under multicore stress tests.

## How To Inspect

```sh
git clone https://github.com/aeilot/MIT6.S081-2025fall.git
cd MIT6.S081-2025fall
git checkout cow
make qemu
```

Each completed lab branch contains the complete xv6 source tree for that assignment.

## References

- [MIT 6.1810 Fall 2025 lab list](https://pdos.csail.mit.edu/6.1810/2025/)
- [xv6, a simple Unix-like teaching operating system](https://pdos.csail.mit.edu/6.1810/2025/xv6.html)
- [xv6 lab source repository](git://g.csail.mit.edu/xv6-labs-2025)
