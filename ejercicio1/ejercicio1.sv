module control_de_leds_switch_botones(
    input  logic [15:0] sw,    // SW15..SW0 switch (activos en alto)
    input  logic [3:0]  btn,   // 4 botones (activos en alto)
    output logic [15:0] led    // LED15..LED0 (activos en alto)
);
    // Grupo 0: [3:0]   controlado por el boton[0]
    // Grupo 1: [7:4]   controlado por el boton[1]
    // Grupo 2: [11:8]  controlado por el boton[2]
    // Grupo 3: [15:12] controlado por el boton[3]

    always @(*) begin
        // always @(*) se asegura que sea combinacional
        
        led[3:0]    = (btn[0]) ? 4'b0000 : sw[3:0];   // si el boton = 1 entonces los leds del 0 al 3 pasan a 0 y se apagan,
        led[7:4]    = (btn[1]) ? 4'b0000 : sw[7:4];   // si no copia lo que dice el switch
        led[11:8]   = (btn[2]) ? 4'b0000 : sw[11:8];
        led[15:12]  = (btn[3]) ? 4'b0000 : sw[15:12];
    end
endmodule
