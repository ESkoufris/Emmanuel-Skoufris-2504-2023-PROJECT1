using Pkg, DataStructures
Pkg.activate(".")

struct PolynomialModP
    polynomial::PolynomialSparse
    prime::Integer
    function PolynomialModP(p::PolynomialSparse, prime::Integer)
        return new(mod(p, prime), prime)
    end
end

# show method 
function show(io::IO, p::PolynomialModP)
    print(io, p.polynomial, " ", "(mod $(p.prime))")
end

# polynomial operations 
## addition
+(p1::PolynomialModP, p2::PolynomialSparse)::PolynomialModP = PolynomialModP(p1.polynomial + p2, p1.prime)
+(p1::PolynomialSparse, p2::PolynomialModP,)::PolynomialModP = PolynomialModP(p2.polynomial + p1, p2.prime)

function +(p1::PolynomialModP, p2::PolynomialModP)::PolynomialModP
    @assert p1.prime == p2.prime
    return PolynomialModP(p1.polynomial + p2.polynomial, p1.prime)
end 

## subtraction
-(p1::PolynomialModP, p2::PolynomialSparse)::PolynomialModP = PolynomialModP(p1.polynomial - p2, p1.prime)
-(p1::PolynomialSparse, p2::PolynomialModP,)::PolynomialModP = PolynomialModP(p2.polynomial - p1, p2.prime)

function -(p1::PolynomialModP, p2::PolynomialModP)::PolynomialModP
    @assert p1.prime == p2.prime
    return PolynomialModP(p1.polynomial - p2.polynomial, p1.prime)
end 

## multiplication
*(p1::PolynomialModP, p2::PolynomialSparse)::PolynomialModP = PolynomialModP(p1.polynomial*p2, p1.prime)
*(p1::PolynomialSparse, p2::PolynomialModP,)::PolynomialModP = PolynomialModP(p2.polynomial*p1, p2.prime)

function *(p1::PolynomialModP, p2::PolynomialModP)::PolynomialModP
    @assert p1.prime == p2.prime
    return PolynomialModP(p1.polynomial*p2.polynomial, p1.prime)
end 

## exponentiation
^(p::PolynomialModP, n::Integer)::PolynomialModP = PolynomialModP(p.polynomial^n, p.prime)

## division 
÷(p1::PolynomialModP, p2::PolynomialSparse)::PolynomialModP = PolynomialModP((p1.polynomial ÷ p2)(p1.prime), p1.prime)
÷(p1::PolynomialSparse, p2::PolynomialModP,)::PolynomialModP = PolynomialModP((p2.polynomial ÷ p1)(p2.prime), p2.prime)

function ÷(p1::PolynomialModP, p2::PolynomialModP)::PolynomialModP
    @assert p1.prime == p2.prime
    return PolynomialModP((p1.polynomial ÷ p2.polynomial)(p1.prime), p1.prime)
end 

# remainder

# gcd
gcd(p1::PolynomialModP, p2::PolynomialSparse)::PolynomialModP = PolynomialModP(gcd(p1.polynomial, p2, p1.prime), p1.prime) 
gcd(p1::PolynomialSparse, p2::PolynomialModP)::PolynomialModP = PolynomialModP(gcd(p1, p2.polynomial, p2.prime))

function gcd(p1::PolynomialModP, p2::PolynomialModP)::PolynomialModP
    @assert p1.prime == p2.prime
    return PolynomialModP(gcd(p1.polynomial, p2.polynomial, p1.prime), p1.prime)
end

# factorisation 
factor(p::PolynomialModP) = factor(p.polynomial, p.prime)

# queries 
iszero(p::PolynomialModP) = iszero(p.polynomial)
length(p::PolynomialModP) = length(p.polynomial)
==(p1::PolynomialModP, p2::PolynomialModP) = p1.prime == p2.prime && p1.polynomial == p2.polynomial
leading(p::PolynomialModP) = leading(p.polynomial)
degree(p::PolynomialModP) = degree(p.polynomial)


