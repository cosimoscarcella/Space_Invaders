library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Shift_register is
		generic 
		(
			LENGTH		: positive
		);
		
		port
		( 
			clk			: in std_logic;
			load		: in std_logic;
			en			: in std_logic;
			left_right	: in std_logic;  --0 left, 1 right
			output		: out std_logic_vector(LENGTH downto 0);
			input		: in std_logic_vector(LENGTH downto 0)
		);
 
end Shift_register;

architecture RTL of Shift_register is
begin
		process
			variable temp: std_logic_vector(LENGTH downto 0); 
			begin
				wait until rising_edge (clk);
				
				if en = '1' then
					temp := Input; 
					if left_right = '0' then 
						for i in 0 to LENGTH-1 loop
							temp(i) := temp(i+1);
						end loop;
						temp(LENGTH-1) := '0';
					end if;
					if left_right = '1' then 
						for i in LENGTH-1 downto 0 loop
							temp(i) := temp(i-1);
						end loop;
						temp(0) := '0'; 
					end if;
					Output <= temp;
				end if;
		end process;
end RTL;