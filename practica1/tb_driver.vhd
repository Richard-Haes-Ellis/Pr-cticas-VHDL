library IEEE;
use IEEE.std_logic_1164.all;
use work.protocol_common.all;

entity tb_driver is
  generic( N : integer := 16); -- d0 mod 5 = 0 -> N = 16
end tb_driver;

architecture tb_driver_arch of tb_driver is

  -- Declaramos el dirver como componente
  component driver is
    port (
      input_tran    : in protocol_type;
      clk           : in  std_logic;
      data          : out std_logic_vector(N-1 downto 0);
      ena           : out std_logic;
      startp        : out std_logic;
      endp          : out std_logic
    );
  end component;

  -- Declaramos los signals que necesitamos para conectar
  signal clk: std_logic := '0';
  signal input_tran : protocol_type;
  signal data : std_logic_vector(N-1 downto 0);
  signal ena : std_logic;
  signal startp : std_logic;
  signal endp : std_logic;


  -- Control de la simulacion
  constant clk_period : time := 10 ns;

  signal endsim : boolean := false;

begin

  -- Instanciamos leds
  driver_inst: driver
  port map (
    input_tran => input_tran,
    clk => clk,
    data => data,
    ena => ena,
    startp => startp,
    endp => endp
  );

  -- Generación de reloj
  clk_process : process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
    if endsim=true then
      wait;
    end if;
  end process;

  -- Proceso de estimulos
  stim_process : process
  begin
    input_tran.valid <= '0';
	  input_tran.data(31 downto 24) <= "01101001";
    input_tran.data(23 downto 16) <= "01101001";
    input_tran.data(15 downto 8)  <= "10010110";
    input_tran.data(7 downto 0)   <= "10010110";
    wait for clk_period;
    input_tran.valid <= '1';
    wait for clk_period;
    input_tran.valid <= '0';
    wait for 250*clk_period;
    endsim <= true;
    wait;
  end process;

end tb_driver_arch;
