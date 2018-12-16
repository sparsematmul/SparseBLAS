 library ieee;  
 use ieee.std_logic_1164.all;  
 use ieee.std_logic_textio.all;  
 use ieee.numeric_std.all;  
 use std.textio.all;  
 entity tb_IntMatMultCore is  
 end tb_IntMatMultCore;  
 architecture behavior of tb_IntMatMultCore is   
 component IntMatMulCore  
      port(  
           Reset, Clock,      WriteEnable, BufferSel:      in std_logic;  
           WriteAddress: in std_logic_vector (9 downto 0);  
           WriteData:           in std_logic_vector (5 downto 0);  
           ReadAddress:      in std_logic_vector (9 downto 0);  
           ReadEnable:      in std_logic;  
           ReadData:           out std_logic_vector (63 downto 0);  
           DataReady:           out std_logic  
      );  
 end component;        
 signal tb_Reset : std_logic := '0';  
 signal tb_Clock : std_logic := '0';  
 signal tb_BufferSel : std_logic := '0';  
 signal tb_WriteEnable : std_logic := '0';  
 signal tb_WriteAddress : std_logic_vector(9 downto 0) := (others => '0');  
 signal tb_WriteData : std_logic_vector(5 downto 0) := (others => '0');  
 signal tb_ReadEnable : std_logic := '0';  
 signal tb_ReadAddress : std_logic_vector(9 downto 0) := (others => '0');  
 signal tb_DataReady : std_logic;  
 signal tb_ReadData : std_logic_vector(63 downto 0);  
 signal tb_MatrixData1,tb_MatrixData2,tb_MatrixData3,tb_MatrixData4,tb_MatrixData5,tb_MatrixData6: std_logic_vector(5 downto 0); 
 -- Clock period definitions  
 constant period : time := 100 ns;    
 begin  
 -- fpga4student.com FPGA projects, Verilog projects, VHDL projects
      -- Instantiate the Unit Under Test (UUT)  
      uut: IntMatMulCore   
           PORT MAP (  
                Reset                    => tb_Reset,  
                Clock                    => tb_Clock,  
                WriteEnable          => tb_WriteEnable,  
                BufferSel          => tb_BufferSel,  
                WriteAddress     => tb_WriteAddress,  
                WriteData          => tb_WriteData,            
                ReadEnable          => tb_ReadEnable,  
                ReadAddress          => tb_ReadAddress,  
                ReadData               => tb_ReadData,  
                DataReady          => tb_DataReady  
    );  
  -- Test Bench Statements  
      process is       
      begin  
           --while now <= 10000000000000 * period loop  
                tb_Clock <= '0';  
                wait for period/2;  
                tb_Clock <= '1';  
                wait for period/2;  
           --end loop;  
           --wait;  
      end process;  
      process is       
      begin  
           tb_Reset <= '1';  
           wait for 10*period;  
           tb_Reset <= '0';  
           wait;    
      end process;  
      writingA: process is                                
           file FIA: TEXT open READ_MODE is "InputA.txt";  -- the input file must have 17 rows  
           file FIB: TEXT open READ_MODE is "InputB.txt";  -- the input file must have 17 rows  
           variable L: LINE;  
           --signal tb_MatrixData1,tb_MatrixData2,tb_MatrixData3,tb_MatrixData4,tb_MatrixData5,tb_MatrixData6: std_logic_vector(2 downto 0);  
      begin
      	   tb_WriteEnable <= '0';  
           tb_BufferSel <= '1';  
           tb_WriteAddress <= "11"&x"FF";  
           wait for 20*period;
           tb_MatrixData1 <= "100001";
           wait until falling_edge(tb_Clock);
           tb_WriteAddress <= std_logic_vector(unsigned(tb_WriteAddress)+1);
           tb_BufferSel <= '1';
           tb_WriteEnable <= '1';
           tb_WriteData <=tb_MatrixData1;
           tb_MatrixData2 <= "110001";
           wait until falling_edge(tb_Clock);
           tb_WriteAddress <= std_logic_vector(unsigned(tb_WriteAddress)+1);
           tb_BufferSel <= '1';
           tb_WriteEnable <= '1';
           tb_WriteData <=tb_MatrixData2;
           tb_MatrixData3 <= "000100";
           wait until falling_edge(tb_Clock);
           tb_WriteAddress <= std_logic_vector(unsigned(tb_WriteAddress)+1);
           tb_BufferSel <= '1';
           tb_WriteEnable <= '1';
           tb_WriteData <=tb_MatrixData3;
           tb_MatrixData4 <= "100001";
           wait until falling_edge(tb_Clock);
           tb_WriteAddress <= std_logic_vector(unsigned(tb_WriteAddress)+1);
           tb_BufferSel <= '0';
           tb_WriteEnable <= '1';
           tb_WriteData <=tb_MatrixData4;
           tb_MatrixData5 <= "100000";
           wait until falling_edge(tb_Clock);
           tb_WriteAddress <= std_logic_vector(unsigned(tb_WriteAddress)+1);
           tb_BufferSel <= '0';
           tb_WriteEnable <= '1';
           tb_WriteData <=tb_MatrixData5;
           tb_MatrixData6 <= "100111";
           wait until falling_edge(tb_Clock);
           tb_WriteAddress <= std_logic_vector(unsigned(tb_WriteAddress)+1);
           tb_BufferSel <= '0';
           tb_WriteEnable <= '1';
           tb_WriteData <=tb_MatrixData6;
           --READLINE(FIA, L);  
           --while not ENDFILE(FIA) loop  
                --READLINE(FIA, L);            
                --HREAD(L, tb_MatrixData);       
                --wait until falling_edge(tb_Clock);  
                --tb_WriteAddress <= std_logic_vector(unsigned(tb_WriteAddress)+1);  
                --tb_BufferSel <= '1';  
                --tb_WriteEnable <= '1';  
                --tb_WriteData <=tb_MatrixData;  
           --end loop;  
           --READLINE(FIB, L);  
           --while not ENDFILE(FIB) loop  
                --READLINE(FIB, L);            
                --HREAD(L, tb_MatrixData);       
                --wait until falling_edge(tb_Clock);  
                --tb_WriteAddress <= std_logic_vector(unsigned(tb_WriteAddress)+1);  
                --tb_BufferSel <= '0';  
                --tb_WriteEnable <= '1';  
                --tb_WriteData <=tb_MatrixData;  
           --end loop;  
           wait for period;  
           tb_WriteEnable <= '0';            
           wait;   
      end process;       
 -- fpga4student.com FPGA projects, Verilog projects, VHDL projects
      reading: process is                                
           file FO: TEXT open WRITE_MODE is "OutputMultC.txt";  
           file FI: TEXT open READ_MODE is "OutputMultC_matlab.txt";  
           variable L, Lm: LINE;  
           variable v_ReadDatam: std_logic_vector(63 downto 0);  
           variable v_OK: boolean;  
      begin  
           tb_ReadEnable <= '0';  
           tb_ReadAddress <=(others =>'0');  
           ---wait for Mul done       
           wait until rising_edge(tb_DataReady);   
           wait until falling_edge(tb_DataReady);   
           READLINE(FI, Lm);  
           Write(L, STRING'("OutputMultC"));  
           WRITELINE(FO, L);  
           tb_ReadEnable<= '1' ;  
           while not ENDFILE(FI) loop  
                wait until rising_edge(tb_Clock);  
                wait for 20 ns;  
                READLINE(FI, Lm);  
                HREAD(Lm, v_ReadDatam);            
                if v_ReadDatam = tb_ReadData then  
                     v_OK :=True;  
                     report "Matched";  
                else  
                     v_OK :=False;  
                end if;  
                HWRITE(L, '0'& tb_ReadData, Left, 10);  
                WRITE(L, v_OK, Right, 10);                 
                WRITELINE(FO, L);  
                tb_ReadAddress <= std_logic_vector(unsigned(tb_ReadAddress)+1);  
           end loop;  
           tb_ReadEnable <= '0';  
           assert false report "Simulation Finished" severity failure; -- to stop simulation  
           wait;   
      end process;  
 end;  