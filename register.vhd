library ieee;
use ieee.std_logic_1164.all;

entity reg is
    generic (N : integer);
    port (clock  : in  std_logic;
          reset  : in  std_logic;
          enable : in  std_logic;
          data   : in  std_logic_vector(N-1 downto 0);
          q      : out std_logic_vector(N-1 downto 0));
end reg;

architecture arch of reg is
begin
    process (clock, reset)
    begin
        if (reset = '1') then
            q <= (others => '0');
        elsif (rising_edge(clock)) then
            if (enable = '1') then
                q <= data;
            end if;
        end if;
    end process;
end architecture;
