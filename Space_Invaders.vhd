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
					 
                SW                  : in  std_logic_vector(9 downto 9);
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
		  signal ship						: ship_type;
		
		--NAVICELLA
		signal ship_left		: std_logic;
		signal ship_right		: std_logic;
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
		signal redraw       : std_logic;
		
		
		--ALIENI
		signal alien_left_right	: std_logic;
		
		--PROIETTILE

		signal shoot			: std_logic;
				
begin

        pll : entity work.PLL
                port map (
                        inclk0  => CLOCK_50,
                        c0      => clock_vga,
                        c1      => clock
                ); 
        
                                        
--        reset_sync : process(CLOCK_50)
--        begin
--                if (rising_edge(CLOCK_50)) then
--                        reset_sync_reg <= SW(9);
--                        RESET_N <= reset_sync_reg;
--                end if;
--        end process;
        
        
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
        
        
--        controller : entity work.Space_Invaders_Controller
--                port map (
--                        
--                );
                
                
        datapath : entity work.Space_Invaders_Datapath
                port map (
					CLOCK				=>	clock,
					TIME_10MS       => time_10ms, -- Probabilmente andrà nel controller
					RESET_N				=>	reset_n,
					SHIP_LEFT			=>	ship_left,
					SHIP_RIGHT			=>	ship_right,				
					ALIEN_LEFT_RIGHT	=>	alien_left_right,					
					SHOOT				=>	shoot,
					SHIP_OUT			=> ship
                );
                        
        view : entity work.Space_Invaders_View
                port map (
                        CLOCK   		=>	clock,
								RESET_N		=>	reset_n,								
								REDRAW       => redraw,
								
								FB_READY       => fb_ready,
								FB_CLEAR       => fb_clear,
								FB_DRAW_RECT   => fb_draw_rect,
								FB_DRAW_LINE   => fb_draw_line,
								FB_FILL_RECT   => fb_fill_rect,
								FB_COLOR       => fb_color,
								FB_X0          => fb_x0,
								FB_Y0          => fb_y0,
								FB_X1          => fb_x1,
								FB_Y1          => fb_y1,
								
								SHIP_IN			=> ship
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
	
	
end architecture;