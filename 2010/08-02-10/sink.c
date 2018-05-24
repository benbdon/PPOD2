/*
 * sink.c: C Source stub file for sink driver
 * Generated on: 10-Jul-2009 10:58:51
*/

#include "sink.h"

void sinkStart(unsigned short int *isSoundOn, double *lastNote)
{
#ifndef MATLAB_MEX_FILE
// Place driver code to run on the target at model start/stop here (see xpcIsModelInit)
#endif
}

void sinkOutput(double *frequencyIn, double *resolution, unsigned short int *isSoundOn, double *lastNote)
{
#ifndef MATLAB_MEX_FILE
// Place driver code to run on the target during model execution here
#endif
}

void sinkTerminate(unsigned short int *isSoundOn)
{
#ifndef MATLAB_MEX_FILE
// Place driver code to run on the target at model start/stop here
#endif
}

