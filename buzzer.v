`timescale 1ns / 1ps

module buzzer(
    input EN,
    input clk,
	input rst,
	input confirm,
	input [3 : 0] state,
	input [4 : 0] r0,r1,r2,r3,r4,r5,r6,r7,
	input [1 : 0] speed_mode,
   input [7 : 0] switch,
	output reg buzzer//          
	);

	parameter  M0 = 98800,
                 MS = 75850,
                 ML = 75851;
        
        reg flag;
        reg [16:0] cnt0; 
        reg [10:0] cishu_cnt;
        reg [5 :0] LONG;
        reg [10:0] cishu;
        wire [10:0] cishu_div;
        reg [16:0] pre_set;
        wire [16:0] pre_div;
        wire [5:0] num;
        wire confirm_key;
        wire clkout;
        wire [7 : 0] switch_out;
        clock c(clk, rst, clkout);
        debounce confirm_out(clkout,rst,confirm,confirm_key);
        debounce d0(clkout, rst, switch[0], switch_out[0]);
        debounce d1(clkout, rst, switch[1], switch_out[1]);
        debounce d2(clkout, rst, switch[2], switch_out[2]);
        debounce d3(clkout, rst, switch[3], switch_out[3]);
        debounce d4(clkout, rst, switch[4], switch_out[4]);
        debounce d5(clkout, rst, switch[5], switch_out[5]);
        debounce d6(clkout, rst, switch[6], switch_out[6]);
        debounce d7(clkout, rst, switch[7], switch_out[7]);

 
    always @ (posedge clk or posedge rst) begin 
        if(rst)
            cnt0 <= 0;
        else if(confirm_key || switch_out)
            cnt0 <= 0;
        else begin
             if(cnt0 == pre_set - 1)
                cnt0 <= 0;
             else 
                cnt0 <= cnt0 + 1;
         end
    end         
    

        always @(posedge clk or posedge rst) begin
            if(rst)
               cishu_cnt <= 0;
            else if(confirm_key || switch_out)
              cishu_cnt <= 0;
            else begin
              if(cnt0 == pre_set - 1)begin
                  if(cishu_cnt == cishu)
                      cishu_cnt <= 0;
                  else
                      cishu_cnt <= cishu_cnt + 1;
               end
             end
          end
   reg [7 : 0] switch_on;
   assign num = switch_on != 0 ? 5 : 6 * state - 1;
 
    always @(posedge clk or posedge rst) begin
                  if(rst) begin
                  if(EN)begin
                      LONG <= 0;
                      flag <= 0;
                      end
                  end
                  else if((confirm_key || switch_out) && state != 0 && EN) begin
                      LONG <= 0;
                      if(confirm_key)
                        flag <= 1;
                      if(switch_out != 0)begin
                        if(switch_out[0] && state >= 1)
                          begin switch_on[0] <= 1; flag <= 1; end
                        else if(switch_out[1] && state >= 2)
                           begin switch_on[1] <= 1; flag <= 1; end
                        else if(switch_out[2] && state >= 3)
                          begin switch_on[2] <= 1; flag <= 1; end
                        else if(switch_out[3] && state >= 4)
                          begin switch_on[3] <= 1; flag <= 1; end
                        else if(switch_out[4] && state >= 5)
                          begin switch_on[4] <= 1; flag <= 1; end
                        else if(switch_out[5] && state >= 6)
                          begin switch_on[5] <= 1; flag <= 1; end
                        else if(switch_out[6] && state >= 7)
                          begin switch_on[6] <= 1; flag <= 1; end
                        else if(switch_out[7] && state >= 8)
                          begin switch_on[7] <= 1; flag <= 1; end
                      end
                  end    
                  else begin
                      if(cishu_cnt == cishu & cnt0 == pre_set - 1) begin
                        if(LONG == num) begin
                             flag <= 0;
                             switch_on <= 0;
                        end
                        else
                            LONG <= LONG + 1;
                      end
                  end
              end
              
    always @ (*) begin
        case(speed_mode)
            2'b00: case(pre_set)
                       M0:cishu = 363;
                       MS:cishu = 315;
                       ML:cishu = 700;
                   endcase
            2'b01: case(pre_set)      //slow speed
                       M0:cishu = 605;
                       MS:cishu = 525;
                       ML:cishu = 1165;
                   endcase
            2'b10: case(pre_set)      //fast speed
                       M0:cishu = 242;
                       MS:cishu = 210;
                       ML:cishu = 466;
                   endcase                        
            2'b11: case(pre_set)      //fast speed
                       M0:cishu = 242;
                       MS:cishu = 210;
                       ML:cishu = 466;
                   endcase            
        endcase
    end
    

    always @(posedge clk or posedge rst) begin
        if(rst)
            pre_set <= M0;
         else if(flag == 1'b1)
         begin
            if(switch_on[0])
            begin
               case(LONG)    
               0:case(r0[4])
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase
               1:case(r0[3])        
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase
               2:case(r0[2])
                     0:pre_set = MS;
                     1:pre_set = ML; 
                  endcase             
               3:case(r0[1])
                     0:pre_set = MS;
                     1:pre_set = ML;  
                  endcase 
               4:case(r0[0])
                     0:pre_set = MS;
                     1:pre_set = ML;    
                  endcase          
               5:pre_set = M0;
               endcase        
            end
            else if (switch_on[1])
            begin
               case(LONG)    
               0:case(r1[4])
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase
               1:case(r1[3])        
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase
               2:case(r1[2])
                     0:pre_set = MS;
                     1:pre_set = ML; 
                  endcase             
               3:case(r1[1])
                     0:pre_set = MS;
                     1:pre_set = ML;  
                  endcase
               4:case(r1[0])
                     0:pre_set = MS;
                     1:pre_set = ML;    
                  endcase          
               5:pre_set = M0;
               endcase           
            end
             else if (switch_on[2])
            begin
               case(LONG)    
               0:case(r2[4])
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase
               1:case(r2[3])        
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase
               2:case(r2[2])
                     0:pre_set = MS;
                     1:pre_set = ML; 
                  endcase             
               3:case(r2[1])
                     0:pre_set = MS;
                     1:pre_set = ML;  
                  endcase 
               4:case(r2[0])
                     0:pre_set = MS;
                     1:pre_set = ML;    
                  endcase          
               5:pre_set = M0;
               endcase           
            end
             else if (switch_on[3])
            begin
               case(LONG)    
               0:case(r3[4])
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase
               1:case(r3[3])        
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase
               2:case(r3[2])
                     0:pre_set = MS;
                     1:pre_set = ML; 
                  endcase             
               3:case(r3[1])
                     0:pre_set = MS;
                     1:pre_set = ML;  
                  endcase
               4:case(r3[0])
                     0:pre_set = MS;
                     1:pre_set = ML;    
                  endcase          
               5:pre_set = M0;
               endcase           
            end
             else if (switch_on[4])
            begin
               case(LONG)    
               0:case(r4[4])
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase
               1:case(r4[3])        
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase
               2:case(r4[2])
                     0:pre_set = MS;
                     1:pre_set = ML; 
                  endcase             
               3:case(r4[1])
                     0:pre_set = MS;
                     1:pre_set = ML;  
                  endcase 
               4:case(r4[0])
                     0:pre_set = MS;
                     1:pre_set = ML;    
                  endcase          
               5:pre_set = M0;
               endcase           
            end
             else if (switch_on[5])
            begin
               case(LONG)    
               0:case(r5[4])
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase
               1:case(r5[3])        
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase
               2:case(r5[2])
                     0:pre_set = MS;
                     1:pre_set = ML; 
                  endcase             
               3:case(r5[1])
                     0:pre_set = MS;
                     1:pre_set = ML;  
                  endcase 
               4:case(r5[0])
                     0:pre_set = MS;
                     1:pre_set = ML;    
                  endcase          
               5:pre_set = M0;
               endcase           
            end
             else if (switch_on[6])
            begin
               case(LONG)    
               0:case(r6[4])
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase
               1:case(r6[3])        
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase
               2:case(r6[2])
                     0:pre_set = MS;
                     1:pre_set = ML; 
                  endcase             
               3:case(r6[1])
                     0:pre_set = MS;
                     1:pre_set = ML;  
                  endcase 
               4:case(r6[0])
                     0:pre_set = MS;
                     1:pre_set = ML;    
                  endcase          
               5:pre_set = M0;
               endcase           
            end
            else if (switch_on[7])
            begin
               case(LONG)    
               0:case(r7[4])
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase
               1:case(r7[3])        
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase
               2:case(r7[2])
                     0:pre_set = MS;
                     1:pre_set = ML; 
                  endcase             
               3:case(r7[1])
                     0:pre_set = MS;
                     1:pre_set = ML;  
                  endcase 
               4:case(r7[0])
                     0:pre_set = MS;
                     1:pre_set = ML;    
                  endcase          
               5:pre_set = M0;
               endcase           
            end
        else begin
            case(LONG)    
               0:case(r0[4])
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase
               1:case(r0[3])        
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase
               2:case(r0[2])
                     0:pre_set = MS;
                     1:pre_set = ML; 
                  endcase             
               3:case(r0[1])
                     0:pre_set = MS;
                     1:pre_set = ML;  
                  endcase            
               4:case(r0[0])
                     0:pre_set = MS;
                     1:pre_set = ML;    
                  endcase          
               5:pre_set = M0;
               
               6:case(r1[4])        
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               7:case(r1[3])        
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               8:case(r1[2])        
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               9:case(r1[1])        
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               10:case(r1[0])        
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               11:pre_set = M0;                   
               
               12:case(r2[4])        
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               13:case(r2[3])        
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               14:case(r2[2])        
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               15:case(r2[1])        
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               16:case(r2[0])       
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               17:pre_set = M0;                   
               
               18:case(r3[4])        
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               19:case(r3[3])        
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               20:case(r3[2])        
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               21:case(r3[1])        
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               22:case(r3[0])       
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               23:pre_set = M0;     
               
               24:case(r4[4])  
                     0:pre_set = MS; 
                     1:pre_set = ML;
                  endcase      
               25:case(r4[3])  
                     0:pre_set = MS;
                     1:pre_set = ML; 
                  endcase      
               26:case(r4[2])  
                     0:pre_set = MS;
                     1:pre_set = ML; 
                  endcase      
               27:case(r4[1])  
                     0:pre_set = MS;
                     1:pre_set = ML; 
                  endcase      
               28:case(r4[0])  
                     0:pre_set = MS;
                     1:pre_set = ML; 
                  endcase      
               29:pre_set = M0;              
               
               30:case(r5[4])       
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               31:case(r5[3])       
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               32:case(r5[2])       
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               33:case(r5[1])       
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               34:case(r5[0])       
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               35:pre_set = M0;     
               
               36:case(r6[4])       
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               37:case(r6[3])       
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               38:case(r6[2])       
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               39:case(r6[1])       
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               40:case(r6[0])       
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               41:pre_set = M0;     
               
               42:case(r7[4])       
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               43:case(r7[3])       
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               44:case(r7[2])       
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               45:case(r7[1])       
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               46:case(r7[0])       
                     0:pre_set = MS;
                     1:pre_set = ML;
                  endcase           
               47:pre_set = M0;
            endcase//end state
            end
         end
    end
    
    assign pre_div = pre_set >> 1;   
    assign cishu_div = cishu * 1/2;  
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            buzzer <= 1'b0;
        end
        else if(pre_set != M0) begin
            if(cishu_cnt < cishu_div) begin
                if(cnt0 < pre_div)
                    buzzer <= 1'b1;
                else
                    buzzer <= 1'b0;
            end
            else
                buzzer <= 1'b0;
            
            end 
        else
            buzzer <= 1'b0;
    end
endmodule

