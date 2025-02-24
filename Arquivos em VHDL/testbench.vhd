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
    
    -- Período do clock
    constant PERIOD : time := 10 ns;
    
    -- Sinais para monitoramento básico
    signal pc_output : std_logic_vector(31 downto 0);
    signal instruction : std_logic_vector(31 downto 0);
    signal ula_result : std_logic_vector(31 downto 0);
    signal reg_write_data : std_logic_vector(31 downto 0);
    
    -- Sinais para todos os registradores
    signal reg_zero : std_logic_vector(31 downto 0); -- x0
    signal reg_ra : std_logic_vector(31 downto 0);   -- x1
    signal reg_sp : std_logic_vector(31 downto 0);   -- x2
    signal reg_gp : std_logic_vector(31 downto 0);   -- x3
    signal reg_tp : std_logic_vector(31 downto 0);   -- x4
    signal reg_t0 : std_logic_vector(31 downto 0);   -- x5
    signal reg_t1 : std_logic_vector(31 downto 0);   -- x6
    signal reg_t2 : std_logic_vector(31 downto 0);   -- x7
    signal reg_s0 : std_logic_vector(31 downto 0);   -- x8
    signal reg_s1 : std_logic_vector(31 downto 0);   -- x9
    signal reg_a0 : std_logic_vector(31 downto 0);   -- x10
    signal reg_a1 : std_logic_vector(31 downto 0);   -- x11
    signal reg_a2 : std_logic_vector(31 downto 0);   -- x12
    signal reg_a3 : std_logic_vector(31 downto 0);   -- x13
    signal reg_a4 : std_logic_vector(31 downto 0);   -- x14
    signal reg_a5 : std_logic_vector(31 downto 0);   -- x15
    signal reg_a6 : std_logic_vector(31 downto 0);   -- x16
    signal reg_a7 : std_logic_vector(31 downto 0);   -- x17
    signal reg_s2 : std_logic_vector(31 downto 0);   -- x18
    signal reg_s3 : std_logic_vector(31 downto 0);   -- x19
    signal reg_s4 : std_logic_vector(31 downto 0);   -- x20
    signal reg_s5 : std_logic_vector(31 downto 0);   -- x21
    signal reg_s6 : std_logic_vector(31 downto 0);   -- x22
    signal reg_s7 : std_logic_vector(31 downto 0);   -- x23
    signal reg_s8 : std_logic_vector(31 downto 0);   -- x24
    signal reg_s9 : std_logic_vector(31 downto 0);   -- x25
    signal reg_s10 : std_logic_vector(31 downto 0);  -- x26
    signal reg_s11 : std_logic_vector(31 downto 0);  -- x27
    signal reg_t3 : std_logic_vector(31 downto 0);   -- x28
    signal reg_t4 : std_logic_vector(31 downto 0);   -- x29
    signal reg_t5 : std_logic_vector(31 downto 0);   -- x30
    signal reg_t6 : std_logic_vector(31 downto 0);   -- x31
    
begin
    -- Instanciação do DUT (Device Under Test)
    DUT: entity work.TopLevel
    port map (
        clk => clk,
        reset => reset,
        pc_out => pc_output,
        instruction_out => instruction,
        ula_result_out => ula_result,
        reg_write_data_out => reg_write_data,
        
        -- Conectando todos os registradores
        reg_zero_out => reg_zero,
        reg_ra_out => reg_ra,
        reg_sp_out => reg_sp,
        reg_gp_out => reg_gp,
        reg_tp_out => reg_tp,
        reg_t0_out => reg_t0,
        reg_t1_out => reg_t1,
        reg_t2_out => reg_t2,
        reg_s0_out => reg_s0,
        reg_s1_out => reg_s1,
        reg_a0_out => reg_a0,
        reg_a1_out => reg_a1,
        reg_a2_out => reg_a2,
        reg_a3_out => reg_a3,
        reg_a4_out => reg_a4,
        reg_a5_out => reg_a5,
        reg_a6_out => reg_a6,
        reg_a7_out => reg_a7,
        reg_s2_out => reg_s2,
        reg_s3_out => reg_s3,
        reg_s4_out => reg_s4,
        reg_s5_out => reg_s5,
        reg_s6_out => reg_s6,
        reg_s7_out => reg_s7,
        reg_s8_out => reg_s8,
        reg_s9_out => reg_s9,
        reg_s10_out => reg_s10,
        reg_s11_out => reg_s11,
        reg_t3_out => reg_t3,
        reg_t4_out => reg_t4,
        reg_t5_out => reg_t5,
        reg_t6_out => reg_t6
    );
    
    -- Processo de geração do clock
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for PERIOD/2;
            clk <= '1';
            wait for PERIOD/2;
        end loop;
    end process;
    
    -- Processo de reset
    reset_process: process
    begin
        reset <= '1'; 
        wait for PERIOD * 2;  
        reset <= '0';  
        wait;  
    end process;
    
    -- Processo de estímulo
    stimulus: process
    begin
        -- Aguarda algumas instruções serem executadas
        wait for PERIOD * 100;  -- Executa por mais tempo para ver mudanças nos registradores
        
        -- Finaliza a simulação
        wait;
    end process;
    
    -- Processo de monitoramento (opcional para debug)
    monitor: process(clk)
    begin
        if rising_edge(clk) then
            report "PC: " & to_hstring(pc_output);
            report "Instrução: " & to_hstring(instruction);
            
            -- Pode-se adicionar mais logs, mas não é necessário já que estamos visualizando 
            -- no gráfico de forma de onda
        end if;
    end process;
    
end architecture Behavioral;
