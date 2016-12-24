require 'simplecov'
SimpleCov.start

require 'minitest/reporters'
require 'minitest/autorun'
Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new)

require 'descriptive_statistics'
require_relative '../src/montecarlo'

include Montecarlo

class TestMontecarlo < Minitest::Test
  def setup
    @iteraciones = 100000
    @delta = 0.01
    @epsilon = 0.1
  end

  def test_integral_a_b
    resultado = integral_a_b(0, 1, @iteraciones) { |x| 2 * x**2 + 3 }

    assert_in_epsilon resultado, 11.fdiv(3), @epsilon
  end

  def test_integral_a_inf_1
    resultado = integral_a_inf(0, @iteraciones) { |x| x * Math.exp(3 - x) }

    assert_in_epsilon resultado, Math.exp(3), @epsilon
  end

  def test_integral_a_inf_2
    resultado = integral_a_inf(2, @iteraciones) { |x| 1.fdiv((x - 1) ** 2) }

    assert_in_epsilon resultado, 1, @epsilon
  end

  def test_integral_inf_b
    resultado = integral_inf_b(0, @iteraciones) { |x| 1.fdiv(x**2 + 1) }

    assert_in_epsilon resultado, Math::PI.fdiv(2), @epsilon
  end

  def test_integral_inf_inf
    resultado = integral_inf_inf(@iteraciones) { |x| x * Math.exp(- x**2) }

    assert_in_delta resultado, 0, @delta
  end

  # Distribución normal estándar
  def test_integral_inf_inf_normal
    integral = integral_inf_inf(@iteraciones) { |x| Math.exp(- (x**2).fdiv(2)) }

    resultado = integral.fdiv(Math.sqrt(2 * Math::PI))

    assert_in_epsilon resultado, 1, @epsilon
  end
end
