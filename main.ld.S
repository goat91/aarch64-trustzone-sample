ENTRY(reset)

SECTIONS {
	. = 0x0;
	.text : {
		reset.o (.text);
		monitor.o (monitor_vectors);
		context.o (.text);
		context_mgmt.o (.text);
	}

	flash_ns_sdata = .;
	. = 0x40000000;
	ram_ns_sdata = .;
	.nsecure_data : AT (flash_ns_sdata) {
		nsecure.o (.text);
		sub.o (.text);
		nsecure.o (.data);
	}
	ns_data_size = . - ram_ns_sdata		;

	ns_bss_start = .		;
	.nsecure_bss : {
		nsecure.o (.bss);
	}
	ns_bss_size = . - ns_bss_start ;
	ram_ns_end = .;

	flash_s_sdata = flash_ns_sdata + ram_ns_end - ram_ns_sdata; 	

	. = 0x50000000;
	ram_s_sdata = .;
	.secure_data : AT (flash_s_sdata) {
		secure.o (.text);
		add.o (.text);
		secure.o (.data);
	}
	s_data_size = . - ram_s_sdata;

	s_bss_start = .		;
	.secure_bss : {
		secure.o (.bss);
		context.o (.bss);
	}
	s_bss_size = . - s_bss_start;

	ns_sp_start = 0x50000000;
	s_sp_start = 0x60000000;
	runtime_sp = 0x80000000;
}
	














