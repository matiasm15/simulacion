require 'securerandom'
require 'descriptive_statistics'

# Generación de valores aleatorios discretos mediante distintas distribuciones.
module VADiscreto
  # Genera valores discretos aleatorios en base a una distribución geométrica de la cantidad
  # de fracasos antes de obtener un éxito en un ensayo de Bernoulli.
  # @param prob_exito [Numeric] probabilidad de éxito de cada ensayo
  # @return [Integer] cantidad de fracasos
  def dist_geometrica(prob_exito)
    Math.log(SecureRandom.random_number).fdiv(Math.log(1 - prob_exito)).floor
  end

  # Genera valores discretos aleatorios en base a una distribución binomial negativa de la
  # cantidad de fracasos antes de obtener una cierta cantidad de éxitos en un ensayo de
  # Bernoulli.
  # @param exitos [Integer] cantidad de éxitos esperados
  # @param prob_exito [Numeric] probabilidad de éxito de cada ensayo
  # @return [Integer] cantidad de fracasos
  def dist_binomial_negativa(exitos, prob_exito)
    Array.new(exitos) { dist_geometrica(prob_exito) }.sum
  end

  # Genera valores discretos aleatorios en base a una distribución binomial de la cantidad de
  # éxitos en una cierta cantidad de ensayos de Bernoulli.
  # @param ensayos [Integer] cantidad de ensayos
  # @param prob_exito [Numeric] probabilidad de éxito de cada ensayo
  # @return [Integer] cantidad de éxitos
  def dist_binomial(ensayos, prob_exito)
    (1..ensayos).select { SecureRandom.random_number < prob_exito }.size
  end

  # Genera valores discretos aleatorios en base a una distribución de Poisson de una cierta
  # cantidad de ocurrencias de un evento.
  # @param lambdax [Numeric] parámetro lambda de la distribución
  # @return [Integer] cantidad de ocurrencias del evento
  def dist_poisson(lambdax)
    limite = Math.exp(-lambdax)

    var_aleatoria = 0
    productoria = SecureRandom.random_number

    while limite < productoria
      var_aleatoria += 1

      productoria *= SecureRandom.random_number
    end

    var_aleatoria
  end

  # Genera valores discretos aleatorios en base a una distribución hipergeométrica de una
  # cierta cantidad de elementos de una categoría X en una muestra sin reemplazo de una
  # población.
  # @param poblacion_t [Integer] cantidad de elementos de la población
  # @param poblacion_x [Integer] cantidad de elementos de la población pertenecientes a la categoría X
  # @param muestra_t [Integer] cantidad de elementos de la muestra
  # @return [Integer] cantidad de elementos de la muestra pertenecientes a la categoría X
  def dist_hipergeometrica(poblacion_t, poblacion_x, muestra_t)
    (0..muestra_t - 1).inject(0) do |muestra_x, num_muestra|
      u = SecureRandom.random_number

      u > (poblacion_x - muestra_x).fdiv(poblacion_t - num_muestra) ? muestra_x : muestra_x + 1
    end
  end
end
