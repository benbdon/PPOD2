/*
 * sink.h: Header file for sink driver
 * Generated on: 10-Jul-2009 10:58:51
*/

#ifndef __SINK_H__
#define __SINK_H__

#ifndef MATLAB_MEX_FILE
#include "xpctarget.h"
#endif

void sinkStart(unsigned short int *isSoundOn, double *lastNote);
void sinkOutput(double *frequencyIn, double *resolution, unsigned short int *isSoundOn, double *lastNote);
void sinkTerminate(unsigned short int *isSoundOn);

#endif

/*
 * Mapping of mask variables to parameter arguments:
 *    P1   SParameter1   resolution
*/
