// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void kfree_init(void* pa);
void freerange(void* pa_start, void* pa_end);

extern char end[];  // first address after kernel.
                    // defined by kernel.ld.

struct run {
	struct run* next;
};

struct {
	struct spinlock lock;
	struct run* freelist;
} kmem;

#define PA2REFIDX(pa) (((uint64)(pa) - KERNBASE) / PGSIZE)
struct {
	struct spinlock lock;
	int refcnt[(PHYSTOP - KERNBASE) / PGSIZE];
} kmem_ref;

void kinit() {
	initlock(&kmem.lock, "kmem");
	initlock(&kmem_ref.lock, "kmem_ref");
	freerange(end, (void*)PHYSTOP);
}

void freerange(void* pa_start, void* pa_end) {
	char* p;
	p = (char*)PGROUNDUP((uint64)pa_start);
	for (; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
		kfree_init((void*)p);
}

void kref_inc(uint64 pa) {
	acquire(&kmem_ref.lock);
	kmem_ref.refcnt[PA2REFIDX(pa)]++;
	release(&kmem_ref.lock);
}

int kref_count(uint64 pa) {
	int n;
	acquire(&kmem_ref.lock);
	n = kmem_ref.refcnt[PA2REFIDX(pa)];
	release(&kmem_ref.lock);
	return n;
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void* pa) {
	struct run* r;

	if (((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
		panic("kfree");

	acquire(&kmem_ref.lock);
	if (kmem_ref.refcnt[PA2REFIDX(pa)] < 1) {
		release(&kmem_ref.lock);
		panic("kfree ref error");
	}

	kmem_ref.refcnt[PA2REFIDX(pa)]--;

	if (kmem_ref.refcnt[PA2REFIDX(pa)] > 0) {
		release(&kmem_ref.lock);
		return;
	}

	release(&kmem_ref.lock);

	// Fill with junk to catch dangling refs.
	memset(pa, 1, PGSIZE);

	r = (struct run*)pa;

	acquire(&kmem.lock);
	r->next = kmem.freelist;
	kmem.freelist = r;
	release(&kmem.lock);
}

// initializing the allocator
void kfree_init(void* pa) {
	struct run* r;

	if (((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
		panic("kfree");

	// Fill with junk to catch dangling refs.
	memset(pa, 1, PGSIZE);

	r = (struct run*)pa;

	acquire(&kmem.lock);
	r->next = kmem.freelist;
	kmem.freelist = r;
	release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void* kalloc(void) {
	struct run* r;

	acquire(&kmem.lock);
	r = kmem.freelist;
	if (r)
		kmem.freelist = r->next;
	release(&kmem.lock);

	if (r) {
		memset((char*)r, 5, PGSIZE);  // fill with junk

		acquire(&kmem_ref.lock);
		kmem_ref.refcnt[PA2REFIDX(r)] = 1;
		release(&kmem_ref.lock);
	}
	return (void*)r;
}
