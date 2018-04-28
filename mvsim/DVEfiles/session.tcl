# Begin_DVE_Session_Save_Info
# DVE full session
# Saved on Tue Nov 13 14:39:01 2012
# Designs open: 1
#   V1: /proj/bobcata_ver_user/vjs/user/mvsim/vcdplus.vpd
# Toplevel windows open: 2
# 	TopLevel.1
# 	TopLevel.2
#   Source.1: tb
#   Wave.1: 64 signals
#   Group count = 3
#   Group dut signal count = 25
#   Group pmu_i signal count = 20
#   Group ififo signal count = 19
# End_DVE_Session_Save_Info

# DVE version: G-2012.09
# DVE build date: Aug 24 2012 00:30:46


#<Session mode="Full" path="/proj/bobcata_ver_user/vjs/user/mvsim/DVEfiles/session.tcl" type="Debug">

gui_set_loading_session_type Post
gui_continuetime_set

# Close design
if { [gui_sim_state -check active] } {
    gui_sim_terminate
}
gui_close_db -all
gui_expr_clear_all

# Close all windows
gui_close_window -type Console
gui_close_window -type Wave
gui_close_window -type Source
gui_close_window -type Schematic
gui_close_window -type Data
gui_close_window -type DriverLoad
gui_close_window -type List
gui_close_window -type Memory
gui_close_window -type HSPane
gui_close_window -type DLPane
gui_close_window -type Assertion
gui_close_window -type CovHier
gui_close_window -type CoverageTable
gui_close_window -type CoverageMap
gui_close_window -type CovDetail
gui_close_window -type Local
gui_close_window -type Stack
gui_close_window -type Watch
gui_close_window -type Group
gui_close_window -type Transaction



# Application preferences
gui_set_pref_value -key app_default_font -value {Helvetica,10,-1,5,50,0,0,0,0,0}
gui_src_preferences -tabstop 8 -maxbits 24 -windownumber 1
#<WindowLayout>

# DVE Topleve session: 


# Create and position top-level windows :TopLevel.1

if {![gui_exist_window -window TopLevel.1]} {
    set TopLevel.1 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.1 TopLevel.1
}
gui_show_window -window ${TopLevel.1} -show_state minimized -rect {{5 22} {1505 723}}

# ToolBar settings
gui_set_toolbar_attributes -toolbar {TimeOperations} -dock_state top
gui_set_toolbar_attributes -toolbar {TimeOperations} -offset 0
gui_show_toolbar -toolbar {TimeOperations}
gui_set_toolbar_attributes -toolbar {&File} -dock_state top
gui_set_toolbar_attributes -toolbar {&File} -offset 0
gui_show_toolbar -toolbar {&File}
gui_set_toolbar_attributes -toolbar {&Edit} -dock_state top
gui_set_toolbar_attributes -toolbar {&Edit} -offset 0
gui_show_toolbar -toolbar {&Edit}
gui_set_toolbar_attributes -toolbar {Simulator} -dock_state top
gui_set_toolbar_attributes -toolbar {Simulator} -offset 0
gui_show_toolbar -toolbar {Simulator}
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -dock_state top
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -offset 0
gui_show_toolbar -toolbar {Interactive Rewind}
gui_set_toolbar_attributes -toolbar {Signal} -dock_state top
gui_set_toolbar_attributes -toolbar {Signal} -offset 0
gui_show_toolbar -toolbar {Signal}
gui_set_toolbar_attributes -toolbar {&Scope} -dock_state top
gui_set_toolbar_attributes -toolbar {&Scope} -offset 0
gui_show_toolbar -toolbar {&Scope}
gui_set_toolbar_attributes -toolbar {&Trace} -dock_state top
gui_set_toolbar_attributes -toolbar {&Trace} -offset 0
gui_show_toolbar -toolbar {&Trace}
gui_set_toolbar_attributes -toolbar {BackTrace} -dock_state top
gui_set_toolbar_attributes -toolbar {BackTrace} -offset 0
gui_show_toolbar -toolbar {BackTrace}
gui_set_toolbar_attributes -toolbar {Testbench} -dock_state top
gui_set_toolbar_attributes -toolbar {Testbench} -offset 0
gui_show_toolbar -toolbar {Testbench}
gui_set_toolbar_attributes -toolbar {&Window} -dock_state top
gui_set_toolbar_attributes -toolbar {&Window} -offset 0
gui_show_toolbar -toolbar {&Window}
gui_set_toolbar_attributes -toolbar {Zoom} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom} -offset 0
gui_show_toolbar -toolbar {Zoom}
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -offset 0
gui_show_toolbar -toolbar {Zoom And Pan History}
gui_set_toolbar_attributes -toolbar {Grid} -dock_state top
gui_set_toolbar_attributes -toolbar {Grid} -offset 0
gui_show_toolbar -toolbar {Grid}

# End ToolBar settings

# Docked window settings
set HSPane.1 [gui_create_window -type HSPane -parent ${TopLevel.1} -dock_state left -dock_on_new_line true -dock_extent 438]
catch { set Hier.1 [gui_share_window -id ${HSPane.1} -type Hier] }
catch { set Power.1 [gui_share_window -id ${HSPane.1} -type Power -silent] }
gui_set_window_pref_key -window ${HSPane.1} -key dock_width -value_type integer -value 438
gui_set_window_pref_key -window ${HSPane.1} -key dock_height -value_type integer -value -1
gui_set_window_pref_key -window ${HSPane.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${HSPane.1} {{left 0} {top 0} {width 437} {height 328} {dock_state left} {dock_on_new_line true} {child_hier_colhier 187} {child_hier_coltype 107} {child_hier_colpd 133} {child_hier_col1 0} {child_hier_col2 1} {child_hier_col3 2}}
set DLPane.1 [gui_create_window -type DLPane -parent ${TopLevel.1} -dock_state left -dock_on_new_line true -dock_extent 289]
catch { set Data.1 [gui_share_window -id ${DLPane.1} -type Data] }
gui_set_window_pref_key -window ${DLPane.1} -key dock_width -value_type integer -value 289
gui_set_window_pref_key -window ${DLPane.1} -key dock_height -value_type integer -value 328
gui_set_window_pref_key -window ${DLPane.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${DLPane.1} {{left 0} {top 0} {width 288} {height 328} {dock_state left} {dock_on_new_line true} {child_data_colvariable 203} {child_data_colvalue 10} {child_data_coltype 69} {child_data_col1 0} {child_data_col2 1} {child_data_col3 2}}
set Console.1 [gui_create_window -type Console -parent ${TopLevel.1} -dock_state bottom -dock_on_new_line true -dock_extent 267]
gui_set_window_pref_key -window ${Console.1} -key dock_width -value_type integer -value 1501
gui_set_window_pref_key -window ${Console.1} -key dock_height -value_type integer -value 267
gui_set_window_pref_key -window ${Console.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${Console.1} {{left 0} {top 0} {width 1500} {height 266} {dock_state bottom} {dock_on_new_line true}}
#### Start - Readjusting docked view's offset / size
set dockAreaList { top left right bottom }
foreach dockArea $dockAreaList {
  set viewList [gui_ekki_get_window_ids -active_parent -dock_area $dockArea]
  foreach view $viewList {
      if {[lsearch -exact [gui_get_window_pref_keys -window $view] dock_width] != -1} {
        set dockWidth [gui_get_window_pref_value -window $view -key dock_width]
        set dockHeight [gui_get_window_pref_value -window $view -key dock_height]
        set offset [gui_get_window_pref_value -window $view -key dock_offset]
        if { [string equal "top" $dockArea] || [string equal "bottom" $dockArea]} {
          gui_set_window_attributes -window $view -dock_offset $offset -width $dockWidth
        } else {
          gui_set_window_attributes -window $view -dock_offset $offset -height $dockHeight
        }
      }
  }
}
#### End - Readjusting docked view's offset / size
gui_sync_global -id ${TopLevel.1} -option true

# MDI window settings
set Source.1 [gui_create_window -type {Source}  -parent ${TopLevel.1}]
gui_show_window -window ${Source.1} -show_state maximized
gui_update_layout -id ${Source.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false}}

# End MDI window settings


# Create and position top-level windows :TopLevel.2

if {![gui_exist_window -window TopLevel.2]} {
    set TopLevel.2 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.2 TopLevel.2
}
gui_show_window -window ${TopLevel.2} -show_state normal -rect {{5 22} {1125 697}}

# ToolBar settings
gui_set_toolbar_attributes -toolbar {TimeOperations} -dock_state top
gui_set_toolbar_attributes -toolbar {TimeOperations} -offset 0
gui_show_toolbar -toolbar {TimeOperations}
gui_set_toolbar_attributes -toolbar {&File} -dock_state top
gui_set_toolbar_attributes -toolbar {&File} -offset 0
gui_show_toolbar -toolbar {&File}
gui_set_toolbar_attributes -toolbar {&Edit} -dock_state top
gui_set_toolbar_attributes -toolbar {&Edit} -offset 0
gui_show_toolbar -toolbar {&Edit}
gui_set_toolbar_attributes -toolbar {Simulator} -dock_state top
gui_set_toolbar_attributes -toolbar {Simulator} -offset 0
gui_show_toolbar -toolbar {Simulator}
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -dock_state top
gui_set_toolbar_attributes -toolbar {Interactive Rewind} -offset 0
gui_show_toolbar -toolbar {Interactive Rewind}
gui_set_toolbar_attributes -toolbar {Signal} -dock_state top
gui_set_toolbar_attributes -toolbar {Signal} -offset 0
gui_show_toolbar -toolbar {Signal}
gui_set_toolbar_attributes -toolbar {&Scope} -dock_state top
gui_set_toolbar_attributes -toolbar {&Scope} -offset 0
gui_show_toolbar -toolbar {&Scope}
gui_set_toolbar_attributes -toolbar {&Trace} -dock_state top
gui_set_toolbar_attributes -toolbar {&Trace} -offset 0
gui_show_toolbar -toolbar {&Trace}
gui_set_toolbar_attributes -toolbar {BackTrace} -dock_state top
gui_set_toolbar_attributes -toolbar {BackTrace} -offset 0
gui_show_toolbar -toolbar {BackTrace}
gui_set_toolbar_attributes -toolbar {Testbench} -dock_state top
gui_set_toolbar_attributes -toolbar {Testbench} -offset 0
gui_show_toolbar -toolbar {Testbench}
gui_set_toolbar_attributes -toolbar {&Window} -dock_state top
gui_set_toolbar_attributes -toolbar {&Window} -offset 0
gui_show_toolbar -toolbar {&Window}
gui_set_toolbar_attributes -toolbar {Zoom} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom} -offset 0
gui_show_toolbar -toolbar {Zoom}
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -offset 0
gui_show_toolbar -toolbar {Zoom And Pan History}
gui_set_toolbar_attributes -toolbar {Grid} -dock_state top
gui_set_toolbar_attributes -toolbar {Grid} -offset 0
gui_show_toolbar -toolbar {Grid}

# End ToolBar settings

# Docked window settings
gui_sync_global -id ${TopLevel.2} -option true

# MDI window settings
set Wave.1 [gui_create_window -type {Wave}  -parent ${TopLevel.2}]
gui_show_window -window ${Wave.1} -show_state maximized
gui_update_layout -id ${Wave.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 296} {child_wave_right 819} {child_wave_colname 195} {child_wave_colvalue 97} {child_wave_col1 0} {child_wave_col2 1}}

# End MDI window settings

gui_set_env TOPLEVELS::TARGET_FRAME(Source) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(Schematic) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(PathSchematic) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(Wave) none
gui_set_env TOPLEVELS::TARGET_FRAME(List) none
gui_set_env TOPLEVELS::TARGET_FRAME(Memory) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(DriverLoad) none
gui_update_statusbar_target_frame ${TopLevel.1}
gui_update_statusbar_target_frame ${TopLevel.2}

#</WindowLayout>

#<Database>

# DVE Open design session: 

if { ![gui_is_db_opened -db {/proj/bobcata_ver_user/vjs/user/mvsim/vcdplus.vpd}] } {
	gui_open_db -design V1 -file /proj/bobcata_ver_user/vjs/user/mvsim/vcdplus.vpd -nosource
}
gui_set_precision 1ns
gui_set_time_units 1ns
#</Database>

# DVE Global setting session: 


# Global: Bus

# Global: Expressions

# Global: Signal Time Shift

# Global: Signal Compare

# Global: Signal Groups
gui_load_child_values {tb.dut.ififo}


set _session_group_11 dut
gui_sg_create "$_session_group_11"
set dut "$_session_group_11"

gui_sg_addsignal -group "$_session_group_11" { tb.dut.VDDGS tb.dut.VDDG tb.dut.pwr_on tb.dut.pwr_down tb.dut.mvsim_flag tb.dut.odata tb.dut.VDD tb.dut.VSS tb.dut.exec_odata tb.dut.ofifo_rdy tb.dut.ofifo_pop tb.dut.exec_not_full tb.dut.exec_idle tb.dut.upf_simstate tb.dut.ififo_not_full tb.dut.dwidth tb.dut.exec_push tb.dut.exec_pop tb.dut.exec_rdy tb.dut.clk tb.dut.iso_enable tb.dut.idata tb.dut.exec_idata tb.dut.rst tb.dut.ififo_push }
gui_set_radix -radix {decimal} -signals {V1:tb.dut.dwidth}
gui_set_radix -radix {twosComplement} -signals {V1:tb.dut.dwidth}

set _session_group_12 pmu_i
gui_sg_create "$_session_group_12"
set pmu_i "$_session_group_12"

gui_sg_addsignal -group "$_session_group_12" { tb.dut.pmu_i.timer_cnt_rc tb.dut.pmu_i.pwr_down tb.dut.pmu_i.mvsim_flag tb.dut.pmu_i.init tb.dut.pmu_i.ififo_rdy tb.dut.pmu_i.pwr_down_wc tb.dut.pmu_i.exec_idle tb.dut.pmu_i.upf_simstate tb.dut.pmu_i.state tb.dut.pmu_i.pwroff tb.dut.pmu_i.clk tb.dut.pmu_i.iso_enable_wc tb.dut.pmu_i.iso_enable tb.dut.pmu_i.next_state tb.dut.pmu_i.begin_pwrdown tb.dut.pmu_i.start_cntdown tb.dut.pmu_i.iso_enable_rc tb.dut.pmu_i.timer_cnt_wc tb.dut.pmu_i.rst tb.dut.pmu_i.IDLE_LIMIT }
gui_set_radix -radix {decimal} -signals {V1:tb.dut.pmu_i.init}
gui_set_radix -radix {twosComplement} -signals {V1:tb.dut.pmu_i.init}
gui_set_radix -radix {decimal} -signals {V1:tb.dut.pmu_i.pwroff}
gui_set_radix -radix {twosComplement} -signals {V1:tb.dut.pmu_i.pwroff}
gui_set_radix -radix {decimal} -signals {V1:tb.dut.pmu_i.begin_pwrdown}
gui_set_radix -radix {twosComplement} -signals {V1:tb.dut.pmu_i.begin_pwrdown}
gui_set_radix -radix {decimal} -signals {V1:tb.dut.pmu_i.start_cntdown}
gui_set_radix -radix {twosComplement} -signals {V1:tb.dut.pmu_i.start_cntdown}
gui_set_radix -radix {decimal} -signals {V1:tb.dut.pmu_i.IDLE_LIMIT}
gui_set_radix -radix {twosComplement} -signals {V1:tb.dut.pmu_i.IDLE_LIMIT}

set _session_group_13 ififo
gui_sg_create "$_session_group_13"
set ififo "$_session_group_13"

gui_sg_addsignal -group "$_session_group_13" { tb.dut.ififo.cnt tb.dut.ififo.dout tb.dut.ififo.din tb.dut.ififo.rd_ptr tb.dut.ififo.reset tb.dut.ififo.rdy tb.dut.ififo.pop tb.dut.ififo.mvsim_flag tb.dut.ififo.size tb.dut.ififo.wr_ptr tb.dut.ififo.fmem tb.dut.ififo.swidth tb.dut.ififo.pwidth tb.dut.ififo.upf_simstate tb.dut.ififo.push tb.dut.ififo.dwidth tb.dut.ififo.clk tb.dut.ififo.not_full tb.dut.ififo.not_empty }
gui_set_radix -radix {decimal} -signals {V1:tb.dut.ififo.size}
gui_set_radix -radix {twosComplement} -signals {V1:tb.dut.ififo.size}
gui_set_radix -radix {decimal} -signals {V1:tb.dut.ififo.swidth}
gui_set_radix -radix {twosComplement} -signals {V1:tb.dut.ififo.swidth}
gui_set_radix -radix {decimal} -signals {V1:tb.dut.ififo.pwidth}
gui_set_radix -radix {twosComplement} -signals {V1:tb.dut.ififo.pwidth}
gui_set_radix -radix {decimal} -signals {V1:tb.dut.ififo.dwidth}
gui_set_radix -radix {twosComplement} -signals {V1:tb.dut.ififo.dwidth}

# Global: Highlighting

# Global: Stack
gui_change_stack_mode -mode list

# Post database loading setting...

# Restore C1 time
gui_set_time -C1_only 10265



# Save global setting...

# Wave/List view global setting
gui_list_create_group_when_add -wave -enable
gui_cov_show_value -switch false

# Close all empty TopLevel windows
foreach __top [gui_ekki_get_window_ids -type TopLevel] {
    if { [llength [gui_ekki_get_window_ids -parent $__top]] == 0} {
        gui_close_window -window $__top
    }
}
gui_set_loading_session_type noSession
# DVE View/pane content session: 


# Hier 'Hier.1'
gui_show_window -window ${Hier.1}
gui_list_set_filter -id ${Hier.1} -list { {Package 1} {All 0} {Process 1} {UnnamedProcess 1} {Function 1} {Block 1} {OVA Unit 1} {LeafScCell 1} {LeafVlgCell 1} {Interface 1} {PowSwitch 0} {LeafVhdCell 1} {$unit 1} {NamedBlock 1} {Task 1} {VlgPackage 1} {IsoCell 0} {ClassDef 1} }
gui_list_set_filter -id ${Hier.1} -text {*}
gui_hier_list_init -id ${Hier.1}
gui_change_design -id ${Hier.1} -design V1
catch {gui_list_expand -id ${Hier.1} tb}
catch {gui_list_expand -id ${Hier.1} tb.dut}
catch {gui_list_select -id ${Hier.1} {tb.dut.ififo}}
gui_view_scroll -id ${Hier.1} -vertical -set 0
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Power 'Power.1'
gui_list_set_filter -id ${Power.1} -list { {Retention Strategy 1} {Isolation Strategy 1} {All 1} {Level Shift Strategy 1} {Power Switch 1} }
gui_list_set_filter -id ${Power.1} -text {*}
gui_change_design -id ${Power.1} -design V1
catch {gui_list_expand -id ${Power.1} {<upf>.\tb/dut }}

# Data 'Data.1'
gui_list_set_filter -id ${Data.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {LowPower 1} {Parameter 1} {All 1} {Aggregate 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Data.1} -text {*}
gui_list_show_data -id ${Data.1} {tb.dut.ififo}
gui_view_scroll -id ${Data.1} -vertical -set 0
gui_view_scroll -id ${Data.1} -horizontal -set 0
gui_view_scroll -id ${Hier.1} -vertical -set 0
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Source 'Source.1'
gui_src_value_annotate -id ${Source.1} -switch false
gui_set_env TOGGLE::VALUEANNOTATE 0
gui_open_source -id ${Source.1}  -replace -active tb /proj/bobcata_ver_user/vjs/user/mvsim/tb.v
gui_view_scroll -id ${Source.1} -vertical -set 34
gui_src_set_reusable -id ${Source.1}

# View 'Wave.1'
gui_wv_sync -id ${Wave.1} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_set_ref -id ${Wave.1}  C1
gui_wv_zoom_timerange -id ${Wave.1} 0 554
gui_list_add_group -id ${Wave.1} -after {New Group} {dut}
gui_list_add_group -id ${Wave.1} -after {New Group} {pmu_i}
gui_list_add_group -id ${Wave.1} -after {New Group} {ififo}
gui_list_collapse -id ${Wave.1} dut
gui_list_collapse -id ${Wave.1} ififo
gui_seek_criteria -id ${Wave.1} {Any Edge}



gui_set_env TOGGLE::DEFAULT_WAVE_WINDOW ${Wave.1}
gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_list_set_filter -id ${Wave.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.1} -text {*}
gui_list_set_insertion_bar  -id ${Wave.1} -group ififo  -position in

gui_marker_move -id ${Wave.1} {C1} 10265
gui_view_scroll -id ${Wave.1} -vertical -set 25
gui_show_grid -id ${Wave.1} -enable false
# Restore toplevel window zorder
# The toplevel window could be closed if it has no view/pane
if {[gui_exist_window -window ${TopLevel.1}]} {
	gui_set_active_window -window ${TopLevel.1}
	gui_set_active_window -window ${Source.1}
	gui_set_active_window -window ${HSPane.1}
}
if {[gui_exist_window -window ${TopLevel.2}]} {
	gui_set_active_window -window ${TopLevel.2}
	gui_set_active_window -window ${Wave.1}
}
#</Session>

