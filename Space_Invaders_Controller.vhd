library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.space_invaders_package.all;

entity Space_Invaders_Controller is
	port
	(
		CLOCK           : in  std_logic;
		RESET_N         : in  std_logic;
		TIME_10MS       : in  std_logic;
		
		BUTTON_LEFT     : in  std_logic;
		BUTTON_RIGHT    : in  std_logic;
		BUTTON_SHOT     : in  std_logic;
	
		-- Connections with Tetris_Datapath
		SHIP_LEFT			: out  std_logic;			
		SHIP_RIGHT			: out  std_logic;						
		ALIEN_LEFT_RIGHT	: out  std_logic;				
		SHOOT					: out  std_logic;
		
		-- Connections with View
		REDRAW          : out std_logic
	);

end entity;


architecture RTL of Space_Invaders_Controller is

begin   

--MOVIMENTO TEMPORIZZATO
				   
--	TimedFall : process(CLOCK, RESET_N)
--	begin
--		if (RESET_N = '0') then
--			time_to_next_fall <= 0;
--			move_piece_down   <= '0';
--		elsif rising_edge(CLOCK) then
--			move_piece_down <= '0';
--			
--			if (TIME_10MS = '1') then
--				if (time_to_next_fall = 0) then
--					time_to_next_fall <= fall_speed - 1;
--					move_piece_down   <= '1';
--				else
--					time_to_next_fall <= time_to_next_fall - 1;
--				end if;
--			end if;
--		end if;
--	end process;
--						


--	TimedMove : process(CLOCK, RESET_N)
--	begin
--		if (RESET_N = '0') then
--			time_to_next_move  <= 0;
--			move_time          <= '0';
--		elsif rising_edge(CLOCK) then
--			move_time <= '0';
--			
--			if (TIME_10MS = '1') then
--				if (time_to_next_move = 0) then
--					time_to_next_move  <= MOVEMENT_SPEED - 1;
--					move_time          <= '1';
--				else
--					time_to_next_move  <= time_to_next_move - 1;
--				end if;
--			end if;
--		end if;
--	end process;
	
	
	Controller_RTL : process (CLOCK, RESET_N)
	begin
		if (RESET_N = '0') then
			SHOOT       <= '0';
			SHIP_LEFT       <= '0';
			SHIP_RIGHT      <= '0';	
			REDRAW          <= '0';			
		elsif rising_edge(CLOCK) then
			SHOOT       <= '0';
			SHIP_LEFT       <= '0';
			SHIP_RIGHT      <= '0';	
			REDRAW          <= '0';	
		
			if (BUTTON_LEFT = '1') then
					SHIP_LEFT <= '1';
					REDRAW  <= '1';
					
			elsif (BUTTON_RIGHT = '1') then
					SHIP_RIGHT <= '1';
					REDRAW <= '1';
				
			elsif (BUTTON_SHOT = '1') then
					SHOOT <= '1';
					REDRAW  <= '1';			
			end if;
	
	end if;
	end process;
		
end architecture;
