include("taylor.jl")
using Test, .SeriesTaylor

@testset "Taylor" begin

    @testset "Suma" begin
        @test 1 + Taylor([0,0]) == Taylor([1,0])
        @test Taylor([1.0,1.0]) + 1.0 == Taylor([2.0,1.0])
        @test Taylor([1,2,3]) + Taylor([3,2,1]) == Taylor([4,4,4])
    end;
    
    @testset "Resta" begin
        @test 5.0 - Taylor([3.0,2.0]) == Taylor([2.0,-2.0])
        @test Taylor([2,3]) - 4 == Taylor([-2,3])
        @test Taylor([1.0,2.0,1.0]) - Taylor([2.0,1.0,2.0]) == Taylor([-1.0,1.0,-1.0])
        @test -Taylor([1,2]) + Taylor([3,4]) == Taylor([2,2])
    end;
    
    @testset "Producto" begin
        @test 5*Taylor([1,1,1,1,1]) == Taylor([5,5,5,5,5])
        @test Taylor([0,1,0,1,0]) * -2 == Taylor([0,-2,0,-2,0])
        
        # (1 + x)(1 - x) = 1 - x^2
        @test Taylor([1,1,0]) * Taylor([1,-1,0]) == Taylor([1,0,-1])

        # (1 + x)(1 - x + x^2) = 1 + x^3
        @test Taylor(3, [1,1]) * Taylor(3, [1,-1,1]) == Taylor([1,0,0,1])

        # (1 - x)(1 + x + x^2) = 1 - x^3
        @test Taylor(3,[1,1]) * Taylor(3, [1,-1,1]) == Taylor([1,0,0,1])
    end;
    
    @testset "División" begin
        @test Taylor(4,[1,1])/0.5 == Taylor(4,[2,2])
        
        # 1 / (x - 1) = Sum x^i
        @test 1 / Taylor(28, [1,-1]) == Taylor(ones(29))
        
        # (1 - x^2) / (1 - x) = (1 + x)
        @test Taylor([1,0,-1]) / Taylor([1,-1,0]) == Taylor([1,1,0])

        # (1 + x^3) / (1 + x) = (1 - x + x^2)
        @test Taylor([1,0,0,1]) / Taylor(3, [1,1]) == Taylor(3,[1,-1,1])

        # (1 - x^3) / (1 - x) = (1 + x + x^2)
        @test Taylor(3,[1,0,0,-1]) / Taylor(3, [1,-1]) == Taylor(3,[1,1,1])
    end;
    
    @testset "Exponencial" begin
        # e^x = Sum x^i / i!
        @test exp(Taylor(100, [0,1])) ≈ Taylor([inv(factorial(big(n))) for n in 0:100])
        @test exp(Taylor(100, [0,2])) ≈ Taylor([2^n * inv(factorial(big(n))) for n in 0:100])
        @test exp(Taylor(100, [0,-1])) ≈ Taylor([(-1)^n * inv(factorial(big(n))) for n in 0:100])
    end;
    
    @testset "Logaritmo" begin
        # log(1+x) = Sum (-1)^(i+1) x^i / i
        @test log(Taylor(100, [1,1])) ≈ Taylor(vcat([0],[(-1)^(n+1) / n for n in 1:100]))
        @test log(Taylor(100, [1,2])) ≈ Taylor(vcat([0],[(-1)^(n+1) * big(2)^n / n for n in 1:100]))
        @test log(Taylor(100, [1,-1])) ≈ -Taylor(vcat([0],[1/n for n in 1:100]))
    end;
    
    @testset "Potencia" begin
        @test Taylor(2,[0,1])^2 == Taylor([0,0,1])
        
        # (1 + x)^2 = 1 + 2x + x^2
        @test (1 + Taylor(2, [0,1]))^2 == Taylor([1,2,1])

        # (1 - x)^2 = 1 - 2x + x^2
        @test (Taylor(2, [0,-1]) + 1)^2 == Taylor([1,-2,1])
        
        # (x^2 + x^3)^2 = x^4 + 2x^5 + x^6
        @test Taylor(6, [0,0,1,1])^2 == Taylor([0,0,0,0,1,2,1])
        
        # (x - x^3)^2 = x^2 - 2x^4 + x^6
        @test Taylor(6, [0,1,0,-1])^2 == Taylor([0,0,1,0,-2,0,1])
        
        # (1 + x)^3 = 1 + 3x + 3x^2 + x^3
        @test (Taylor([1,0,0,0]) + Taylor([0,1,0,0]))^3 == Taylor([1,3,3,1])

        # (1 - x)^3 = 1 - 3x + 3x^2 - x^3
        @test (-Taylor([-1,1,0,0]))^3 == Taylor([1,-3,3,-1])
        
        # (x - x^2)^3 = x^3 - 3x^4 + 3x^5 - x^6
        @test Taylor(6, [0,1,-1])^3 == Taylor([0,0,0,1,-3,3,-1])
        
        # 1 / (1 - x) = Sum x^i
        @test Taylor(100, [1,-1])^-1 ≈ Taylor(ones(101))

        # 1 / (1 - x)^2 = Sum i x^(i-1)
        @test Taylor(100, [1]) / (Taylor(100, [0,1]) - 1)^2 == Taylor(1:101)

        # 1 / (1 - x)^3 = Sum i(i+1) x^(i-1) / 2
        @test Taylor(31, [1,-1])^(-3) == Taylor([i*(i+1)/2 for i in 1:32])
        
        # (1+x)^(1/2) = Sum (-1)^i (2i)! x^i / 4^i (1-2i) (i!)^2
        @test Taylor(25, [1,1])^0.5 ≈ Taylor([(-1)^i*factorial(2*big(i)) /(4^i*(1-2i)*factorial(big(i))^2) for i in 0:25])
    end;
    
    @testset "Coseno" begin
        # cos(x) = Sum (-1)^i x^(2i) / (2i)!
        @test cos(Taylor(99, [0,1])) ≈ Taylor( vcat([[(-1)^i * inv(factorial(big(2*i))),0] for i in 0:49]...) )
        @test cos(Taylor(99, [0,-1])) ≈ Taylor( vcat([[(-1)^i * inv(factorial(big(2*i))),0] for i in 0:49]...) )
        @test cos(Taylor(99, [0,3])) ≈ Taylor( vcat([[(-9)^i * inv(factorial(big(2*i))),0] for i in 0:49]...) )
    end;
    
    @testset "Seno" begin
        # sen(x) = Sum (-1)^i x^(2i+1) / (2i+1)!
        @test sin(Taylor(99, [0,1])) ≈ Taylor( vcat([[0,(-1)^i * inv(factorial(big(2*i+1)))] for i in 0:49]...) )
        @test sin(Taylor(99, [0,-1])) ≈ -Taylor( vcat([[0,(-1)^i * inv(factorial(big(2*i+1)))] for i in 0:49]...) )
        @test sin(Taylor(99, [0,4])) ≈ Taylor( vcat([[0,(-16)^i * 4 * inv(factorial(big(2*i+1)))] for i in 0:49]...) )
    end;
    
end;