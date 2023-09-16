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

function pow_mod1(f::PolynomialSparse128, m::Integer, p::Integer)
    num_bits = Int(floor(log2(m) + 1)) # computing the position of the leftmost bit.
    bits = zeros(num_bits) 

    for i in 1:num_bits
        (m & (1 << (i-1)) != 0) && (bits[i] = 1) # checks if the i'th bit is zero. 
    end

    ans, w = 1, mod(f, p)   

    for i in 1:num_bits
        if bits[i] == 1
           ans = mod(ans*w, p)  # reducing modulo p for more efficient multiplcation
        end
        w = mod(w^2, p)
    end
    return ans
end