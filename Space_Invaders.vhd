library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.space_invaders_package.all;
use work.vga_package.all;


entity Space_Invaders is

        port
        (
                CLOCK_50            : in  std_logic;
                KEY                 : in  std_logic_vector(3 downto 0);
					 HEX0						: out  std_logic_vector(6 downto 0);
					 HEX1						: out  std_logic_vector(6 downto 0);
					 HEX2						: out  std_logic_vector(6 downto 0);
					 HEX3						: out  std_logic_vector(6 downto 0);					 
                SW                  : in  std_logic_vector(9 downto 0);
					 
                VGA_R               : out std_logic_vector(3 downto 0);
                VGA_G               : out std_logic_vector(3 downto 0);
                VGA_B               : out std_logic_vector(3 downto 0);
                VGA_HS              : out std_logic;
                VGA_VS              : out std_logic;
                
                SRAM_ADDR           : out   std_logic_vector(17 downto 0);
                SRAM_DQ             : inout std_logic_vector(15 downto 0);
                SRAM_CE_N           : out   std_logic;
                SRAM_OE_N           : out   std_logic;
                SRAM_WE_N           : out   std_logic;
                SRAM_UB_N           : out   std_logic;
                SRAM_LB_N           : out   std_logic
        );

end;


architecture RTL of Space_Invaders is
      signal clock              : std_logic;
		signal datapath_reset     : std_logic;
      signal clock_vga          : std_logic;
		signal time_10ms          : std_logic;
		signal RESET_N            : std_logic;	
		signal START           	  : std_logic;	  
		signal reset_sync_reg     : std_logic;
		signal ship					  : ship_type;
		signal alien_state		  : alien_status;
		
		--vga
		signal fb_ready           : std_logic;
		signal fb_clear           : std_logic;
		signal fb_flip            : std_logic;
		signal fb_draw_rect       : std_logic;
		signal fb_fill_rect       : std_logic;
		signal fb_draw_line       : std_logic;
		signal fb_x0              : xy_coord_type;
		signal fb_y0              : xy_coord_type;
		signal fb_x1              : xy_coord_type;
		signal fb_y1              : xy_coord_type;
		signal fb_color           : color_type;
		
		
		-- Controller Signals
		signal ship_left				 : std_logic;
		signal ship_right			 	 : std_logic;
		signal button_shot			 : std_logic;
		signal button_right			 : std_logic;
		signal button_left			 : std_logic;
		signal redraw      			 : std_logic;
		signal shoot					 : std_logic;
		signal bullet_time			 : std_logic;
		signal alien_time				 : std_logic;
		signal alien_speed			 : std_logic;
		signal start_game			 	 : std_logic;
		
		
		--View
		signal ledrossi       : std_logic_vector(9 downto 0);
		signal ledverdi       : std_logic;
		
		
		--Datapath
		signal alien 			 : alien_group;
		signal ledgreen       : std_logic;
		signal hex_0			 : unsigned(11 downto 0);
		signal game_status	 : std_logic;
		signal win				 : std_logic;
		
		
begin

        pll : entity work.PLL
                port map (
						inclk0  => CLOCK_50,
						c0      => clock_vga,
						c1      => clock
				 ); 
        
         
        reset_sync : process(CLOCK_50)
        begin
                if (rising_edge(CLOCK_50)) then
						reset_sync_reg <= SW(9);
						start_game <= not(SW(0));
						RESET_N <= reset_sync_reg;
						START <= start_game;
                end if;
        end process;
        
        
        vga : entity work.VGA_Framebuffer
                port map (
						CLOCK     => clock_vga,
						RESET_N   => RESET_N,
						READY     => fb_ready,
						COLOR     => fb_color,
						CLEAR     => fb_clear,
						DRAW_RECT => fb_draw_rect,
						FILL_RECT => fb_fill_rect,
						DRAW_LINE => fb_draw_line,
						FLIP      => fb_flip,   
						X0        => fb_x0,
						Y0        => fb_y0,
						X1        => fb_x1,
						Y1        => fb_y1,
					 
						VGA_R     => VGA_R,
						VGA_G     => VGA_G,
						VGA_B     => VGA_B,
						VGA_HS    => VGA_HS,
						VGA_VS    => VGA_VS,
			 
						SRAM_ADDR => SRAM_ADDR,
						SRAM_DQ   => SRAM_DQ,                   
						SRAM_CE_N => SRAM_CE_N,
						SRAM_OE_N => SRAM_OE_N,
						SRAM_WE_N => SRAM_WE_N,
						SRAM_UB_N => SRAM_UB_N,
						SRAM_LB_N => SRAM_LB_N
				 );
        
        
        controller : entity work.Space_Invaders_Controller
                port map (
						CLOCK					=>	clock,
						TIME_10MS      	 => time_10ms,
						RESET_N				=>	reset_n,
						SHIP_LEFT			=>	ship_left,
						SHIP_RIGHT			=>	ship_right,								
						SHOOT					=>	shoot,
						BUTTON_LEFT			=>	not(KEY(1)),
						BUTTON_RIGHT		=>	not(KEY(0)),
						BUTTON_SHOT			=>	not(KEY(2)),
						REDRAW          	=> redraw,
						BULLET_TIME       => bullet_time,
						ALIEN_SPEED_IN		=> alien_speed,
						ALIEN_TIME        => alien_time,
						START					=> start_game
             );
                
                
        datapath : entity work.Space_Invaders_Datapath
                port map (
						CLOCK					=>	clock,
						TIME_10MS    	   => time_10ms,
						RESET_N				=>	reset_n,
						SHIP_LEFT			=>	ship_left,
						SHIP_RIGHT			=>	ship_right,				
						SHOOT					=>	shoot,
						SHIP_OUT				=> ship,
						ALIEN_OUT			=> alien,
						BULLET_TIME       => bullet_time,
						ALIEN_TIME        => alien_time,
						ALIEN_STATE			=> alien_state,
						ALIEN_SPEED_OUT	=> alien_speed,
						SCORE_OUT			=> hex_0,
						START					=> start_game,
						GAME_STATUS			=> game_status,
						WIN					=> win
				);
                        
        view : entity work.Space_Invaders_View
                port map (
						CLOCK   			=>	clock,
						RESET_N			=>	reset_n,								
						REDRAW      	=> redraw,
						
						FB_READY       => fb_ready,
						FB_CLEAR       => fb_clear,
						FB_DRAW_RECT   => fb_draw_rect,
						FB_DRAW_LINE   => fb_draw_line,
						FB_FILL_RECT   => fb_fill_rect,
						FB_FLIP        => fb_flip,
						FB_COLOR       => fb_color,
						FB_X0          => fb_x0,
						FB_Y0          => fb_y0,
						FB_X1          => fb_x1,
						FB_Y1          => fb_y1,
						ALIEN_STATE		=> alien_state,
						SHIP_IN			=> ship,
						ALIEN_IN			=> alien,
						
						SPLASH_ENABLE  => start_game,
						
						GAME_STATUS			=> game_status,
						WIN					=> win	
				);                    
        

	timegen : process(CLOCK, RESET_N)
	variable counter : integer range 0 to (500000-1);
	begin	
		
		if (RESET_N = '0') then		
			counter := 0;
			time_10ms <= '0';
		elsif (rising_edge(clock)) then		
		 
			if(counter = counter'high) then
				counter := 0;
				time_10ms <= '1';
			else
				counter := counter+1;
				time_10ms <= '0';
			end if;
			
		end if;
	end process;
	
	
	
	score_display : process(CLOCK, RESET_N)
	variable current_score     : std_logic_vector(11 downto 0);
	begin
		if (RESET_N = '0') then
				HEX0 <="1000000"; 
				HEX1 <="1000000"; 
				HEX2 <="1000000"; 
				HEX3 <="1000000"; 
		
		elsif (rising_edge(CLOCK)) then	
			current_score := std_logic_vector(hex_0);
			
			-- Unità
			case  current_score(3 downto 0) is
				when "0000"=> HEX0 <="1000000";  -- '0'
				when "0001"=> HEX0 <="1111001";  -- '1'
				when "0010"=> HEX0 <="0100100";  -- '2'
				when "0011"=> HEX0 <="0110000";  -- '3'
				when "0100"=> HEX0 <="0011001";  -- '4' 
				when "0101"=> HEX0 <="0010010";  -- '5'
				when "0110"=> HEX0 <="0000010";  -- '6'
				when "0111"=> HEX0 <="1111000";  -- '7'
				when "1000"=> HEX0 <="0000000";  -- '8'
				when "1001"=> HEX0 <="0010000";  -- '9'
				 --nothing is displayed when a number more than 9 is given as input. 
				when others=> HEX0 <="1000000"; 
			end case;
			
			
			-- Decine
			case  current_score(7 downto 4) is
				when "0000"=> HEX1 <="1000000";  -- '0'
				when "0001"=> HEX1 <="1111001";  -- '1'
				when "0010"=> HEX1 <="0100100";  -- '2'
				when "0011"=> HEX1 <="0110000";  -- '3'
				when "0100"=> HEX1 <="0011001";  -- '4' 
				when "0101"=> HEX1 <="0010010";  -- '5'
				when "0110"=> HEX1 <="0000010";  -- '6'
				when "0111"=> HEX1 <="1111000";  -- '7'
				when "1000"=> HEX1 <="0000000";  -- '8'
				when "1001"=> HEX1 <="0010000";  -- '9'
				 --nothing is displayed when a number more than 9 is given as input. 
				when others=> HEX1 <="1000000"; 
			end case;
			
			
			-- Centinaia
			case  current_score(11 downto 8) is
				when "0000"=> HEX2 <="1000000";  -- '0'
				when "0001"=> HEX2 <="1111001";  -- '1'
				when "0010"=> HEX2 <="0100100";  -- '2'
				when "0011"=> HEX2 <="0110000";  -- '3'
				when "0100"=> HEX2 <="0011001";  -- '4' 
				when "0101"=> HEX2 <="0010010";  -- '5'
				when "0110"=> HEX2 <="0000010";  -- '6'
				when "0111"=> HEX2 <="1111000";  -- '7'
				when "1000"=> HEX2 <="0000000";  -- '8'
				when "1001"=> HEX2 <="0010000";  -- '9'
				 --nothing is displayed when a number more than 9 is given as input. 
				when others=> HEX2 <="1000000"; 
			end case;
		end if;
		
		HEX3 <="1000000"; 

	end process;
	
	
end architecture;