$(TEST_BUILD_DIR)/triangle_glx: tests/triangle_glx/triangle_glx.c $(LIBGL)
	$(CC) tests/triangle_glx/triangle_glx.c -Iinclude -o $(TEST_BUILD_DIR)/triangle_glx $(LINK_TEST)