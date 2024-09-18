source_filename = "main.c"

;分别保存格式化字符串 "%d" 和 "%d\n"，用于 scanf 和 printf 函数。

@.str = constant [3 x i8] c"%d\00", align 1
@.str.1 = constant [4 x i8] c"%d\0A\00", align 1


;@.str = private unnamed_addr constant [3 x i8] c"%d\00", align 1

 
define i32 @main() #0 {

  ;为变量a, b, i, t, n 分配空间。
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %i = alloca i32, align 4
  %t = alloca i32, align 4
  %n = alloca i32, align 4
  
  ;为变量a, b, i 分配初值。
  store i32 0, i32* %a, align 4
  store i32 1, i32* %b, align 4
  store i32 1, i32* %i, align 4

  ;读入n的值。i8*是字符指针，从@.str地址读取[3 x i8]类型数组的0位置的值，在%n存成整型。
  %1 = call i32(i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str, i32 0, i32 0), i32* %n)

  ;打印 a 和 b
  %2 = load i32, i32* %a, align 4
  %3 = call i32(i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0), i32 %2)
  %4 = load i32, i32* %b, align 4
  %5 = call i32(i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0), i32 %4)

  br label %loop


  ;循环控制跳转，i < n 时候跳转到body;否则跳到end。

  loop: 
    %6 = load i32, i32* %i, align 4
    %7 = load i32, i32* %n, align 4
    %cmp = icmp slt i32 %6, %7
    br i1 %cmp, label %body, label %end

  body:

    ;t = b
    %8 = load i32, i32* %b, align 4
    store i32 %8, i32* %t, align 4

    ;b = a + b
    %9 = load i32, i32* %a, align 4
    %10 = load i32, i32* %b, align 4
    %sum = add i32 %9, %10
    store i32 %sum, i32* %b, align 4


    ;printf("%d\n", b)
    %11 = load i32, i32* %b, align 4
    %12 = call i32(i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0), i32 %11)

    ;a = t
    %13 = load i32, i32* %t, align 4
    store i32 %13, i32* %a, align 4

    ;i = i + 1
    %14 = load i32, i32* %i, align 4
    %inc = add i32 %14, 1
    store i32 %inc, i32* %i, align 4
    
    ;返回循环条件。
    br label %loop

    end:
    ;函数返回。
    ret i32 0
}


declare dso_local i32 @__isoc99_scanf(i8*, ...)
declare dso_local i32 @printf(i8*, ...)