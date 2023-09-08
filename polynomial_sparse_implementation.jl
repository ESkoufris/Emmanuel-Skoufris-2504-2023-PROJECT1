using Pkg
Pkg.activate(".")

include("poly_factorization_project.jl")

include("sorted_linked_list.jl")


using DataStructures


"""
A Polynomial type - designed to be for polynomials with integer coefficients.
"""

struct PolynomialSparse

    #A zero packed vector of terms
    #Terms are assumed to be in order with first term having degree 0, second degree 1, and so fourth
    #until the degree of the polynomial. The leading term (i.e. last) is assumed to be non-zero except 
    #for the zero polynomial where the vector is of length 1.
    #Note: at positions where the coefficient is 0, the power of the term is also 0 (this is how the Term type is designed)
    terms::MutableLinkedList{Term}
    dict::

    #Inner constructor of 0 polynomial
    PolynomialSparse() = new([zero(Term)])

    #Inner constructor of polynomial based on arbitrary list of terms
    function PolynomialSparse(vt::Vector{Term})

        #Filter the vector so that there is not more than a single zero term
        vt = filter((t)->!iszero(t), vt)
        if isempty(vt)
            vt = [zero(Term)]
        end

        dict = Dict{Int, DataStructures.ListNode{Term}}()
        terms = MutableLinkedList{Term}()
        max_degree = maximum((t)->t.degree, vt)

        #now update based on the input terms
        for t in vt
            value = vt[i]
            insert_sorted!(terms, dict, t.degree, t) #+1 accounts for 1-indexing
        end
        return new(terms, dict)
    end
end

"""
Construct a polynomial with a single term.
"""
PolynomialSparse(t::Term) = PolynomialSparse([t])

PolynomialSparse(Term(1,1))
