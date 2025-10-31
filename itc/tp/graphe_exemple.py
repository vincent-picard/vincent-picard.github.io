N = 10

g = [ [0 for j in range(N)] for i in range(N)]
c = [ [float('inf') for j in range(N)] for i in range(N)]

print(g)
print(c)

def newarc(i, j, p):
    g[i][j] = 1
    c[i][j] = p

newarc(0, 1, 6)
newarc(0, 2, 5)

newarc(1, 3, 4)
newarc(1, 4, 7)

newarc(2, 3, 2)
newarc(2, 5, 6)

newarc(3, 6, 6)

newarc(4, 8, 8)
newarc(4, 6, 1)

newarc(5, 6, 4)
newarc(5, 7, 7)
newarc(5, 9, 15)

newarc(6, 7, 6)
newarc(6, 8, 9)

newarc(7, 8, 5)
newarc(7, 9, 3)

newarc(8, 9, 3)

print(g)
print(c)
