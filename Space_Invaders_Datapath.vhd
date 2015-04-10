library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.space_invaders_package.all;
use work.vga_package.all;


entity Space_Invaders_Datapath is
        port
        (
			CLOCK					: in  std_logic;
			TIME_10MS			: in  std_logic;
			RESET_N				: in  std_logic;	
			SHIP_LEFT			: in  std_logic;			
			SHIP_RIGHT			: in  std_logic;						
			ALIEN_LEFT_RIGHT	: in  std_logic;				
			SHOOT					: in  std_logic;
			CLEAR	: in  std_logic;	
			SHIP_OUT				: out ship_type
        );

end entity;

architecture RTL of Space_Invaders_Datapath is

-- Shared variables
shared variable bullet_y : max_bullets;
shared variable bullet_x : max_bullets;
shared variable clock_tick : integer range 0 to MAX_TICK;

signal ship : ship_type;


begin

--bullet_move : process(CLOCK, RESET_N, SHOOT)
--begin
--
--	if (RESET_N = '1') then
--		clock_tick := 0; 
--		
--	elsif (rising_edge(CLOCK)) then
--		clock_tick := clock_tick + 1;
--		
--		if (clock_tick >= MAX_TICK) then
--			clock_tick := 0;
--		end if;
--		
--		if ((clock_tick mod BULLET_MOVE_TIME) = 0) then
--			for I in 1 to MAX_B loop
--			
--				if (bullet_x(I) > 0) then
--					bullet_y(I) := bullet_y(I) + 1;
--				
--					if (bullet_y(I) > MAX_Y) then --Da inserire condizione se colpisce alieno
--						bullet_y(I) := 0;
--						bullet_x(I) := 0;
--					end if;
--			
--				end if;				
--				
--			end loop;
--				
--					
--		end if;		
--	
--	end if;
--
--end process;

ship_move : process(CLOCK, RESET_N)
begin

	if (RESET_N = '1') then
		ship.x <= 0; 
		ship.y <= 0; 
		SHIP_OUT <= ship;
		
	elsif (rising_edge(CLOCK)) then
		if (SHIP_LEFT = '1' and ship.x > 0) then
			ship.x  <= ship.x - 100 ;
			SHIP_OUT <= ship;
			
		elsif (SHIP_RIGHT = '1' and ship.x < MAX_X) then
			ship.x <= ship.x + 100;
			SHIP_OUT <= ship;
					
		end if;		
	
	end if;

end process;


end architecture;
