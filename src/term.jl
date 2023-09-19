#############################################################################
#############################################################################
#
# This file defines the Term type with several operations 
#                                                                               
#############################################################################
#############################################################################

##############################
# Term type and construction #
##############################

"""
A term.
"""
struct Term  #structs are immutable by default
    coeff::Integer
    degree::Integer
    function Term(coeff::Integer, degree::Integer) 
        degree < 0 && error("Degree must be non-negative")
        coeff != 0 ? new(coeff,degree) : new(coeff,0)
    end
end
"""
Creates the zero term.
"""

zero(::Type) = Term(0,0)
zero(::Type)::Term = Term(0,0)

Term128(n,k) = Term(Int128(n), Int128(k))
Term128(t::Term) = Term128(t.coeff, t.degree)

"""
Creates the unit term.
"""
one(::Type) = Term(1,0)
one(::Type)::Term = Term(1,0)

###########
# Display #
###########

"""
Unicode superscript.
"""

function superscript(n::Integer)

    digit_to_unicode = Dict(
        '0' => 0x2070,
        '1' => 0x00B9,
        '2' => 0x00B2,
        '3' => 0x00B3,
        '4' => 0x2074,
        '5' => 0x2075,
        '6' => 0x2076,
        '7' => 0x2077,
        '8' => 0x2078,
        '9' => 0x2079 
    )

    n_str = string(n)

    unicode_str = ""

    for i in n_str
        unicode_digit = Char(digit_to_unicode[i])
        unicode_str *= unicode_digit
    end

    return unicode_str
end

"""
Show a term.
"""

function show(io::IO, t::Term)  
    iszero(t.coeff) && return print(io,"0")
    iszero(t.degree) && return print(io,t.coeff)
    if abs(t.coeff) == 1
        print(io, t.coeff == 1 ? "x" : "-x", t.degree == 1 ? "" : superscript(t.degree)) 
    else 
        print(io, "$(t.coeff)x", t.degree == 1 ? "" : superscript(t.degree))
    end
end

########################
# Queries about a term #
########################

"""
Check if a term is 0.
"""
iszero(t::Term)::Bool = iszero(t.coeff)

"""
Compare two terms.
"""
isless(t1::Term,t2::Term)::Bool =  t1.degree == t2.degree ? (t1.coeff < t2.coeff) : (t1.degree < t2.degree)  

"""
Evaluate a term at a point x.
"""
evaluate(t::Term, x::T) where T <: Number = t.coeff * x^t.degree

##########################
# Operations with a term #
##########################

"""
Add two terms of the same degree.
"""
function +(t1::Term, t2::Term)::Term
    @assert t1.degree == t2.degree
    Term(t1.coeff + t2.coeff, t1.degree)
end

"""
Negate a term.
"""
-(t::Term,) = Term(-t.coeff,t.degree)  

"""
Subtract two terms with the same degree.
"""
-(t1::Term, t2::Term)::Term = t1 + (-t2) 

"""
Multiply two terms.
"""
*(t1::Term, t2::Term)::Term = Term(t1.coeff * t2.coeff, t1.degree + t2.degree)


"""
Compute the symmetric mod of a term with an integer.
"""
mod(t::Term, p::Int) = Term(mod(t.coeff,p), t.degree)
smod(t::Term, p::Int) = Term(smod(t.coeff,p), t.degree)

"""
Compute the derivative of a term.
"""
derivative(t::Term) = Term(t.coeff*t.degree,max(t.degree-1,0))

"""
Divide two terms. Returns a function of an integer.
"""
function ÷(t1::Term,t2::Term) #\div + [TAB]
    @assert t1.degree ≥ t2.degree
    f(p::Int)::Term = Term(mod((t1.coeff * int_inverse_mod(t2.coeff, p)), p), t1.degree - t2.degree)
end

"""
Integer divide a term by an integer.
"""
÷(t::Term, n::Integer) = t ÷ Term(n,0)
