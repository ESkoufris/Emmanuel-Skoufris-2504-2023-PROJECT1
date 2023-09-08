using Pkg, DataStructures
Pkg.activate(".")


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
    dict::Dict{Int, DataStructures.ListNode{Term}}

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
            insert_sorted!(terms, dict, t.degree, t) #+1 accounts for 1-indexing
        end
        return new(terms, dict)
    end
end

# Example operations 

#= 
PolynomialSparse(x_poly().terms)

pop!(PolynomialSparse([Term(1,1), Term(1,2), Term(-1,4)]).terms) =#


"""
This function maintains the invariant of the Polynomial type so that there are no zero terms beyond the highest
non-zero term.
"""
function trim!(p::PolynomialSparse)::PolynomialSparse
    i = length(p.terms)
    while i > 1
        if iszero(p.terms[i])
            pop!(p.terms)
        else
            break
        end
        i -= 1
    end
    return p
end

"""
Construct a polynomial with a single term.
"""

PolynomialSparse(t::Term) = PolynomialSparse([t])

"""
Construct a polynomial with a single term.
"""
PolynomialSparse(t::Term) = PolynomialSparse([t])

"""
Construct a polynomial of the form x^p-x.
"""
cyclotonic_polynomialsparse(p::Int) = PolynomialSparse([Term(1,p), Term(-1,0)])


"""
Construct a polynomial of the form x-n.
"""
linear_monic_polynomialsparse(n::Int) = PolynomialSparse([Term(1,1), Term(-n,0)])

"""
Construct a polynomial of the form x.
"""
x_polysparse() = PolynomialSparse(Term(1,1))

"""
Creates the zero polynomial.
"""
zero(::Type{PolynomialSparse})::PolynomialSparse = PolynomialSparse()

"""
Creates the unit polynomial.
"""
one(::Type{PolynomialSparse})::PolynomialSparse = PolynomialSparse(one(Term))
one(p::PolynomialSparse) = one(typeof(p))

"""
Generates a random polynomial.
"""
function rand(::Type{PolynomialSparse} ; 
                degree::Int = -1, 
                terms::Int = -1, 
                max_coeff::Int = 100, 
                mean_degree::Float64 = 5.0,
                prob_term::Float64  = 0.7,
                monic = false,
                condition = (p)->true)
        
    while true 
        _degree = degree == -1 ? rand(Poisson(mean_degree)) : degree
        _terms = terms == -1 ? rand(Binomial(_degree,prob_term)) : terms
        degrees = vcat(sort(sample(0:_degree-1,_terms,replace = false)),_degree)
        coeffs = rand(1:max_coeff,_terms+1)
        monic && (coeffs[end] = 1)
        p = PolynomialSparse( [Term(coeffs[i],degrees[i]) for i in 1:length(degrees)] )
        condition(p) && return p
    end
end

###########
# Display #
###########

"""
Shows a polynomial.
"""

# By default, print from highest to lowest powers. 
global lowest_to_highest = false

# modified show for polynomials  
function show(io::IO, p::PolynomialSparse) 

    if iszero(p)
        print(io,"0")
    else
        n = length(p.terms)
        (hasproperty(Main, :lowest_to_highest) && lowest_to_highest) ?  p_terms = p.terms  : p_terms = reverse(p.terms)
        for (i,t) in enumerate([y for y in p_terms if !iszero(y)])
            print(io, i==1 ? "$t" : (t.coeff ≥ 0 ? " + $t" : " - $(-t)"))
        end
    end
    
end

##############################################
# Iteration over the terms of the polynomial #
##############################################

"""
Allows to do iteration over the non-zero terms of the polynomial. This implements the iteration interface.
"""
iterate(p::PolynomialSparse, state=1) = iterate(p.terms, state)

##############################
# Queries about a polynomial #
##############################

"""
The number of terms of the polynomial.
"""
length(p::PolynomialSparse) = length(p.terms) 

"""
The leading term of the polynomial.
"""
leading(p::PolynomialSparse)::Term = isempty(p.terms) ? zero(Term) : last(p.terms) 

"""
Returns the coefficients of the polynomial.
"""
coeffs(p::PolynomialSparse)::Vector{Int} = [t.coeff for t in p]

"""
The degree of the polynomial.
"""
degree(p::PolynomialSparse)::Int = leading(p).degree 

"""
The content of the polynomial is the GCD of its coefficients.
"""
content(p::PolynomialSparse)::Int = euclid_alg(coeffs(p))

"""
Evaluate the polynomial at a point `x`.
"""
evaluate(f::PolynomialSparse, x::T) where T <: Number = sum(evaluate(t,x) for t in f)

################################
# Pushing and popping of terms #
################################

"""
Push a new term into the polynomial.
"""
#Note that ideally this would throw and error if pushing another term of degree that is already in the polynomial
function push!(p::PolynomialSparse, t::Term) 
    if t.degree <= degree(p)
        p.terms[t.degree + 1] = t
        p.dict[t.degree] =  t
    else
        # this implementation differs from that of PolynomialDense, since we also have to update the dictionary.
        insert_sorted!(p.terms, p.dict, t.degree, t)
    end
    return p        
end

push!(x_polysparse(), Term(1,2))

"""
Pop the leading term out of the polynomial. When polynomial is 0, keep popping out 0.
"""
function pop!(p::PolynomialSparse)::Term 
    popped_term = pop!(p.terms) #last element popped is leading coefficient

    while !isempty(p.terms) && iszero(last(p.terms))
        pop!(p.terms)
    end

    if isempty(p.terms)
        push!(p.terms, zero(Term))
    end

    return popped_term
end

"""
Check if the polynomial is zero.
"""
iszero(p::PolynomialSparse)::Bool = p.terms == [Term(0,0)]

"""
The negative of a polynomial.
"""
-(p::PolynomialSparse) = PolynomialSparse(map((pt)->-pt, p.terms))

"""
Create a new polynomial which is the derivative of the polynomial.
"""
function derivative(p::PolynomialSparse)::PolynomialSparse 
    der_p = PolynomialSparse()
    for term in p.terms
        der_term = derivative(term)
        !iszero(der_term) && push!(der_p,der_term)
    end
    return trim!(der_p)
end

"""
The prim part (multiply a polynomial by the inverse of its content).
"""
prim_part(p::PolynomialSparse) = p ÷ content(p)


"""
A square free polynomial.
"""
square_free(p::Polynomial, prime::Int)::Polynomial = (p ÷ gcd(p,derivative(p),prime))(prime)

#################################
# Queries about two polynomials #
#################################

"""
Check if two polynomials are the same
"""
==(p1::Polynomial, p2::Polynomial)::Bool = p1.terms == p2.terms


"""
Check if a polynomial is equal to 0.
"""
#Note that in principle there is a problem here. E.g The polynomial 3 will return true to equalling the integer 2.
==(p::Polynomial, n::T) where T <: Real = iszero(p) == iszero(n)

##################################################################
# Operations with two objects where at least one is a polynomial #
##################################################################

"""
Subtraction of two polynomials.
"""
-(p1::Polynomial, p2::Polynomial)::Polynomial = p1 + (-p2)


"""
Multiplication of polynomial and term.
"""
*(t::Term, p1::Polynomial)::Polynomial = iszero(t) ? Polynomial() : Polynomial(map((pt)->t*pt, p1.terms))
*(p1::Polynomial, t::Term)::Polynomial = t*p1

"""
Multiplication of polynomial and an integer.
"""
*(n::Int, p::Polynomial)::Polynomial = p*Term(n,0)
*(p::Polynomial, n::Int)::Polynomial = n*p

"""
Integer division of a polynomial by an integer.

Warning this may not make sense if n does not divide all the coefficients of p.
"""
÷(p::Polynomial, n::Int) = (prime)->Polynomial(map((pt)->((pt ÷ n)(prime)), p.terms))

"""
Take the mod of a polynomial with an integer.
"""
function mod(f::Polynomial, p::Int)::Polynomial
    f_out = deepcopy(f)
    for i in 1:length(f_out.terms)
        f_out.terms[i] = mod(f_out.terms[i], p)
    end
    return trim!(f_out)
        
    # p_out = Polynomial()
    # for t in f
    #     new_term = mod(t, p)
    #     @show new_term
    #     push!(p_out, new_term)
    # end
    # return p_out
end

"""
Power of a polynomial mod prime.
"""
function pow_mod(p::Polynomial, n::Int, prime::Int)
    n < 0 && error("No negative power")
    out = one(p)
    for _ in 1:n
        out *= p
        out = mod(out, prime)
    end
    return out
end


