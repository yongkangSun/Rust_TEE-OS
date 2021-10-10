.option norvc
.section .data

.section .text.init
.global _start
_start:
	# Any hardware threads (hart) that are not bootstrapping
	# need to wait for an IPI

    # control status register read (csrr)
	csrr	t0, mhartid
    # if t0 is not 0, park it (busy loop ?)
	bnez	t0, 3f

	# SATP should be zero, but let's make sure
    # supervisor address translation and protection (satp)
	csrw	satp, zero

    # control the MMU (Memory Management Unit)

.option push
.option norelax
	la		gp, _global_pointer

.option pop
    # The BSS section is expected to be zero
	la 		a0, _bss_start
	la		a1, _bss_end
	bgeu	a0, a1, 2f

1:
    # sd (store doubleword [64-bits])
	sd		zero, (a0)
	addi	a0, a0, 8
	bltu	a0, a1, 1b

2:	


3:
	wfi
	j	3b