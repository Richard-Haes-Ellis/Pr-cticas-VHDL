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

entity driver is
  generic (
    N : integer := 16 -- d0 mod 5 = 0 -> N = 16
  );
  port (
    input_tran : in protocol_type;
    clk : in std_logic;
    data : out std_logic_vector(N - 1 downto 0) := (others => '0');
    ena : out std_logic := '0';
    startp : out std_logic := '0';
    endp : out std_logic := '0'
  );
end driver;

architecture driver_arch of driver is

  --signal clk_period : time := 10 ns;
  --signal endsim : boolean := false;

  -- Procedure to wait a number of clock cycles 
  procedure wait_clock (constant numCycles : in integer) is
  begin
    for i in 1 to numCycles loop
      wait until rising_edge(clk);
    end loop;
  end procedure;

begin

  stim_process : process
  begin
    if input_tran.valid = '1' then
      ena <= '1';     -- d2 = 1 -> activa a nivel alto
      wait_clock(9);  -- d3 = 9 -> ciclos de espera tras la activacion de ena que hay que esperar antes de activar startp
      startp <= '1';  -- d3 = 9 -> activa a nivel alto
      wait_clock(1);
      startp <= '0';
      wait_clock(1);
      data <= input_tran.data(N - 1 downto 0); -- d1 = 3 -> LSB first
      wait_clock(72);                          -- d5*10 + d4 = 72 -> duración, en ciclos, de cada dato
      data <= input_tran.data(31 downto N);    -- d1 = 3 -> MSB last
      wait_clock(72);
      data <= (others => 'Z'); -- Set output to high impedance
      wait_clock(2);    -- d6 2 Ciclos, a contar desde el fin del último ciclo del último dato, que hay que esperar antes de activar la señal endp
      endp <= '1';      -- d3 = 9 -> activa a nivel alto
      wait_clock(1);
      endp <= '0';
      wait_clock(9);  -- d6 + d5 = 2 + 7 = 9 Ciclos, tras la activación de la señal endp, que hay que esperar antes de deshabilitar ena
      ena <= '0';     -- d3 = 9 -> desactiva a nivel alto
      wait_clock(9);  -- d5 + d4 = 7 + 2 = 9 Ciclos mínimos, tras la deshabilitación de ena, que hay que esperar antes de activar de nuevo ena si se quiere enviar una nueva transacción
    else 
      -- Esencialmente esperamis hacta el proximo ciclo del clock 
      wait_clock(1);  
    end if;

    end process;
end driver_arch;