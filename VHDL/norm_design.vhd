library ieee;   
 use ieee.std_logic_1164.all;   
 use ieee.numeric_std.all;  
 use IEEE.STD_LOGIC_UNSIGNED.ALL;  
 -- Required entity declaration  
 entity IntMatMulCore is  
      port(  
           Reset, Clock,      WriteEnable, BufferSel:      in std_logic;  
           WriteAddress: in std_logic_vector (9 downto 0);  
           WriteData:           in std_logic_vector (5 downto 0);  
           ReadAddress:      in std_logic_vector (9 downto 0);  
           ReadEnable:      in std_logic;  
           ReadData:           out std_logic_vector (63 downto 0);  
           DataReady:           out std_logic  
      );  
 end IntMatMulCore;  
 architecture IntMatMulCore_arch of IntMatMulCore is  
 -- fpga4student.com FPGA projects, Verilog projects, VHDL projects 
 COMPONENT dpram1024x16  
  PORT (  
   clka : IN STD_LOGIC;  
   wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);  
   addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);  
   dina : IN STD_LOGIC_VECTOR(5 DOWNTO 0);  
   clkb : IN STD_LOGIC;  
       enb : IN STD_LOGIC;  
   addrb : IN STD_LOGIC_VECTOR(9 DOWNTO 0);  
   doutb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)  
  );  
 END COMPONENT;  
 -- fpga4student.com FPGA projects, Verilog projects, VHDL projects 
 COMPONENT dpram1024x64  
  PORT (  
   clka : IN STD_LOGIC;  
   wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);  
   addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);  
   dina : IN STD_LOGIC_VECTOR(35 DOWNTO 0);  
   clkb : IN STD_LOGIC;  
   enb : IN STD_LOGIC;  
   addrb : IN STD_LOGIC_VECTOR(9 DOWNTO 0);  
   doutb : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)  
  );  
 END COMPONENT;  
 -- fpga4student.com FPGA projects, Verilog projects, VHDL projects
 type     stateType is (stIdle, stWriteBufferA, stWriteBufferB, stReadBufferAB, stSaveData, stWriteBufferC, stComplete);  
 signal presState: stateType;  
 signal nextState: stateType;  
 signal iReadEnableAB, iCountReset,iCountEnable, iCountEnableAB,iCountResetAB: std_logic;  
 signal iWriteEnableA, iWriteEnableB, iWriteEnableC: std_logic_vector(0 downto 0);  
 signal iReadDataA, iReadDataB: std_logic_vector (15 downto 0);  
 signal iWriteDataC: std_logic_vector (35 downto 0);  
 signal iCount, iReadAddrA, iReadAddrB,iRowA : unsigned(9 downto 0);  
 signal CountAT,CountBT:unsigned(9 downto 0);  
 signal iColB:unsigned(19 downto 0);  
 signal irow,icol,iCountA,iCountB: unsigned(4 downto 0);  
 signal iCountEnableAB_d1,iCountEnableAB_d2,iCountEnableAB_d3: std_logic;  
 begin  
      --Write Enable for RAM A   
      iWriteEnableA(0) <= WriteEnable and BufferSel;  
      --Write Enable for RAM B  
      iWriteEnableB(0) <= WriteEnable and (not BufferSel); 
 -- fpga4student.com FPGA projects, Verilog projects, VHDL projects 
      --Input Buffer A Instance  
           InputBufferA : dpram1024x16  
           PORT MAP (  
                clka => Clock,  
                wea  => iWriteEnableA,  
                addra => WriteAddress,  
                dina => WriteData,  
                clkb      => Clock,  
                enb     => iReadEnableAB,  
                addrb => std_logic_vector(iReadAddrA),  
                doutb => iReadDataA  
           );  
 -- fpga4student.com FPGA projects, Verilog projects, VHDL projects
      InputBufferB : dpram1024x16  
           PORT MAP (  
                clka => Clock,  
                wea  => iWriteEnableB,  
                addra => WriteAddress,  
                dina => WriteData,  
                clkb      => Clock,  
                enb     => iReadEnableAB,  
                addrb => std_logic_vector(iReadAddrB),  
                doutb => iReadDataB  
           );  
 -- fpga4student.com FPGA projects, Verilog projects, VHDL projects
      OutputBufferC : dpram1024x64  
           PORT MAP (  
                clka      => Clock,  
                wea      => iWriteEnableC,  
                addra => std_logic_vector(iCount),  
                dina      => iWriteDataC,  
                clkb      => Clock,  
                enb      => ReadEnable,  
                addrb => ReadAddress,  
                doutb => ReadData  
           );  
      process(Clock,Reset)  
      begin  
      if(rising_edge(Clock)) then  
      if(Reset='1') then  
      iCountEnableAB_d1 <= '0';  
      iCountEnableAB_d2 <= '0';  
      else  
      iCountEnableAB_d1 <= iCountEnable;  
      iCountEnableAB_d2 <= iCountEnableAB_d1;  
      end if;  
      end if;  
      end process;  
      iCountEnableAB_d3 <= (not iCountEnableAB_d2) AND iCountEnableAB_d1 ;  
 -- fpga4student.com FPGA projects, Verilog projects, VHDL projects
      process (Clock)  
      begin  
           if rising_edge (Clock) then  
                if(Reset='1') then  
                     iWriteDataC <= (others => '0');  
                elsif(iWriteEnableC(0)='1') then  
                     iWriteDataC <= (others => '0');  
                elsif(iCountEnableAB_d3='1') then  
                     iWriteDataC <= (others => '0');  
                elsif(iReadEnableAB='1') then   
                     iWriteDataC <= iWriteDataC + std_logic_vector(signed(iReadDataA(15)&iReadDataA)*signed(iReadDataB(15)&iReadDataB));       
                end if;   
           end if;   
      end process;  
 -- fpga4student.com FPGA projects, Verilog projects, VHDL projects
       process (Clock)  
      begin  
           if rising_edge (Clock) then  
                if Reset = '1' then  
                     presState <= stIdle;  
                     iCountA <= (others=>'0');  
                     iCountB <= (others=>'0');  
                else  
                     presState <= nextState;  
                     if iCountResetAB = '1' then  
                          iCountA <= (others=>'0');  
                          iCountB <= (others=>'0');  
                     elsif iCountEnableAB = '1' then  
                          iCountA <= iCountA + 1;  
                          iCountB <= iCountB + 1;  
                     end if;  
                end if;  
                if iCountReset = '1' then  
                     iCount <= (others=>'0');  
                elsif iCountEnable = '1' then  
                     iCount <= iCount + 1;  
                end if;  
           end if;  
      end process;  
      iRowA <= iCount srl 5;  
      iColB <= ("0000000000"&iCount) - iRowA*32;  
      irow <= iRowA(4 downto 0);  
      icol <= iColB(4 downto 0);  
      CountAT <= "00000"&iCountA;  
      CountBT <= "00000"&iCountB;  
      iReadAddrA <= (iRowA sll 5)+CountAT;  
      iReadAddrB <= (CountBT sll 5)+ iColB(9 downto 0);  
 -- fpga4student.com FPGA projects, Verilog projects, VHDL projects
      process (presState, WriteEnable, BufferSel, iCount, iCountA, iCountB)  
      begin  
           -- signal defaults  
           iCountResetAB <= '0';  
           iCountReset <= '0';  
           iCountEnable <= '1';  
           iReadEnableAB <= '0';   
           iWriteEnableC(0) <= '0';  
           Dataready <= '0';  
           iCountEnableAB <= '0';  
           case presState is  
                when stIdle =>       
                     if (WriteEnable = '1' and BufferSel = '1') then  
                          nextState <= stWriteBufferA;  
                     else  
                          iCountReset <= '1';  
                          nextState <= stIdle;  
                     end if;  
                when stWriteBufferA =>  
                     if iCount = x"3FF" then  
                          report "Writing A";  
                          iCountReset <= '1';                      
                          nextState <= stWriteBufferB;  
                      else  
                          nextState <= stWriteBufferA;  
                     end if;  
                when stWriteBufferB =>  
                     report "Writing B";  
                     if iCount = x"3FF" then  
                          iCountReset <= '1';                      
                          nextState <= stReadBufferAB;  
                      else  
                          nextState <= stWriteBufferB;  
                     end if;  
                when stReadBufferAB =>  
                     iReadEnableAB <= '1';  
                     iCountEnable <= '0';  
                     report "CalculatingAB";  
                     if iCountA = x"1F" and iCountB = x"1F" then  
                          nextState <= stSaveData;  
                          report "Calculating";  
                          iCountEnableAB <= '0';  
                          iCountResetAB <= '1';  
                     else  
                          nextState <= stReadBufferAB;  
                          iCountEnableAB <= '1';  
                          iCountResetAB <= '0';  
                     end if;  
                when stSaveData =>   
                     iReadEnableAB <= '1';  
                     iCountEnable <= '0';  
                     nextState <= stWriteBufferC;  
                when stWriteBufferC =>  
                     iWriteEnableC(0) <= '1';  
                     report "finish 1 component";  
                     if iCount = x"3FF" then  
                          iCountReset <= '1';                           
                          nextState <= stComplete;  
                      else  
                          nextState <= stReadBufferAB;  
                     end if;                 
                when stComplete =>  
                     DataReady <= '1';  
                     nextState <= stIdle;                      
           end case;  
      end process;  
 end IntMatMulCore_arch;