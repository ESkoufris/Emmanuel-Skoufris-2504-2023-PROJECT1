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

    #much of this was modified to accomodate for the mutable linked list and dictionary structure 
    if haskey(p.dict, t.degree) 
        t0 = get_element(p.terms, p.dict, t.degree)
        delete_element!(p.terms, p.dict, t.degree)
        insert_sorted!(p.terms, p.dict, t.degree, t0 + t)
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