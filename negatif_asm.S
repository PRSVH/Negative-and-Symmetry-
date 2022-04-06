                                                                                      
@  Importation des,constantes symboliques WIDTH, HEIGHT, BYTES, BYTES_PER_LINE        
#include "image_bits_include.h"                                                       
										      
                                                                                      
                 .text                                                                
                                                                                      
@ r0 : parametre octet                                                                
                                                                                      
#ifndef C_NEG_OCTET                                                                   
                 .global neg_octet                                                    
                                                                                      

neg_octet: 

eor r0,#0xff          @Complement a 1 de r0
bx lr


                                                                           
                                                                                      
#endif // C_NEG_OCTET                                                                 
                                                                                      
#ifndef C_NEG_IMAGE                                                               
                 .global neg_image                                                    
@ r0 : parametre reçu image                                                           
                                                                                      


                                                                                     
neg_image:
	push {lr}
	
	ldr r4, adr_bytes
	mov r5,r0
	add r3,r0,r4   
	
	loop:  cmp r5, r3
	       bhs endloop 
	       ldrb r0, [r5]
	       bl neg_octet
	       strb r0, [r5]  
	       add r5,r5,#1
	       b loop                                                                      
                                                                                      
        endloop: 
	pop {lr}
	mov pc,lr
	
		                                                           
                                                                                      
adr_bytes:	.word BYTES 
                                                          
#endif // C_NEG_IMAGE                                                                 
