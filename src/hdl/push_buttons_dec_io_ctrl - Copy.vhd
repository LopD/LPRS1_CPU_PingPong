
----------------------------------------------------------------------------------
-- Logicko projektovanje racunarskih sistema 1
-- 2020
--
-- Input/Output controler for RGB matrix
--
-- authors:
-- Milos Subotic (milos.subotic@uns.ac.rs)
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

library work;

entity push_buttons_dec_io_ctrl is
	port(
		iCLK       : in  std_logic;
		inRST      : in  std_logic;
		iPB_UP     : in  std_logic;
		iPB_DOWN   : in  std_logic;
		iPB_LEFT   : in  std_logic;
		iPB_RIGHT  : in  std_logic;
		iBUS_A     : in  std_logic_vector(7 downto 0);
		oBUS_RD    : out std_logic_vector(15 downto 0);
		iBUS_WD    : in  std_logic_vector(15 downto 0);
		iBUS_WE    : in  std_logic
	);
end entity push_buttons_dec_io_ctrl;

architecture Behavioral of push_buttons_dec_io_ctrl is

	--type tDIR is (NONE, UP, DOWN, LEFT, RIGHT);
	type tDIR is (NONE, UP, DOWN);
	signal sDIR_1 : tDIR;
	signal sDIR_2 : tDIR;
	
	signal sMOVE_PLAYER_1 : std_logic_vector(15 downto 0);
	signal sMOVE_PLAYER_2 : std_logic_vector(15 downto 0);
	signal sMOVE_PLAYER_1_rst : std_logic := '0';
	signal sMOVE_PLAYER_2_rst : std_logic := '0';
	signal sMOVE_PLAYER_1_old : std_logic_vector(15 downto 0) := (others=>'0');
	signal sMOVE_PLAYER_2_old : std_logic_vector(15 downto 0) := (others=>'0');
	

begin
	
--	process(iBUS_A, sMOVE_PLAYER_1, sMOVE_PLAYER_2)
--	begin
--		case iBUS_A is
--			when x"00" =>
--				oBUS_RD <= sMOVE_PLAYER_1;
--			when x"01" =>
--				oBUS_RD <= sMOVE_PLAYER_2;
--			when others =>
--				oBUS_RD <= (others => '0');
--		end case;
--	end process;
	--    		 * up_left
	-- *  down_left     	* up_right
	--	  		 *	down_right


	process(iBUS_A, sMOVE_PLAYER_1, sMOVE_PLAYER_2)
	begin
		case iBUS_A is
			when x"00" =>
				oBUS_RD <= sMOVE_PLAYER_1;
			when x"01" =>
				oBUS_RD <= sMOVE_PLAYER_2;
			when others =>
				oBUS_RD <= (others => '0');
		end case;
	end process;


	
	
	process (iCLK, inRST, iPB_UP, iPB_LEFT)
	begin
		if (inRST = '0') then
			sDIR_1 <= NONE;
		elsif rising_edge(iCLK) then
			if iPB_UP = '1' then
				sDIR_1 <= UP;
			elsif iPB_LEFT = '1' then
				sDIR_1 <= DOWN;
			end if;
		end if;
	end process;
	
	process (iCLK, inRST, sDIR_1) 
	begin
		if (inRST = '0') then
			sMOVE_PLAYER_1 <= conv_std_logic_vector(0, 16);
		elsif rising_edge(iCLK) then
			if sDIR_1 = UP then
				sMOVE_PLAYER_1 <= conv_std_logic_vector(-1, 16);
			elsif sDIR_1 = DOWN then
				sMOVE_PLAYER_1 <= conv_std_logic_vector(1, 16);
			else
				sMOVE_PLAYER_1 <= conv_std_logic_vector(0, 16);
			end if;
		end if;
	end process;
	
	
	--sMOVE_PLAYER_2
	process (iCLK, inRST, iPB_DOWN, iPB_RIGHT) 
	begin
		if (inRST = '0') then
			sMOVE_PLAYER_2 <= (others=>'0');
		elsif rising_edge(iCLK) then
			if iPB_RIGHT = '1' then
				sMOVE_PLAYER_2 <= conv_std_logic_vector(-1, 16);
			elsif iPB_DOWN = '1' then
				sMOVE_PLAYER_2 <= conv_std_logic_vector(1, 16);
			end if;
		end if;
	end process;
	
	
	
	
	
--	--sMOVE_PLAYER_1 
--	process (iCLK, inRST, iPB_UP, iPB_LEFT,sMOVE_PLAYER_1_rst) 
--	begin
--		if (inRST = '0') then
--			sMOVE_PLAYER_1 <= (others=>'0');
--			sMOVE_PLAYER_1_rst <= '0';
--		elsif rising_edge(iCLK) then
--			if (sMOVE_PLAYER_1_rst = '1') then 
--				sMOVE_PLAYER_1 <= conv_std_logic_vector(0, 16);
--				sMOVE_PLAYER_1_rst <= '0';
--			elsif iPB_UP = '1' then
--				sMOVE_PLAYER_1 <= conv_std_logic_vector(-1, 16);
--			elsif iPB_LEFT = '1' then
--				sMOVE_PLAYER_1 <= conv_std_logic_vector(1, 16);
--			end if;
--		end if;
--	end process;
--	
--	--sMOVE_PLAYER_2
--	process (iCLK, inRST, iPB_DOWN, iPB_RIGHT, sMOVE_PLAYER_2_rst) 
--	begin
--		if (inRST = '0') then
--			sMOVE_PLAYER_2 <= (others=>'0');
--			sMOVE_PLAYER_2_rst <= '0';
--		elsif rising_edge(iCLK) then
--			if (sMOVE_PLAYER_2_rst = '1') then
--				sMOVE_PLAYER_2 <= conv_std_logic_vector(0, 16);
--				sMOVE_PLAYER_2_rst <= '0';
--			elsif iPB_RIGHT = '1' then
--				sMOVE_PLAYER_2 <= conv_std_logic_vector(-1, 16);
--			elsif iPB_DOWN = '1' then
--				sMOVE_PLAYER_2 <= conv_std_logic_vector(1, 16);
--			end if;
--		end if;
--	end process;
	
	
	
	
--	--sMOVE_PLAYER_1 
--	process (iCLK, inRST, iPB_UP, iPB_LEFT, sMOVE_PLAYER_1_old) 
--	begin
--		if inRST = '0' then
--			sMOVE_PLAYER_1 <= (others=>'0');
--			sMOVE_PLAYER_1_old <= "00";
--		elsif rising_edge(iCLK) then
--			
--			if iPB_UP = '1' then
--				
--				if (sMOVE_PLAYER_1_old /= "10") then
--					sMOVE_PLAYER_1 <= conv_std_logic_vector(-1, 16);
--					sMOVE_PLAYER_1_old <= "10";
--				else 
--					sMOVE_PLAYER_1 <= conv_std_logic_vector(0, 16);
--					sMOVE_PLAYER_1_old <= "00";
--				end if;
--				
--			elsif iPB_LEFT = '1' then
--				if (sMOVE_PLAYER_1_old /= "01") then
--					sMOVE_PLAYER_1 <= conv_std_logic_vector(1, 16);
--					sMOVE_PLAYER_1_old <= "01";
--				else
--					sMOVE_PLAYER_1 <= conv_std_logic_vector(0, 16);
--					sMOVE_PLAYER_1_old <= "00";
--				end if;
--			end if;
--		end if;
--	end process;
--	
--	--sMOVE_PLAYER_2
--	process (iCLK, inRST, iPB_RIGHT, iPB_DOWn) 
--	begin
--		if inRST = '0' then
--			sMOVE_PLAYER_2 <= (others=>'0');
--		elsif rising_edge(iCLK) then
--			if iPB_RIGHT = '1' then
--				if (sMOVE_PLAYER_2_old /= "10") then
--					sMOVE_PLAYER_2 <= conv_std_logic_vector(-1, 16);
--					sMOVE_PLAYER_2_old <= "10";
--				else
--					sMOVE_PLAYER_2 <= conv_std_logic_vector(0, 16);
--					sMOVE_PLAYER_2_old <= "00";
--				end if;
--			elsif iPB_DOWN = '1' then
--				if (sMOVE_PLAYER_2_old /= "01") then
--					sMOVE_PLAYER_2 <= conv_std_logic_vector(1, 16);
--					sMOVE_PLAYER_2_old <= "01";
--				else 
--					sMOVE_PLAYER_2 <= conv_std_logic_vector(0, 16);
--					sMOVE_PLAYER_2_old <= "00";
--				end if;
--			end if;
--		end if;
--	end process;
	
	
	
	
	
--	process(iCLK, inRST, iPB_UP, iPB_LEFT)
--	begin
--		if inRST = '0' then
--			sDIR_1 <= NONE;
--		elsif rising_edge(iCLK) then
--			if iPB_UP = '1' then
--				sDIR_1 <= UP;
--			elsif iPB_LEFT = '1' then
--				sDIR_1 <= DOWN;
--			end if;
--		end if;
--	end process;
--	
--	process(iCLK, inRST, iPB_RIGHT, iPB_DOWN)
--	begin
--		if inRST = '0' then
--			sDIR_2 <= NONE;
--		elsif rising_edge(iCLK) then
--			if iPB_RIGHT = '1' then
--				sDIR_2 <= UP;
--			elsif iPB_DOWN = '1' then
--				sDIR_2 <= DOWN;
--			end if;
--		end if;
--	end process;
--	
--	process(sDIR_1)
--	begin
--		case sDIR_1 is
--			when NONE =>
--				sMOVE_PLAYER_1 <= conv_std_logic_vector( 0, 16);
--			when UP =>
--				sMOVE_PLAYER_1 <= conv_std_logic_vector(-1, 16);
--			when DOWN =>
--				sMOVE_PLAYER_1 <= conv_std_logic_vector(1, 16);
--		end case;
--	end process;
--	
--	
--	process(sDIR_2)
--	begin
--		case sDIR_2 is
--			when NONE =>
--				sMOVE_PLAYER_2 <= conv_std_logic_vector( 0, 16);
--			when UP =>
--				sMOVE_PLAYER_2 <= conv_std_logic_vector(-1, 16);
--			when DOWN =>
--				sMOVE_PLAYER_2 <= conv_std_logic_vector( 1, 16);
--		end case;
--	end process;
	
end architecture;

----------------------DON'T OVERWRITE THIS SHIT----------------
---------------------THIS IS MY MODIFICATION to push_buttons_dec_io_ctrl.vhd----------------------
--------------------------------------------------------------------------------------------------
