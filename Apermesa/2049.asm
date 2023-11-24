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
ret

            PRINT ;打印游戏
ld r0 board00
and r6 r6 #0
and r5 r5 #0
ld r5 board00
loop_print




add r0 r0 r6
out 
add r6 r6 #1
and r5 r5 #0 ;用r6和16减一下，用于判断循环次数
add r5 r6 #-3
brn loop_print
ret

            MAIN ;游戏入口

jsr print

halt
nextInt .fill #1998 ;线性同余值
lcg_c .fill #19 ;线性同余公式中的C
lcg_m .fill #-10007 ;线性同余公式中的m
temp_mod1
temp_mod2
;以下16个是二维数组的所有元素，代表游戏主体
temp_element
board00 .fill #48
board01 .fill #48
board02 .fill #48
board03 .fill #48
board10 .fill #48
board11 .fill #48
board12 .fill #48
board13 .fill #48
board20 .fill #48
board21 .fill #48
board22 .fill #48
board23 .fill #48
board30 .fill #48
board31 .fill #48
board32 .fill #48
board33 .fill #49
.end
