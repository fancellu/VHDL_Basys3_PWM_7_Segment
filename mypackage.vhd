library IEEE;
use IEEE.std_logic_1164.all;

package mypackage is

subtype SevenSeg is STD_LOGIC_VECTOR (6 downto 0);
subtype Digit is integer range 0 to 9;

end mypackage;