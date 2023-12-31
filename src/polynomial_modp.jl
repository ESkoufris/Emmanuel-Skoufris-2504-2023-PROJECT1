using Pkg, DataStructures, Primes
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

function divide(p1::PolynomialModP, p2::PolynomialModP)
    @assert p1.prime == p2.prime
        divide(p1.polynomial, p2.polynomial)(p1.prime)
end 

# Derivatives
derivative(p::PolynomialModP) = PolynomialModP(derivative(p.polynomial), p.prime)

# Extended euclidean algorithm
function extended_euclid_alg(p1::PolynomialModP, p2::PolynomialModP)
    @assert p1.prime == p2.prime 
    return extended_euclid_alg(p1.polynomial, p2.polynomial, p1.prime)
end
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
coeffs(p::PolynomialModP) = coeffs(p.polynomial)


# Multiplication using the Chinese Remainder Theorem
#= function crt_poly(a::PolynomialSparse, b::PolynomialSparse, m_a::Integer, m_b::Integer)
    c = PolynomialModP(zero(PolynomialSparse), m_a*m_b)
    n = max(degree(a),degree(b))
    for k in 1:(n+1)
        (n - k + 1) > degree(a) || !haskey(a.dict, n - k + 1) ? ak = 0 : ak = get_element(a.terms, a.dict, n - k + 1).coeff
        (n - k + 1) > degree(b) || !haskey(b.dict, n - k + 1) ? bk = 0 : bk = get_element(b.terms, b.dict, n - k + 1).coeff
        ck = crt([ak,bk], [m_a, m_b])
        c += ck*x_polysparse()^(n - k + 1)
    end
    return c
end  =#

function crt_poly(a::PolynomialSparse, b::PolynomialSparse, m_a::Integer, m_b::Integer)
    c = PolynomialModP(zero(PolynomialSparse), m_a*m_b)
    n = max(degree(a),degree(b))
    for k in push!(reverse(collect(1:n)),0)
        k > degree(a) || !haskey(a.dict, k) ? ak = 0 : ak = get_element(a.terms, a.dict, k).coeff
        k > degree(b) || !haskey(b.dict, k) ? bk = 0 : bk = get_element(b.terms, b.dict, k).coeff
        ck = crt([ak,bk], [m_a, m_b])
        c += ck*(x_polysparse()^k)
    end
    return c
end 

function crt_multiply(a::PolynomialSparse, b::PolynomialSparse)
    height_a = maximum(abs.(coeffs(a)))
    height_b = maximum(abs.(coeffs(b)))

    B = 2*height_a*height_b*min(degree(a)+1,degree(b)+1)
    p = 3
    M = p
    c = PolynomialModP(a*b, M)
    
    while M < B
        p = nextprime(p+1)
        c1 = PolynomialModP(a*b, p)
        c = crt_poly(c.polynomial, c1.polynomial, M, p)
        M = M*p
    end
    return smod(c.polynomial, M)
end




## Implementation for PolynomialSparse128
struct PolynomialModP128
    polynomial::PolynomialSparse128
    prime::Integer
    function PolynomialModP128(p::PolynomialSparse128, prime::Integer)
        return new(mod(p, prime), prime)
    end
end

# show method 
function show(io::IO, p::PolynomialModP128)
    print(io, p.polynomial, " ", "(mod $(p.prime))")
end

# polynomial operations 
## addition
+(p1::PolynomialModP128, p2::PolynomialSparse128)::PolynomialModP128 = PolynomialModP128(p1.polynomial + p2, p1.prime)
+(p1::PolynomialSparse128, p2::PolynomialModP128,)::PolynomialModP128 = PolynomialModP128(p2.polynomial + p1, p2.prime)
+(p::PolynomialModP128, n::Integer)::PolynomialModP128 = PolynomialModP128(p.polynomial + n, p.prime)
+(n::Integer, p::PolynomialModP128)::PolynomialModP128 = PolynomialModP128(p.polynomial + n, p.prime)

function +(p1::PolynomialModP128, p2::PolynomialModP128)::PolynomialModP128
    @assert p1.prime == p2.prime
    return PolynomialModP128(p1.polynomial + p2.polynomial, p1.prime)
end 

## subtraction
-(p1::PolynomialModP128, p2::PolynomialSparse128)::PolynomialModP128 = PolynomialModP128(p1.polynomial - p2, p1.prime)
-(p1::PolynomialSparse128, p2::PolynomialModP128,)::PolynomialModP128 = PolynomialModP128(p2.polynomial - p1, p2.prime)

function -(p1::PolynomialModP128, p2::PolynomialModP128)::PolynomialModP128
    @assert p1.prime == p2.prime
    return PolynomialModP128(p1.polynomial - p2.polynomial, p1.prime)
end 

## multiplication
*(p1::PolynomialModP128, p2::PolynomialSparse128)::PolynomialModP128 = PolynomialModP128(p1.polynomial*p2, p1.prime)
*(p1::PolynomialSparse128, p2::PolynomialModP128)::PolynomialModP128 = PolynomialModP128(p2.polynomial*p1, p2.prime)

*(p::PolynomialModP128, n::Integer)::PolynomialModP128 = PolynomialModP128(n*p.polynomial, p.prime)
*(n::Integer,p::PolynomialModP128)::PolynomialModP128 = PolynomialModP128(n*p.polynomial, p.prime)

function *(p1::PolynomialModP128, p2::PolynomialModP128)::PolynomialModP128
    @assert p1.prime == p2.prime
    return PolynomialModP128(p1.polynomial*p2.polynomial, p1.prime)
end 

## exponentiation - REPLACED
#= ^(p::PolynomialModP128, n::Integer)::PolynomialModP128 = PolynomialModP128(p.polynomial^n, p.prime) =#

### better exponentiation

## FOR WHATEVER REASON, THIS IMPLEMENTATION IS VERY SLOW
#= function pow_mod1(f::PolynomialModP128, m::Integer)
    max_pow = floor(Int, log2(m)) # computing the position of the leftmost bit.

    w, ans = f, PolynomialModP128(one(PolynomialSparse128), f.prime)  

    for i in 0:max_pow
        if m & (1 << i) != 0 #if n has a 1 in the ith bit
            ans *= w
        end
        w *= w
    end
    return ans
end =#

function ^(f::PolynomialModP128, m::Integer)
    max_pow = floor(Int, log2(m)) # computing the position of the leftmost bit.

    w = [f]
    
    for i in 1:max_pow
        w = push!(w, w[end]*w[end])
    end 

    ans =  PolynomialModP128(one(PolynomialSparse128), f.prime)  

    for i in 0:max_pow
        if m & (1 << i) != 0 # check if the ith bit of m is 1
            ans *= w[i+1]
        end
    end
    return ans
end

## Derivatives
derivative(p::PolynomialModP128) = PolynomialModP128(derivative(p.polynomial), p.prime)

## division 
÷(p1::PolynomialModP128, p2::PolynomialSparse128)::PolynomialModP128 = PolynomialModP128((p1.polynomial ÷ p2)(p1.prime), p1.prime)
÷(p1::PolynomialSparse128, p2::PolynomialModP128)::PolynomialModP128 = PolynomialModP128((p2.polynomial ÷ p1)(p2.prime), p2.prime)

÷(p1::PolynomialModP128, n::Integer)::PolynomialModP128 = PolynomialModP128((p1.polynomial ÷ n)(p1.prime), p1.prime)

divide(num::PolynomialModP128, den::PolynomialModP128) = divide(num.polynomial, den.polynomial)(num.prime)

function ÷(p1::PolynomialModP128, p2::PolynomialModP128)::PolynomialModP128
    @assert p1.prime == p2.prime
    return PolynomialModP128((p1.polynomial ÷ p2.polynomial)(p1.prime), p1.prime)
end 

# remainder
rem(num::PolynomialModP128, den::PolynomialModP128)  =  last(divide(num,den))

# gcd
gcd(p1::PolynomialModP128, p2::PolynomialSparse128)::PolynomialModP128 = PolynomialModP128(gcd(p1.polynomial, p2, p1.prime), p1.prime) 
gcd(p1::PolynomialSparse128, p2::PolynomialModP128)::PolynomialModP128 = PolynomialModP128(gcd(p1, p2.polynomial, p2.prime))

function gcd(p1::PolynomialModP128, p2::PolynomialModP128)::PolynomialModP128
    @assert p1.prime == p2.prime
    return PolynomialModP128(gcd(p1.polynomial, p2.polynomial, p1.prime), p1.prime)
end

# factorisation 
#= factor(p::PolynomialModP128) = factor(p.polynomial, p.prime) =#

# queries 
iszero(p::PolynomialModP128) = iszero(p.polynomial)
length(p::PolynomialModP128) = length(p.polynomial)
==(p1::PolynomialModP128, p2::PolynomialModP128) = p1.prime == p2.prime && p1.polynomial == p2.polynomial
leading(p::PolynomialModP128) = leading(p.polynomial)
degree(p::PolynomialModP128) = degree(p.polynomial)
coeffs(p::PolynomialModP128) = coeffs(p.polynomial)


# Multiplication using the Chinese Remainder Theorem
#= function crt_poly(a::PolynomialSparse128, b::PolynomialSparse128, m_a::Integer, m_b::Integer)
    c = PolynomialModP128(zero(PolynomialSparse128), m_a*m_b)
    n = max(degree(a),degree(b))
    for k in 1:(n+1)
        (n - k + 1) > degree(a) || !haskey(a.dict, n - k + 1) ? ak = 0 : ak = get_element(a.terms, a.dict, Int128(n - k + 1)).coeff
        (n - k + 1) > degree(b) || !haskey(b.dict, n - k + 1) ? bk = 0 : bk = get_element(b.terms, b.dict, Int128(n - k + 1)).coeff
        ck = crt([ak,bk], [m_a, m_b])
        c += ck*x_polysparse128()^(n - k + 1)
    end
    return c
end  =#

function crt_poly(a::PolynomialSparse128, b::PolynomialSparse128, m_a::Integer, m_b::Integer)
    c = PolynomialModP128(zero(PolynomialSparse128), m_a*m_b)
    n = max(degree(a),degree(b))
    for k in push!(reverse(collect(1:n)),0)
        k > degree(a) || !haskey(a.dict, k) ? ak = 0 : ak = get_element(a.terms, a.dict, Int128(k)).coeff
        k > degree(b) || !haskey(b.dict, k) ? bk = 0 : bk = get_element(b.terms, b.dict, Int128(k)).coeff
        ck = crt([ak,bk], [m_a, m_b])
        c += ck*x_polysparse128()^k
    end
    return c
end 

function crt_multiply(a::PolynomialSparse128, b::PolynomialSparse128)
    height_a = maximum(abs.(coeffs(a)))
    height_b = maximum(abs.(coeffs(b)))

    B = 2*height_a*height_b*min(degree(a) + 1,degree(b) + 1)
    p = 3
    M = p
    c = PolynomialModP128(a*b, M)
    
    while M < B
        p = nextprime(p+1)
        c1 = PolynomialModP128(a*b, p)
        c = crt_poly(c.polynomial, c1.polynomial, M, p)
        M = M*p
    end
    return smod(c.polynomial, M)
end



content(p::PolynomialModP128)::Int = euclid_alg(coeffs(p))
prim_part(p::PolynomialModP128) = p ÷ content(p)