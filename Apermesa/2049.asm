.orig x3000

br main

random .fill #0;0-3随机数
nextInt .fill #1998 ;线性同余值
lcg_c .fill #19 ;线性同余公式中的C
lcg_m .fill #-10007 ;线性同余公式中的m
temp_mod1 .fill #0
temp_mod2 .fill #0

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

temp_random .fill #0

SPAWN ; 生成随机数0或1

loop_spawn
    ST R7, temp_address
    JSR LCG          ; 调用LCG生成伪随机数
    LD R7, temp_address
    LD R1, random
    AND R2, R1, #1   ; R2 = a，获取0或1的随机数
    ADD R2, R2, #1   ; R2 = a + 1，将0或1转换为1或2
    ; 计算board[a][b]的地址
    LEA R3, board00  ; R3 = board数组起始地址
    ADD R3, R3, R2   ; R3 = board[a][b]地址
    LDR R4, R3, #0   ; R4 = board[a][b]值
    BRnp loop_spawn   ; 如果board[a][b]是0，重新运行SPAWN
    ; board[a][b]不是0，可以在这里放置1或2
    ADD R1, R4, #1   ; R1 = board[a][b] + 1
    STR R1, R3, #0   ; 将1或2存入board[a][b]
    RET



space .fill #32 ;空格
newLine .fill #10 ;换行
ascii_template .fill #48
temp_address .fill #0 ;临时地址用于嵌套函数

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

;检测/输出所需字符
char_negW .fill #-87
char_negA .fill #-65
char_negS .fill #-83
char_negD .fill #-68
character_? .fill #63

            INPUT ;输入
            
and r0 r0 #0
and r2 r2 #0 
and r3 r3 #0 ;R3用于临时存储用户输入的方向，然后存到userInput里面去
in ;获取输入值
; 检测输入是否为W
add r2 r2 r0
ld r1 char_negW 
add r1 r0 r1
brz INPUT_W ;如果是，则跳转到W输入事件
; 检测输入是否为A
ld r1 char_negA
add r1 r0 r1
brz INPUT_A ;如果是，则跳转到A输入事件
; 检测输入是否为S
ld r1 char_negS
add r1 r0 r1
brz INPUT_S ;如果是，则跳转到S输入事件
; 检测输入是否为D
ld r1 char_negD
add r1 r0 r1
brz INPUT_D ;如果是，则跳转到D输入事件
; 如果不是WASD则跳转到其他事件
br INPUT_OTHER
INPUT_W ;W输入事件
; 存0
st r3 userInput
ret
INPUT_A ;A输入事件
; 存1
add r3 r3 #1
st r3 userInput
ret
INPUT_S ;S输入事件
; 存2
add r3 r3 #2
st r3 userInput
ret
INPUT_D ;D输入事件
; 存3
add r3 r3 #3
st r3 userInput
ret
INPUT_OTHER ;其他输入事件
; 执行操作
ld r0 character_?
out
ret

            MAIN ;游戏入口

jsr spawn
jsr spawn
jsr print
infinite_loop ;无限循环
jsr input
jsr move
jsr merge
jsr move
jsr spawn
jsr print
br infinite_loop

            MERGE ;合并的总方法
            
ld r1 userInput ;将用户的方向加载入R1
brz user_merge_up ;如果R1为零说明向上
add r1 r1 #-1 
brz user_merge_left ;如果R1为1说明向左
ld r1 userInput
add r1 r1 #-2
brz user_merge_down ;如果R1为2说明向下
st r7 temp_address
jsr merge_right ;最后一个情况只剩向右
ld r7 temp_address
ret
user_merge_up 
st r7 temp_address
jsr merge_up
ld r7 temp_address
ret
user_merge_left 
st r7 temp_address
jsr merge_left
ld r7 temp_address
ret
user_merge_down 
st r7 temp_address
jsr merge_down
ld r7 temp_address
ret

;以下16个是二维数组的所有元素，代表游戏主体
board00 .fill #0
board01 .fill #0
board02 .fill #0
board03 .fill #0
board10 .fill #0
board11 .fill #0
board12 .fill #0
board13 .fill #0
board20 .fill #0
board21 .fill #0
board22 .fill #0
board23 .fill #0
board30 .fill #0
board31 .fill #0
board32 .fill #0
board33 .fill #0

            MERGE_UP ;合并元素
            
and r2 r2 #0 ;外层循环，用r2储存i的值
and r3 r3 #0 ;内层循环，用r3储存j的值
up_outer_loop ;外层循环
and r4 r4 #0 
add r4 r2 #-4
brz merge_up_done ;用r4检测r2的值是否为4作为结束外层循环的条件
and r3 r3 #0 ;清空当前r3的值
br up_inner_loop ;如果外层循环没有结束则跳转至内层循环

up_inner_loop ;内层循环
and r5 r5 #0
add r5 r3 #-4
brz up_outer_loop_addition ;用r5检测r3的值是否为4作为结束 内层循环的条件
and r5 r5 #0 ;复用r5用以储存索引映射值
;以下四行为计算4i的代码
add r5 r5 r2
add r5 r5 r2
add r5 r5 r2
add r5 r5 r2
add r5 r5 r3 ;4i+j
add r3 r3 #1 ;计算完后增加当前j值，代表本次循环“已完成”
lea r4 board00 ;用r4加载初始地址
add r5 r5 r4 ;初始地址+偏移值
st r5 this ;存储当前元素地址
and r4 r4 #0
and r6 r6 #0
add r6 r5 #4
st r6 that ;存储另一个相关元素的地址
ld r6 this
add r5 r4 r6 ;用r5计算当前元素地址
ldr r5 r5 #0;加载当前元素值
brz up_inner_loop ;如果board[i][j] == 0, 则结束循环
ld r6 that
add r6 r4 r6 ;用r6计算当前元素地址
ldr r6 r6 #0;加载另一个元素值
not r6 r6
add r6 r6 #1
add r6 r6 r5 ;判断两个值是否相同
brnp up_inner_loop ;如果board[i][j] != board[i + 1][j], 则结束循环
add r5 r5 #1 ;将当前元素值加倍
ld r6 this
str r5 r6 #0 ;用新的元素值覆盖当前元素值
; 加载另一个元素地址
ld r6 that
and r5 r5 #0 ;将另一个元素值归零
str r5 r6 #0 ;用新的元素值覆盖当前元素值
br up_inner_loop ;执行下一次内层循环
up_outer_loop_addition
add r2 r2 #1 ;增加当前i值
br up_outer_loop

merge_up_done
ret

            MERGE_DOWN ;合并元素
            
and r2 r2 #0 ;外层循环，用r2储存i的值
and r3 r3 #0 ;内层循环，用r3储存j的值
down_outer_loop ;外层循环
and r4 r4 #0 
add r4 r2 #-4
brz merge_down_done ;用r4检测r2的值是否为4作为结束外层循环的条件
and r3 r3 #0 ;清空当前r3的值
br down_inner_loop ;如果外层循环没有结束则跳转至内层循环

down_inner_loop ;内层循环
and r5 r5 #0
add r5 r3 #-4
brz down_outer_loop_addition ;用r5检测r3的值是否为4作为结束 内层循环的条件
and r5 r5 #0 ;复用r5用以储存索引映射值
;以下四行为计算4i的代码
add r5 r5 r2
add r5 r5 r2
add r5 r5 r2
add r5 r5 r2
add r5 r5 r3 ;4i+j
add r3 r3 #1 ;计算完后增加当前j值，代表本次循环“已完成”
lea r4 board00 ;用r4加载初始地址
add r5 r5 r4 ;初始地址+偏移值
st r5 this ;存储当前元素地址
and r4 r4 #0
and r6 r6 #0
add r6 r5 #-4
st r6 that ;存储另一个相关元素的地址
ld r6 this
add r5 r4 r6 ;用r5计算当前元素地址
ldr r5 r5 #0;加载当前元素值
brz down_inner_loop ;如果board[i][j] == 0, 则结束循环
ld r6 that
add r6 r4 r6 ;用r6计算当前元素地址
ldr r6 r6 #0;加载另一个元素值
not r6 r6
add r6 r6 #1
add r6 r6 r5 ;判断两个值是否相同
brnp down_inner_loop ;如果board[i][j] != board[i - 1][j], 则结束循环
add r5 r5 #1 ;将当前元素值加倍
ld r6 this
str r5 r6 #0 ;用新的元素值覆盖当前元素值
; 加载另一个元素地址
ld r6 that
and r5 r5 #0 ;将另一个元素值归零
str r5 r6 #0 ;用新的元素值覆盖当前元素值
br down_inner_loop ;执行下一次内层循环
down_outer_loop_addition
add r2 r2 #1 ;增加当前i值
br down_outer_loop

merge_down_done
ret

;以下两行为merge方法中储存的索引
this .fill x0000 ;当前元素索引
that .fill x0000 ;另一个相关元素的索引
userInput .fill #0;存储用户输入的方向，0上 1左 2下 3右

            MERGE_LEFT ;合并元素

and r2 r2 #0 ;外层循环，用r2储存j的值
and r3 r3 #0 ;内层循环，用r3储存i的值
left_outer_loop ;外层循环
and r4 r4 #0 
add r4 r2 #-4
brz merge_left_done ;用r4检测r2的值是否为4作为结束外层循环的条件
and r3 r3 #0 ;清空当前r3的值
br left_inner_loop ;如果外层循环没有结束则跳转至内层循环

left_inner_loop ;内层循环
and r5 r5 #0
add r5 r3 #-3
brz left_outer_loop_addition ;用r5检测r3的值是否为3作为结束 内层循环的条件
and r5 r5 #0 ;复用r5用以储存索引映射值
;以下四行为计算4i的代码
add r5 r5 r2
add r5 r5 r2
add r5 r5 r2
add r5 r5 r2
add r5 r5 r3 ;4i+j
add r3 r3 #1 ;计算完后增加当前i值，代表本次循环“已完成”
lea r4 board00 ;用r4加载初始地址
add r5 r5 r4 ;初始地址+偏移值
st r5 this ;存储当前元素地址
and r4 r4 #0
and r6 r6 #0
add r6 r5 #1
st r6 that ;存储另一个相关元素的地址
ld r6 this
add r5 r4 r6 ;用r5计算当前元素地址
ldr r5 r5 #0;加载当前元素值
brz left_inner_loop ;如果board[i][j] == 0, 则结束循环
ld r6 that
add r6 r4 r6 ;用r6计算当前元素地址
ldr r6 r6 #0;加载另一个元素值
not r6 r6
add r6 r6 #1
add r6 r6 r5 ;判断两个值是否相同
brnp left_inner_loop ;如果board[i][j] != board[i][j+1], 则结束循环
add r5 r5 #1 ;将当前元素值加倍
ld r6 this
str r5 r6 #0 ;用新的元素值覆盖当前元素值
; 加载另一个元素地址
ld r6 that
and r5 r5 #0 ;将另一个元素值归零
str r5 r6 #0 ;用新的元素值覆盖当前元素值
br left_inner_loop ;执行下一次内层循环
left_outer_loop_addition
add r2 r2 #1 ;增加当前j值
br left_outer_loop

merge_left_done
ret

            MERGE_RIGHT ;合并元素
            
and r2 r2 #0 ;外层循环，用r2储存j的值
and r3 r3 #0 ;内层循环，用r3储存i的值
right_outer_loop ;外层循环
and r4 r4 #0 
add r4 r2 #-4
brz merge_right_done ;用r4检测r2的值是否为4作为结束外层循环的条件
and r3 r3 #0 ;清空当前r3的值
add r3 r3 #1 ;增加1
br right_inner_loop ;如果外层循环没有结束则跳转至内层循环

right_inner_loop ;内层循环
and r5 r5 #0
add r5 r3 #-4
brz right_outer_loop_addition ;用r5检测r3的值是否为3作为结束 内层循环的条件
and r5 r5 #0 ;复用r5用以储存索引映射值
;以下四行为计算4i的代码
add r5 r5 r2
add r5 r5 r2
add r5 r5 r2
add r5 r5 r2
add r5 r5 r3 ;4i+j
add r3 r3 #1 ;计算完后增加当前i值，代表本次循环“已完成”
lea r4 board00 ;用r4加载初始地址
add r5 r5 r4 ;初始地址+偏移值
st r5 this ;存储当前元素地址
and r4 r4 #0
and r6 r6 #0
add r6 r5 #-1 ;由于当前j增加了1，映射为-1
st r6 that ;存储另一个相关元素的地址
ld r6 this
add r5 r4 r6 ;用r5计算当前元素地址
ldr r5 r5 #0;加载当前元素值
brz right_inner_loop ;如果board[i][j] == 0, 则结束循环
ld r6 that
add r6 r4 r6 ;用r6计算当前元素地址
ldr r6 r6 #0;加载另一个元素值
not r6 r6
add r6 r6 #1
add r6 r6 r5 ;判断两个值是否相同
brnp right_inner_loop ;如果board[i][j] != board[i][j-1], 则结束循环
add r5 r5 #1 ;将当前元素值加倍
ld r6 this
str r5 r6 #0 ;用新的元素值覆盖当前元素值
; 加载另一个元素地址
ld r6 that
and r5 r5 #0 ;将另一个元素值归零
str r5 r6 #0 ;用新的元素值覆盖当前元素值
br right_inner_loop ;执行下一次内层循环
right_outer_loop_addition
add r2 r2 #1 ;增加当前j值
br right_outer_loop

merge_right_done
ret

temp_address2 .fill #0
;以下16个是二维数组的所有元素，代表游戏主体
bboard00 .fill board00
bboard01 .fill board01
bboard02 .fill board02
bboard03 .fill board03
bboard10 .fill board10
bboard11 .fill board11
bboard12 .fill board12
bboard13 .fill board13
bboard20 .fill board20
bboard21 .fill board21
bboard22 .fill board22
bboard23 .fill board23
bboard30 .fill board30
bboard31 .fill board31
bboard32 .fill board32
bboard33 .fill board33

            MOVE ;移动的总方法
            
ld r1 userInput ;将用户的方向加载入R1
brz user_move_up ;如果R1为零说明向上
add r1 r1 #-1 
brz user_move_left ;如果R1为1说明向左
ld r1 userInput
add r1 r1 #-2
brz user_move_down ;如果R1为2说明向下
st r7 temp_address2
jsr move_right ;最后一个情况只剩向右
ld r7 temp_address2
ret
user_move_up
st r7 temp_address2
jsr move_up
ld r7 temp_address2
ret
user_move_left 
st r7 temp_address2
jsr move_left
ld r7 temp_address2
ret
user_move_down 
st r7 temp_address2
jsr move_down
ld r7 temp_address2
ret

temp_index .fill #0;临时存储索引值

            MOVE_UP ;向上移动

;整个双层循环要循环4次
moveUpLoop
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
add r1 r2 #-3
brzp endOfMoveUpOuterLoop
and r3 r3 #0
add r3 r2 r3
add r3 r2 r3
add r3 r2 r3
add r3 r2 r3
add r3 r4 r3 ;经过这5行，R3变为4I+J，即为数组当前元素索引
ld r6 bboard00
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
;检测最大循环
ld r1 temp_index
add r1 r1 #1
st r1 temp_index
add r1 r1 #-4
brn moveUpLoop
;这两行初始化temp_index
and r1 r1 #0
st r1 temp_index
ret

            MOVE_DOWN ;向下移动
            
;整个双层循环要循环4次
moveDOWNLoop
and r2 r2 #0 ;R2用作小循环索引i
and r4 r4 #0 ;R4用作大循环索引j
and r3 r3 #0 ;R3用作数组索引[i][j]
and r5 r5 #0 ;R5用作数组索引[i-1][j]
and r6 r6 #0 ;R6用作临时数组元素起始绝对地址和临时元素值
moveDOWNOuterLoop
and r2 r2 #0
add r2 r2 #3
and r1 r1 #0 ;R1用于判断循环是否需要停止
add r1 r4 #-4
brzp endOfMoveDOWN
moveDOWNInnerLoop
and r1 r1 #0 ;R1用于判断循环是否需要停止
add r1 r2 #0
brz endOfMoveDOWNOuterLoop
and r3 r3 #0
add r3 r2 r3
add r3 r2 r3
add r3 r2 r3
add r3 r2 r3
add r3 r4 r3 ;经过这5行，R3变为4I+J，即为数组当前元素索引
ld r6 bboard00
add r3 r6 r3 ;加上后R3即为[i][j]绝对地址
ldr r6 r3 #0 ;R6即为[i][j]元素的值
brnp endOfMoveDOWNInnerLoop ;如果R3不为0，说明[i][j]非空，无法移动
add r5 r3 #-4 ;R3减4即为[i-1][j]绝对地址
ldr r6 r5 #0 ;R6即为[i-1][j]元素的值
brz endOfMoveDOWNInnerLoop ;如果R5为0，说明[i-1][j]为空，无法移动
str r6 r3 #0 ;将[i-1][j]赋值给[i][j]
and r6 r6 #0 ;初始化[i-1][j]
str r6 r5 #0 ;将初始化的[i-1][j]赋值给[i-1][j]绝对地址
endOfMoveDOWNInnerLoop
add r2 r2 #-1 ;小循环索引自减
br moveDOWNInnerLoop
endOfMoveDOWNOuterLoop
add r4 r4 #1 ;大循环索引自增
br moveDOWNOuterLoop
endOfMoveDOWN
;检测最大循环
ld r1 temp_index
add r1 r1 #1
st r1 temp_index
add r1 r1 #-4
brn moveDOWNLoop
;这两行初始化temp_index
and r1 r1 #0
st r1 temp_index
ret

            MOVE_LEFT ;向左移动
            
;整个双层循环要循环4次
moveLEFTLoop
and r2 r2 #0 ;R2用作小循环索引j
and r4 r4 #0 ;R4用作大循环索引i
and r3 r3 #0 ;R3用作数组索引[i][j]
and r5 r5 #0 ;R5用作数组索引[i][j+1]
and r6 r6 #0 ;R6用作临时数组元素起始绝对地址和临时元素值
moveLEFTOuterLoop
and r2 r2 #0
and r1 r1 #0 ;R1用于判断循环是否需要停止
add r1 r4 #-4
brzp endOfMoveLEFT
moveLEFTInnerLoop
and r1 r1 #0 ;R1用于判断循环是否需要停止
add r1 r2 #-3
brzp endOfMoveLEFTOuterLoop
and r3 r3 #0
add r3 r4 r3
add r3 r4 r3
add r3 r4 r3
add r3 r4 r3
add r3 r2 r3 ;经过这5行，R3变为4I+J，即为数组当前元素索引
ld r6 bboard00
add r3 r6 r3 ;加上后R3即为[i][j]绝对地址
ldr r6 r3 #0 ;R6即为[i][j]元素的值
brnp endOfMoveLEFTInnerLoop ;如果R3不为0，说明[i][j]非空，无法移动
add r5 r3 #1 ;R3加1即为[i][j+1]绝对地址
ldr r6 r5 #0 ;R6即为[i][j+1]元素的值
brz endOfMoveLEFTInnerLoop ;如果R5为0，说明[i][j+1]为空，无法移动
str r6 r3 #0 ;将[i+1][j]赋值给[i][j]
and r6 r6 #0 ;初始化[i][j+1]
str r6 r5 #0 ;将初始化的[i+1][j]赋值给[i][j+1]绝对地址
endOfMoveLEFTInnerLoop
add r2 r2 #1 ;小循环索引自增
br moveLEFTInnerLoop
endOfMoveLEFTOuterLoop
add r4 r4 #1 ;大循环索引自增
br moveLEFTOuterLoop
endOfMoveLEFT
;检测最大循环
ld r1 temp_index
add r1 r1 #1
st r1 temp_index
add r1 r1 #-4
brn moveLEFTLoop
;这两行初始化temp_index
and r1 r1 #0
st r1 temp_index
ret

            MOVE_RIGHT ;向右移动
            
;整个双层循环要循环4次
moveRIGHTLoop
and r2 r2 #0 ;R2用作小循环索引j
and r4 r4 #0 ;R4用作大循环索引i
and r3 r3 #0 ;R3用作数组索引[i][j]
and r5 r5 #0 ;R5用作数组索引[i][j-1]
and r6 r6 #0 ;R6用作临时数组元素起始绝对地址和临时元素值
moveRIGHTOuterLoop
and r2 r2 #0
add r2 r2 #3
and r1 r1 #0 ;R1用于判断循环是否需要停止
add r1 r4 #-4
brzp endOfMoveRIGHT
moveRIGHTInnerLoop
and r1 r1 #0 ;R1用于判断循环是否需要停止
add r1 r2 #0
brz endOfMoveRIGHTOuterLoop
and r3 r3 #0
add r3 r4 r3
add r3 r4 r3
add r3 r4 r3
add r3 r4 r3
add r3 r2 r3 ;经过这5行，R3变为4I+J，即为数组当前元素索引
ld r6 bboard00
add r3 r6 r3 ;加上后R3即为[i][j]绝对地址
ldr r6 r3 #0 ;R6即为[i][j]元素的值
brnp endOfMoveRIGHTInnerLoop ;如果R3不为0，说明[i][j]非空，无法移动
add r5 r3 #-1 ;R3减1即为[i][j-1]绝对地址
ldr r6 r5 #0 ;R6即为[i][j-1]元素的值
brz endOfMoveRIGHTInnerLoop ;如果R5为0，说明[i-1][j]为空，无法移动
str r6 r3 #0 ;将[i][j-1]赋值给[i][j]
and r6 r6 #0 ;初始化[i][j-1]
str r6 r5 #0 ;将初始化的[i][j-1]赋值给[i][j-1]绝对地址
endOfMoveRIGHTInnerLoop
add r2 r2 #-1 ;小循环索引自减
br moveRIGHTInnerLoop
endOfMoveRIGHTOuterLoop
add r4 r4 #1 ;大循环索引自增
br moveRIGHTOuterLoop
endOfMoveRIGHT
;检测最大循环
ld r1 temp_index
add r1 r1 #1
st r1 temp_index
add r1 r1 #-4
brn moveRIGHTLoop
;这两行初始化temp_index
and r1 r1 #0
st r1 temp_index
ret

halt
.end
