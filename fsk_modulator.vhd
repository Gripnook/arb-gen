-- Implements an fsk modulator that uses two N-bit inputs and a select signal to select the output frequency.
-- The output frequency is given by frequency_control * clock_rate / 2 ** N
-- 
-- Uses a pipelined adder with delay equalizer as part of an accumulator to generate the frequency.

library ieee;
use ieee.std_logic_1164.all;

entity fsk_modulator is
    generic (N : integer := 5);
    port (clock : in std_logic;
          reset : in std_logic;
          frequency_select : in std_logic;
          frequency_control_0 : in std_logic_vector(N-1 downto 0);
          frequency_control_1 : in std_logic_vector(N-1 downto 0);
          frequency : out std_logic);
end fsk_modulator;

architecture arch of fsk_modulator is

    component fsk_bit_slice is
        port (clock : in std_logic;
              reset : in std_logic;
              frequency_control_0 : in std_logic;
              frequency_control_1 : in std_logic;
              frequency_select_in : in std_logic;
              Cin : in std_logic;
              frequency_select_out : out std_logic;
              Cout : out std_logic);
    end component;

    constant HIGH : std_logic := '1';
    constant LOW  : std_logic := '0';

    signal frequency_selects : std_logic_vector(0 to N); -- select propagation chain
    signal C : std_logic_vector(0 to N); -- carry propagation chain

    signal frequency_internal : std_logic;

begin

    accumulator : for i in 0 to N-1 generate
        bits : fsk_bit_slice
        port map (clock => clock,
                  reset => reset,
                  frequency_control_0 => frequency_control_0(i),
                  frequency_control_1 => frequency_control_1(i),
                  frequency_select_in => frequency_selects(i),
                  Cin => C(i),
                  frequency_select_out => frequency_selects(i+1),
                  Cout => C(i+1));
    end generate accumulator;

    toggle_output : process (clock, reset)
    begin
        if (reset = '1') then
            frequency_internal <= '0';
        elsif (rising_edge(clock)) then
            if (C(N) = '1') then
                frequency_internal <= not frequency_internal;
            end if;
        end if;
    end process;

    frequency_selects(0) <= frequency_select;
    C(0) <= LOW;
    frequency <= frequency_internal;

end architecture;
