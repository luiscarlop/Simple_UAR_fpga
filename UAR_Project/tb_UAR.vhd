--------------------------------------------------------------------------------
-- Company: UPCT
-- Engineer: Luis Carretero Lopez
--
-- Create Date:   00:14:12 05/16/2024
-- Design Name:   
-- Module Name:   C:/Users/Luiso/OneDrive/Escritorio/VHDL/UAR_Project/tb_UAR.vhd
-- Project Name:  UAR_Project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: UAR
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY tb_UAR IS
END tb_UAR;
 
ARCHITECTURE behavior OF tb_UAR IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT UAR
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         RX_in : IN  std_logic;
         baud_sel : IN  std_logic;
         RX_data : OUT  std_logic_vector(7 downto 0);
         RX_newdata : OUT  std_logic;
         RX_error : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal RX_in : std_logic := '1';
   signal baud_sel : std_logic := '0';

 	--Outputs
   signal RX_data : std_logic_vector(7 downto 0);
   signal RX_newdata : std_logic;
   signal RX_error : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: UAR PORT MAP (
          clk => clk,
          reset => reset,
          RX_in => RX_in,
          baud_sel => baud_sel,
          RX_data => RX_data,
          RX_newdata => RX_newdata,
          RX_error => RX_error
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin	
	
		reset <= '1';
      -- hold reset state for 100 ns.
      wait for 100 ns;
		reset <= '0';
		
		
		-- Test 1 -- Check reception at 9600 bauds and first data bit is 1
		baud_sel <= '0';
		wait for 1 ms;
		
		RX_in <= '0';  -- 1
		wait for 104160 ns;

		RX_in <= '1'; -- 2
		wait for 104160 ns;
		
		RX_in <= '1'; -- 3
		wait for 104160 ns;

		RX_in <= '0'; -- 4
		wait for 104160 ns;
		
		RX_in <= '1'; -- 5
		wait for 104160 ns;
		
		RX_in <= '0'; -- 6
		wait for 104160 ns;
		
		RX_in <= '0'; -- 7
		wait for 104160 ns;
		
		RX_in <= '1'; -- 8
		wait for 104160 ns;
		
		RX_in <= '0'; -- 9
		wait for 104160 ns;
		
		RX_in <= '1'; -- 10
		wait for 10 ms;

      -- Test 2 -- check reception at 19200 bauds and first data bit is 0
      baud_sel <= '1';

      wait for 1 ms;

      RX_in <= '0';  -- 1
      wait for 52080 ns;

      RX_in <= '0'; -- 2
      wait for 52080 ns;

      RX_in <= '1'; -- 3
      wait for 52080 ns;

      RX_in <= '0'; -- 4
      wait for 52080 ns;

      RX_in <= '1'; -- 5
      wait for 52080 ns;

      RX_in <= '0'; -- 6
      wait for 52080 ns;

      RX_in <= '0'; -- 7
      wait for 52080 ns;

      RX_in <= '0'; -- 8
      wait for 52080 ns;

      RX_in <= '0'; -- 9
      wait for 52080 ns;

      RX_in <= '1'; -- 10

      wait for 10 ms;

      -- Test 3 -- check state 'error' if EOT bit is 0
      baud_sel <= '0';
      wait for 1 ms;

      RX_in <= '0';  -- 1
      wait for 104160 ns;

      RX_in <= '1'; -- 2
      wait for 104160 ns;

      RX_in <= '1'; -- 3
      wait for 104160 ns;

      RX_in <= '0'; -- 4
      wait for 104160 ns;

      RX_in <= '1'; -- 5
      wait for 104160 ns;

      RX_in <= '0'; -- 6
      wait for 104160 ns;

      RX_in <= '0'; -- 7
      wait for 104160 ns;

      RX_in <= '0'; -- 8
      wait for 104160 ns;

      RX_in <= '0'; -- 9
      wait for 104160 ns;

      RX_in <= '0'; -- 10

      wait for 5 ms;
      RX_in <= '1';

      -- Test 4 -- check behavioral if baud_sel is changed during reception
      wait for 2 ms;
      baud_sel <= '1';

      wait for 1 ms;
      RX_in <= '0';  -- 1
      wait for 52080 ns;

      RX_in <= '1'; -- 2
      wait for 52080 ns;

      RX_in <= '1'; -- 3
      wait for 52080 ns;
      
      RX_in <= '0'; -- 4
      baud_sel <= '0';
      wait for 52080 ns;

      RX_in <= '1'; -- 5
      wait for 52080 ns;

      RX_in <= '0'; -- 6
      wait for 52080 ns;

      RX_in <= '1'; -- 7
      wait for 52080 ns;

      RX_in <= '0'; -- 8
      wait for 52080 ns;

      RX_in <= '0'; -- 9
      wait for 52080 ns;

      RX_in <= '1'; -- 10



      -- insert stimulus here 

      wait;
   end process;

END;
