#include"multiboot.h"

//Fuunction declaration
void WriteCharacter(unsigned char, unsigned char, unsigned char);
//global variables
int pos_x,pos_y; //these variable control the x and the y coordinates of the cursor


int main(struct multiboot_info* mbt) 
{
	int i,j=0,k=0;
	int n[64], index;
	char ch;
	int len = mbt->mmap_length;				//stores the length of the data recieved from the memory probe
	unsigned long x = 0, mem=0;
	unsigned char *welcome = "Welcome to MEMOS-2: The System memory is: ";	//messages to pe printed
	unsigned char *mb="MB";
	unsigned char forecolour=0x0F;			//printing the characters with Black Background and white characters
	unsigned char backcolour=0x00;
	memory_map_t* mmap = mbt->mmap_addr;	//sotres the address where the amount of memory is returned on memory probe

	//i = (mbt->flags) & (0x20);
		while(mmap <(mbt->mmap_addr + len))		//while the entire data has been recieved
		{
			if(mmap->type == 1)					//if the returned memory is type 1 i.e. free memory RAM
				{
					x = mmap->length_low;		//becasue the allocated memory is low we are just going to extract the lower byte
					//x = x<<32;
					//x = x | mmap->length_high; 
					mem = mem + x;				//storing the sum of memory in mem
				}
				
			mmap = (memory_map_t*) ( (unsigned int)mmap + mmap->size + sizeof(unsigned int) ); //reinitialsing the data received
		}
		mem = mem>>20;				//converting the amount of memory to MB
		while(mem>0)				//extractign each digit and storing in a number arrat
		{
			n[j] = mem%10;
			mem = mem/10;
			j++;
		}
		
		//  This loop will remove all the contents from the screen before we print our data
		for(pos_y=0;pos_y<=25;pos_y++)					
		{
			for( pos_x=0;pos_x<80;pos_x+=2)
			{
				WriteCharacter(0x00,forecolour,backcolour);		//Writes Null to the entire screen 80*25 
			}
		}
		
		pos_x=0;					//resets the position cursor to the start
		pos_y=0;
		index=0;

		//printing the message character by character
		while(welcome[index])
		{
			WriteCharacter(welcome[index],forecolour,backcolour); 		//printing the character at indexth location	
			index++;	
			pos_x+=2;													//incrementing the pointer to the next cursor location
		}
		
		//printing the digits in mem to the screen
		for(i=j-1;i>=0;i--)												
		{
			ch = n[i] + '0';											//converting each digit to character
			WriteCharacter(ch,forecolour,backcolour);					//and then printing it
			pos_x+=2;													//incrementing the cursor to the next position
		}
		index=0;
		//printing the unit "MB" 
		while(mb[index])									
		{
			WriteCharacter(mb[index],forecolour,backcolour);
			index++;	
			pos_x+=2;
		}
}


//function to print the character 'c' on the screen
void WriteCharacter(unsigned char c, unsigned char forecolour, unsigned char backcolour)
{
	//resets the cursor if position outside 80*25
	if(pos_x>=80)
	{
		pos_x=0;
		pos_y=pos_y+1;
	}
	//now print it
     unsigned char attrib = (backcolour << 4) | (forecolour & 0x0F);	//attrib shifted and stored in 1 byte. Higher nibble is back colour and lower nibble is forecolour
     unsigned char *video_buffer;										//pointer to video buffer at 0xB8000
     video_buffer = (unsigned char *)0xB8000 + (pos_y * 80 + pos_x) ;	//pointing the video buffer pointer to the position
     *video_buffer = attrib;											// storing the attrib at the first byte
     *video_buffer++ = c;												//storing the attrib at the next byte
     return;
}

