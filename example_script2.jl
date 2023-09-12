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

(x ÷ x)(5)

(q ÷ p)(5)


mod(q,5)
gcd(2x^2 + 4, x+1, 5)

gcd(x,x,5)


p - q
- p
p = x
t = Term(1,2)

p*q

push!(x, Term(1,2)).terms


((2x^2 + 4) ÷ (x+1))(5)


q*Term(1,5)

Term(Int128(1), Int128(2))

superscript(Int128(2))

u = x^2 + 128x

v = 4x + 1

gcd(u, v, 5)
typeof(Term128(1,2).coeff)


