using Pkg
Pkg.activate(".")

include("poly_factorization_project.jl")


x = x_poly()

@show -4x^2 + 6x + 1 - 6x^3 - 5x^1 - 9089x^5
@show 0*x + 5x^2 + 0*x^3 - 7x^4

typeof(0*x) 
iszero(0*x)
p1 = x^2 + 5x - 56x + x^4 - 6x







