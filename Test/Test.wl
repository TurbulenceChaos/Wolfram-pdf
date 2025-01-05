TextCell["Test.wl", "Title"]

TextCell[Row[{section = 1, " Test Formula and Plot"}], "Section"]

sol1 = DSolve[{D[y[x, t], t] + 2 D[y[x, t], x] == Sin[x], y[0, t] == 
    Cos[t]}, y[x, t], {x, t}]

sol2 = sol1[[1, 1, 2]]

Plot3D[sol2, {x, -10, 10}, {t, -5, 5}]

TextCell[Row[{++section, " Test Manipulate"}], "Section"]

Manipulate[Plot[Sin[n x], {x, 0, 2 Pi}], {n, 1, 20}]
