//Este archivo sera el testbench de ejercicio1.sv 

`timescale 1ns/1ps

module tb_control_de_leds_switch_botones;

  // Señales del DUT
  logic [15:0] sw;
  logic [3:0]  btn;
  logic [15:0] led;

  // Instancia del DUT
  control_de_leds_switch_botones dut (
    .sw  (sw),
    .btn (btn),
    .led (led)
  );

  // --- Utilidades de verificación ---

  // Función de referencia: calcula lo que debería salir en 'led'
  function automatic logic [15:0] modelo_esperado(logic [15:0] sw_i, logic [3:0] btn_i);
    logic [15:0] out;
    // Grupo 0: [3:0]
    out[3:0]    = (btn_i[0]) ? 4'b0000 : sw_i[3:0];
    // Grupo 1: [7:4]
    out[7:4]    = (btn_i[1]) ? 4'b0000 : sw_i[7:4];
    // Grupo 2: [11:8]
    out[11:8]   = (btn_i[2]) ? 4'b0000 : sw_i[11:8];
    // Grupo 3: [15:12]
    out[15:12]  = (btn_i[3]) ? 4'b0000 : sw_i[15:12];
    return out;
  endfunction

  // Tarea: aplicar entradas, esperar asentamiento, y chequear
  task automatic drive_and_check(input logic [15:0] sw_i, input logic [3:0] btn_i, string etiqueta);
    logic [15:0] exp;
    
    sw  = sw_i;
    btn = btn_i;
    #1; // pequeño delay para propagación combinacional

    exp = modelo_esperado(sw_i, btn_i);

    // Mensaje informativo
    $display("[%0t] %s  sw=%h  btn=%b  led=%h  exp=%h",
             $time, etiqueta, sw, btn, led, exp);

    // Auto-verificación
    if (led === exp) begin
      $display("PASS: LED == ESPERADO");
    end else begin
      $error("FALLO: LED != ESPERADO. sw=%h btn=%b led=%h exp=%h", sw, btn, led, exp);
      $fatal(1);
    end
  endtask

  // --- Estímulos ---

  initial begin
    // VCD para GTKWave (Icarus/Verilator)
    $dumpfile("tb_control_de_leds_switch_botones.vcd");
    $dumpvars(0, tb_control_de_leds_switch_botones);

    // Valores iniciales
    sw  = '0;
    btn = '0;
    #1;

    // 1) Pruebas básicas
    drive_and_check(16'h0000, 4'b0000, "BASIC: todo en 0");
    drive_and_check(16'hFFFF, 4'b0000, "BASIC: switches en 1, sin botones");
    drive_and_check(16'hA5A5, 4'b0000, "BASIC: patrón mixto, sin botones");

    // 2) Un botón a la vez (cada grupo apagado por su botón)
    drive_and_check(16'hFFFF, 4'b0001, "BTN0: apaga [3:0]");
    drive_and_check(16'hFFFF, 4'b0010, "BTN1: apaga [7:4]");
    drive_and_check(16'hFFFF, 4'b0100, "BTN2: apaga [11:8]");
    drive_and_check(16'hFFFF, 4'b1000, "BTN3: apaga [15:12]");

    // 3) Combinaciones de botones
    drive_and_check(16'hF0F0, 4'b0011, "BTN0+BTN1: apagan [7:0] por grupos");
    drive_and_check(16'h0FF0, 4'b1100, "BTN2+BTN3: apagan [15:8] por grupos");
    drive_and_check(16'h1234, 4'b1010, "BTN1 y BTN3: apagan grupos 1 y 3");

    // 4) Barrido por grupos con varios patrones de switches
    drive_and_check(16'h000F, 4'b0001, "SW=000F, BTN0");
    drive_and_check(16'h00F0, 4'b0010, "SW=00F0, BTN1");
    drive_and_check(16'h0F00, 4'b0100, "SW=0F00, BTN2");
    drive_and_check(16'hF000, 4'b1000, "SW=F000, BTN3");

    // 5) Aleatorio con auto-check (20 casos)
    repeat (20) begin
      logic [15:0] sw_r;
      logic [3:0]  btn_r;
      sw_r = $urandom;
      btn_r = $urandom;
      drive_and_check(sw_r, btn_r, "RANDOM");
    end

    $display("==> Todas las pruebas PASARON ");
    #5;
    $finish;
  end

endmodule