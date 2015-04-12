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
			CLEAR					: in  std_logic;	
			BULLET_TIME			: in  std_logic;
			SHIP_OUT				: out ship_type;
			--LEDVERDIDAT		: out  std_logic
			LEDVERDI				: out  std_logic
        );

end entity;

architecture RTL of Space_Invaders_Datapath is

-- Shared variables
shared variable ship_pos     :  integer := 0;
shared variable bullet_pos     : bullet;
shared variable bullet_index : integer := 0;
shared variable count : integer := 0;


begin


ship_move : process(CLOCK, RESET_N)
begin

	if (RESET_N = '0') then
		--LEDVERDI <=	'0';
		
	elsif (rising_edge(CLOCK)) then
		
		if (SHIP_LEFT = '1' and ship_pos > 0) then
			ship_pos := ship_pos - BLOCK_SIZE;
			SHIP_OUT.x <= ship_pos;
			
			
		elsif (SHIP_RIGHT = '1' and ship_pos < (BOARD_COLUMNS-2)*BLOCK_SIZE) then
			ship_pos := ship_pos + BLOCK_SIZE;
			SHIP_OUT.x <= ship_pos;
		end if;
	
	end if;
end process;


	
bullet_move : process(CLOCK, RESET_N)
begin

	if (RESET_N = '0') then
		bullet_index := 0;
		for i in 0 to MAX_B loop
			
			bullet_pos(i).x := 0;
			bullet_pos(i).y := (BOARD_ROWS-1)*BLOCK_SIZE;			

		end loop; 
		
	elsif (rising_edge(CLOCK)) then
		
		if (SHOOT = '1') then
			if (bullet_index < MAX_B) then
				bullet_pos(count).x := ship_pos;			
				--SHIP_OUT.bullets(bullet_index).x <= bullet_pos(bullet_index).x;		
				bullet_pos(count).shooted := '1';
				bullet_index := bullet_index + 1;
				count := count + 1;
			end if;
		end if;
	
		if(BULLET_TIME = '1') then
			for i in 0 to MAX_B loop
				
				--if (i < bullet_index and bullet_pos(i).y > 0) then
				if (bullet_pos(i).shooted = '1' and bullet_pos(i).y > 0) then
					bullet_pos(i).y := bullet_pos(i).y - BLOCK_SIZE;
				end if;	
					--SHIP_OUT.bullets(i).y <= bullet_pos(i).y;	
				if (bullet_pos(i).y <= 0) then --DA METTERE AND SE COLPISCE ALIENO
					--bullet_index := bullet_index - 1;
					bullet_pos(i).y := (BOARD_ROWS-1)*BLOCK_SIZE;
					bullet_pos(i).shooted := '0';
					bullet_index := bullet_index - 1;
					
					for j in 0 to MAX_B loop
						if (bullet_pos(j).shooted = '0') then
							count := j;
							exit;
						end if;
					end loop;
					
				end if;	
				
			end loop;
			
			SHIP_OUT.bullets <= bullet_pos;
		end if;	
	
	end if;		
end process;

end architecture;
