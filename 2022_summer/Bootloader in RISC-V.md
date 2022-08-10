Bootloader in RISC-V
从bios中得到 mhartid in a0, dtb addr in a1， call init_first_hart() //mentry.S
根据dtb，调用qeury_uart16660()获得 uart 硬件信息 //minit.c
hart_init()进一步调用 mstatus_init(), fp_init(), delegate_traps() 完成初步硬件初始化 //minit.c
mstatus_init: Enable software interrupts, Disable paging
delegate_traps: send S-mode interrupts and most exceptions straight to S-mode
IRQ包括：IRQ_S_SOFT ，IRQ_S_TIMER， IRQ_S_EXT
Execption包括：MISALIGNED_FETCH，FETCH_PAGE_FAULT，BREAKPOINT，
LOAD/STORE_PAGE_FAULT，USER_ECALL
hls_init(0)：好像是对multi core的自己core做一些准备
qeury_mem(dtb)：获得内存配置 base=0x80000000 size=128MB
query_harts(dtb):查询其他cpu core
query_clint(dtb):查询local interrupt CLINT：Core Local Interruptor
query_plic(dtb): 查询平台级的中断控制器 PLIC:Platform Level Interrupt Controller
wake_harts(): 唤醒其他cpu cores
plic_init, hart_plic_init, 初始化平台级的中断控制器
memory_init(): 设置mem_size，保证页对齐。
boot_loader(dtb) : call enter_supervisor_mode(entry, hartid, dtb_output()); 跳到kernel处执行 //bbl.c
enter_supervisor_mode: 设置PMP，设置 mstatus的MPP为PRV_S， MPIE为0, mscratch= MACHINE_STACK_TOP() - MENTRY_FRAME_SIZE, mepc=kernel entry, a0= hartid, a1=dtb addr 输出位置 在payload_end的后面的4MB页对齐处，为返回S mode做好设置, 执行 mret，返回到PRV态的kernel 入口处 //minit.c