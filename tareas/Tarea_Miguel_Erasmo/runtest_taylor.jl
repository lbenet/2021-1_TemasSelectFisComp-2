include("taylor.jl")
using Test, .SeriesTaylor

@testset "Taylor: Operaciones" begin
    
    @testset "Producto" begin
        # (1 + x)^2 = 1 + 2x + x^2
        @test (1 + Taylor(2, [0,1]))^2 == Taylor([1,2,1])

        # (1 - x)^2 = 1 - 2x + x^2
        @test (Taylor(2, [0,-1]) + 1)^2 == Taylor([1,-2,1])

        # (1 + x)(1 - x) = 1 - x^2
        @test Taylor([1,1,0]) * Taylor([1,-1,0]) == Taylor([1,0,-1])

        # (1 + x)^3 = 1 + 3x + 3x^2 + x^3
        @test (Taylor([1,0,0,0]) + Taylor([0,1,0,0]))^3 == Taylor([1,3,3,1])

        # (1 - x)^3 = 1 - 3x + 3x^2 - x^3
        @test (-Taylor([-1,1,0,0]))^3 == Taylor([1,-3,3,-1])

        # (1 + x)(1 - x + x^2) = 1 + x^3
        @test Taylor(3, [1,1]) * Taylor(3, [1,-1,1]) == Taylor([1,0,0,1])

        # (1 - x)(1 + x + x^2) = 1 - x^3
        @test Taylor(3,[1,1]) * Taylor(3, [1,-1,1]) == Taylor([1,0,0,1])
    end;
    
    @testset "División" begin
        # 1 / (1 - x) = Sum x^i
        @test inv(1 - Taylor(28, [0,1])) == Taylor(ones(29))

        # 1 / (1 - x)^2 = Sum i x^(i-1)
        @test Taylor(100, [1]) / (Taylor(100, [0,1]) - 1)^2 == Taylor(1:101)

        # 1 / (1 - x)^3 = Sum i(i+1) x^(i-1) / 2
        @test Taylor(31, [1,-1])^(-3) == Taylor([i*(i+1)/2 for i in 1:32])
    end;
end;