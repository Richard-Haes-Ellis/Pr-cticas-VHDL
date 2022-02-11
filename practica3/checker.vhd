library IEEE;
use IEEE.std_logic_1164.all;
use work.protocol_common.all;

-- dL = R
-- d0 = 5
-- d1 = 3
-- d2 = 1
-- d3 = 9
-- d4 = 2
-- d5 = 7
-- d6 = 2
-- d7 = X

-- d0 5 mod 5 = 0 = anchura de 16 bits 
-- d1 3 impar = Enviamos primero menos significativos y terminando en los mas significativos
-- d2 1 impar = La señal ena activa a nivel alto 
-- d3 9 impar = Polaridades de las señales startp y endp == activas a nivel alto 
-- d3 9 ciclos de espera tras la activacion de ena que hay que esperar antes de activar startp 
-- d4 2 Ciclos, tras la activación de startp, que hay que esperar antes de dar valor al primer dato
-- d5*10 + d4 = 72: Duración, en ciclos, de cada dato
-- d6 2 Ciclos, a contar desde el fin del último ciclo del último dato, que hay que esperar antes de activar la señal endp
-- d6 + d5 = 2 + 7 = 9 Ciclos, tras la activación de la señal endp, que hay que esperar antes de deshabilitar ena
-- d5 + d4 = 7 + 2 = 9 Ciclos mínimos, tras la deshabilitación de ena, que hay que esperar antes de activar de nuevo ena si se quiere enviar una nueva transacción

entity checker is
  generic (N : integer := 16);

  port (
      generated_tran: in protocol_type;
    output_tran : in protocol_type;
    clk : in std_logic
  );

end checker;

architecture checker_arch of checker is
  -- Procedure to wait a number of clock cycles on FALLING EDGE  
  procedure wait_clock (constant numCycles : in integer) is
  begin
    for i in 1 to numCycles loop
      wait until falling_edge(clk);
    end loop;
  end procedure;

begin

  stim_process : process
  begin
    if generated_tran.valid = '1' and output_tran.valid = '1' then
        -- Maybe we shoudl store the generated value untill out is valid
        -- check and report
    else
      wait_clock(1);
    end if;

  end process;

end checker_arch;