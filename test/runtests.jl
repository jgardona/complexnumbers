using ComplexNumbers
using Test

@testset "ComplexNumbers" begin

    @testset "Construtores e acessores" begin
        z = ComplexNumber(3, 4)
        @test real(z) == 3
        @test imag(z) == 4
        @test ComplexNumber(2) == ComplexNumber(2, 0)
        @test ComplexNumber(1, 2.5) isa ComplexNumber{Float64}
    end

    @testset "Polar -> cartesiana" begin
        @test frompolar(1, π / 2) ≈ ComplexNumber(0, 1)
        @test frompolar(2, π) ≈ ComplexNumber(-2, 0)
        @test frompolar(2, 180; degrees=true) ≈ ComplexNumber(-2, 0)
        @test frompolar(√2, 45; degrees=true) ≈ ComplexNumber(1, 1)
        @test frompolar(5, atan(4, 3)) ≈ ComplexNumber(3, 4)
        @test frompolar(0, 1.234) ≈ ComplexNumber(0, 0)
    end

    @testset "Cartesiana -> polar" begin
        r, θ = topolar(ComplexNumber(3, 4))
        @test r ≈ 5
        @test θ ≈ atan(4, 3)

        r, θ = topolar(ComplexNumber(0, 1); degrees=true)
        @test r ≈ 1
        @test θ ≈ 90

        # Quatro quadrantes
        @test argument(ComplexNumber(1, 1)) ≈ π / 4
        @test argument(ComplexNumber(-1, 1)) ≈ 3π / 4
        @test argument(ComplexNumber(-1, -1)) ≈ -3π / 4
        @test argument(ComplexNumber(1, -1)) ≈ -π / 4
        @test argument(ComplexNumber(-1, 0)) ≈ π

        @test modulus(ComplexNumber(-3, -4)) ≈ 5
        @test abs(ComplexNumber(3, 4)) ≈ 5
        @test angle(ComplexNumber(0, 2)) ≈ π / 2

        # Ida e volta
        for z in (ComplexNumber(3.0, 4.0), ComplexNumber(-2.5, 1.0), ComplexNumber(-1.0, -7.0), ComplexNumber(0.5, -0.25))
            @test frompolar(topolar(z)...) ≈ z
            @test frompolar(topolar(z; degrees=true)...; degrees=true) ≈ z
        end
    end

    @testset "tostring" begin
        @test tostring(ComplexNumber(3.0, 4.0)) == "3.0 + 4.0i"
        @test tostring(ComplexNumber(3.0, -4.0)) == "3.0 - 4.0i"
        @test tostring(ComplexNumber(3.0, 0.0)) == "3.0 + 0.0i"
        @test tostring(ComplexNumber(3.0, -0.0)) == "3.0 + 0.0i"
        @test tostring(ComplexNumber(-1, 2)) == "-1 + 2i"
        @test tostring(ComplexNumber(1 / 3, 2 / 3); digits=2) == "0.33 + 0.67i"

        @test tostring(ComplexNumber(3, 4); form=:polar) == "5.0∠0.9273 rad"
        @test tostring(ComplexNumber(3, 4); form=:polar, degrees=true) == "5.0∠53.1301°"
        @test tostring(ComplexNumber(0, 1); form=:polar, degrees=true) == "1.0∠90.0°"

        # string/print usam a forma cartesiana via show
        @test string(ComplexNumber(1.5, -2.0)) == "1.5 - 2.0i"
        @test sprint(print, ComplexNumber(1, 1)) == "1 + 1i"

        @test_throws ArgumentError tostring(ComplexNumber(1, 1); form=:invalida)
    end

    @testset "Operadores aritméticos" begin
        a = ComplexNumber(1, 2)
        b = ComplexNumber(3, 4)

        @test a + b == ComplexNumber(4, 6)
        @test a - b == ComplexNumber(-2, -2)
        @test a * b == ComplexNumber(-5, 10)
        @test a / b ≈ ComplexNumber(0.44, 0.08)
        @test (a / b) * b ≈ a
        @test -a == ComplexNumber(-1, -2)

        # Com números reais, nos dois lados
        @test a + 2 == ComplexNumber(3, 2)
        @test 2 + a == ComplexNumber(3, 2)
        @test a - 1 == ComplexNumber(0, 2)
        @test 1 - a == ComplexNumber(0, -2)
        @test a * 3 == ComplexNumber(3, 6)
        @test 3 * a == ComplexNumber(3, 6)
        @test true * a == a
        @test a / 2 ≈ ComplexNumber(0.5, 1.0)
        @test 1 / ComplexNumber(0, 1) ≈ ComplexNumber(0, -1)

        # Divisão por zero
        @test_throws DivideError a / ComplexNumber(0, 0)
        @test_throws DivideError a / 0

        # Verificação cruzada com o Complex nativo do Julia
        x = ComplexNumber(1.7, -3.2)
        y = ComplexNumber(-0.4, 2.9)
        for (op, r) in ((+, x + y), (-, x - y), (*, x * y), (/, x / y))
            @test Complex(r) ≈ op(Complex(x), Complex(y))
        end
    end

    @testset "Interoperabilidade com Complex" begin
        z = ComplexNumber(3, 4)

        @test z + 10im == ComplexNumber(3, 14)
        @test 10im + z == ComplexNumber(3, 14)
        @test z - 2im == ComplexNumber(3, 2)
        @test 2im - z == ComplexNumber(-3, -2)
        @test z * im == ComplexNumber(-4, 3)
        @test im * z == ComplexNumber(-4, 3)
        @test z / (1 + 1im) ≈ ComplexNumber(3.5, 0.5)
        @test (3 + 4im) / z ≈ ComplexNumber(1, 0)

        @test z + 10im isa ComplexNumber{Int}
        @test z + 1.5im isa ComplexNumber{Float64}

        @test ComplexNumber(3 + 4im) == z
        @test Complex(z) == 3 + 4im
        @test z == 3 + 4im
        @test 3 + 4im == z
        @test z ≈ 3.0 + 4.0im

        @test_throws DivideError z / (0 + 0im)
    end

    @testset "Conjugado" begin
        z = ComplexNumber(3, 4)
        @test conj(z) == ComplexNumber(3, -4)
        @test z' == ComplexNumber(3, -4)
        @test (z')' == z
        @test z * z' == ComplexNumber(25, 0)
        @test real(z * z') ≈ modulus(z)^2
        @test (z + z') == ComplexNumber(6, 0)
        @test ComplexNumber(5.0)' == ComplexNumber(5.0, -0.0)
    end
end
