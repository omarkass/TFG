def primeNum(num):
    flag = False
    if num > 1:
        for i in range(2, num):
            if (num % i) == 0:
                flag = True
                break
    if flag:
        return "is not a prime number"
    return "is a prime number"

def sumNum (num1 , num2):
    return num1 + num2 