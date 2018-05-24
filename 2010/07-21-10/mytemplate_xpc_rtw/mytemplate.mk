# Copyright 1996-2007 The MathWorks, Inc.
#
# File    : xpc_watc.tmf
#
# $Revision: $
# $Date: 2004/01/22 22:02:17 $
#
# Abstract:
#       Real-Time Workshop template makefile for building a WindowsNT-based
#       or Windows95-based stand-alone generic real-time version of Simulink
#       model using generated C code and the
#       Watcom C/C++ Compiler Versions 10.6, 11.0
#
#     On Windows95 systems, you must verify that your DOS applications
#       have enough environment space. It is suggested that the
#       environment space be set to the maximum of 4096.
#
#     The following defines (macro names) can be used to modify the behavior
#     of the build:
#         OPT_OPTS       - Optimization option. Default is -oabmilrt. To enable
#                          debugging specify as "OPT_OPTS=-d2".
#         OPTS           - User specific options.
#         USER_OBJS      - Additional user objects, such as files needed by
#                          S-functions.
#         USER_PATH      - The directory path to the source (.c) files which
#                          are used to create any .obj files specified in
#                          USER_OBJS. Multiple paths must be separated
#                          with a semicolon. For example:
#                          "USER_PATH=path1;path2"
#         USER_INCLUDES  - Additional include paths (i.e.
#                          "USER_INCLUDES=-Iinclude-path1 -Iinclude-path2")
#
#       In particular, note how the quotes are before the name of the macro
#       name.


#------------------------ Macros read by make_rtw -----------------------------
#
# The following macros are read by the Real-Time Workshop build procedure:
#       MAKECMD - This is the command used to invoke the make utility
#       HOST    - What platform this template makefile is targeted for
#                 (i.e. PC or UNIX)
#       BUILD   - Invoke make from the Real-Time Workshop build procedure
#                 (yes/no)?
#   TARGET  - Type of target Real-Time (RT) or Nonreal-Time (NRT)
#

MAKECMD         = "%WATCOM%\binnt\wmake"
SYS_TARGET_FILE = xpctarget.tlc
HOST            = PC
BUILD           = yes

#---------------------- Tokens expanded by make_rtw ---------------------------
#
# The following tokens, when wrapped with "|>" and "|<" are expanded by the
# Real-Time Workshop build procedure.
#
#  MODEL_NAME        - Name of the Simulink block diagram
#  MODEL_MODULES_OBJ - Object file name for any additional generated source
#                      modules
#  MAKEFILE_NAME     - Name of makefile created from template makefile
#                      <model>.mk
#  MATLAB_ROOT       - Path to were MATLAB is installed.
#  MATLAB_BIN        - Path to MATLAB executable.
#  S_FUNCTIONS_LIB   - List of S-functions libraries to link.
#  S_FUNCTIONS_OBJ   - List of S-functions .obj sources
#  NUMST             - Number of sample times
#  TID01EQ           - yes (1) or no (0): Are sampling rates of continuous
#                      task (tid=0) and 1st discrete task equal.
#  NCSTATES          - Number of continuous states
#  BUILDARGS         - Options passed in at the command line.
#  MULTITASKING      - yes (1) or no (0): Is solver mode multitasking
#  EXT_MODE          - yes (1) or no (0): Build for external mode

MODEL           = mytemplate
MODULES_OBJ     = mytemplate_capi.obj mytemplate_data.obj rt_logging.obj rt_logging_mmi.obj rt_matrx.obj rtw_modelmap_utils.obj 
MAKEFILE        = mytemplate.mk
MATLAB_ROOT     = C:\Program Files\MATLAB\R2008a
ALT_MATLAB_ROOT = C:\PROGRA~1\MATLAB\R2008a
MATLAB_BIN      = C:\Program Files\MATLAB\R2008a\bin
ALT_MATLAB_BIN  = C:\PROGRA~1\MATLAB\R2008a\bin
S_FUNCTIONS     = adcbpcidas1600.obj dacbpcidda0x12.obj
S_FUNCTIONS_LIB = 
NUMST           = 1
TID01EQ         = 0
NCSTATES        = 0
BUILDARGS       =  GENERATE_REPORT=0 EXT_MODE=1 MODELLIB=mytemplatelib.lib RELATIVE_PATH_TO_ANCHOR=.. MODELREF_TARGET_TYPE=NONE
MULTITASKING    = 0
EXT_MODE        = 0

#-- In the case when directory name contains space ---
!ifneq MATLAB_ROOT $(ALT_MATLAB_ROOT)
MATLAB_ROOT = $(ALT_MATLAB_ROOT)
!endif
!ifneq MATLAB_BIN $(ALT_MATLAB_BIN)
MATLAB_BIN = $(ALT_MATLAB_BIN)
!endif
#--------------------------------- Tool Locations -----------------------------
#
# Modify the following macro to reflect where you have installed
# the Watcom C/C++ Compiler.
#
!ifndef %WATCOM
!error WATCOM environmental variable must be defined
!else
WATCOM = $(%WATCOM)
!endif

#---------------------------- Tool Definitions ---------------------------

!include $(MATLAB_ROOT)\rtw\c\tools\watctools.mak

#-------------------------------- Include Path --------------------------------

MATLAB_INCLUDES = &
$(MATLAB_ROOT)\simulink\include;&
$(MATLAB_ROOT)\extern\include;&
$(MATLAB_ROOT)\rtw\c\src;&
$(MATLAB_ROOT)\rtw\c\src\ext_mode\common;

# Additional inludes
ADD_INCLUDES = &
C:\DOCUME~1\LIMS\Desktop\PPOD_6D\06-18-09\MYTEMP~1;&
C:\DOCUME~1\LIMS\Desktop\PPOD_6D\06-18-09;&
C:\DOCUME~1\LIMS\Desktop\ILYAMA~1;&
$(MATLAB_ROOT)\rtw\c\libsrc;&



COMPILER_INCLUDES = $(WATCOM)\h;$(WATCOM)\h\nt;

XPC_INCLUDES= $(MATLAB_ROOT)\toolbox\rtw\targets\xpc\target\build\include;$(MATLAB_ROOT)\toolbox\rtw\targets\xpc\target\build\xpcblocks\include;

INCLUDES = .;..;$(XPC_INCLUDES)$(MATLAB_INCLUDES)$(ADD_INCLUDES)$(COMPILER_INCLUDES)


#----------------------------------- C Flags ----------------------------------


REQ_OPTS = -of -w1 -bt=nt -mf -zq -s -3s -fpi87 -zp8 -ei

# Optimization Options.
#   -oaxt : maximum optimization
#   -d2   : debugging options
#
OPT_OPTS = -oabmilrt
DEFAULT_OPT_OPTS = -oabmilrt

CC_OPTS = $(REQ_OPTS) $(OPT_OPTS) $(OPTS)

CPP_REQ_DEFINES = -DMODEL=$(MODEL) -DRT -DNUMST=$(NUMST) &
                  -DTID01EQ=$(TID01EQ) -DNCSTATES=$(NCSTATES) &
                  -DMT=$(MULTITASKING) -DHAVESTDIO -DXPCCALLCONV=__cdecl &
                  -DUSE_RTMODEL -DERT_CORE

CFLAGS = $(CC_OPTS) $(CPP_REQ_DEFINES) $(USER_INCLUDES)
CPPFLAGS = $(CPP_OPTS) $(CC_OPTS) $(CPP_REQ_DEFINES) $(USER_INCLUDES)

ASFLAGS = -fpi87 -3s -zq


#-------------------------------- Source Files --------------------------------

REQ_OBJS   = $(MODEL).obj $(MODULES_OBJ) rt_nonfinite.obj xpctarget.obj

C_OBJS = $(REQ_OBJS) $(S_FCNS_OBJ) $(TIMER_OBJS) $(USER_OBJS)

OBJS = $(REQ_OBJS) $(USER_OBJS) $(S_FUNCTIONS)

#---------------------------- Additional Libraries ----------------------------

LIBS =


LIBS += $(S_FUNCTIONS_LIB) xpcruntime.lib

#-------------------------- Source Path ---------------------------------------

# User source path

!ifdef USER_PATH
EXTRA_PATH = ;$(USER_PATH)
!else
EXTRA_PATH =
!endif

# Additional sources

ADD_SOURCES = $(MATLAB_ROOT)\rtw\c\src;$(MATLAB_ROOT)\toolbox\rtw\targets\xpc\target\build\xpcblocks;

# Source Path

.c : ..;$(MATLAB_ROOT)\toolbox\rtw\targets\xpc\target\build\src;$(MATLAB_ROOT)\toolbox\rtw\targets\xpc\target\build\xpcblocks;$(MATLAB_ROOT)\toolbox\rtw\targets\xpc\target\build\xpcblocks\include;$(MATLAB_ROOT)\toolbox\rtw\targets\xpc\target\build\xpcblocks\thirdpartydrivers;$(MATLAB_ROOT)\rtw\c\src;$(MATLAB_ROOT)\simulink\src;$(ADD_SOURCES)$(EXTRA_PATH)
.cpp : ..;$(MATLAB_ROOT)\toolbox\rtw\targets\xpc\target\build\src;$(MATLAB_ROOT)\toolbox\rtw\targets\xpc\target\build\xpcblocks;$(MATLAB_ROOT)\toolbox\rtw\targets\xpc\target\build\xpcblocks\include;$(MATLAB_ROOT)\toolbox\rtw\targets\xpc\target\build\xpcblocks\thirdpartydrivers;$(MATLAB_ROOT)\rtw\c\src;$(MATLAB_ROOT)\simulink\src;$(ADD_SOURCES)$(EXTRA_PATH)


#----------------------- Exported Environment Variables -----------------------
#
#  Setup path for tools.
#
PATH = $(WATCOM)\binnt;$(WATCOM)\binw

#------------------------------ CAN LIBRARIES --------------------------------
!include xpcextralibs.mk

#------------------------------------ Rules -----------------------------------

BUILD_SUCCESS = xPC Target application created

.ERASE

.BEFORE
        @set path=$(PATH)
        @set INCLUDE=$(INCLUDES)
        @set WATCOM=$(WATCOM)
        @set MATLAB=$(MATLAB_ROOT)
        @if exist $(MODEL).lnk @del $(MODEL).lnk
        @if exist $(MODEL).dlm @del $(MODEL).dlm
        @echo name $(MODEL) >> $(MODEL).lnk
        @echo SYS nt_dll >> $(MODEL).lnk
        @echo exp getrlmdlinfo=_getrlmdlinfo,MdlStart=MdlStart,MdlTerminate=MdlTerminate,MdlOutputs=MdlOutputs,MdlUpdate=MdlUpdate,getDLMVersion=_getDLMVersion >> $(MODEL).lnk
        @echo Ref __DLLstart_ >> $(MODEL).lnk
        @echo OPTION ELIMINATE >> $(MODEL).lnk
        @echo DISABLE 1027 >> $(MODEL).lnk        
        @for %i in ($(OBJS)) do @echo FILE %i >> $(MODEL).lnk
        @echo LIBRARY $(WATCOM)\lib386\nt\clib3s.lib >> $(MODEL).lnk
	@for %i in ( $(LIBS)) do @echo LIBRARY %i >> $(MODEL).lnk
!ifdef CANAC2_C200
        @echo LIBRARY $(MATLAB_ROOT)\toolbox\rtw\targets\xpc\target\build\xpcblocks\lib\xpccanac2s_watc110.lib >> $(MODEL).lnk
!endif
!ifdef CANAC2_527
        @echo LIBRARY $(MATLAB_ROOT)\toolbox\rtw\targets\xpc\target\build\xpcblocks\lib\xpccanac2e_watc110.lib >> $(MODEL).lnk
!endif
!ifdef CANAC2_1000
        @echo LIBRARY $(MATLAB_ROOT)\toolbox\rtw\targets\xpc\target\build\xpcblocks\lib\xpccanac2pci_mb1_watc110.lib >> $(MODEL).lnk
        @echo LIBRARY $(MATLAB_ROOT)\toolbox\rtw\targets\xpc\target\build\xpcblocks\lib\xpccanac2pci_mb2_watc110.lib >> $(MODEL).lnk
        @echo LIBRARY $(MATLAB_ROOT)\toolbox\rtw\targets\xpc\target\build\xpcblocks\lib\xpccanac2pci_mb3_watc110.lib >> $(MODEL).lnk
!endif
!ifdef CANAC2_1000_MB
        @echo LIBRARY $(MATLAB_ROOT)\toolbox\rtw\targets\xpc\target\build\xpcblocks\lib\xpccanac2pci_mb1_watc110.lib >> $(MODEL).lnk
        @echo LIBRARY $(MATLAB_ROOT)\toolbox\rtw\targets\xpc\target\build\xpcblocks\lib\xpccanac2pci_mb2_watc110.lib >> $(MODEL).lnk
        @echo LIBRARY $(MATLAB_ROOT)\toolbox\rtw\targets\xpc\target\build\xpcblocks\lib\xpccanac2pci_mb3_watc110.lib >> $(MODEL).lnk
!endif
!ifdef CANAC2_104
        @echo LIBRARY $(MATLAB_ROOT)\toolbox\rtw\targets\xpc\target\build\xpcblocks\lib\xpccanac2104_mb1_watc110.lib >> $(MODEL).lnk
        @echo LIBRARY $(MATLAB_ROOT)\toolbox\rtw\targets\xpc\target\build\xpcblocks\lib\xpccanac2104_mb2_watc110.lib >> $(MODEL).lnk
        @echo LIBRARY $(MATLAB_ROOT)\toolbox\rtw\targets\xpc\target\build\xpcblocks\lib\xpccanac2104_mb3_watc110.lib >> $(MODEL).lnk
!endif


..\$(MODEL).dlm: $(MODEL).dll
        $(MATLAB_ROOT)\toolbox\rtw\targets\xpc\xpc\bin\mkusrdlm -c+ -q+ -g- $(MODEL).dll ..\$(MODEL)
        @echo $#$#$# xPC Target application created: $(MODEL).dlm

$(MODEL).dll: $(OBJS) $(LIBS)
        $(LD) $(LDFLAGS) @$(MODEL).lnk
        @del $(MODEL).lnk

.c.obj:
	@echo $#$#$# Compiling $[@
	$(CC) $(CFLAGS) $[@

.cpp.obj:
	@echo $#$#$# Compiling $[@
	$(CPP) $(CPPFLAGS) $[@

$(OBJS) : $(MAKEFILE) rtw_proj.tmw .AUTODEPEND

# Libraries:





xpcruntime.lib: xpcimports.obj xpcPCFunctions.obj
	@echo $#$#$# Creating $@
	@echo $#$#$# Running $(LIBCMD)
	$(LIBCMD) $@ $<

#------------------ Dependencies -----------------------------
$(OBJS) : $(MAKEFILE) rtw_proj.tmw

xpcPCFunctions.obj xpcimports.obj: $(MAKEFILE) rtw_proj.tmw

#EOF: xpc_watc.tmf
