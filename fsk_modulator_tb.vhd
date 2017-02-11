library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsk_modulator_tb is
end fsk_modulator_tb;

architecture arch of fsk_modulator_tb is

    component fsk_modulator is
        generic (N : integer := 5);
        port (clock : in std_logic;
              reset : in std_logic;
              frequency_select : in std_logic;
              frequency_control_0 : in std_logic_vector(N-1 downto 0);
              frequency_control_1 : in std_logic_vector(N-1 downto 0);
              frequency : out std_logic);
    end component;

    constant clock_period : time := 15.625 ns; -- 64 MHz

    constant ZERO_FREQUENCY : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(10, 5));
    constant ONE_FREQUENCY : std_logic_vector(4 downto 0) := std_logic_vector(to_unsigned(11, 5));

    signal clock : std_logic;
    signal reset : std_logic;
    signal nrz_data : std_logic;
    signal frequency : std_logic;

begin

    fsk : fsk_modulator
    port map (clock => clock,
              reset => reset,
              frequency_select => nrz_data,
              frequency_control_0 => ZERO_FREQUENCY,
              frequency_control_1 => ONE_FREQUENCY,
              frequency => frequency);

    clock_process : process
    begin
        clock <= '0';
        wait for clock_period/2;
        clock <= '1';
        wait for clock_period/2;
    end process;

    test_process : process
        variable i : integer;
        variable bit_sequence : std_logic_vector(0 to 15) := "1001101000010101";
    begin

        reset <= '1';
        wait for clock_period;
        reset <= '0';

        for i in 0 to bit_sequence'length - 1 loop
            nrz_data <= bit_sequence(i);
            wait for 128 * clock_period;
        end loop;

        wait;
    end process;

end architecture;
