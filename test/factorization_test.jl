#############################################################################
#############################################################################
#
# This file contains units tests for polynomial factorization
#                                                                               
#############################################################################
#############################################################################


"""
Test factorization of polynomials.
"""
function factor_test_poly(;N::Int = 2, seed::Int = 3, primes::Vector{Int} = [5,17,19])
    Random.seed!(seed)
    for prime in primes
        print("\ndoing prime = $prime \t")
        for _ in 1:N
            print(".")
            p = rand(PolynomialDense)
            factorization = factor(p, prime)
            pr = mod(expand_factorization(factorization),prime)
            @assert mod(p-pr,prime) == 0 
        end
    end

    println("\nfactor_test_poly - PASSED")
end

function factor_test_poly_sparse(;N::Int = 3, seed::Int = 3, primes::Vector{Int} = [5,7,11])
    Random.seed!(seed)
    for prime in primes
        print("\ndoing prime = $prime \t")
        for _ in 1:N
            print(".")
            p = rand(PolynomialSparse)
            factorization = factor(p, prime)
            pr = mod(expand_factorization(factorization),prime)
            @assert mod(p-pr,prime) == 0 
        end
    end

    println("\nfactor_test_poly_sparse - PASSED")
end

function factor_test_poly_modp(;N::Int = 2, seed::Int = 3, primes::Vector{Int} = [5,17,19])
    Random.seed!(seed)
    for prime in primes
        print("\ndoing prime = $prime \t")
        for _ in 1:N
            print(".")
            p = PolynomialModP128(rand(PolynomialSparse128), prime)
            factorization = factor(p)
            pr = expand_factorization(factorization)
            @assert iszero(p-pr) 
        end
    end

    println("\nfactor_test_poly_modp - PASSED")
end