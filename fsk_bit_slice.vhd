-- Implements a single bit of a pipelined fsk modulator which repeatedly
-- adds a signal frequency_control with carry-in Cin on every rising clock edge
-- and produces a carry-out signal Cout. The frequency_control signal is stored
-- internally and can only be changed by the input through the frequency_select_in signal.
-- The frequency_select_out signal allows propagation of the select signal in sync with the pipeline.

library ieee;
use ieee.std_logic_1164.all;

entity fsk_bit_slice is
    port (clock : in std_logic;
          reset : in std_logic;
          frequency_control_0 : in std_logic;
          frequency_control_1 : in std_logic;
          frequency_select_in : in std_logic;
          Cin : in std_logic;
          frequency_select_out : out std_logic;
          Cout : out std_logic);
end fsk_bit_slice;

architecture arch of fsk_bit_slice is

    component fsk_delay_equalizer is
        port (clock : in std_logic;
              reset : in std_logic;
              frequency_control_in_0 : in std_logic;
              frequency_control_in_1 : in std_logic;
              frequency_select_in : in std_logic;
              frequency_control_out : out std_logic;
              frequency_select_out : out std_logic);
    end component;

    component accumulator is
        port (clock : in std_logic;
              reset : in std_logic;
              A : in std_logic;
              Cin : in std_logic;
              Cout : out std_logic);
    end component;

    signal frequency_control_internal : std_logic;

begin

    delay : fsk_delay_equalizer
    port map (clock => clock,
              reset => reset,
              frequency_control_in_0 => frequency_control_0,
              frequency_control_in_1 => frequency_control_1,
              frequency_select_in => frequency_select_in,
              frequency_control_out => frequency_control_internal,
              frequency_select_out => frequency_select_out);

    acc : accumulator
    port map (clock => clock,
              reset => reset,
              A => frequency_control_internal,
              Cin => Cin,
              Cout => Cout);

end architecture;
