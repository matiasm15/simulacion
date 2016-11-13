require 'simplecov'
SimpleCov.start

require 'minitest/reporters'
require 'minitest/autorun'
Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new)

require 'descriptive_statistics'
require_relative '../src/aleatorio_continuo'

include VAContinuo

class TestAleatorioContinuo < Minitest::Test
  def setup
    @iteraciones = 10000
    @iteraciones_reducidas = 1000
    @epsilon = 0.1
    @delta = 0.05
  end

  def test_dist_uniforme
    a = 5
    b = 15

    data = Array.new(@iteraciones) { dist_uniforme(a , b) }

    media = (a + b).fdiv(2)
    varianza = ((b - a) ** 2).fdiv(12)

    assert_in_epsilon data.mean, media, @epsilon
    assert_in_epsilon data.variance, varianza, @epsilon
  end

  def test_dist_triangular
    a = 0
    b = 2
    c = 10

    data = Array.new(@iteraciones) { dist_triangular(a, b, c) }

    media = (a + b + c).fdiv(3)
    varianza = (a ** 2 + b ** 2 + c ** 2 - a * b - a * c - b * c).fdiv(18)

    assert_in_epsilon data.mean, media, @epsilon
    assert_in_epsilon data.variance, varianza, @epsilon
  end

  def test_dist_exponencial
    lambdax = 5

    data = Array.new(@iteraciones) { dist_exponencial(5) }

    media = 1.fdiv(lambdax)
    varianza = 1.fdiv(lambdax ** 2)

    assert_in_epsilon data.mean, media, @epsilon
    assert_in_epsilon data.variance, varianza, @epsilon
  end

  def test_dist_normal_box_muller
    media = 5
    varianza = 2

    data = Array.new(@iteraciones) { dist_normal_box_muller(media, varianza) }

    data_x = data.map { |par| par[0] }
    data_y = data.map { |par| par[1] }

    assert_in_epsilon data_x.mean, media, @epsilon
    assert_in_epsilon data_x.variance, varianza, @epsilon

    assert_in_epsilon data_y.mean, media, @epsilon
    assert_in_epsilon data_y.variance, varianza, @epsilon
  end

  def test_dist_normal_polar
    media = 5
    varianza = 2

    data = Array.new(@iteraciones) { dist_normal_polar(media, varianza) }

    data_x = data.map { |par| par[0] }
    data_y = data.map { |par| par[1] }

    assert_in_epsilon data_x.mean, media, @epsilon
    assert_in_epsilon data_x.variance, varianza, @epsilon

    assert_in_epsilon data_y.mean, media, @epsilon
    assert_in_epsilon data_y.variance, varianza, @epsilon
  end

  def test_dist_normal_tlc
    media = 5
    varianza = 2

    data = Array.new(@iteraciones_reducidas) { dist_normal_tlc(media, varianza) }

    assert_in_epsilon data.mean, media, @epsilon
    assert_in_epsilon data.variance, varianza, @epsilon
  end

  def test_dist_chi_cuadrado
    gr_libertad = 7

    data = Array.new(@iteraciones_reducidas) { dist_chi_cuadrado(gr_libertad) }

    media = gr_libertad
    varianza = gr_libertad * 2

    assert_in_epsilon data.mean, media, @epsilon
    assert_in_epsilon data.variance, varianza, @epsilon
  end

  def test_dist_student
    gr_libertad = 7

    data = Array.new(@iteraciones_reducidas) { dist_student(gr_libertad) }

    media = 0
    varianza = gr_libertad.fdiv(gr_libertad - 2)

    assert_in_delta data.mean, media, @delta
    assert_in_epsilon data.variance, varianza, @epsilon
  end

  def test_dist_logaritmica
    media = 5
    varianza = 2

    data = Array.new(@iteraciones_reducidas) { dist_logaritmica(media, varianza) }

    assert_in_epsilon data.mean, media, @epsilon
    assert_in_epsilon data.variance, varianza, @epsilon
  end

  def test_dist_erlang
    k = 5
    lambdax = 4.5

    data = Array.new(@iteraciones) { dist_erlang(k, lambdax) }

    media = k.fdiv(lambdax)
    varianza = k.fdiv(lambdax ** 2)

    assert_in_epsilon data.mean, media, @epsilon
    assert_in_epsilon data.variance, varianza, @epsilon
  end

  def test_dist_gamma_ahrens_dieter
    k = 0.25
    lambdax = 4.5

    data = Array.new(@iteraciones) { dist_gamma(k, lambdax) }

    media = k.fdiv(lambdax)
    varianza = k.fdiv(lambdax ** 2)

    assert_in_epsilon data.mean, media, @epsilon
    assert_in_epsilon data.variance, varianza, @epsilon
  end

  def test_dist_gamma_fishman
    k = 5
    lambdax = 4.5

    data = Array.new(@iteraciones) { dist_gamma(k, lambdax) }

    media = k.fdiv(lambdax)
    varianza = k.fdiv(lambdax ** 2)

    assert_in_epsilon data.mean, media, @epsilon
    assert_in_epsilon data.variance, varianza, @epsilon
  end

  def test_dist_beta
    alfa = 3.25
    beta = 4.75

    data = Array.new(@iteraciones_reducidas) { dist_beta(alfa, beta) }

    media = alfa.fdiv(alfa + beta)
    varianza = (alfa * beta).fdiv((alfa + beta + 1) * (alfa + beta) ** 2)

    assert_in_epsilon data.mean, media, @epsilon
    assert_in_epsilon data.variance, varianza, @epsilon
  end

  def test_dist_laplace
    mu = 3.25
    theta = 4.75

    data = Array.new(@iteraciones_reducidas) { dist_laplace(mu, theta) }

    media = mu
    varianza = 2 * theta ** 2

    assert_in_epsilon data.mean, media, @epsilon
    assert_in_epsilon data.variance, varianza, @epsilon
  end
end
