using Pkg
Pkg.activate(".")

include("poly_factorization_project.jl")

x = x_poly()

@show p1 = -5x^2 + 6x + 1 - 6x^3 - 5x^10
