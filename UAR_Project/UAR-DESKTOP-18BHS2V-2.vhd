----------------------------------------------------------------------------------
-- Company: UPCT
-- Engineer: Luis Carretero Lopez
-- 
-- Create Date:    22:44:41 05/15/2024 
-- Design Name: 	 
-- Module Name:    UAR - Behavioral 
-- Project Name:   VHDL_Project
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UAR is
    Port ( clk : in  STD_LOGIC; -- 50MHz - 20ns
            reset : in  STD_LOGIC;
            RX_in : in  STD_LOGIC;
            baud_sel : in  STD_LOGIC; -- 0 for 9600 bauds and 1 for 19200 bauds
            RX_data : out  STD_LOGIC_VECTOR (7 downto 0);
            RX_newdata : out  STD_LOGIC;
            RX_error : out  STD_LOGIC);
end UAR;

architecture Behavioral of UAR is
    type FSM_states is (espera, inicio, recibiendo, fin, error);
    signal current_state, next_state : FSM_states;

    signal baudRate_counter, baudRate_counter_limit: unsigned(12 downto 0);
    signal RX_nbits : unsigned(3 downto 0);
    signal reg, RSR : std_logic_vector(7 downto 0);
    signal enable_count: std_logic;


begin
    -- baudRate_counter_limit --> 5208 for 9600 bauds and 2604 for 19200 bauds
	 process(baud_sel)
	 begin
		if baud_sel = '0' then
			baudRate_counter_limit <= "1010001011000"; -- 5208
		else
			baudrate_counter_limit <= "0101000101100"; -- 2604
		end if;
	 end process;
	 

    -- baudRate_counter --> 104.16 us for 9600 bauds and 52.08 us for 19200 bauds
    process(clk, reset)
    begin
        if reset = '1' then
            baudRate_counter <= (others => '0');
        elsif (clk'event and clk = '1') then
            if enable_count = '1' then
                if baudRate_counter = baudRate_counter_limit - 1 then
                    baudRate_counter <= (others => '0');
                else
                    baudRate_counter <= baudRate_counter + 1;
                end if;
            end if;
        end if;
    end process;

    -- receiver counter
    process(clk, reset)
    begin
        if reset = '1' then
            RX_nbits <= (others => '0');
        elsif (clk'event and clk='1') then
            if current_state = recibiendo then
                if RX_nbits = 7 and baudRate_counter = baudRate_counter_limit - 1 then
                    RX_nbits <= (others => '0');
                elsif baudRate_counter = baudRate_counter_limit - 1 then
                    RX_nbits <= RX_nbits + 1;
                end if;
            end if;
        end if;
    end process;

    -- receiver shift register
    process(clk, reset)
    begin
        if reset = '1' then
            reg <= (others => '0');
        elsif (clk'event and clk='1') then
            if (enable_count = '1' and RX_nbits < 7) then
                if baudRate_counter = baudRate_counter_limit - 1 then
                    reg <= RX_in & reg(7 downto 1); -- shift right
                end if;
            end if;
        end if;
    end process;
    
    RSR <= reg;	-- parallel output 

    -- regRX
    process(clk, reset)
    begin
        if reset = '1' then
            RX_data <= (others => '0');
        elsif (clk'event and clk = '1') then
            if current_state = fin then
                RX_data <= RSR;
            end if;
        end if;
    end process;

    -- regRX_newdata
    process(clk, reset)
    begin
        if reset = '1' then
            RX_newdata <= '0';
        elsif (clk'event and clk = '1') then
            if current_state = fin then
                RX_newdata <= '1';
            else
                RX_newdata <= '0';
            end if;
        end if;
    end process;

    -- regRX_error
    process(clk, reset)
    begin
        if reset = '1' then
            RX_error <= '0';
        elsif (clk'event and clk = '1') then
            if current_state = error then
                RX_error <= '1';
            else
                RX_error <= '0';
            end if;
        end if;
    end process;

    -- FSM
    current_state_process: process(clk, reset)
    begin
        if reset = '1' then
            current_state <= espera;
        elsif (clk'event and clk = '1') then
            current_state <= next_state;
        end if;
    end process;

    output_process: process(current_state)
    begin
        case current_state is
            when espera =>      enable_count <= '0';

            when inicio =>      enable_count <= '1';

            when recibiendo =>  enable_count <= '1';

            when fin =>         enable_count <= '0';

            when error =>       enable_count <= '0';
        end case;
		end process;

    next_state_process: process(current_state, RX_in, baudRate_counter, baudRate_counter_limit, RX_nbits)
    begin
        case current_state is
            when espera =>      if RX_in = '0' then
                                    next_state <= inicio;
                                else
                                    next_state <= espera;
                                end if;
                
            when inicio =>      if baudRate_counter = baudRate_counter_limit - 1 then
                                    next_state <= recibiendo;
                                else
                                    next_state <= inicio;
                                end if;

            when recibiendo =>  if RX_nbits = 8 and RX_in = '1' then
                                    next_state <= fin;
                                elsif RX_nbits = 8 and RX_in = '0' then
                                    next_state <= error;
                                else
                                    next_state <= recibiendo;
                                end if;

            when fin =>         next_state <= espera;

            when error =>       if RX_in = '1' then
                                    next_state <= espera;
                                else
                                    next_state <= error;
                                end if; 
        end case;
    end process;


end Behavioral;

