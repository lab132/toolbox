DMD=@EZ_DMD@

OUTFILENAME=@DOUTFILENAME@

OUTPUT_LIB_DEBUG=@OUTPUT_LIB_DEBUG@
OUTPUT_LIB_RELEASE=@OUTPUT_LIB_RELEASE@
OUTPUT_LIB_MINSIZE=@OUTPUT_LIB_MINSIZE@
OUTPUT_LIB_RELWITHDEB=@OUTPUT_LIB_RELWITHDEB@

SRCS=@DFILES@
LIBS_DEBUG=@DLIBS_DEBUG@
LIBS_RELEASE=@DLIBS_RELEASE@
LIBS_MINSIZE=@DLIBS_MINSIZE@
LIBS_RELWITHDEB=@DLIBS_RELWITHDEB@

ARCH_FLAG=-m64
DFLAGS_GENERAL=-lib -L/NODEFAULTLIB:libcmt @DINCLUDE_DIRS_FMT@
DFLAGS_DEBUG=-gc -debug -op -defaultlib="druntime64ds.lib" -L/NODEFAULTLIB:msvcrt -Lmsvcrtd.lib
DFLAGS_RELEASE=-release -O -noboundscheck -defaultlib="druntime64s.lib" -Lmsvcrt.lib
DFLAGS_MINSIZE=-release -O -noboundscheck -defaultlib="druntime64s.lib" -Lmsvcrt.lib
DFLAGS_RELWITHDEB=-gc -release -op -O -noboundscheck -defaultlib="druntime64s.lib" -Lmsvcrt.lib

Debug: $(OUTPUT_LIB_DEBUG)/$(OUTFILENAME)
	
$(OUTPUT_LIB_DEBUG)/$(OUTFILENAME): $(SRCS) $(LIBS_DEBUG) @MAKEFILENAME@ 
	@echo Building Debug: $(OUTFILENAME)
	@$(DMD) $(ARCH_FLAG) $(DFLAGS_GENERAL) $(DFLAGS_DEBUG) $(SRCS) $(LIBS_DEBUG) -of"$(OUTPUT_LIB_DEBUG)/$(OUTFILENAME)"
@DPOST_BUILD_DEBUG_FMT@

Release: $(OUTPUT_LIB_RELEASE)/$(OUTFILENAME)
	
$(OUTPUT_LIB_RELEASE)/$(OUTFILENAME): $(SRCS) $(LIBS_RELEASE) @MAKEFILENAME@
	@echo Building Release: $(OUTFILENAME)
	@$(DMD) $(ARCH_FLAG) $(DFLAGS_GENERAL) $(DFLAGS_RELEASE) $(SRCS) $(LIBS_RELEASE) -of"$(OUTPUT_LIB_RELEASE)/$(OUTFILENAME)"
@DPOST_BUILD_RELEASE_FMT@

MinSizeRel: $(OUTPUT_LIB_MINSIZE)/$(OUTFILENAME)
	
$(OUTPUT_LIB_MINSIZE)/$(OUTFILENAME): $(SRCS) $(LIBS_MINSIZE) @MAKEFILENAME@ 
	@echo Building MinSizeRel: $(OUTFILENAME)
	@$(DMD) $(ARCH_FLAG) $(DFLAGS_GENERAL) $(DFLAGS_MINSIZE) $(SRCS) $(LIBS_MINSIZE) -of"$(OUTPUT_LIB_MINSIZE)/$(OUTFILENAME)"
@DPOST_BUILD_MINSIZE_FMT@

RelWithDebInfo: $(OUTPUT_LIB_RELWITHDEB)/$(OUTFILENAME) 
	
$(OUTPUT_LIB_RELWITHDEB)/$(OUTFILENAME): $(SRCS) $(LIBS_RELWITHDEB) @MAKEFILENAME@
	@echo Building RelWithDebInfo: $(OUTFILENAME)
	@$(DMD) $(ARCH_FLAG) $(DFLAGS_GENERAL) $(DFLAGS_RELWITHDEB) $(SRCS) $(LIBS_RELWITHDEB) -of"$(OUTPUT_LIB_RELWITHDEB)/$(OUTFILENAME)"
@DPOST_BUILD_RELWITHDEB_FMT@