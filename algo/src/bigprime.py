import random as rd

def random_big_odd_int():
    n = 0
    for _ in range(511):
        n = 2 * n + rd.randint(0, 1)
    n = 2 * n + 1
    return n

# Calcul a^n modulo p
def mod_exp(a, n, p):
    if n == 0:
        return 1
    elif n == 1:
        return (a % p)
    elif (n % 2 == 0):
        return mod_exp((a * a) % p, n // 2, p)
    else:
        return (a * mod_exp((a * a) % p, n // 2, p)) % p

def test_de_fermat(p, k):
    # On itère k fois le test de fermat
    for _ in range(k):
        a = rd.randint(1, p-1)
        if mod_exp(a, p-1, p) != 1:
            return False
    return True

def big_prime():
    print("Génération...")
    n = random_big_odd_int()
    echecs = 0
    while not(test_de_fermat(n, 10)):
           echecs += 1
           n += 2
    print("Echecs : ", echecs)
    return n

print("Nombres (probablement) premiers de 2 à 100")
for i in range(2, 100):
    if test_de_fermat(i, 10):
        print(i)

print("Grand nombre premier : ", big_prime())
