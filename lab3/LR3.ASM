; Лабораторная работа №3, вариант 1 (шифр 1.2.1)
; Исходные данные: a, b, i, k (16-бит)
; Результат: res

.MODEL SMALL
.STACK 100h
.DATA
	a		DW	4		; Значение a
	b		DW	5		; Значение b
	i		DW	1		; Значение i
	k		DW	0	    ; Значение k

	i1		DW	4		; Результат fn1
	i2		DW	-10		; Результат fn1
	res		DW	?		; Результат fn3

.CODE
start:
	; Инициализация сегментного регистра
    mov ax, @DATA
    mov ds, ax
    
    ; ========== Начало вычислительной части ==========
    
    mov ax, i		; ax = i
	shl ax, 1		; ax = 2*i = i<<1
	
	; Сравнение a и b
    mov cx, a		; cx = a		
    cmp cx, b		; сравнить a и b
    
    jg a_greater_b	; если a > b, перейти к a_greater_b
    
    ; Ветка a <= b: Вычисление i1 = 3*i + 4, i2 = 6*i - 10

    add ax, i       ; ax = 3 * i
    add i1, ax      ; i1 = 3*i + 4

    shl ax, 1       ; ax = 6 * i
    add i2, ax      ; i2 = 6 * i - 10

    ; Перейти к вычислению fn3
    jmp calc_fn3
    
a_greater_b:
	; Ветка a > b: Вычисление i1 = 15 - 2*i, i2 = -(4*i + 3)

    add i1, 11      ; i1 = 15
    sub i1, ax      ; i1 = 15 - 2*i

    sub i2, 13      ; i2 = -3
    shl ax, 1       ; ax = 4*i
    sub i2, ax      ; i2 = -3 - 4*i
	
calc_fn3:
	; Вычисление fn3 в зависимости от k
    mov cx, i1      ; cx = i1
    mov ax, i2      ; ax = i2
	cmp k, 0		; сравнить k с 0
	jz k_zero; если k = 0, перейти к k_zero
	
	; Ветка k != 0
	; Вычисление fn3 = max(i1,i2)
    cmp cx, i2      ; сравнить i1 с i2
    jg store_i1     ; i1 > i2 сохраняем i1
    jmp store_res   ; i1 <= i2 сохраняем i2
	
k_zero:
	; Ветка k == 0
	; Вычисление fn3 = min(i1,i2)
    cmp cx, i2      ; сравнить i1 с i2
    jl store_i1     ; i1 < i2 сохраняем i1
    jmp store_res   ; i1 >= i2 сохраняем i2

store_i1:
	mov ax, i1		; ax = i1

store_res:
	mov res, ax		; сохранить конечный результат
	
    ; ========== Конец вычислительнйо части (КОЛИЧЕСТВО КОМАНД = 27) ==========
	
end_prog:
	; Завершение программы
	mov ax, 4C00h   ; Функция завершения программы DOS
    int 21h         ; Вызов прерывания DOS
end start
