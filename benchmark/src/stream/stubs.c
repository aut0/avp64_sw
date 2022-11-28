#include <sys/stat.h>
#include <sys/time.h>

#define UART0_ADDR 0x10009000
#define UART_DR(baseaddr) (*(unsigned int *)(baseaddr))

void exit(int status) {
	*((int*) 0x10008000) = 1; // stop the simulation using the simdev
}

char *heap_end = 0;
caddr_t _sbrk(int incr) {
	extern char heap_low; /* Defined by the linker */
	extern char heap_top; /* Defined by the linker */
	void *prev_heap_end;

	if (heap_end == 0) {
		heap_end = &heap_low;
	}
	prev_heap_end = heap_end;

	if (heap_end + incr > &heap_top) {
		/* Heap and stack collision */
		return (caddr_t)0;
	}

	heap_end += incr;
	return (caddr_t)prev_heap_end;
}

int _read(int file, char *ptr, int len) {
	return 0;
}

int _write(int file, char *ptr, int len) {
	for (int i = 0; i < len; i++) {
		UART_DR(UART0_ADDR) = *(ptr++);
	}
	return len;
}

int _open(const char *name, int flags, int mode) {
	return -1;
}

int _close(int file) {
	return 0;
}

int _lseek(int file, int ptr, int dir) {
	return 0;
}

int _fstat(int file, struct stat *st) {
 	st->st_mode = S_IFCHR;
	return 0;
}

int _isatty(int file) {
	return 1;
}

void initialise_monitor_handles(void) {
	return;
}

int _gettimeofday(struct timeval *tv, struct timezone *tz) {
  unsigned int usec = *((unsigned int*) 0x10008020);
  tv->tv_sec = usec / 1000000;
  tv->tv_usec = usec - tv->tv_sec * 1000000;
  return 0;
}
