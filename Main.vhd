
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.mypackage.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Main is
    generic ( clk_input : integer := 100000000 ); 
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           PWM : in SevenSeg;
           data_out : out STD_LOGIC;
           seven_seg: out SevenSeg;
           AN: out bit_vector(3 downto 0)
    );           
end Main;

architecture Behavioral of Main is

constant maxcount: integer := (clk_input/20000);

    -- signals for PWM
signal sqr_wave: std_logic := '0';
signal count_sqr: integer range 0 to 100 := 0;
signal N: integer range 0 to 128 := 50;

    -- signals for 7 segment display
signal counter: unsigned(26 downto 0) := to_unsigned(0,27);
signal digitmux: bit_vector(3 downto 0):="0111";
signal Seg0, Seg1, Seg2, Seg3: SevenSeg:= "1000000";
signal N_input0, N_input1, N_input2, N_input3: Digit:=0;

component pwm_to_7seg
port(
   N_input : in Digit;
   seven_seg1 : out SevenSeg
);
end component;

begin

seg_0: pwm_to_7seg
port map(
 N_input => N_input0, seven_seg1=> Seg0
);

seg_1: pwm_to_7seg
port map(
 N_input => N_input1, seven_seg1=> Seg1
);

seg_2: pwm_to_7seg
port map(
 N_input => N_input2, seven_seg1=> Seg2
);

seg_3: pwm_to_7seg
port map(
 N_input => N_input3, seven_seg1=> Seg3
);

 data_out <= sqr_wave;
 
 AN(3 downto 0) <= digitmux;

generate_pwm: process(clk,rst)
begin
    if (rst='1') then
        sqr_wave <= '0';
        count_sqr <= 0;
        N <= 0;
    else 
        if (rising_edge(clk)) then
            count_sqr <= count_sqr +1;
            if (count_sqr>=0 and count_sqr<N) then
                sqr_wave<='1';
            elsif (count_sqr>=N and count_sqr<99) then
                sqr_wave<='0';
            elsif (count_sqr>=99) then
                count_sqr<= 0;
                N<= to_integer(unsigned(PWM));  
            end if;
        end if;                
    end if;
end process;

count_for_rotate_anode_mux: process(clk)
begin
 if (rising_edge(clk)) then
  if (rst='1' or counter>= maxcount) then
   counter <= (others => '0');
    digitmux<= digitmux ror 1;
  else
   counter <= counter +1;
  end if;
 end if;
end process;

digitmux_segment_choose: process(digitmux)
begin
 if (digitmux(0)='0') then
    seven_seg <=Seg0;
 elsif (digitmux(1)='0') then
    seven_seg <=Seg1;
 elsif (digitmux(2)='0') then
  seven_seg <=Seg2;    
 elsif (digitmux(3)='0') then
    seven_seg <=Seg3;     
 end if;
end process;

digit_writer: process(clk)
begin 
 if(rising_edge(clk)) then  
    N_input0<=N mod 10;
    N_input1<=N/10 mod 10;
    N_input2<=N/100 mod 10;          
    N_input3<=0;
 end if;
end process;

end Behavioral;
