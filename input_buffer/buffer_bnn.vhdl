library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;



entity buffer_bnn is 
    generic(size_of_AB : integer := 1024; --number of rows matrix "A" must be equal number of columns matrix "B", else we can't multiply matrices 
            size_of_T : integer := 16;
            size_columns_A : integer := 128;
            size_rows_B : integer := 64
    );
    port(
        clk : in std_logic; 
        bnn_ready : in std_logic;                               -- if '0', matrices can be read in 
        data_A : out std_logic_vector(size_of_AB - 1 downto 0); -- rows from matrix "A"
        data_B : out std_logic_vector(size_of_AB - 1 downto 0); -- columns from matrix "B"
        data_T : out std_logic_vector(size_of_T - 1 downto 0);  -- Threshold
        en_A :  out std_logic;                                  -- Enable "A"
        en_B :  out std_logic;                                  -- Enable "B"
        en_T :  out std_logic;                                  -- Enable "T"
        start : out std_logic;                                  -- '1' if matrices A,B are transferred
        length : out integer;                                   -- length of vectrors "A" and "B"
        depth_A : out integer;                                  -- depth of matrix "A"
        width_B : out integer                                   -- width of matrix "B"
    );
end buffer_bnn;

architecture rtl of buffer_bnn is
    
    --matrices are created for weights and data    
    type matrix_A is array (size_columns_A - 1 downto 0) of bit_vector(size_of_AB - 1 downto 0); 
    
    -- type matrix_B is array (size_of_AB - 1 downto 0) of bit_vector(size_rows_B - 1 downto 0); 
    type matrix_B is array (size_of_AB - 1 downto 0) of bit_vector(size_rows_B -1 downto 0);

    begin
        length <= size_of_AB;
        depth_A <= size_columns_A;
        width_B <= size_rows_B;
        start <= '0';
        process is
            
            variable num_bits : integer := size_of_AB * size_columns_A;
            variable tmp_o : bit_vector(num_bits - 1 downto 0) := (others => '0');
            variable tmp_ch : bit_vector(num_bits - 1 downto 0) := (others => '0');
       
            variable text_line : line;
            file text_file : text open read_mode is "data.txt";
            variable tmp : integer;
            variable tmp_1 : integer;
            variable tmp_2 : integer;
            variable tmp_mem : matrix_A ;       
            begin
                while not endfile(text_file) loop
                    readline(text_file, text_line);
                        read(text_line, tmp_o);
                end loop;

                tmp_1 :=size_of_AB - 1;
                tmp_2 := num_bits - 1;

                for i in 0 to size_columns_A - 1 loop
                    tmp_ch(tmp_1 downto tmp_1 - (size_of_AB-1)) := tmp_o(tmp_2 downto tmp_2 - (size_of_AB-1));
                    tmp_1 := tmp_1 + size_of_AB;
                    tmp_2 := tmp_2 - size_of_AB;
                end loop;

                tmp := 0;
                for i in 0 to size_columns_A - 1 loop
                    for j in 0 to size_of_AB - 1 loop
                        tmp_mem(i)(j) := tmp_ch(tmp);
                        tmp := tmp + 1;
                    end loop;
                end loop; 
                for i in 0 to size_columns_A - 1 loop
                    en_A <= '0';
                    data_A <= to_stdlogicvector(tmp_mem(i));
                    en_A <= '1';
                    wait until rising_edge(clk);
                end loop;
                wait;
            end process;
            
            process is
            variable num_bits : integer := size_of_AB * size_rows_B;
            variable tmp_o : bit_vector(num_bits - 1 downto 0) := (others => '0');
            variable tmp_ch : bit_vector(num_bits - 1 downto 0) := (others => '0');
            variable tmp_ch_1 : bit_vector(size_of_AB - 1 downto 0);
       
            variable text_line : line;
            file text_file : text open read_mode is "weights.txt";
            variable tmp : integer;
            variable tmp_1 : integer;
            variable tmp_2 : integer;
            variable tmp_3 : integer;
            variable tmp_mem : matrix_B;       
            begin
                while not endfile(text_file) loop
                    readline(text_file, text_line);
                        read(text_line, tmp_o);
                end loop;
                tmp_1 :=size_rows_B - 1;
                tmp_2 := num_bits - 1;

                for i in 0 to 1023 loop
                    tmp_ch(tmp_1 downto tmp_1 - (size_rows_B -1)) := tmp_o(tmp_2 downto tmp_2 - (size_rows_B -1));
                    tmp_1 := tmp_1 + size_rows_B;
                    tmp_2 := tmp_2 - size_rows_B;
                end loop;
                tmp :=0;
                for i in 0 to size_of_AB - 1 loop
                    for j in 0 to size_rows_B - 1 loop
                        tmp_mem(i)(j) := tmp_ch(tmp);
                        tmp:= tmp +1;
                    end loop;
                    
                    
                end loop; 
                tmp :=size_of_AB - 1;
                tmp_1:=size_rows_B - 1;
                for i in 0 to size_rows_B - 1 loop
                    for j in 0 to size_of_AB - 1 loop
                        tmp_ch_1(tmp) := tmp_mem(j)(tmp_1);     
                        tmp := tmp - 1;
                    end loop;
                    tmp_1 := tmp_1 - 1;
                    if(tmp_1 < 0 )then
                        tmp_1 := size_rows_B - 1;
                    end if;
                    tmp := size_of_AB - 1;
                    en_B <= '0';
                    data_B <= to_stdlogicvector(tmp_ch_1);
                    en_B <= '1';
                    wait until rising_edge(clk);
                    end loop;
                    
                wait;
            end process;
            
            start <= '1';

            process is
                variable tmp_o : bit_vector(15 downto 0);
                variable text_line : line;
                file text_file : text open read_mode is "threshold.txt";
                begin
                    en_T <= '0';
                    while not endfile(text_file) loop
                        readline(text_file, text_line);
                            read(text_line, tmp_o);
                    end loop;
                    data_T <= to_stdlogicvector(tmp_o);
                    en_T <= '1';
                wait;
            end process;
    end rtl;
        






