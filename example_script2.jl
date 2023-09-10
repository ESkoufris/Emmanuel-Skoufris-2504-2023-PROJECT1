using Pkg
Pkg.activate(".")

include("poly_factorization_project.jl")

x = x_polysparse()

p = -4x^2 + 3x^6 + 2x^9
q = 0*x + 5x^2 + 0*x^3 - 7x^4 + 9098x^7 - x^9

@show (p*q).dict

mod(p, 5)
derivative(p)

(p ÷ q)(5)


