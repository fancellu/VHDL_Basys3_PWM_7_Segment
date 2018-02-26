
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.mypackage.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pwm_to_7seg is
    Port ( N_input : in Digit;
           seven_seg1 : out SevenSeg);
end pwm_to_7seg;

architecture Behavioral of pwm_to_7seg is
signal output: SevenSeg;

begin

seven_seg1 <= not output;

process(N_input)
begin
    case N_input is
        when 0=> output <="0111111";
        when 1=> output <="0000110";
        when 2=> output <="1011011";
        when 3=> output <="1001111";
        when 4=> output <="1100110";
        when 5=> output <="1101101";
        when 6=> output <="1111101";
        when 7=> output <="0000111";
        when 8=> output <="1111111";
        when 9=> output <="1101111";
        when others=> output <= (others=>'X');
    end case;

end process;

end Behavioral;
