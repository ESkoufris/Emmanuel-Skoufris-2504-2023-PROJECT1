#############################################################################
#############################################################################
#
# This file contains units tests for poly_sparsenomial operations
#                                                                               
#############################################################################
#############################################################################


"""
Test product of polynomials.
"""
function prod_test_poly_sparse(;N::Int = 15, N_prods::Int = 20, seed::Int = 0)
    Random.seed!(seed)
    for _ in 1:N
        p1 = rand(PolynomialSparse)
        p2 = rand(PolynomialSparse)
        prod = p1*p2
        @assert leading(prod) == leading(p1)*leading(p2)
    end

    for _ in 1:N
        p_base = PolynomialSparse(Term(1,0))
        for _ in 1:N_prods
            p = rand(PolynomialSparse)
            prod = p_base*p
            @assert leading(prod) == leading(p_base)*leading(p)
            p_base = prod
        end
    end
    println("prod_test_poly_sparse - PASSED")
end



"""
Test derivative of polynomials (as well as product).
"""
function prod_derivative_test_poly_sparse(;N::Int = 10^2,  seed::Int = 0)
    Random.seed!(seed)
    for _ in 1:N
        p1 = rand(PolynomialSparse)
        p2 = rand(PolynomialSparse)
        p1d = derivative(p1)
        p2d = derivative(p2)
        @assert (p1d*p2) + (p1*p2d) == derivative(p1*p2)
    end
    println("prod_derivative_test_poly_sparse - PASSED")
end


"""
Test division of polynomials modulo p.
"""
function division_test_poly_sparse(;prime::Int = 101, N::Int = 10^4, seed::Int = 0)
    Random.seed!(seed)
    for _ in 1:N
        p1 = rand(PolynomialSparse)
        p2 = rand(PolynomialSparse)
        p_prod = p1*p2
        q, r = PolynomialSparse(), PolynomialSparse()
        try
            q, r = divide(p_prod, p2)(prime)
            if (q, r) == (nothing,nothing)
                println("Unlucky prime: $p1 is reduced to $(p1 % prime) modulo $prime")
                continue
            end
        catch e
            if typeof(e) == DivideError
                @assert mod(p2, prime) == 0
            else
                throw(e)
            end
        end
        @assert iszero( mod(q*p2+r - p_prod, prime) )
    end
    println("division_test_poly_sparse - PASSED")
end

"""
Test the extended euclid algorithm for polynomials modulo p.
"""
function ext_euclid_test_poly_sparse(;prime::Int=101, N::Int = 10^3, seed::Int = 0)
    Random.seed!(seed)
    for _ in 1:N
        p1 = rand(PolynomialSparse)
        p2 = rand(PolynomialSparse)
        g, s, t = extended_euclid_alg(p1, p2, prime)
        @assert mod(s*p1 + t*p2 - g, prime) == 0
    end
    println("ext_euclid_test_poly_sparse - PASSED")
end

"""
Test multiplication using the Chineses Remainder Theorem
"""
function crt_multiply_test_poly_sparse(;N::Int = 100)
    for _ in 1:N
        p1 = rand(PolynomialSparse128)
        p2 = rand(PolynomialSparse128)
        crt_multiply(p1,p2) != p1*p2 && println("p1 = $(p1)", "\n","p2 = $(p2)", "\n", crt_multiply(p1,p2), "\n", p1*p2) # useful for debugging 
        @assert crt_multiply(p1,p2) == p1*p2
    end 
    println("crt_multiply_test_poly_sparse - PASSED")
end

# Tests for PolynomialSparse128

"""
Test product of polynomials.
"""
function prod_test_poly_sparse128(;N::Int = 15, N_prods::Int = 20, seed::Int = 0)
    Random.seed!(seed)
    for _ in 1:N
        p1 = rand(PolynomialSparse128)
        p2 = rand(PolynomialSparse128)
        prod = p1*p2
        @assert leading(prod) == leading(p1)*leading(p2)
    end

    for _ in 1:N
        p_base = PolynomialSparse128(Term(1,0))
        for _ in 1:N_prods
            p = rand(PolynomialSparse128)
            prod = p_base*p
            @assert leading(prod) == leading(p_base)*leading(p)
            p_base = prod
        end
    end
    println("prod_test_poly_Sparse128 - PASSED")
end



"""
Test derivative of polynomials (as well as product).
"""
function prod_derivative_test_poly_sparse128(;N::Int = 10^2,  seed::Int = 0)
    Random.seed!(seed)
    for _ in 1:N
        p1 = rand(PolynomialSparse128)
        p2 = rand(PolynomialSparse128)
        p1d = derivative(p1)
        p2d = derivative(p2)
        @assert (p1d*p2) + (p1*p2d) == derivative(p1*p2)
    end
    println("prod_derivative_test_poly_Sparse128 - PASSED")
end


"""
Test division of polynomials modulo p.
"""
function division_test_poly_sparse128(;prime::Int = 101, N::Int = 10^4, seed::Int = 0)
    Random.seed!(seed)
    for _ in 1:N
        p1 = rand(PolynomialSparse128)
        p2 = rand(PolynomialSparse128)
        p_prod = p1*p2
        q, r = PolynomialSparse128(), PolynomialSparse128()
        try
            q, r = divide(p_prod, p2)(prime)
            if (q, r) == (nothing,nothing)
                println("Unlucky prime: $p1 is reduced to $(p1 % prime) modulo $prime")
                continue
            end
        catch e
            if typeof(e) == DivideError
                @assert mod(p2, prime) == 0
            else
                throw(e)
            end
        end
        @assert iszero( mod(q*p2+r - p_prod, prime) )
    end
    println("division_test_poly_Sparse128 - PASSED")
end

"""
Test the extended euclid algorithm for polynomials modulo p.
"""
function ext_euclid_test_poly_sparse128(;prime::Int=101, N::Int = 10^3, seed::Int = 0)
    Random.seed!(seed)
    for _ in 1:N
        p1 = rand(PolynomialSparse128)
        p2 = rand(PolynomialSparse128)
        g, s, t = extended_euclid_alg(p1, p2, prime)
        @assert mod(s*p1 + t*p2 - g, prime) == 0
    end
    println("ext_euclid_test_poly_Sparse128 - PASSED")
end

"""
Test potential overflow of coefficients 
"""
function overflow_test(; n = 127)
    for k in 2:n
        p = PolynomialSparse128([Term(Int128(2)^k - 1,1)])
        @assert leading(p).coeff > 0
    end 
    println("overflow_test- PASSED")
end


"""
Test exponentiation modulo a prime number
"""

function pow_mod_test(;prime = 103, N =20)
    p_base = rand(PolynomialSparse128)
    p = one(PolynomialSparse128)
    for k in 1:N
        p = mod(p_base*p, prime)
        @assert pow_mod(p_base,k,prime) == p
    end 
    println("pow_mod_test - PASSED")
end 