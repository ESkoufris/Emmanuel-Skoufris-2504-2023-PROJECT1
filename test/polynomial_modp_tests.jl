using Primes

"""
Test product of polynomials.
"""
function prod_test_poly_modp(;num_primes::Int = 5, N::Int = 15, N_prods::Int = 20, seed::Int = 0)
    Random.seed!(seed)

    # obtaining the first 100 primes
    primes = [prime(i) for i in 1:100]

    #sampling 5 primes from the first 100 primes
    for m in sample(primes, num_primes, replace = false)
        for _ in 1:N
            p1 = PolynomialModP(rand(PolynomialSparse),m)
            p2 = PolynomialModP(rand(PolynomialSparse),m)
            prod = p1*p2
            @assert leading(prod) == mod(leading(p1)*leading(p2), m)
        end
    end 
    for m in sample(primes, 5, replace = false)
        for _ in 1:N
            p_base = PolynomialModP(PolynomialSparse(Term(1,0)), m)
            for _ in 1:N_prods
                p = PolynomialModP(rand(PolynomialSparse), m)
                prod = p_base*p
                @assert leading(prod) == mod(leading(p_base)*leading(p), m)
                p_base = prod
            end
        end
    end
    println("prod_test_poly_modp - PASSED")
end

"""
Test derivative of polynomials (as well as product).
"""
function prod_derivative_test_poly_modp(;num_primes::Int = 20, N::Int = 10^2,  seed::Int = 0)
    Random.seed!(seed)
    # obtaining the first 100 primes
    primes = [prime(i) for i in 1:100]
    for m in sample(primes, num_primes, replace = false)
        for _ in 1:N
            p1 = PolynomialModP(rand(PolynomialSparse),m)
            p2 = PolynomialModP(rand(PolynomialSparse),m)
            p1d = derivative(p1)
            p2d = derivative(p2)
            @assert (p1d*p2) + (p1*p2d) == derivative(p1*p2)
        end
    end
    println("prod_derivative_test_poly_modp - PASSED")
end


"""
Test division of polynomials modulo p.
"""
function division_test_poly_modp(;prime::Int = 101, N::Int = 10^4, seed::Int = 0)
    Random.seed!(seed)
    for _ in 1:N
        p1 = PolynomialModP(rand(PolynomialSparse),prime)
        p2 = PolynomialModP(rand(PolynomialSparse),prime)
        p_prod = p1*p2
        q, r = PolynomialModP(PolynomialSparse(), prime), PolynomialModP(PolynomialSparse(), prime)
        try
            q, r = divide(p_prod, p2)
            if (q, r) == (nothing,nothing)
                println("Unlucky prime: $p1 is reduced to $(p1 % prime) modulo $prime")
                continue
            end
        catch e
            if typeof(e) == DivideError
                @assert p2 == 0
            else
                throw(e)
            end
        end
        @assert iszero(q*p2+r - p_prod)
    end                    
    println("division_test_poly_modp - PASSED")
end

"""
Test the extended euclid algorithm for polynomials modulo p.
"""
function ext_euclid_test_poly_modp(;prime::Int=103, N::Int = 10^3, seed::Int = 0)
    Random.seed!(seed)
    for _ in 1:N
        p1 = PolynomialModP(rand(PolynomialSparse),prime)
        p2 = PolynomialModP(rand(PolynomialSparse),prime)
        g, s, t = extended_euclid_alg(p1, p2)
        @assert iszero(s*p1 + t*p2 - g)
    end
    println("ext_euclid_test_poly_modp - PASSED")
end

"""
Test exponentiation using repeated squaring
"""

function pow_mod_test(;prime::Int=103, N::Int = 10)
    p = rand(PolynomialSparse128)
    for k in 1:N
        @assert pow_mod_efficient(PolynomialModP128(p, prime), k) == PolynomialModP128(p, prime)^k
    end 
    println("pow_mod_test - PASSED")
end 
