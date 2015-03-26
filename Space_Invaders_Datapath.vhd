library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
--use work.space_invaders_package.all;
--use work.vga_package.all;


entity Space_Invaders_Datapath is
        port
        (
			CLOCK					: in  std_logic;
			DATAPATH_RESET		: in  std_logic;	
			SHIP_LEFT			: in  std_logic;			
			SHIP_RIGHT			: in  std_logic;			
			SHIP_EN				: in  std_logic;			
			ALIEN_EN_X			: in  std_logic;			
			ALIEN_EN_Y			: in  std_logic;			
			ALIEN_LEFT_RIGHT	: in  std_logic;	
			SHOOT_EN_Y			: in  std_logic;			
			SHOOT_LOAD			: in  std_logic;			
			SHOOT					: in  std_logic				     
        );

end entity;

architecture RTL of Space_Invaders_Datapath is
--Global Variable
constant  MAX_X    : positive   := 32;
constant  MAX_Y    : positive   := 32;
constant  MAX_B    : positive   := 5; -- numero massimo proiettili sullo schermo
constant  MAX_TICK    : positive   := 50000000; -- frequenza CPU FPGA
constant  BULLET_MOVE_TIME    : positive   := 500000;

type max_bullets is array (1 to MAX_B) of integer range 0 to (MAX_X-1);

shared variable ship_x : integer range 0 to (MAX_X-1);
shared variable bullet_y : max_bullets;
shared variable bullet_x : max_bullets;
shared variable clock_tick : integer range 0 to MAX_TICK;




begin

bullet_move : process(CLOCK, DATAPATH_RESET, SHOOT)
begin

	if (DATAPATH_RESET = '1') then
		clock_tick := 0; 
		
	elsif (rising_edge(CLOCK)) then
		clock_tick := clock_tick + 1;
		
		if (clock_tick >= MAX_TICK) then
			clock_tick := 0;
		end if;
		
		if ((clock_tick mod BULLET_MOVE_TIME) = 0) then
			for I in 1 to MAX_B loop
			
				if (bullet_x(I) > 0) then
					bullet_y(I) := bullet_y(I) + 1;
				
					if (bullet_y(I) > MAX_Y) then --Da inserire condizione se colpisce alieno
						bullet_y(I) := 0;
						bullet_x(I) := 0;
					end if;
			
				end if;				
				
			end loop;
				
					
		end if;		
	
	end if;

end process;

ship_move : process(CLOCK, DATAPATH_RESET, SHIP_LEFT, SHIP_RIGHT)
begin

	if (DATAPATH_RESET = '1') then
		ship_x := 0; 
		
	elsif (rising_edge(CLOCK)) then
		if (SHIP_LEFT = '1' and ship_x > 0) then
			ship_x := ship_x - 1 ;
			
		elsif (SHIP_RIGHT = '1' and ship_x < MAX_X) then
			ship_x := ship_x + 1;
					
		end if;		
	
	end if;

end process;


end architecture;
