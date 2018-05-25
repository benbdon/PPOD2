#ifndef __mytemplate_XPCOPTIONS_H___
#define __mytemplate_XPCOPTIONS_H___
#include "simstruc_types.h"
#ifndef MT
#define MT                             0                         /* MT may be undefined by simstruc_types.h */
#endif

#include "mytemplate.h"
#define SIZEOF_PARAMS                  (-1 * (int)sizeof(Parameters_mytemplate))
#define SIMMODE                        0
#define LOGTET                         1
#define LOGBUFSIZE                     100000
#define IRQ_NO                         0
#define IO_IRQ                         0
#define WWW_ACCESS_LEVEL               0
#define CPUCLOCK                       0
#define MAXOVERLOAD                    0
#define MAXOVERLOADLEN                 0
#define XPCSTARTUPFLAG                 1

/* Change all stepsize using the newBaseRateStepSize */
void mytemplate_ChangeStepSize(real_T newBaseRateStepSize, rtModel_mytemplate
  *mytemplate_rtM)
{
  real_T ratio = newBaseRateStepSize / 0.0005;

  /* update non-zore stepsize of periodic
   * sample time. Stepsize of asynchronous
   * sample time is not changed in this function */
  mytemplate_rtM->Timing.stepSize0 = mytemplate_rtM->Timing.stepSize0 * ratio;
  mytemplate_rtM->Timing.stepSize = mytemplate_rtM->Timing.stepSize * ratio;
}

void XPCCALLCONV changeStepSize(real_T stepSize)
{
  /* Change all stepsize using the newBaseRateStepSize */
  mytemplate_ChangeStepSize(stepSize, mytemplate_rtM);
}

#endif                                 /* __mytemplate_XPCOPTIONS_H___ */
