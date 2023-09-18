using Pkg
Pkg.activate(".")

include("poly_factorization_project.jl")

x = x_polysparse()


p = -4x^2 + 3x^6 + 2x^9
q = 4x^4 - 190x^10 + 1 

# generating a random polynomial
rand(PolynomialSparse)


# PolynomialSparse allows one to access the degrees of (non-zero) terms through a dictionary 
@show (p*q).dict


# reducing the coeffcients of p modulo 5
mod(q, 5)


# dividing p by q modulo 7. In particular, the set of equivalence classes modulo 7 forms a field since 7 is prime,
# and so "division" of the nonzero coefficients is perfectly well defined 
(q ÷ p)(7)


# finding the gcd of two polynomials modulo 5. We are reducing the coeffcients of the polynomials modulo 7 and then looking 
# for the polynomial of greatest degree that divides both of them. 
gcd(x - 2, x^2 - 4, 7)


# factoring a polynomial over the ring Z₁₁[x]
factor(10x^8 + 8x^7 + 9x^6 + 3x + 4, 11)

