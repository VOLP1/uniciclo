library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;


entity Testbench is
end entity Testbench;

architecture Behavioral of Testbench is
    -- Sinais para teste
    signal clk : std_logic := '0';
    signal reset : std_logic := '1';
    
    -- Per�odo do clock
    constant PERIOD : time := 10 ns;
    
    -- Sinais para monitoramento
    signal pc_output : std_logic_vector(31 downto 0);
    signal instruction : std_logic_vector(31 downto 0);
    signal ula_result : std_logic_vector(31 downto 0);
    signal reg_write_data : std_logic_vector(31 downto 0);

begin
    -- Instancia��o do DUT (Device Under Test)
    DUT: entity work.TopLevel
    port map (
        clk => clk,
        reset => reset,
        pc_out => pc_output,
        instruction_out => instruction,
        ula_result_out => ula_result,
        reg_write_data_out => reg_write_data
    );

    -- Processo de gera��o do clock
    clk_process: process
    begin
	while true loop
        	clk <= '0';
        	wait for PERIOD/2;
        	clk <= '1';
        	wait for PERIOD/2;
	end loop;
    end process;

    reset_process: process
    begin
        reset <= '1'; 
        wait for PERIOD * 2;  
        reset <= '0';  
        wait;  
    end process;

    -- Processo de est�mulo
    stimulus: process
    begin
        -- Reset inicial
        reset <= '1';
        wait for PERIOD;
        reset <= '0';
        
        -- Aguarda algumas instru��es serem executadas
        wait for PERIOD * 10;
        
        -- Adicione aqui verifica��es espec�ficas para seu programa
        
        -- Finaliza a simula��o
        wait;
    end process;

    -- Processo de monitoramento
    monitor: process(clk)
    begin
        if rising_edge(clk) then
            -- Adicione aqui prints ou assertions para verificar o comportamento
            report "PC: " & to_hstring(pc_output);
            report "Instruction: " & to_hstring(instruction);
            report "ULA Result: " & to_hstring(ula_result);
        end if;
    end process;

end architecture Behavioral;