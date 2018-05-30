ENTRY(reset)

MEMORY {
	rom (rx) : org = 0x0, len = 16M
	secure_ram (rwx) : org = 0x40000000, len = 256M
	normal_ram (rwx) : org = 0x50000000, len = 256M
	runtime_ram (rwx) : org = 0x60000000, len = 512M
}

SECTIONS {
	.text : {
		reset.o (.text);
		monitor.o (monitor_vectors);
		context.o (.text);
		context_mgmt.o (.text);
	} > rom

	.nsecure_data : {
		nsecure.o (.text);
		sub.o (.text);
		nsecure.o (.data);
	} > normal_ram AT> rom
	flash_ns_sdata = LOADADDR(.nsecure_data);
	ram_ns_sdata = ADDR(.nsecure_data);
	ns_data_size = SIZEOF(.nsecure_data);

	.nsecure_bss : {
		nsecure.o (.bss);
	} > normal_ram AT> rom
	ns_bss_start = ADDR(.nsecure_bss);
	ns_bss_size = SIZEOF(.nsecure_bss);

	.secure_data : {
		secure.o (.text);
		add.o (.text);
		secure.o (.data);
	} > secure_ram AT> rom
	flash_s_sdata = LOADADDR(.secure_data);
	ram_s_sdata = ADDR(.secure_data);
	s_data_size = SIZEOF(.secure_data);

	.secure_bss : {
		secure.o (.bss);
		context.o (.bss);
	} > secure_ram AT> rom
	s_bss_start = ADDR(.secure_bss);
	s_bss_size = SIZEOF(.secure_bss);

	ns_sp_start = ORIGIN(normal_ram) + LENGTH(normal_ram);
	s_sp_start = ORIGIN(secure_ram) + LENGTH(secure_ram);
	runtime_sp = ORIGIN(runtime_ram) + LENGTH(runtime_ram);
}
