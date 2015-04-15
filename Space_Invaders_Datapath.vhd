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
			ALIEN_TIME			: in  std_logic;
			SHIP_OUT				: out ship_type;
			ALIEN_OUT			: out alien_group;
			ALIEN_STATE			: out alien_status;
			SCORE_OUT			: out integer;
			--LEDVERDIDAT		: out  std_logic
			LEDVERDI				: out std_logic;
			ALIEN_SPEED_OUT	: out std_logic
        );

end entity;

architecture RTL of Space_Invaders_Datapath is

-- Shared variables
shared variable ship_pos     :  integer := 0;
shared variable bullet_pos    : bullet;
shared variable alien_posx		: integer := 0;
shared variable alien_posy		: integer := 0;
shared variable alien_obj		: alien_group;
shared variable bullet_index : integer := 0;
shared variable count 			: integer := 0;
shared variable alien_direction : std_logic := '1'; --0 se va a destra, 1 se va a sinistra
shared variable alien_down		: integer := 0;
shared variable alien_hit		: std_logic := '0';
shared variable alien_alive	: alien_status;
constant score_len				: integer := 9999;
shared variable score 			: integer range 0 to score_len := 0;

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
			bullet_pos(i).hit := '0';
		end loop; 
		for i in 0 to MAX_A_ROWS loop
			for j in 0 to MAX_A loop
				alien_alive(i)(j).alive := '1';
			end loop;
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
				for k in 0 to MAX_A_ROWS loop
					for j in 0 to MAX_A loop
						if(alien_alive(k)(j).alive = '1' and alien_obj(k)(j).x = bullet_pos(i).x and alien_obj(k)(j).y = bullet_pos(i).y) then
							alien_alive(k)(j).alive := '0';
							bullet_pos(i).hit := '1';
							score := score + 1;
--							SCORE_OUT <= std_logic_vector(to_bcd(to_unsigned(score, score_len)));
							SCORE_OUT <= score;
							exit;
						end if;
					end loop;
				end loop;
				ALIEN_STATE <= alien_alive;
				if (bullet_pos(i).y <= 0 ) then --DA METTERE AND SE COLPISCE ALIENO
					--bullet_index := bullet_index - 1;
					bullet_pos(i).y := (BOARD_ROWS-1)*BLOCK_SIZE;
					bullet_pos(i).shooted := '0';
					bullet_pos(i).hit := '0';
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

alien_move : process(CLOCK, RESET_N)
begin

	if (RESET_N = '0') then
		LEDVERDI <=	'0';
		alien_posx := 0;
		alien_posy := BLOCK_SIZE * 2;
		for i in 0 to MAX_A_ROWS loop
			for j in 0 to MAX_A loop
				alien_obj(i)(j).y := 3 * BlOCK_SIZE * i + BLOCK_SIZE;
			end loop;
		end loop;
		
	elsif (rising_edge(CLOCK)) then
		ALIEN_SPEED_OUT <= '0';
		if(ALIEN_TIME = '1') then
			if (alien_obj(0)(MAX_A).x >= (BOARD_COLUMNS-2)*BLOCK_SIZE and alien_direction = '0') then
				alien_direction := '1';
				alien_down := alien_down + 1;
			end if;
			if (alien_posx <= 0 and alien_direction = '1') then
				alien_direction := '0';
				alien_down := alien_down + 1;
			end if;
			if (alien_direction = '0') then
				alien_posx := alien_posx + BLOCK_SIZE;
			else
				alien_posx := alien_posx - BLOCK_SIZE;
			end if;
			if (alien_down = 6) then
				alien_posy := alien_posy + 2 * BLOCK_SIZE;
				alien_down := 0;
				ALIEN_SPEED_OUT <= '1';
			end if;
			for i in 0 to MAX_A_ROWS loop
				for j in 0 to MAX_A loop
					alien_obj(i)(j).x := alien_posx + 4 * BlOCK_SIZE * j;
					alien_obj(i)(j).y := alien_posy + 3 * BlOCK_SIZE * i + BLOCK_SIZE;
				end loop;
			end loop;
			if (alien_obj(MAX_A_ROWS)(0).y >= BOARD_ROWS * BLOCK_SIZE) then	
				LEDVERDI <=	'1';
				alien_posx := 0;
				alien_posy := BLOCK_SIZE * 2;
			end if;
			ALIEN_OUT <= alien_obj;
		end if;
		
--		if (SHIP_LEFT = '1' and ship_pos > 0) then
--			ship_pos := ship_pos - BLOCK_SIZE;
--			SHIP_OUT.x <= ship_pos;
--			
--			
--		elsif (SHIP_RIGHT = '1' and ship_pos < (BOARD_COLUMNS-2)*BLOCK_SIZE) then
--			ship_pos := ship_pos + BLOCK_SIZE;
--			SHIP_OUT.x <= ship_pos;
--		end if;
	
	end if;
end process;

end architecture;
