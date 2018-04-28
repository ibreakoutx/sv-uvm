/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

localparam int bitmax=31;
typedef logic [bitmax:0] data_type;

interface fifo_intf (input bit clk);
  data_type w_data;  // data being pushed into the stack
  data_type r_data;   // data being popped out of the stack
  logic resetn;           
  logic [3:0] stack_ptr; // Pointer to the next write location in the stack 
  

  logic fifo_empty, fifo_full;

  /*****************************************************************************
   * Data Queue
   ****************************************************************************/
  data_type QUEUE[$];

  /*****************************************************************************
   * Methods to write into and read from the FIFO
   ****************************************************************************/
  function void write(input data_type write_data);
    if(!fifo_full)
    begin
       stack_ptr++;
       w_data = write_data;
       QUEUE.push_back(w_data);
    end   
    else
      $display("fifo is full - unable to write");
  endfunction:write

  function void read(output data_type read_data);
    if(!fifo_empty)
    begin
       r_data = QUEUE.pop_front();
       stack_ptr--; 
       read_data = r_data;
    end  
    else 
      $display("fifo is empty - unable to read");
  endfunction:read

  /*****************************************************************************
   * Reset task()
   ****************************************************************************/
  task reset();
    resetn <= 0;
    fifo_empty <= 1;
    fifo_full  <= 0;
    stack_ptr  <= 0;
    repeat(2)
      @(posedge clk)
    resetn <=1;
  endtask:reset

  /******************************************************************************
   * Clock Synchronization Logic
   *****************************************************************************/
  always @(posedge clk, negedge resetn)
  begin
    if(!resetn) 
    begin
      stack_ptr <= 0;
    end
  end

  always @(posedge clk)
  begin
    if(QUEUE.size > 0)
      fifo_empty <= 0;
  
    if(QUEUE.size == 8)  // FIFO size set to 8
      fifo_full <= 1; 
  end
endinterface
