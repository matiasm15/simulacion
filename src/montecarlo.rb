require 'securerandom'
require 'descriptive_statistics'

# Aproximación de integrales mediante el método de Montecarlo.
module Montecarlo
  # Cálculo de integral propia: utilizada para aproximar la integral propia I = Integral(a..b) de f(x)dx.
  # @param a [Numeric] extremo inferior de la integral
  # @param b [Numeric] extremo superior de la integral
  # @param n [Integer] cantidad de iteraciones
  # @yield funcion f(x) que se va a integrar
  # @yieldparam [Numeric] argumento x de la función
  # @yieldreturn [Numeric] resultado de la función
  # @return [Numeric] aproximación de la integral I
  def integral_a_b(a, b, n = 10000, &funcion)
    imagen = (1..n).map do |i|
      u = SecureRandom.random_number

      argumento = u * (b - a) + a

      funcion.call(argumento) * (b - a)
    end

    imagen.sum.fdiv(n)
  end

  # Cálculo de integral con límite superior igual a infinito: utilizada para aproximar la integral
  # I = Integral(a..Inf) de f(x)dx.
  # @param a [Numeric] extremo inferior de la integral
  # @param n [Integer] cantidad de iteraciones
  # @yield funcion f(x) que se va a integrar
  # @yieldparam [Numeric] argumento x de la función
  # @yieldreturn [Numeric] resultado de la función
  # @return [Numeric] aproximación de la integral I
  def integral_a_inf(a, n = 10000, &funcion)
    imagen = (1..n).map do |i|
      u = SecureRandom.random_number

      argumento = a - Math::log(u)

      funcion.call(argumento).fdiv(u)
    end

    imagen.sum.fdiv(n)
  end

  # Cálculo de integral con límite inferior igual a infinito: utilizada para aproximar la integral
  # I = Integral(-Inf..b) de f(x)dx.
  # @param b [Numeric] extremo superior de la integral
  # @param n [Integer] cantidad de iteraciones
  # @yield funcion f(x) que se va a integrar
  # @yieldparam [Numeric] argumento x de la función
  # @yieldreturn [Numeric] resultado de la función
  # @return [Numeric] aproximación de la integral I
  def integral_inf_b(b, n = 10000, &funcion)
    imagen = (1..n).map do |i|
      u = SecureRandom.random_number

      argumento = b + Math::log(u)

      funcion.call(argumento).fdiv(u)
    end

    imagen.sum.fdiv(n)
  end

  # Cálculo de integral con limites inferiores y superiores iguales a infinito: utilizada para aproximar
  # la integral I = Integral(-Inf..Inf) de f(x)dx.
  # @param n [Integer] cantidad de iteraciones
  # @yield funcion f(x) que se va a integrar
  # @yieldparam [Numeric] argumento x de la función
  # @yieldreturn [Numeric] resultado de la función
  # @return [Numeric] aproximación de la integral I
  def integral_inf_inf(n = 10000, &funcion)
    imagen = (1..n).map do |i|
      u = SecureRandom.random_number

      argumento = Math::tan(Math::PI * u - Math::PI.fdiv(2))

      funcion.call(argumento) * Math::PI.fdiv(Math::cos(Math::PI * u - Math::PI.fdiv(2)) ** 2)
    end

    imagen.sum.fdiv(n)
  end
end
