// Dataacquisition and analysis
// by Raphael Nagel
// 10032284 - University of the West of England, Bristol
// Created 24 Januar 2013

// This software contacts the MPL3115A2 barometer via I2C and reads a single barometer value with 20bits
// accuracy. It calculates the averages over a 30 sample long period


#include <Wire.h>
#define CP_OK 1
#define CP_ERROR 0


/*Barometer registers*/
#define baro 0x60
#define OUT_P_MSB  0x01
#define OUT_P_CSB 0x02
#define OUT_P_LSB 0x03
#define CTRL_REG1 0x26 
#define set_OST 0x02

#define Period500Hz 2000

#if 0
 /*Temperature Registers - currently not needed*/
  char OUT_T_MSB = 0x04;
  char OUT_T_LSB = 0x05;  
#endif



unsigned long raw = 0; //the raw input value in binary
unsigned long averaged[2]; //the averaged value
unsigned long output = 0; //the output value after it has been worked - in binary
unsigned long input[32]; //the 32 word FIFO buffer

unsigned int counter = 1;
unsigned int i,x;
unsigned int delay_val = 1800;
unsigned int time = 0;
unsigned int time2 = 0;


void PrintSignedNumber(unsigned long );
unsigned int SingleBarometerRead(unsigned long *);

void setup()
{
  Wire.begin();        // join i2c bus (address optional for master)
   TWBR = 12;         //set the I2C frequency to 400kHz 
  Serial.begin(115200);  // start serial for output
}

void loop()
{
for(x = 0;x<4;x++){  
 time = micros(); //store the start time of our reads
 SingleBarometerRead(&raw);


//32 element FIFO buffer
for(i = 31;i>=1;i--){
  input[i]=input[i-1];
}
input[0] = raw;


/*average the output*/

if(counter <=32){
    output = input[0];  
    PrintSignedNumber(output);
    counter++; 
  }
  else{
    averaged[0] = 0;
  for(i = 0;i<30;i++){
      averaged[0] = averaged[0]+input[i];
  }  
  averaged[0] = (averaged[0]/30);
  PrintSignedNumber(averaged[0]);
  }
  
  
    time2 = micros(); //how much time has evolved since we started the read and
    time2 = time2-time;
    Serial.print(time2,DEC); 
   Serial.println("Hz - time before Adjustment"); 

 #if 1 
  /*ensure a sample rate of about 500Hz*/
  //time2 = (micros()-time); //how much time has evolved since we started the read and
 if((Period500Hz-time2)> 0){ 
     delayMicroseconds(Period500Hz-time2); 
 }else{
   for(i = 0; i>10;i++){
     Serial.print("cannot run at 500Hz sampling rate");  
     delay(1000);  
   }  
  }
  
   time2 = (micros()-time); //how much time has evolved since we started the read and
   Serial.print(time2,DEC); 
   Serial.println("Hz - time after "); 
 #endif
 
}
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

unsigned int SingleBarometerRead(unsigned long *raw){

  
  /*Temporary output data*/
  unsigned long MSB_Data = 0; 
  unsigned long CSB_Data = 0; 
  unsigned long LSB_Data = 0; 
  
  
    Wire.write(baro,CTRL_REG1,set_OST); //initiates a single barometer read.  
    Wire.read(baro,OUT_P_MSB,8);
    MSB_Data = I2c.receive();//these are the 8 MSB out of the total of 20-bit
    
    Wire.read(baro,OUT_P_CSB,8);
    CSB_Data = I2c.receive();//these are the 8 CSB out of a total of 20-bits
    
    Wire.read(baro,OUT_P_LSB,8);
    LSB_Data = (I2c.receive()>>4);//these are the 4 LSB of the 20-bit output. 
    //The bitmap of the value received from the barometer however places these at the 4 MSB positions of the 8-bit word received. 
    //The lower 4-bits are '0'. THus we rightshift to get rid of these.
    
    *raw = ((MSB_Data<<12)|(CSB_Data<<4)|LSB_Data);   //all output data put together. 
  if(raw != 0){
      return CP_OK;
  }else{
    return CP_ERROR;
  }
  
}

