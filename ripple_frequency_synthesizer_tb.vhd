library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ripple_frequency_synthesizer_tb is
end ripple_frequency_synthesizer_tb;

architecture arch of ripple_frequency_synthesizer_tb is

    component ripple_frequency_synthesizer is
        generic (N : integer := 5);
        port (clock : in std_logic;
              reset : in std_logic;
              frequency_control : in std_logic_vector(N-1 downto 0);
              frequency: out std_logic);
    end component;

    constant clock_period : time := 15.625 ns; -- 64 MHz

    signal clock : std_logic;
    signal reset : std_logic;
    signal frequency_control : std_logic_vector(4 downto 0);
    signal frequency : std_logic;

begin

    synthesizer : ripple_frequency_synthesizer
    port map (clock => clock,
              reset => reset,
              frequency_control => frequency_control,
              frequency => frequency);

    clock_process : process
    begin
        clock <= '0';
        wait for clock_period/2;
        clock <= '1';
        wait for clock_period/2;
    end process;

    test_process : process
    begin

        reset <= '1';
        wait for clock_period;
        reset <= '0';

        frequency_control <= std_logic_vector(to_unsigned(1, 5));
        wait for 128 * clock_period;

        frequency_control <= std_logic_vector(to_unsigned(2, 5));
        wait for 128 * clock_period;

        frequency_control <= std_logic_vector(to_unsigned(10, 5));
        wait for 128 * clock_period;

        frequency_control <= std_logic_vector(to_unsigned(11, 5));
        wait for 128 * clock_period;

        frequency_control <= std_logic_vector(to_unsigned(16, 5));
        wait for 128 * clock_period;

        frequency_control <= std_logic_vector(to_unsigned(31, 5));
        wait for 128 * clock_period;

        wait;
    end process;

end architecture;
