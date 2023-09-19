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
function factor(f::PolynomialModP128)::Vector{Tuple{PolynomialModP128,Integer}}
    #Cantor Zassenhaus factorization

    degree(f) ≤ 1 && return [(f,1)]

    # make f primitive
    ff = prim_part(f)      
    # @show "after prim:", ff

     # make f square-free #
    
    squares_poly = gcd(f, derivative(ff))
    ff = ff ÷ squares_poly
    # @show "after square free:", ff

    # make f monic
    old_coeff = leading(ff).coeff
    ff = ff ÷ old_coeff       
    # @show "after monic:", ff

    dds = dd_factor(ff)

    ret_val = Tuple{PolynomialModP128,Int}[]

    for (k,dd) in enumerate(dds)
        sp = dd_split(dd, k)
        sp = map((p)->(p ÷ leading(p).coeff)(f.prime),sp) #makes the polynomials inside the list sp, monic
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
function expand_factorization(factorization::Vector{Tuple{PolynomialModP128,Integer}})::PolynomialModP128
    length(factorization) == 1 && return first(factorization[1])^last(factorization[1])
    return *([first(tt)^last(tt) for tt in factorization]...)
end

"""
Compute the number of times g divides f
"""
function multiplicity(f::PolynomialSparse, g::PolynomialSparse)::Int
    @assert f.prime == g.prime 
    degree(gcd(f, g)) == 0 && return 0
    return 1 + multiplicity(f ÷ g, g)
end


"""
Distinct degree factorization.

Given a square free polynomial `f` returns a list, `g` such that `g[k]` is a product of irreducible polynomials of degree `k` for `k` in 1,...,degree(f) ÷ 2, such that the product of the list (mod `prime`) is equal to `f` (mod `prime`).
"""
function dd_factor(f::PolynomialModP128)::Array{PolynomialModP128}
    x = x_polysparse128()
    w = deepcopy(x)
    g = Array{PolynomialModP128}(undef,degree(f)) #Array of polynomials indexed by degree

    #Looping over degrees
    for k in 1:degree(f)
        w = rem(PolynomialModP128(w^(f.prime), f.prime), f)
        g[k] = gcd(w - PolynomialModP128(x,f.prime), f) 
        f = f ÷ g[k]
    end


    #edge case for final factor
    f.polynomial != one(PolynomialSparse128) && push!(g,f)
    
    return g
end

"""
Distinct degree split.

Returns a list of irreducible polynomials of degree `d` so that the product of that list (mod prime) is the polynomial `f`.
"""
function dd_split(f::PolynomialModP128, d::Int)::Vector{PolynomialModP128}
    degree(f) == d && return [f]
    degree(f) == 0 && return []
    w = rand(PolynomialSparse128, degree = d, monic = true)
    w = PolynomialModP128(w,f.prime)
    n_power = (f.prime^d-1) ÷ 2
    g = gcd(w^(n_power) - PolynomialModP128(one(PolynomialSparse128), f.prime), f)
    ḡ = f ÷ g # g\bar + [TAB]

    return vcat(dd_split(g, d), dd_split(ḡ, d) )
end

