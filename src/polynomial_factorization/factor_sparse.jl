#############################################################################
#############################################################################
#
# This file implements factorization 
#                                                                               
#############################################################################
#############################################################################

"""
Factors a polynomial over the field Z_p.

Returns a vector of tuples of (irreducible polynomials (mod p), multiplicity) such that their product of the list (mod p) is f. Irreducibles are fixed points on the function factor.
"""
function factor(f::PolynomialSparse, prime::Int)::Vector{Tuple{PolynomialSparse,Integer}}
    #Cantor Zassenhaus factorization

    f_modp = mod(f, prime)
    degree(f_modp) ≤ 1 && return [(f_modp,1)]

    # make f primitive
    ff = prim_part(f_modp)(prime)      
    # @show "after prim:", ff

     # make f square-free
    squares_poly = gcd(f, derivative(ff), prime) 
    ff = (ff ÷ squares_poly)(prime) 
    # @show "after square free:", ff

    # make f monic
    old_coeff = leading(ff).coeff
    ff = (ff ÷ old_coeff)(prime)        
    # @show "after monic:", ff

    dds = dd_factor(ff, prime)

    ret_val = Tuple{PolynomialSparse,Int}[]

    for (k,dd) in enumerate(dds)
        sp = dd_split(dd, k, prime)
        sp = map((p)->(p ÷ leading(p).coeff)(prime),sp) #makes the polynomials inside the list sp, monic
        for mp in sp
            push!(ret_val, (mp, multiplicity(f_modp,mp,prime)) )
        end
    end

    #Append the leading coefficient as well
    push!(ret_val, (leading(f_modp).coeff* one(PolynomialSparse), 1) )

    return ret_val
end

"""
Expand a factorization.
"""
function expand_factorization(factorization::Vector{Tuple{PolynomialSparse,Integer}})::PolynomialSparse 
    length(factorization) == 1 && return first(factorization[1])^last(factorization[1])
    return *([first(tt)^last(tt) for tt in factorization]...)
end

"""
Compute the number of times g divides f
"""
function multiplicity(f::PolynomialSparse, g::PolynomialSparse, prime::Int)::Int
    degree(gcd(f, g, prime)) == 0 && return 0
    return 1 + multiplicity((f ÷ g)(prime), g, prime)
end


"""
Distinct degree factorization.

Given a square free polynomial `f` returns a list, `g` such that `g[k]` is a product of irreducible polynomials of degree `k` for `k` in 1,...,degree(f) ÷ 2, such that the product of the list (mod `prime`) is equal to `f` (mod `prime`).
"""
function dd_factor(f::PolynomialSparse, prime::Int)::Array{PolynomialSparse}
    x = x_polysparse()
    w = deepcopy(x)
    g = Array{PolynomialSparse}(undef,degree(f)) #Array of polynomials indexed by degree

    #Looping over degrees
    for k in 1:degree(f)
        w = rem(pow_mod(w,prime,prime), f)(prime)
        g[k] = gcd(w - x, f, prime) 
        f = (f ÷ g[k])(prime)
    end


    #edge case for final factor
    f != one(PolynomialSparse) && push!(g,f)
    
    return g
end

"""
Distinct degree split.

Returns a list of irreducible polynomials of degree `d` so that the product of that list (mod prime) is the polynomial `f`.
"""
function dd_split(f::PolynomialSparse, d::Int, prime::Int)::Vector{PolynomialSparse}
    f = mod(f,prime)
    degree(f) == d && return [f]
    degree(f) == 0 && return []
    w = rand(PolynomialSparse, degree = d, monic = true)
    w = mod(w,prime)
    n_power = (prime^d-1) ÷ 2
    g = gcd(pow_mod(w,n_power,prime) - one(PolynomialSparse), f, prime)
    ḡ = (f ÷ g)(prime) # g\bar + [TAB]
    return vcat(dd_split(g, d, prime), dd_split(ḡ, d, prime) )
end

# Implementation for PolynomialSparse128

function factor(f::PolynomialSparse128, prime::Int)::Vector{Tuple{PolynomialSparse128,Integer}}
    #Cantor Zassenhaus factorization

    f_modp = mod(f, prime)
    degree(f_modp) ≤ 1 && return [(f_modp,1)]

    # make f primitive
    ff = prim_part(f_modp)(prime)      
    # @show "after prim:", ff

     # make f square-free
    squares_poly = gcd(f, derivative(ff), prime) 
    ff = (ff ÷ squares_poly)(prime) 
    # @show "after square free:", ff

    # make f monic
    old_coeff = leading(ff).coeff
    ff = (ff ÷ Int(old_coeff))(prime)        
    # @show "after monic:", ff

    dds = dd_factor(ff, prime)

    ret_val = Tuple{PolynomialSparse128,Int}[]

    for (k,dd) in enumerate(dds)
        sp = dd_split(dd, k, prime)
        sp = map((p)->(p ÷ Int(leading(p).coeff))(prime),sp) #makes the polynomials inside the list sp, monic
        for mp in sp
            push!(ret_val, (mp, multiplicity(f_modp,mp,prime)) )
        end
    end

    #Append the leading coefficient as well
    push!(ret_val, (leading(f_modp).coeff* one(PolynomialSparse128), 1) )

    return ret_val
end

"""
Expand a factorization.
"""
function expand_factorization(factorization::Vector{Tuple{PolynomialSparse128,Int}})::PolynomialSparse128 
    length(factorization) == 1 && return first(factorization[1])^last(factorization[1])
    return *([first(tt)^last(tt) for tt in factorization]...)
end

"""
Compute the number of times g divides f
"""
function multiplicity(f::PolynomialSparse128, g::PolynomialSparse128, prime::Int)::Int
    degree(gcd(f, g, prime)) == 0 && return 0
    return 1 + multiplicity((f ÷ g)(prime), g, prime)
end


"""
Distinct degree factorization.

Given a square free polynomial `f` returns a list, `g` such that `g[k]` is a product of irreducible polynomials of degree `k` for `k` in 1,...,degree(f) ÷ 2, such that the product of the list (mod `prime`) is equal to `f` (mod `prime`).
"""
function dd_factor(f::PolynomialSparse128, prime::Int)::Array{PolynomialSparse128}
    x = x_polysparse128()
    w = deepcopy(x)
    g = Array{PolynomialSparse128}(undef,degree(f)) #Array of polynomials indexed by degree

    #Looping over degrees
    for k in 1:degree(f)
        w = rem(pow_mod(w,prime,prime), f)(prime)
        g[k] = gcd(w - x, f, prime) 
        f = (f ÷ g[k])(prime)
    end


    #edge case for final factor
    f != one(PolynomialSparse128) && push!(g,f)
    
    return g
end

"""
Distinct degree split.

Returns a list of irreducible polynomials of degree `d` so that the product of that list (mod prime) is the polynomial `f`.
"""
function dd_split(f::PolynomialSparse128, d::Int, prime::Int)::Vector{PolynomialSparse128}
    f = mod(f,prime)
    degree(f) == d && return [f]
    degree(f) == 0 && return []
    w = rand(PolynomialSparse128, degree = d, monic = true)
    w = mod(w,prime)
    n_power = (prime^d-1) ÷ 2
    g = gcd(pow_mod(w,n_power,prime) - one(PolynomialSparse128), f, prime)
    ḡ = (f ÷ g)(prime) # g\bar + [TAB]
    return vcat(dd_split(g, d, prime), dd_split(ḡ, d, prime) )
end