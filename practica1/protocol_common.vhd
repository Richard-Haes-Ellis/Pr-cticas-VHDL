library IEEE;
use IEEE.STD_LOGIC_1164.all;

package protocol_common is

  type protocol_type is
    record
      data : std_logic_vector (31 downto 0);
      valid: std_logic;
    end record;

end protocol_common;


package body protocol_common is

end protocol_common;
