library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity TopLevel is
port (
    clk : in std_logic;
    reset : in std_logic;
    -- Sinais para debug/monitoramento
    pc_out : out std_logic_vector(31 downto 0);
    instruction_out : out std_logic_vector(31 downto 0);
    ula_result_out : out std_logic_vector(31 downto 0);
    reg_write_data_out : out std_logic_vector(31 downto 0);
    
    -- Saídas de todos os registradores para visualização no waveform
    reg_zero_out : out std_logic_vector(31 downto 0); -- x0
    reg_ra_out : out std_logic_vector(31 downto 0);   -- x1
    reg_sp_out : out std_logic_vector(31 downto 0);   -- x2
    reg_gp_out : out std_logic_vector(31 downto 0);   -- x3
    reg_tp_out : out std_logic_vector(31 downto 0);   -- x4
    reg_t0_out : out std_logic_vector(31 downto 0);   -- x5
    reg_t1_out : out std_logic_vector(31 downto 0);   -- x6
    reg_t2_out : out std_logic_vector(31 downto 0);   -- x7
    reg_s0_out : out std_logic_vector(31 downto 0);   -- x8
    reg_s1_out : out std_logic_vector(31 downto 0);   -- x9
    reg_a0_out : out std_logic_vector(31 downto 0);   -- x10
    reg_a1_out : out std_logic_vector(31 downto 0);   -- x11
    reg_a2_out : out std_logic_vector(31 downto 0);   -- x12
    reg_a3_out : out std_logic_vector(31 downto 0);   -- x13
    reg_a4_out : out std_logic_vector(31 downto 0);   -- x14
    reg_a5_out : out std_logic_vector(31 downto 0);   -- x15
    reg_a6_out : out std_logic_vector(31 downto 0);   -- x16
    reg_a7_out : out std_logic_vector(31 downto 0);   -- x17
    reg_s2_out : out std_logic_vector(31 downto 0);   -- x18
    reg_s3_out : out std_logic_vector(31 downto 0);   -- x19
    reg_s4_out : out std_logic_vector(31 downto 0);   -- x20
    reg_s5_out : out std_logic_vector(31 downto 0);   -- x21
    reg_s6_out : out std_logic_vector(31 downto 0);   -- x22
    reg_s7_out : out std_logic_vector(31 downto 0);   -- x23
    reg_s8_out : out std_logic_vector(31 downto 0);   -- x24
    reg_s9_out : out std_logic_vector(31 downto 0);   -- x25
    reg_s10_out : out std_logic_vector(31 downto 0);  -- x26
    reg_s11_out : out std_logic_vector(31 downto 0);  -- x27
    reg_t3_out : out std_logic_vector(31 downto 0);   -- x28
    reg_t4_out : out std_logic_vector(31 downto 0);   -- x29
    reg_t5_out : out std_logic_vector(31 downto 0);   -- x30
    reg_t6_out : out std_logic_vector(31 downto 0)    -- x31
);
end entity TopLevel;

architecture Behavioral of TopLevel is
    -- Componentes
    component pc is
        port ( 
            clk : in std_logic;
            input : in std_logic_vector(31 downto 0);
            output : out std_logic_vector(31 downto 0)
        );
    end component;

    component rom is
        port(
            address: in std_logic_vector(9 downto 0);
            dataout: out std_logic_vector(31 downto 0)
        );
    end component;

    component breg is
        port (
            clk : in std_logic;
            writeEnable : in std_logic;
            select_rs1 : in std_logic_vector(4 downto 0);
            select_rs2 : in std_logic_vector(4 downto 0);
            select_rd : in std_logic_vector(4 downto 0);
            write_data : in std_logic_vector(31 downto 0);
            output_rs1 : out std_logic_vector(31 downto 0);
            output_rs2 : out std_logic_vector(31 downto 0);
            
            -- Sinais de todos os registradores
            reg_zero_out : out std_logic_vector(31 downto 0);
            reg_ra_out : out std_logic_vector(31 downto 0);
            reg_sp_out : out std_logic_vector(31 downto 0);
            reg_gp_out : out std_logic_vector(31 downto 0);
            reg_tp_out : out std_logic_vector(31 downto 0);
            reg_t0_out : out std_logic_vector(31 downto 0);
            reg_t1_out : out std_logic_vector(31 downto 0);
            reg_t2_out : out std_logic_vector(31 downto 0);
            reg_s0_out : out std_logic_vector(31 downto 0);
            reg_s1_out : out std_logic_vector(31 downto 0);
            reg_a0_out : out std_logic_vector(31 downto 0);
            reg_a1_out : out std_logic_vector(31 downto 0);
            reg_a2_out : out std_logic_vector(31 downto 0);
            reg_a3_out : out std_logic_vector(31 downto 0);
            reg_a4_out : out std_logic_vector(31 downto 0);
            reg_a5_out : out std_logic_vector(31 downto 0);
            reg_a6_out : out std_logic_vector(31 downto 0);
            reg_a7_out : out std_logic_vector(31 downto 0);
            reg_s2_out : out std_logic_vector(31 downto 0);
            reg_s3_out : out std_logic_vector(31 downto 0);
            reg_s4_out : out std_logic_vector(31 downto 0);
            reg_s5_out : out std_logic_vector(31 downto 0);
            reg_s6_out : out std_logic_vector(31 downto 0);
            reg_s7_out : out std_logic_vector(31 downto 0);
            reg_s8_out : out std_logic_vector(31 downto 0);
            reg_s9_out : out std_logic_vector(31 downto 0);
            reg_s10_out : out std_logic_vector(31 downto 0);
            reg_s11_out : out std_logic_vector(31 downto 0);
            reg_t3_out : out std_logic_vector(31 downto 0);
            reg_t4_out : out std_logic_vector(31 downto 0);
            reg_t5_out : out std_logic_vector(31 downto 0);
            reg_t6_out : out std_logic_vector(31 downto 0)
        );
    end component;

    component ulaRV is
        port (
            opcode : in std_logic_vector(3 downto 0);
            A, B : in std_logic_vector(31 downto 0);
            Z : out std_logic_vector(31 downto 0);
            zero : out std_logic
        );
    end component;

    component ram is
        port (
            clock : in std_logic;
            we : in std_logic;
            address : in std_logic_vector(9 downto 0);
            datain : in std_logic_vector(31 downto 0);
            dataout : out std_logic_vector(31 downto 0)
        );
    end component;

    component bloco_controle is
        port (
            opcode : in std_logic_vector(6 downto 0);
            branch : out std_logic;
            memRead : out std_logic;
            memToReg : out std_logic;
            aluOP : out std_logic_vector(2 downto 0);
            memWrite : out std_logic;
            aluSrc : out std_logic;
            regWrite : out std_logic;
            is_LUI : out std_logic;
            is_AUIPC : out std_logic;
            is_JALX : out std_logic;
            is_JALR : out std_logic
        );
    end component;

    component controle_ULA is
        port (
            aluOP : in std_logic_vector(2 downto 0);
            func3 : in std_logic_vector(2 downto 0);
            func7 : in std_logic;
            ULA_control : out std_logic_vector(3 downto 0)
        );
    end component;

    component genImm32 is
        port (
            instr : in std_logic_vector(31 downto 0);
            imm32 : out std_logic_vector(31 downto 0)
        );
    end component;

    component mux_2to1 is
        port (
            sel : in std_logic;
            A : in std_logic_vector(31 downto 0);
            B : in std_logic_vector(31 downto 0);
            X : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Sinais internos
    signal pc_input : std_logic_vector(31 downto 0);
    signal pc_output : std_logic_vector(31 downto 0);
    signal instruction : std_logic_vector(31 downto 0);
    signal reg_write_data : std_logic_vector(31 downto 0);
    signal rs1_data, rs2_data : std_logic_vector(31 downto 0);
    signal immediate : std_logic_vector(31 downto 0);
    signal ula_A, ula_B : std_logic_vector(31 downto 0);
    signal ula_result : std_logic_vector(31 downto 0);
    signal ula_zero : std_logic;
    signal mem_data_out : std_logic_vector(31 downto 0);
    signal ula_ctrl : std_logic_vector(3 downto 0);
    
    -- Sinais de controle
    signal branch, memRead, memToReg, memWrite, aluSrc, regWrite : std_logic;
    signal aluOP : std_logic_vector(2 downto 0);
    signal is_LUI, is_AUIPC, is_JALX, is_JALR : std_logic;
    
    -- Novo sinal para controle de branch
    signal branch_taken : std_logic;

begin
    -- Instanciação do PC
    pc_inst: pc port map (
        clk => clk,
        input => pc_input,
        output => pc_output
    );

    -- Instanciação da ROM
    rom_inst: rom port map (
        address => pc_output(11 downto 2),
        dataout => instruction
    );

    -- Instanciação do Banco de Registradores com os sinais adicionais
    breg_inst: breg port map (
        clk => clk,
        writeEnable => regWrite,
        select_rs1 => instruction(19 downto 15),
        select_rs2 => instruction(24 downto 20),
        select_rd => instruction(11 downto 7),
        write_data => reg_write_data,
        output_rs1 => rs1_data,
        output_rs2 => rs2_data,
        
        -- Conectando todos os registradores às saídas
        reg_zero_out => reg_zero_out,
        reg_ra_out => reg_ra_out,
        reg_sp_out => reg_sp_out,
        reg_gp_out => reg_gp_out,
        reg_tp_out => reg_tp_out,
        reg_t0_out => reg_t0_out,
        reg_t1_out => reg_t1_out,
        reg_t2_out => reg_t2_out,
        reg_s0_out => reg_s0_out,
        reg_s1_out => reg_s1_out,
        reg_a0_out => reg_a0_out,
        reg_a1_out => reg_a1_out,
        reg_a2_out => reg_a2_out,
        reg_a3_out => reg_a3_out,
        reg_a4_out => reg_a4_out,
        reg_a5_out => reg_a5_out,
        reg_a6_out => reg_a6_out,
        reg_a7_out => reg_a7_out,
        reg_s2_out => reg_s2_out,
        reg_s3_out => reg_s3_out,
        reg_s4_out => reg_s4_out,
        reg_s5_out => reg_s5_out,
        reg_s6_out => reg_s6_out,
        reg_s7_out => reg_s7_out,
        reg_s8_out => reg_s8_out,
        reg_s9_out => reg_s9_out,
        reg_s10_out => reg_s10_out,
        reg_s11_out => reg_s11_out,
        reg_t3_out => reg_t3_out,
        reg_t4_out => reg_t4_out,
        reg_t5_out => reg_t5_out,
        reg_t6_out => reg_t6_out
    );

    -- Gerador de imediato
    imm_gen: genImm32 port map (
        instr => instruction,
        imm32 => immediate
    );

    -- Multiplexador para entrada B da ULA
    mux_ula: mux_2to1 port map (
        sel => aluSrc,
        A => rs2_data,
        B => immediate,
        X => ula_B
    );

    -- ULA
    ula_inst: ulaRV port map (
        opcode => ula_ctrl,
        A => rs1_data,
        B => ula_B,
        Z => ula_result,
        zero => ula_zero
    );

    -- Memória de Dados (RAM)
    ram_inst: ram port map (
        clock => clk,
        we => memWrite,
        address => ula_result(11 downto 2),
        datain => rs2_data,
        dataout => mem_data_out
    );

    -- Unidade de Controle
    control_inst: bloco_controle port map (
        opcode => instruction(6 downto 0),
        branch => branch,
        memRead => memRead,
        memToReg => memToReg,
        aluOP => aluOP,
        memWrite => memWrite,
        aluSrc => aluSrc,
        regWrite => regWrite,
        is_LUI => is_LUI,
        is_AUIPC => is_AUIPC,
        is_JALX => is_JALX,
        is_JALR => is_JALR
    );

    -- Controle da ULA
    ula_ctrl_inst: controle_ULA port map (
        aluOP => aluOP,
        func3 => instruction(14 downto 12),
        func7 => instruction(30),
        ULA_control => ula_ctrl
    );

    -- Lógica para determinar se um branch deve ser tomado
    branch_taken <= '1' when (branch = '1' and 
                             ((instruction(14 downto 12) = "000" and ula_zero = '1') or           -- BEQ
                              (instruction(14 downto 12) = "001" and ula_zero = '0') or           -- BNE
                              (instruction(14 downto 12) = "100" and ula_result(0) = '1') or      -- BLT
                              (instruction(14 downto 12) = "101" and ula_result(0) = '0') or      -- BGE
                              (instruction(14 downto 12) = "110" and ula_result(0) = '1') or      -- BLTU
                              (instruction(14 downto 12) = "111" and ula_result(0) = '0')))       -- BGEU
                    else '0';

    -- Lógica para próximo PC
    pc_input <= (others => '0') when reset = '1' else
              std_logic_vector(unsigned(rs1_data) + unsigned(immediate)) when (is_JALR = '1') else
              std_logic_vector(unsigned(pc_output) + unsigned(immediate)) when (is_JALX = '1') else
              std_logic_vector(unsigned(pc_output) + unsigned(immediate)) when branch_taken = '1' else
              std_logic_vector(unsigned(pc_output) + 4);

    -- Multiplexador para escrita no banco de registradores
    reg_write_data <= mem_data_out when memToReg = '1' else ula_result;

    -- Sinais de monitoramento
    pc_out <= pc_output;
    instruction_out <= instruction;
    ula_result_out <= ula_result;
    reg_write_data_out <= reg_write_data;

end architecture Behavioral;
