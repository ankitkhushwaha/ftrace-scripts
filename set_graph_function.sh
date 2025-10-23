#!/bin/sh


DIR2=/proc/sys/kernel/
cd $DIR2

for f in softlockup_panic softlockup_all_cpu_backtrace soft_watchdog panic_on_rcu_stall panic_on_oops panic_on_io_nmi oops_all_cpu_backtrace hung_task_all_cpu_backtrace hung_task_panic hardlockup_panic hardlockup_all_cpu_backtrace ftrace_enabled ftrace_dump_on_oops ; do
echo 1 > $f || echo $f failed to chnages;
done 

DIR=/sys/kernel/tracing
cd $DIR
# Presetup if any
# ./prepare.sh

# Disable tracing and clear trace
echo 0 > tracing_on
echo > trace
echo > set_ftrace_filter
echo > set_graph_function

# Setup tracer type
echo function_graph > current_tracer

cd options

for f in funcgraph-abstime funcgraph-cpu funcgraph-duration funcgraph-irqs funcgraph-overhead funcgraph-proc latency-format; do
	echo 1 > $f;
done

cd ..


#echo __do_page_fault >> set_graph_function
#echo handle_mm_fault >> set_graph_function

# cgroup-related
#echo mem_cgroup_try_charge_delay >> set_graph_function
#echo mem_cgroup_commit_charge >> set_graph_function

#echo alloc_workqueue >> set_graph_function

sh -c 'echo process pid $$; ~/strace -f ~/r; kill -STOP $$; echo $$ > set_ftrace_pid; echo $$ > set_event_pid; echo 1 > tracing_on; kill -CONT $$'

echo "Enabled graph functions:"
#cat set_graph_function

#echo 1 > tracing_on
