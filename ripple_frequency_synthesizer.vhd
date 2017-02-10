library ieee;
use ieee.std_logic_1164.all;

entity ripple_frequency_synthesizer is
    port(clock : in std_logic;
         reset : in std_logic;
         frequency_control : in std_logic_vector(4 downto 0);
         frequency: out std_logic);
end ripple_frequency_synthesizer;

architecture arch of ripple_frequency_synthesizer is

    component ripple_carry_adder is
        generic (N : integer);
        port (A, B : in  std_logic_vector(N-1 downto 0);
              Cin  : in  std_logic;
              Sum  : out std_logic_vector(N-1 downto 0);
              Cout : out std_logic);
    end component;

    component reg is
        generic (N : integer);
        port (clock  : in  std_logic;
              reset  : in  std_logic;
              enable : in  std_logic;
              data   : in  std_logic_vector(N-1 downto 0);
              q      : out std_logic_vector(N-1 downto 0));
    end component;

    constant HIGH : std_logic := '1';
    constant LOW  : std_logic := '0';

    signal adder_output, reg_output : std_logic_vector(4 downto 0);

begin

    adder : ripple_carry_adder
    generic map (N => 5)
    port map (A => frequency_control,
              B => reg_output,
              Cin => LOW,
              Sum => adder_output,
              Cout => frequency);

    accumulator : reg
    generic map (N => 5)
    port map (clock => clock,
              reset => reset,
              enable => HIGH,
              data => adder_output,
              q => reg_output);

end architecture;
