-- Implements a delay equalizer that updates frequency_control_out with
-- the input frequency_control selected by the frequency_select signal when this
-- signal changes. Otherwise, the previous value is stored and output.
-- 
-- A chain of delay equalizers will ensure that the outputs change at a rate of one-bit per clock
-- cycle when the frequency_select_in signal is propagated through the chain.

library ieee;
use ieee.std_logic_1164.all;

entity fsk_delay_equalizer is
    port (clock : in std_logic;
          reset : in std_logic;
          frequency_control_in_0 : in std_logic;
          frequency_control_in_1 : in std_logic;
          frequency_select_in : in std_logic;
          frequency_control_out : out std_logic;
          frequency_select_out : out std_logic);
end fsk_delay_equalizer;

architecture arch of fsk_delay_equalizer is

    signal frequency_select_internal : std_logic;
    signal frequency_control_internal : std_logic;
    signal frequency_control_next : std_logic;

    signal frequency_select : std_logic_vector(1 downto 0); -- concatenation of input and output select signals

begin
    
    regs : process (clock, reset)
    begin
        if (reset = '1') then
            frequency_control_internal <= '0';
            frequency_select_internal <= '0';
        elsif (rising_edge(clock)) then
            frequency_control_internal <= frequency_control_next;
            frequency_select_internal <= frequency_select_in;
        end if;
    end process;

    -- select the new value for frequency when the select signal changes
    frequency_select <= frequency_select_in & frequency_select_internal;
    with frequency_select select frequency_control_next <=
        frequency_control_in_0 when "01", -- change from 1 to 0
        frequency_control_in_1 when "10", -- change from 0 to 1
        frequency_control_internal when others;

    frequency_select_out <= frequency_select_internal;
    frequency_control_out <= frequency_control_internal;

end architecture;
