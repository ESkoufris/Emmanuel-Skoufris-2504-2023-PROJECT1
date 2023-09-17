#############################################################################
#############################################################################
#
# This file implements polynomial addition 
#                                                                               
#############################################################################
#############################################################################

"""
Add a polynomial and a term.
"""
function +(p::PolynomialSparse, t::Term)
    p = deepcopy(p)
 
    if haskey(p.dict, t.degree) 
        t0 = get_element(p.terms, p.dict, t.degree)
        #= t.degree != t0.degree && print(p.terms, "\n", p.terms[1], "\n", (t0,t), "\n", p.dict,) =#
        delete_element!(p.terms, p.dict, t.degree)

        # checking if t0 = 0 is to account for some weird edge cases in which the zeroth term is somehow stored in p.terms
        !iszero(t0) ? insert_sorted!(p.terms, p.dict, t.degree, t0 + t) : insert_sorted!(p.terms, p.dict, t.degree,t)
    else  
        insert_sorted!(p.terms, p.dict, t.degree, t)
    end

    return trim!(p)
end

+(t::Term, p::PolynomialSparse) = p + t

"""
Add two polynomials.
"""
function +(p1::PolynomialSparse, p2::PolynomialSparse)::PolynomialSparse
    p = deepcopy(p1)
    for t in p2.terms
        p += t
    end
    return p
end

-(p1::PolynomialSparse, t::Term)::PolynomialSparse = p1 + (-t)
-(p1::PolynomialSparse, p2::PolynomialSparse)::PolynomialSparse = p1 + - p2

-(t::Term, p1::PolynomialSparse)::PolynomialSparse = -p1 + t

"""
Add a polynomial and an integer.
"""
+(p::PolynomialSparse, n::Int) = p + Term(n,0)
-(p::PolynomialSparse, n::Int) = p - Term(n,0)
+(n::Int, p::PolynomialSparse) = p + Term(n,0)








"""
PolynomialSparse128 implementation
"""
function +(p::PolynomialSparse128, t::Term)
    p = deepcopy(p)

    #much of this was modified to accomodate for the mutable linked list and dictionary structure 
    if haskey(p.dict, t.degree) 
        t0 = get_element(p.terms, p.dict, Int128(t.degree))
        delete_element!(p.terms, p.dict, Int128(t.degree))
        !iszero(t0) ? insert_sorted!(p.terms, p.dict, Int128(t.degree), Term128(t0 + t)) : insert_sorted!(p.terms, p.dict, Int128(t.degree), Term128(t))
    else  
        insert_sorted!(p.terms, p.dict, Int128(t.degree), Term128(t))
    end

    return trim!(p)
end

+(t::Term, p::PolynomialSparse128) = p + t

"""
Add two polynomials.
"""
function +(p1::PolynomialSparse128, p2::PolynomialSparse128)::PolynomialSparse128
    p = deepcopy(p1)
    for t in p2.terms
        p += t
    end
    return p
end

-(p1::PolynomialSparse128, t::Term)::PolynomialSparse128 = p1 + (-t)
-(p1::PolynomialSparse128, p2::PolynomialSparse128)::PolynomialSparse128 = p1 + - p2

-(t::Term, p1::PolynomialSparse128)::PolynomialSparse128 = -p1 + t

"""
Add a polynomial and an integer.
"""
+(p::PolynomialSparse128, n::Int) = p + Term(n,0)
-(p::PolynomialSparse128, n::Int) = p - Term(n,0)
+(n::Int, p::PolynomialSparse128) = p + Term(n,0)