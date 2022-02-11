library IEEE;
use IEEE.std_logic_1164.all;
use work.protocol_common.all;

entity tb_top is
end tb_top;

architecture tb_top_arch of tb_top is

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

  component monitor is
    port (
      output_tran: out protocol_type;
      clk       : in std_logic;
      data      : in std_logic_vector(N - 1 downto 0) := (others => '0');
      ena       : in std_logic := '0';
      startp    : in std_logic := '0';
      endp      : in std_logic := '0'
    );
  end component;

  component generator is
    port (
      generated_tran: out protocol_type;
      clk       : in std_logic
    );
  end component;

  component checker is
    port (
        generated_tran: in protocol_type;
        output_tran: in protocol_type;
        clk       : in std_logic
    );
  end component;

  -- Declaramos el tb_driver como componente

  -- Declaramos los signals que necesitamos para conectar
  signal clk: std_logic := '0';
  signal generated_tran : protocol_type;
  signal output_tran : protocol_type;
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
    input_tran => generated_tran,
    clk => clk,
    data => data,
    ena => ena,
    startp => startp,
    endp => endp
  );

  monitor_inst: monitor
    port map (
      output_tran => output_tran,
      clk => clk,
      data => data,
      ena => ena,
      startp => startp,
      endp => endp
    );

    generator_inst: generator
    port map (
      generated_tran => generated_tran,
      clk => clk
    );

    checker_inst: checker
    port map (
      generated_tran => generated_tran,
      output_tran => output_tran,
      clk => clk
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

end tb_top_arch;
