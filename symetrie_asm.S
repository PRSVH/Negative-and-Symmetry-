                                                                                        
@  Importation des,constantes symboliques WIDTH, HEIGHT, BYTES, BYTES_PER_LINE          
#include "image_bits_include.h"        
                                             
                                                                                        
                 .global symetrie_octet                                                 
                 .global permuter_cols                                                  
                 .global symetrie_axe_v                                                 
                 .global permuter_ligne                                                 
                 .global symetrie_axe_h                                                 
                 .global symetrie_axe_h                                                 
                 .global permuter_lignes                                                
                 .global symetrie_axe_v                                                 
                                                                                        
                 .text                                                                  
                                                                                        
@ r0 : parametre reçu adresse                                                           
@ r1 : variable locale octet                                                            
                                                                                        
#ifndef C_SYMETRIE_OCTET                                                                
#ifndef SYMTAB                                                                          
                                                                                        
@  Version avec opérations bit à bit                                                    
push {lr}                                                                                     
symetrie_octet:
push {r1,r4,r5}   
ldrb r1,[r0]
mov r4,r1
and r4,r4,#0xF0
mov r4,r4, lsr #4
mov r5,r1
and r5,r5,#0x0F
mov r5,r5,lsl #4
orr r1,r4,r5
mov r4,r1
and r4,r4,#0xCC
mov r4,r4, lsr #2
mov r5,r1
and r5,r5,#0x33
mov r5,r5,lsl #2
orr r1,r4,r5
mov r4,r1
and r4,r4,#0xAA
mov r4,r4, lsr #1
mov r5,r1
and r5,r5,#0x55
mov r5,r5,lsl #1
orr r1,r4,r5
strb r1,[r0]
pop {r1,r4,r5}
bx lr


#else  // SYMTAB                                                                        
                                                                                        
@ Version tabulée      
                                                                 
symetrie_octet:        
push {r1,r2}
ldrb r1,[r0]
ldr r2, ptr_tabsym_octet
ldrb r1, [r2,r1]
strb r1,[r0]
pop {r1,r2}
bx lr




                                                               
#endif  // SYMTAB                                                                       
#endif  // C_SYMETRIE_OCTET                                                             
@ r0 : parametre tab                                                                    
@ r1 : parametre col                                                                    

                                                                               
#ifndef C_PERMUTER_COLS                                                                 
                                                                                        
permuter_cols:

push {r2}
push {r3}
push {r4}
ldr r2,ptr_BYTES_PER_LINE  
sub r2,r2,#1
sub r2,r2,r1
ldrb r3,[r0,r2]
ldrb r4,[r0,r1]
strb r4,[r0,r2]      
strb r3, [r0,r1]
pop {r2,r3,r4}
bx lr                                                                  
                                                              
#endif // C_PERMUTER_COLS 


@ r0 : paramètre image

                                                                                        
#ifndef C_SYMETRIE_AXE_V                                                                
symetrie_axe_v:       
push {lr}                                                                  
push {r1,r2,r3,r4,r5,r6,r7,r8,r9}                                                                        
mov r2,r0                            
mov r3,#0
ldr r4,ptr_BYTES
ldr r5, ptr_HEIGHT
ldr r6, ptr_BYTES_PER_LINE


loopv1:
    cmp r3,r4
    bhs endloop11
    add r9, r2, r3
    mov r0,r9
    bl symetrie_octet
    add r3,r3,#1
    b loopv1

endloop11: mov r7,#0
           mov r9,r6,lsr #1
           b loopv2
           
loopv2: 
    cmp r7,r5
    beq endloopv2
    inloopv2:   mul r3, r7,r6
                add r3, r3,r2
                mov r8, #0  
                loopv3:
                 cmp r8,r9
                 bhs endloopv3
                 inloopv3:
                 mov r1,r8
                 mov r0,r3
                 bl permuter_cols
                 add r8,r8,#1
                 b loopv3
    endloopv3: add r7,r7,#1
               b loopv2

    endloopv2: 
    mov r0,r2
    pop {r1,r2,r3,r4,r5,r6,r7,r8,r9}
    pop {lr}
    bx lr
#endif // C_SYMETRIE_AXE_V                                                              
@ r0 : tab                                                                              
@ r1 : li                                                                               
                                                                                        
#ifndef C_PERMUTER_LIGNES                                                               
permuter_lignes:
ldr r8, ptr_BYTES_PER_LINE
ldr r6,ptr_HEIGHT
mul r5,r8,r1
ldrb r4,[r0,r5]
sub r6,r6,#1
sub r6,r6,r1
mul r7,r6,r8
ldrb r9, [r0,r7]
strb r9,[r0,r5]
strb r4, [r0,r7]
bx lr




                                                  
                                                                                        
#endif // C_PERMUTER_LIGNES                                                             
                                                                                        
@ r0 : paramètre image                                                                  
                                                                                        
#ifndef  C_SYMETRIE_AXE_H                                                               
symetrie_axe_h: 
push {lr}
push {r1,r2,r3,r4,r5}                                                                        
mov r2,r0
mov r6,#0                                @r1<-0 (li)
ldr r3,ptr_HEIGHT
mov r3,r3,lsr #1
ldr r5,ptr_BYTES_PER_LINE
loop1:
    cmp r6,r3
    bhs endloop1
    mov r4,#0
loop2:
    cmp r4,r5
    bhs incrementloop1
    add r0,r2,r4
    bl permuter_lignes
    add r4,r4,#1
    
incrementloop1:add r6,r6,#1
               b loop1
endloop1:
        mov r0,r2
        pop {r1,r2,r3,r4,r5}
        pop {lr}
        bx lr

    
#endif   // C_SYMETRIE_AXE_H                                                            

ptr_tabsym_octet: .word tabsym_octet
ptr_BYTES_PER_LINE: .word BYTES_PER_LINE
ptr_HEIGHT: .word HEIGHT
ptr_BYTES: .word BYTES