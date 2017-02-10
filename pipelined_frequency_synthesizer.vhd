library ieee;
use ieee.std_logic_1164.all;

entity pipelined_frequency_synthesizer is
    port (clock : in std_logic;
          reset : in std_logic;
          update : in std_logic;
          frequency_control : in std_logic_vector(4 downto 0);
          frequency : out std_logic);
end pipelined_frequency_synthesizer;

architecture arch of pipelined_frequency_synthesizer is

    component bit_slice is
        port (clock : in std_logic;
              reset : in std_logic;
              frequency_control : in std_logic;
              update_in : in std_logic;
              Cin : in std_logic;
              update_out : out std_logic;
              Cout : out std_logic);
    end component;

    constant HIGH : std_logic := '1';
    constant LOW  : std_logic := '0';

    signal updates : std_logic_vector(0 to 5);
    signal C : std_logic_vector(0 to 5);

begin

    accumulator : for i in 0 to 4 generate
        bits : bit_slice
        port map (clock => clock,
                  reset => reset,
                  frequency_control => frequency_control(i),
                  update_in => updates(i),
                  Cin => C(i),
                  update_out => updates(i+1),
                  Cout => C(i+1));
    end generate accumulator;

    updates(0) <= update;
    C(0) <= LOW;
    frequency <= C(5);

end architecture;
