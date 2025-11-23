#pragma once

#ifdef __cplusplus
extern "C" {
#endif

void custcustapp_start(int argc, char** argv);
void custcustapp_showhelp();
void custcustapp_deinitialize();
char* custcustapp_get_opt_arg();
int custcustapp_get_opt_ind();

#ifdef __cplusplus
}
#endif
