# io2io_virtual.xdc  (10 MHz ⇒ 100 ns de presupuesto)
create_clock -name VCLK -period 100.000

# Exigir que el camino combinacional completo A/B/CIN → SUM/COUT
# sea menor a 100 ns, sin depender de relojes físicos
set_max_delay -datapath_only 100.000 \
  -from [get_ports {a[*] b[*] cin}] \
  -to   [get_ports {sum[*] cout}]
