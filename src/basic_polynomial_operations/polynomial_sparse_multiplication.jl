#############################################################################
#############################################################################
#
# This file implements polynomial multiplication 
#                                                                               
#############################################################################
#############################################################################

"""
Multiply two polynomials.
"""
function *(p1::PolynomialSparse, p2::PolynomialSparse)::PolynomialSparse
    p_out = PolynomialSparse()
    for t in p1.terms
        new_summand = (t * p2)
        p_out = p_out + new_summand
    end
    return p_out
end

"""
Power of a polynomial.
"""
function ^(p::PolynomialSparse, n::Integer)
    n < 0 && error("No negative power")
    out = one(p)
    for _ in 1:n
        out *= p
    end
    return out
end


"""
Multiply two polynomials of type PolynomialSparse128
"""
function *(p1::PolynomialSparse128, p2::PolynomialSparse128)::PolynomialSparse128
    p_out = PolynomialSparse128()
    for t in p1.terms
        new_summand = (t * p2)
        p_out = p_out + new_summand
    end
    return p_out
end

"""
Power of a polynomial.
"""
function ^(p::PolynomialSparse128, n::Int)
    n < 0 && error("No negative power")
    out = one(p)
    for _ in 1:n
        out *= p
    end
    return out
end

function pow_mod_efficient(f::PolynomialSparse128, m::Integer, p::Integer)
    max_pow = floor(Int, log2(m)) # computing the position of the leftmost bit.

    w = [f]
    
    for i in 1:max_pow
        w = push!(w, w[end]^2)
    end 

    ans = mod(one(PolynomialSparse128), p)  

    for i in 0:max_pow
        if m & (1 << i) != 0 # check if the ith bit of m is 1
            ans = mod(w[i+1]*ans,p)
        end
    end
    return ans
end
