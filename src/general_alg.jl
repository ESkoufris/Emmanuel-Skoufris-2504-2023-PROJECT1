#############################################################################
#############################################################################
#
# This file implement several basic algorithms for integers. 
#                                                                               
#############################################################################
#############################################################################

"""
The quotient between two numbers
"""
function quo(a::T,b::T) where T <: Integer
    a < 0 && return -quo(-a,b)
    a < b && return 0
    return 1 + quo(a-b, b)
end

"""
Euclid's algorithm.
"""
function euclid_alg(a, b; rem_function = %)
    b == 0 && return a
    return euclid_alg(b, rem_function(a,b); rem_function = rem_function)
end

"""
Euclid's algorithm on multiple arguments.
"""
euclid_alg(a...) = foldl((a,b)->euclid_alg(a,b), a; init = 0)

"""
Euclid's algorithm on a vector.
"""
euclid_alg(a::Vector{T}) where T <: Integer = euclid_alg(a...)


"""
The extended Euclidean algorithm.
"""
function ext_euclid_alg(a, b, rem_function = %, div_function = ÷)
    a == 0 && return b, 0, 1
    g, t, s = ext_euclid_alg(rem_function(b,a), a, rem_function, div_function)
    s = s - div_function(b,a)*t
    @assert g == a*s + b*t
    return g, s, t
end

"""
Display the result of the extended Euclidean algorithm.
"""
pretty_print_egcd((a,b),(g,s,t)) = println("$a × $s + $b × $t = $g") #\times + [TAB]


"""
Symmetric mod

"""
function smod(x, m)
    r = x % m
    if r <= m // 2
        return r
    else
        return r - m
    end
end

"""
Integer inverse symmetric mod
"""
function int_inverse_mod(a::Integer, m::Integer)::Integer
    if mod(a, m) == 0
        error("Can't find inverse of $a mod $m because $m divides $a") 
    end
    return mod(ext_euclid_alg(a,m)[2],m)
end

"""
Chinese Remainder Theorem
"""

using LinearAlgebra

function crt(u, m)
    #=  length(u) != length(m) && return  =#
    k = length(m)
    v = zeros(k+1)
    v[1] = mod(u[1],m[1])
 
    q = zeros(k + 1)
    q[1] = Int(1)
    
    # could remove this if it causes problems
    #= iszero(u) && return *(m...) =#
    
    # creating a vector of the form (1,m2,m1*m2, m1*m2*m3,...)
    for i in 2:(k+1)
        q[i] = *(m[1:(i-1)]...);
    end
 
    for i in 2:k
        inv = int_inverse_mod(Integer(q[i]), m[i]) 
        v[i] = mod(inv*(u[i] - dot(v,q)), m[i])
    end 
    return Integer(floor(dot(v,q)))
 end 

""" 
 Fast exponentiation mod p using repeated squaring
"""

function pow_mod(x::Integer, m::Integer, p::Integer)
    @assert m > 0 && isprime(p)
    
    num_bits = Int(floor(log2(m) + 1)) # computing the position of the leftmost bit.
    bits = zeros(num_bits) 

    for i in 1:num_bits
        (m & (1 << (i-1)) != 0) && (bits[i] = 1) # checks if the i'th bit is zero. 
    end

    ans, w = 1, mod(x, p)   

    for i in 1:num_bits
        if bits[i] == 1
           ans = mod(ans*w, p)  # reducing modulo p for more efficient multiplcation
        end
        w = mod(w^2, p)
    end
    return ans
end