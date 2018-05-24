set WATCOM=C:\WATCOM
cd .
"%WATCOM%\binnt\wmake" -f template.mk  GENERATE_REPORT=0 EXT_MODE=1 MODELLIB=templatelib.lib RELATIVE_PATH_TO_ANCHOR=.. MODELREF_TARGET_TYPE=NONE WATCOM_VER=1.3
@if errorlevel 1 goto error_exit
exit /B 0

:error_exit
echo The make command returned an error of %errorlevel%
An_error_occurred_during_the_call_to_make
