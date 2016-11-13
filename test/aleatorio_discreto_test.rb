require 'simplecov'
SimpleCov.start

require 'minitest/reporters'
require 'minitest/autorun'
Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new)

require 'descriptive_statistics'
require_relative '../src/aleatorio_discreto'

include VADiscreto

class TestAleatorioDiscreto < Minitest::Test
  def setup
    @iteraciones = 10000
    @epsilon = 0.1
  end

  def test_dist_geometrica
    prob_exito = 0.25

    data = Array.new(@iteraciones) { dist_geometrica(prob_exito) }

    media = (1 - prob_exito).fdiv(prob_exito)
    varianza = (1 - prob_exito).fdiv(prob_exito ** 2)

    assert_in_epsilon data.mean, media, @epsilon
    assert_in_epsilon data.variance, varianza, @epsilon
  end

  def test_dist_binomial_negativa
    exitos = 5
    prob_exito = 0.25

    data = Array.new(@iteraciones) { dist_binomial_negativa(exitos, prob_exito) }

    media = exitos * (1 - prob_exito).fdiv(prob_exito)
    varianza = exitos * (1 - prob_exito).fdiv(prob_exito ** 2)

    assert_in_epsilon data.mean, media, @epsilon
    assert_in_epsilon data.variance, varianza, @epsilon
  end

  def test_dist_binomial
    ensayos = 20
    prob_exito = 0.25

    data = Array.new(@iteraciones) { dist_binomial(ensayos, prob_exito) }

    media = ensayos * prob_exito
    varianza = ensayos * prob_exito * (1 - prob_exito)

    assert_in_epsilon data.mean, media, @epsilon
    assert_in_epsilon data.variance, varianza, @epsilon
  end

  def test_dist_poisson
    lambdax = 5

    data = Array.new(@iteraciones) { dist_poisson(lambdax) }

    media = lambdax
    varianza = lambdax

    assert_in_epsilon data.mean, media, @epsilon
    assert_in_epsilon data.variance, varianza, @epsilon
  end

  def test_dist_hipergeometrica
    poblacion_t = 100
    poblacion_x = 25
    muestra_t = 10

    data = Array.new(@iteraciones) { dist_hipergeometrica(poblacion_t, poblacion_x, muestra_t) }

    media = (poblacion_x * muestra_t).fdiv(poblacion_t)
    varianza = media * (1 - poblacion_x.fdiv(poblacion_t)) * (poblacion_t - muestra_t).fdiv(poblacion_t - 1)

    assert_in_epsilon data.mean, media, @epsilon
    assert_in_epsilon data.variance, varianza, @epsilon
  end
end
