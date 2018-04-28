/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

class GenPerfCallbacks extends Packet_atomic_gen_callbacks;

  Environment  my_env;
  int start_time, end_time;
  int tenure_id, initiator_id, target_id,trans;

  function new(Environment env);
    this.my_env = env;
  endfunction

  virtual task post_inst_gen(Packet_atomic_gen gen, Packet obj, ref bit drop);
    fork
     begin
      vmm_perf_tenure tenure = new(gen.stream_id,,obj);
      obj.notify.wait_for(vmm_data::STARTED);
      this.my_env.tr_perf.start_tenure(tenure);
      obj.notify.wait_for(vmm_data::ENDED);
      this.my_env.tr_perf.end_tenure(tenure);
     end
    join_none
  endtask

endclass
