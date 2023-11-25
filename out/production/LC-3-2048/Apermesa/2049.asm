.orig x3000

br MAIN

            LCG ;线性同余随机数生成器函数

;接下来开始循环加法实现乘法
;a是11，大部分情况下都是生成的随机数比a要大，所以循环a次（11次）
and r1 r1 #0 ;r1用作乘法的结果
and r2 r2 #0 
add r2 r2 #11 ;r2用作计数器，循环11次，因为a是11
and r3 r3 #0
ld r3 nextInt ;r3是上一个随机数
loopMultiply add r1 r1 r3 ;加法
add r2 r2 #-1
brp loopMultiply 
;乘法结束，接下来加c，直接覆盖r1。
and r2 r2 #0
ld r2 lcg_c
add r1 r1 r2
;加法结束，接下来取余：循环相减
;此时不能动R1
and r2 r2 #0
ld r2 lcg_m
loop_mod1 
and r3 r3 #0
add r3 r1 r2 ;R3放r1-10007
brn mod1_complete ;如果加法的结果是非正数，说明r1比10007小，那么直接跳过取余，R1就是余数
;结果是正数，那么继续算
and r1 r1 #0
st r3 temp_mod1
ld r1 temp_mod1 ;把R1替换成刚才的差
br loop_mod1
;到这里取模1就结束了！R1就是取模结果
mod1_complete ;接下来要再取模4
st r1 nextInt
and r2 r2 #0
add r2 r2 #-4
loop_mod2
and r3 r3 #0
add r3 r1 r2
brn mod2_complete
and r1 r1 #0
st r3 temp_mod2
ld r1 temp_mod2
br loop_mod2
mod2_complete
st r1 random ;将生成的0-3随机数存入内存
ret

            PRINT ;打印游戏
            
and r6 r6 #0
add r6 r6 #15
and r5 r5 #0
lea r5 board00 ;r5存字符地址
and r3 r3 #0 ;r3作为外部循环检测
add r3 r3 #3 ;循环四次
and r2 r2 #0 ;r2用作存放48
ld r2 ascii_template
loop_newLine ;外层循环打印label(用于在每四个元素后加\n)
and r4 r4 #0 ;r4作为内部循环检测
add r4 r4 #3 ;循环四次,总计循环4x4次
loop_print ;内层循环用打印label
ldr r0 r5 #0
add r0 r0 r2 ;加上48
out ;打印元素
ld r0 space
out ;打印一个空格
add r5 r5 #1
add r6 r6 #-1
add r4 r4 #-1
brzp loop_print ;继续内层循环
ld r0 newLine ;打印换行符
out
add r3 r3 #-1 
brzp loop_newLine ;继续外层循环
ret

            SPAWN ;随机在一个空位生成一个元素
            
loop_spawn

ret

            MOVE_UP ;向上移动

and r2 r2 #0 ;R2用作小循环索引i
and r4 r4 #0 ;R4用作大循环索引j
and r3 r3 #0 ;R3用作数组索引[i][j]
and r5 r5 #0 ;R5用作数组索引[i+1][j]
and r6 r6 #0 ;R6用作临时数组元素起始绝对地址和临时元素值
moveUpOuterLoop
and r2 r2 #0
and r1 r1 #0 ;R1用于判断循环是否需要停止
add r1 r4 #-4
brzp endOfMoveUp
moveUpInnerLoop
and r1 r1 #0 ;R1用于判断循环是否需要停止
add r1 r2 #-4
brzp endOfMoveUpOuterLoop
and r3 r3 #0
add r3 r2 r3
add r3 r2 r3
add r3 r2 r3
add r3 r2 r3
add r3 r4 r3 ;经过这5行，R3变为4I+J，即为数组当前元素索引
lea r6 board00
add r3 r6 r3 ;加上后R3即为[i][j]绝对地址
ldr r6 r3 #0 ;R6即为[i][j]元素的值
brnp endOfMoveUpInnerLoop ;如果R3不为0，说明[i][j]非空，无法移动
add r5 r3 #4 ;R3加4即为[i+1][j]绝对地址
ldr r6 r5 #0 ;R6即为[i+1][j]元素的值
brz endOfMoveUpInnerLoop ;如果R5为0，说明[i+1][j]为空，无法移动
str r6 r3 #0 ;将[i+1][j]赋值给[i][j]
and r6 r6 #0 ;初始化[i+1][j]
str r6 r5 #0 ;将初始化的[i+1][j]赋值给[i+1][j]绝对地址
endOfMoveUpInnerLoop
add r2 r2 #1 ;小循环索引自增
br moveUpInnerLoop
endOfMoveUpOuterLoop
add r4 r4 #1 ;大循环索引自增
br moveUpOuterLoop
endOfMoveUp
ret

            MAIN ;游戏入口

jsr print
jsr move_up
jsr print

halt
random ;0-3随机数
nextInt .fill #1998 ;线性同余值
lcg_c .fill #19 ;线性同余公式中的C
lcg_m .fill #-10007 ;线性同余公式中的m
temp_mod1
temp_mod2
temp_element
temp_index ;临时存储索引值
space .fill #32 ;空格
newLine .fill #10 ;换行
ascii_template .fill #48
;以下16个是二维数组的所有元素，代表游戏主体
board00 .fill #0
board01 .fill #0
board02 .fill #0
board03 .fill #0
board10 .fill #1
board11 .fill #1
board12 .fill #1
board13 .fill #1
board20 .fill #0
board21 .fill #0
board22 .fill #0
board23 .fill #0
board30 .fill #1
board31 .fill #1
board32 .fill #1
board33 .fill #1
.end
