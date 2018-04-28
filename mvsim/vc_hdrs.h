
#include "svdpi.h"

#ifdef __cplusplus
extern "C" {
#endif

#ifndef _VC_TYPES_
#define _VC_TYPES_
/* common definitions shared with DirectC.h */

typedef unsigned int U;
typedef unsigned char UB;
typedef unsigned char scalar;
typedef struct { U c; U d;} vec32;

#define scalar_0 0
#define scalar_1 1
#define scalar_z 2
#define scalar_x 3

extern long long int ConvUP2LLI(U* a);
extern void ConvLLI2UP(long long int a1, U* a2);
extern long long int GetLLIresult();
extern void StoreLLIresult(const unsigned int* data);
typedef struct VeriC_Descriptor *vc_handle;

#ifndef SV_3_COMPATIBILITY
#define SV_STRING const char*
#else
#define SV_STRING char*
#endif

#endif /* _VC_TYPES_ */


 extern unsigned char supply_on(const char* pad_name, double value);

 extern unsigned char supply_off(const char* pad_name);

 extern unsigned char supply_partial_on(const char* pad_name, double value);

 extern void upf_get_supply_pad(const char* pad_name, /* OUTPUT */svBitVecVal *value);

 extern unsigned char set_supply_set_state(const char* supply_set_name, const char* power_state_name);

 extern void set_lp_msg_severity(const char* msgIds, const char* sev);

 extern void set_lp_msg_onoff(const char* msgIds, const char* value);

 extern void set_lp_msg_log_severity(const char* sev);

 extern void lp_msg_register(const char* msgId, const char* severity, const char* onOff, const char* msgText);

 extern void lp_msg_print(const char* msgId, const char* text);

 extern SV_STRING lp_msg_get_format(const char* msgId);

 extern unsigned char lp_msg_is_enabled(const char* msgId);

 extern void upf_update_retention(const svLogicVecVal *ret_index, const svBitVecVal *st, int save, int restore);

 extern void upf_update_isolation(const svLogicVecVal *iso_index, unsigned char isolation_power, unsigned char isolation_signal);

 extern void upf_update_power_domain_state(const svLogicVecVal *id, int upf_simstate, const svBitVecVal *power, const svBitVecVal *ground);

 extern void upf_initialize_design_config(/* OUTPUT */svBitVecVal *config, /* OUTPUT */unsigned char *initialized);

 extern void UpfGetPowerDomainName(/* OUTPUT */SV_STRING *name);

 extern void UpfGetFileLineNo(/* OUTPUT */SV_STRING *name, /* OUTPUT */int *lineno, int did);

 extern void UpfGetParentInstanceName(/* OUTPUT */SV_STRING *instName);

 extern void UpfGetRetentionPolicy(/* OUTPUT */SV_STRING *name, int id);

 extern void upf_initialize_switch_delay(int id, /* OUTPUT */int *switchDelay, /* OUTPUT */int *onDelay);

 extern void upf_update_supply(/* OUTPUT */int *id, /* OUTPUT */svBitVecVal *value);

 extern void upf_update_supply_net(int id, const svBitVecVal *value);

 extern void upf_update_supply_set(int id, int simstate, const svBitVecVal *power, const svBitVecVal *ground);

 extern void upf_update_explicit_supply_set(/* OUTPUT */int *id, /* OUTPUT */int *simstate, /* OUTPUT */svBitVecVal *power, /* OUTPUT */svBitVecVal *ground);

 extern void upf_update_implicit_supply_set(/* OUTPUT */int *id, /* OUTPUT */int *simstate, /* OUTPUT */svBitVecVal *power, /* OUTPUT */svBitVecVal *ground, /* OUTPUT */int *pwr_state_task_bit_id);

 extern void lpMsgPrint(int msgId, const char* text);

 extern void lpMsgReport(int msgId);

 extern void lpMsgReport1(int msgId, const char* str1);

 extern void lpMsgReport2(int msgId, const char* str1, const char* str2);

 extern void lpMsgReport3(int msgId, const char* str1, const char* str2, const char* str3);

 extern void lpMsgReport4(int msgId, const char* str1, const char* str2, const char* str3, const char* str4);

 extern void lpMsgReport5(int msgId, const char* str1, const char* str2, const char* str3, const char* str4, const char* str5);

 extern void lpMsgReport6(int msgId, const char* str1, const char* str2, const char* str3, const char* str4, const char* str5, const char* str6);

 extern void lpMsgReport7(int msgId, const char* str1, const char* str2, const char* str3, const char* str4, const char* str5, const char* str6, const char* str7);

 extern void lpMsgReport8(int msgId, const char* str1, const char* str2, const char* str3, const char* str4, const char* str5, const char* str6, const char* str7, const char* str8);

 extern void upf_call_power_down_block(const svLogicVecVal *id, int upf_simstate);

 extern SV_STRING lp_getenv(const char* str);

 extern int lp_stat(const char* str);

#ifdef __cplusplus
}
#endif

