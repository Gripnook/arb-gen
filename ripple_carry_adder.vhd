library ieee;
use ieee.std_logic_1164.all;

entity ripple_carry_adder is
    generic (N : integer);
    port (A, B : in  std_logic_vector(N-1 downto 0);
          Cin  : in  std_logic;
          Sum  : out std_logic_vector(N-1 downto 0);
          Cout : out std_logic);
end ripple_carry_adder;

architecture arch of ripple_carry_adder is

    component full_adder is
        port (A, B, Cin : in std_logic;
              S, Cout : out std_logic);
    end component;

    signal C : std_logic_vector(0 to N);

begin

    full_adders: for i in 0 to N-1 generate
        adder: full_adder
        port map (A => A(i),
                  B => B(i),
                  Cin => C(i),
                  S => Sum(i),
                  Cout => C(i+1));
    end generate full_adders;

    C(0) <= Cin;
    Cout <= C(N);

end architecture;
