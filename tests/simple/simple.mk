$(TEST_BUILD_DIR)/simple: tests/simple/simple.c $(LIBGL)
	$(CC) tests/simple/simple.c -Iinclude -I/usr/X11/include -o $(TEST_BUILD_DIR)/simple $(LINK_TEST)