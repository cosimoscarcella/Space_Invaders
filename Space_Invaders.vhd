library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
--use work.tetris_package.all;
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
		
		--NAVICELLA
		signal ship_left		: std_logic;
		signal ship_right		: std_logic;
		signal ship_en			: std_logic;
		
		--ALIENI
		signal alien_en_x		: std_logic;
		signal alien_en_y		: std_logic;
		signal alien_left_right	: std_logic;
		
		--PROIETTILE
		signal shoot_en_y		: std_logic;
		signal shoot_load		: std_logic;
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
        
        
--        vga : entity work.VGA_Framebuffer
--                port map (
--                        CLOCK     => clock_vga,
--                        RESET_N   => RESET_N,
--                        READY     => fb_ready,
--                        COLOR     => fb_color,
--                        CLEAR     => fb_clear,
--                        DRAW_RECT => fb_draw_rect,
--                        FILL_RECT => fb_fill_rect,
--                        DRAW_LINE => fb_draw_line,
--                        FLIP      => fb_flip,   
--                        X0        => fb_x0,
--                        Y0        => fb_y0,
--                        X1        => fb_x1,
--                        Y1        => fb_y1,
--                                
--                        VGA_R     => VGA_R,
--                        VGA_G     => VGA_G,
--                        VGA_B     => VGA_B,
--                        VGA_HS    => VGA_HS,
--                        VGA_VS    => VGA_VS,
--                
--                        SRAM_ADDR => SRAM_ADDR,
--                        SRAM_DQ   => SRAM_DQ,                   
--                        SRAM_CE_N => SRAM_CE_N,
--                        SRAM_OE_N => SRAM_OE_N,
--                        SRAM_WE_N => SRAM_WE_N,
--                        SRAM_UB_N => SRAM_UB_N,
--                        SRAM_LB_N => SRAM_LB_N
--                );
        
        
--        controller : entity work.Space_Invaders_Controller
--                port map (
--                        
--                );
                
                
        datapath : entity work.Space_Invaders_Datapath
                port map (
					CLOCK				=>	clock,
					DATAPATH_RESET				=>	datapath_reset,
					SHIP_LEFT			=>	ship_left,
					SHIP_RIGHT			=>	ship_right,
					SHIP_EN				=>	ship_en,
					ALIEN_EN_X			=>	alien_en_x,
					ALIEN_EN_Y			=>	alien_en_y,
					ALIEN_LEFT_RIGHT	=>	alien_left_right,
					SHOOT_EN_Y			=>	shoot_en_y,
					SHOOT_LOAD			=>	shoot_load,
					SHOOT				=>	shoot                
                );
                        
--        view : entity work.Tetris_View
--                port map (
--                        
--                );                      
        
         
end architecture;