library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.space_invaders_package.all;
use work.vga_package.all;
use work.sprites_package.all;


entity Space_Invaders_View is
	port
	(
		CLOCK          : in  std_logic;
		RESET_N        : in  std_logic;
		
		REDRAW         : in  std_logic;
		
		SHIP_IN			: in ship_type;
		ALIEN_IN			: in alien_group;
		ALIEN_STATE		: in alien_status;
		GAME_STATUS		: in  std_logic;
		WIN				: in  std_logic;
		
		FB_READY       : in  std_logic;
		FB_CLEAR       : out std_logic;
		FB_FLIP        : out std_logic;
		FB_DRAW_RECT   : out std_logic;
		FB_DRAW_LINE   : out std_logic;
		FB_FILL_RECT   : out std_logic;
		FB_COLOR       : out color_type;
		FB_X0          : out xy_coord_type;
		FB_Y0          : out xy_coord_type;
		FB_X1          : out xy_coord_type;
		FB_Y1          : out xy_coord_type;
		
		SPLASH_ENABLE		: in std_logic
		
	);
end entity;


architecture RTL of Space_Invaders_View is

	constant LEFT_MARGIN    : integer := 4;
	constant TOP_MARGIN     : integer := 4;	
	
	type   state_type    is (IDLE, WAIT_FOR_READY, DRAWING);
	type   substate_type is (CLEAR_SCENE, DRAW_SPLASH, DRAW_BOARD_OUTLINE, DRAW_SHIP, DRAW_BULLET, DRAW_ALIENS, END_GAME,FLIP_FRAMEBUFFER);
	signal state        : state_type;
	signal substate     : substate_type;
	
	
begin	
	
	process(CLOCK, RESET_N)
	variable led : std_logic_vector(9 downto 0) := "0000000000";
	variable sprite_index, pixel_x, pixel_y, pixel_x_start_pos, pixel_y_start_pos, i, j, k : integer := 0;
	variable stop_game_drawing : std_logic := '0';
	variable init_ship, init_alien, init_splash, block_created : std_logic := '0';
		
	begin
	
		if (RESET_N = '0') then
			state             <= WAIT_FOR_READY;
			substate          <= CLEAR_SCENE;
			FB_CLEAR          <= '0';
			FB_DRAW_RECT      <= '0';
			FB_DRAW_LINE      <= '0';
			FB_FILL_RECT      <= '0';
			FB_FLIP           <= '0';
			i 						:=  0 ;
			stop_game_drawing := '0';			

		elsif (rising_edge(CLOCK)) then
		
			FB_CLEAR       <= '0';
			FB_DRAW_RECT   <= '0';
			FB_DRAW_LINE   <= '0';
			FB_FILL_RECT   <= '0';
			FB_FLIP        <= '0';			
			
			case (state) is
				when IDLE =>
					
					if (REDRAW = '1') then
						state    <= WAIT_FOR_READY;
						substate <= CLEAR_SCENE;
					
					else -- REDRAW = '0'
						state    <= IDLE;
					end if;					
					
				when WAIT_FOR_READY =>
					
					if (FB_READY = '1') then					
						state <= DRAWING;
					end if;
				
				when DRAWING =>
					
					state <= WAIT_FOR_READY;
				
					case (substate) is
						when CLEAR_SCENE =>
							
							FB_COLOR     <= COLOR_BLACK;
							FB_CLEAR     <= '1';							
							
							if (SPLASH_ENABLE = '1') then
								substate     <= DRAW_SPLASH;
							elsif (GAME_STATUS = '1') then
								substate     <= END_GAME;
							else
								substate     <= DRAW_BOARD_OUTLINE;
							end if;		
			
						when DRAW_SPLASH =>	-- Disegno schermata iniziale
							
							if (init_splash = '0') then 
								pixel_x_start_pos := 56;
								pixel_y_start_pos := 75;
								pixel_x := pixel_x_start_pos;
								pixel_y := pixel_y_start_pos;
							end if;
							
							-- Per ogni pixel della spite viene disegnato un rettangolo 4x4 in modo da allargare l'immagine
							if (((pixel_x - pixel_x_start_pos) /= (100*4)) and ((pixel_y - pixel_y_start_pos) /= (33*4))) then
								
								FB_COLOR <= splash_sprite(sprite_index);
								FB_X0        <= pixel_x;
								FB_Y0        <= pixel_y;
								FB_X1        <= pixel_x+4;
								FB_Y1        <= pixel_y+4;
								FB_FILL_RECT <= '1';
								sprite_index := sprite_index + 1;
								
								pixel_x := pixel_x + 4;
								if ((pixel_x - pixel_x_start_pos) = (100*4)) then 
									pixel_x := pixel_x_start_pos;
									pixel_y := pixel_y + 4;
								end if;
								
								init_splash := '1';
							else
								init_splash := '0';
								sprite_index := 0;
								substate <= FLIP_FRAMEBUFFER;
							end if;
						
						when DRAW_BOARD_OUTLINE => -- Disegno Bordo schermata di gioco
							
							FB_COLOR     <= COLOR_BLUE;
							FB_X0        <= LEFT_MARGIN;
							FB_Y0        <= TOP_MARGIN;
							FB_X1        <= LEFT_MARGIN + ((BOARD_COLUMNS - 1) * BLOCK_SIZE) + LEFT_MARGIN * 2;
							FB_Y1        <= TOP_MARGIN + (BOARD_ROWS * BLOCK_SIZE) ;						
							FB_DRAW_RECT <= '1';
							
							substate     <= DRAW_SHIP;			
							
						when DRAW_SHIP =>	
							
							if (init_ship = '0') then 
								pixel_x_start_pos := (LEFT_MARGIN * 2) + SHIP_IN.x;
								pixel_y_start_pos := (BOARD_ROWS-1) * BLOCK_SIZE;
								pixel_x := pixel_x_start_pos;
								pixel_y := pixel_y_start_pos;
							end if;
							
							-- Ad ogni clock viene disegnato un pixel del colore indicato dalla sprite
							if (((pixel_x - pixel_x_start_pos) /= BLOCK_SIZE) and ((pixel_y - pixel_y_start_pos) /= BLOCK_SIZE)) then
								
								FB_COLOR <= ship_sprite(sprite_index);
								FB_X0        <= pixel_x;
								FB_Y0        <= pixel_y;
								FB_X1        <= pixel_x+1;
								FB_Y1        <= pixel_y+1;
								FB_FILL_RECT <= '1';
								sprite_index := sprite_index + 1;
								
								pixel_x := pixel_x + 1;
								if ((pixel_x - pixel_x_start_pos) = BLOCK_SIZE) then 
									pixel_x := pixel_x_start_pos;
									pixel_y := pixel_y + 1;
								end if;
								
								init_ship := '1';
							else
								init_ship := '0';
								sprite_index := 0;
								substate  <= DRAW_BULLET;
							end if;
							
						when DRAW_BULLET =>	

							if (i = 0) then
								FB_COLOR     <= COLOR_WHITE;							
							elsif (i = 1) then
								FB_COLOR     <= COLOR_GREEN;	
							elsif (i = 2) then
								FB_COLOR     <= COLOR_BLUE;
							elsif (i = 3) then
								FB_COLOR     <= COLOR_CYAN;
							elsif (i = 4) then
								FB_COLOR     <= COLOR_MAGENTA;
							end if;							
							
							if (SHIP_IN.bullets(i).shooted = '1' and SHIP_IN.bullets(i).hit = '0') then
								FB_X0        <= (LEFT_MARGIN * 2) + SHIP_IN.bullets(i).x + 11;
								FB_Y0        <= SHIP_IN.bullets(i).y;
								FB_X1        <= (LEFT_MARGIN * 2) + SHIP_IN.bullets(i).x + 13;
								FB_Y1        <= SHIP_IN.bullets(i).y + BLOCK_SIZE / 2;	
								FB_FILL_RECT <= '1';						
							end if;
							
							i := i + 1;							
							if (i >= MAX_B) then
								i := 0;
								substate <= DRAW_ALIENS;
							end if;
							
						when DRAW_ALIENS =>
						 
							if(ALIEN_STATE(k)(j).alive = '1') then							
							
								if (init_alien = '0') then 
									pixel_x_start_pos := (LEFT_MARGIN * 2) + ALIEN_IN(k)(j).x;
									pixel_y_start_pos := ALIEN_IN(k)(j).y;
									pixel_x := pixel_x_start_pos;
									pixel_y := pixel_y_start_pos;
									init_alien := '1';
								end if;
								
								-- Disegno pixel per pixel come nella ship
								if (((pixel_x - pixel_x_start_pos) /= BLOCK_SIZE) and ((pixel_y - pixel_y_start_pos) /= BLOCK_SIZE)) then
									FB_COLOR <= alien_sprite(sprite_index);
									FB_X0        <= pixel_x;
									FB_Y0        <= pixel_y;
									FB_X1        <= pixel_x+1;
									FB_Y1        <= pixel_y+1;
									FB_FILL_RECT <= '1';
									sprite_index := sprite_index + 1;
									
									pixel_x := pixel_x + 1;
									if ((pixel_x - pixel_x_start_pos) = BLOCK_SIZE) then 
										pixel_x := pixel_x_start_pos;
										pixel_y := pixel_y + 1;
									end if;
									
								else -- quando completo di disegnare tutto il blocco
									block_created := '1';
									init_alien := '0';
									sprite_index := 0;
									
								end if;
							elsif(ALIEN_STATE(k)(j).alive = '0') then
								-- TODO alien explotion!
								block_created := '1';
								
							end if;
							
							-- Quando un blocco è stato completato aumento gli indici j e k in modo da disegnare gli altri blocchi
							if (block_created = '1') then
								j := j + 1;
								if (j > MAX_A) then
									j := 0;
									k := k + 1;
									if (k > MAX_A_ROWS) then
										k := 0;
										substate <= FLIP_FRAMEBUFFER;
									end if;
								end if;
								block_created := '0';
							end if;	
						
						when END_GAME =>	-- Disegno schermate finali
							
							if (init_splash = '0') then 
								pixel_x_start_pos := 159;
								pixel_y_start_pos := 200;
								pixel_x := pixel_x_start_pos;
								pixel_y := pixel_y_start_pos;
							end if;
							
							-- Immagini allargate del doppio
							if (((pixel_x - pixel_x_start_pos) /= (97*2)) and ((pixel_y - pixel_y_start_pos) /= (14*2))) then
								
								if (WIN = '1') then
									FB_COLOR <= win_sprite(sprite_index);
								else
									FB_COLOR <= lose_sprite(sprite_index);
								end if;
							
								FB_X0        <= pixel_x;
								FB_Y0        <= pixel_y;
								FB_X1        <= pixel_x+2;
								FB_Y1        <= pixel_y+2;
								FB_FILL_RECT <= '1';
								sprite_index := sprite_index + 1;
								
								pixel_x := pixel_x + 2;
								if ((pixel_x - pixel_x_start_pos) = (97*2)) then 
									pixel_x := pixel_x_start_pos;
									pixel_y := pixel_y + 2;
								end if;
								
								init_splash := '1';
							else
								init_splash := '0';
								sprite_index := 0;
								
								-- Forzo il Flip
								FB_FLIP  <= '1';
								
								substate <= FLIP_FRAMEBUFFER;
								stop_game_drawing := '1';
							end if;					
						
						when FLIP_FRAMEBUFFER =>  -- Impongo al FrameBuffer di disegnare la mia schermata	
							
							if(stop_game_drawing = '0') then
								state    <= IDLE;	
								FB_FLIP  <= '1';
							else -- stop_game_drawing = '1'
								state    <= IDLE;
							end if;
							
					end case;
			end case;
	
		end if;
	end process;
	
end architecture;
