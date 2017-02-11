-- Implements a basic full adder cell that adds two bits A and B with carry-in Cin
-- into an output sum S and carry-out Cout.

library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
    port (A, B, Cin : in std_logic;
          S, Cout : out std_logic);
end full_adder;

architecture arch of full_adder is 
begin
    S <= A xor B xor Cin;
    Cout <= (A and B) or (A and Cin) or (B and Cin);
end architecture;
