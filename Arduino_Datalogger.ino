// Wire Master Reader
// by Nicholas Zambetti <http://www.zambetti.com>

// Demonstrates use of the Wire library
// Reads data from an I2C/TWI slave device
// Refer to the "Wire Slave Sender" example for use with this

// Created 29 March 2006

// This example code is in the public domain.


#include <I2C.h>

#define baro 0x60
#define 2timesaverage+derv 60

 char OUT_P_MSB = 0x01;
  char OUT_P_CSB = 0x02;
  char OUT_P_LSB = 0x03;
  char OUT_T_MSB = 0x04;
  char OUT_T_LSB = 0x05;  
  char CTRL_REG1 = 0x26;  
  char set_OST = 0x02;
  unsigned long MSB_Data = 0; 
  unsigned long CSB_Data = 0; 
  unsigned long LSB_Data = 0; 


unsigned long output = 0;
void setup()
{
  I2c.begin();        // join i2c bus (address optional for master)
  I2c.pullup(0);
  Serial.begin(115200);  // start serial for output
}

void loop()
{
  I2c.write(baro,CTRL_REG1,set_OST); //initiates a single barometer read.
   

I2c.read(baro,OUT_P_MSB,8);
MSB_Data = I2c.receive();//these are the 8 MSB out of the total of 20-bit

I2c.read(baro,OUT_P_CSB,8);
CSB_Data = I2c.receive();//these are the 8 CSB out of a total of 20-bits

I2c.read(baro,OUT_P_LSB,8);
LSB_Data = (I2c.receive()>>4);//these are the 4 LSB of the 20-bit output. 
//The bitmap of the value received from the barometer however places these at the 4 MSB positions of the 8-bit word received. 
//The lower 4-bits are '0'. THus we rightshift to get rid of these.

output = ((MSB_Data<<12)|(CSB_Data<<4)|LSB_Data);   //all output data put together. 
//Because we stick together MSB followed by CSB and then LSB we bitwise-OR the parts.
 //[b19-2 - 2's Complement][b1-0 - unsigned binary]

//  Serial.print("MSB ");
//  Serial.println(MSB_Data,BIN);
//  Serial.print("CSB ");
//  Serial.println(CSB_Data,BIN);
//  Serial.print("LSB ");
//  Serial.println(LSB_Data,BIN);
  //Serial.println(output,BIN);
/*average the output*/
   PrintSignedNumber(output);
  delay(10);     
}

void PrintSignedNumber(unsigned long twoscomp){
 unsigned long bin_nofract;
 unsigned long fract;
 
  if ((twoscomp) & 0x080000){         //if the MSB is set, the number is negative
    Serial.print("-");
    bin_nofract = ((~(twoscomp>>2)&0x03FFFF))+0x01;       //convert to unsigned binary, ignoring the fractional component
    fract = (twoscomp & 0x03)*0x19;                          //finding the fractional component
  }
  else{                               //otherwise its positive
    Serial.print(PSTR(" "));  
    bin_nofract = (twoscomp>>2)&0x03FFFF;
    fract = (twoscomp & 0x03)*0x19;
  }

    Serial.print(bin_nofract, DEC);
    Serial.print(".");
    Serial.println(fract,DEC);

}

