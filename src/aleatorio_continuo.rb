require 'securerandom'
require 'descriptive_statistics'

# Generación de valores aleatorios continuos mediante distintas distribuciones.
module VAContinuo
  # Genera valores aleatorios en base a una distribución uniforme.
  # @param minimo [Numeric] valor mínimo de la distribución
  # @param maximo [Numeric] valor máximo de la distribución
  # @return [Numeric] valor perteneciente a la distribución
  def dist_uniforme(minimo = 0, maximo = 1)
    minimo + (maximo - minimo) * SecureRandom.random_number
  end

  # Genera valores aleatorios en base a una distribución triangular.
  # @param minimo [Numeric] valor mínimo de la distribución
  # @param moda [Numeric] moda de la distribución
  # @param maximo [Numeric] valor máximo de la distribución
  # @return [Numeric] valor perteneciente a la distribución
  def dist_triangular(minimo = -1, moda = 0, maximo = 1)
    u = SecureRandom.random_number

    limite = (moda - minimo).fdiv(maximo - minimo)

    if limite > u
      minimo + Math::sqrt(u * (moda - minimo) * (maximo - minimo))
    else
      maximo - Math::sqrt((1 - u) * (maximo - minimo) * (maximo - moda))
    end
  end

  # Genera valores aleatorios en base a una distribución exponencial.
  # @param lambdax [Numeric] parámetro lambda de la distribución
  # @return [Numeric] valor perteneciente a la distribución
  def dist_exponencial(lambdax = 1)
    -1.fdiv(lambdax) * Math::log(1 - SecureRandom.random_number)
  end

  # Genera un par de valores aleatorios en base a una distribución normal a través del
  # método de Box Muller.
  # @param media [Numeric] media de la distribución
  # @param varianza [Numeric] varianza de la distribución
  # @return [Array<Numeric>] par de valores perteneciente a la distribución
  def dist_normal_box_muller(media = 0, varianza = 1)
    u = SecureRandom.random_number
    v = SecureRandom.random_number

    raiz = Math::sqrt(-2 * Math::log(u))

    normal_estandar_x = raiz * Math::cos(2 * Math::PI * v)
    normal_estandar_y = raiz * Math::sin(2 * Math::PI * v)

    [media + Math::sqrt(varianza) * normal_estandar_x, media + Math::sqrt(varianza) * normal_estandar_y]
  end

  # Genera un par de valores aleatorios en base a una distribución normal a través del
  # método polar de Marsaglia.
  # @param media [Numeric] media de la distribución
  # @param varianza [Numeric] varianza de la distribución
  # @return [Array<Numeric>] par de valores perteneciente a la distribución
  def dist_normal_polar(media = 0, varianza = 1)
    s = 0
    vx = 0
    vy = 0

    loop do
      vx = 2 * SecureRandom.random_number - 1
      vy = 2 * SecureRandom.random_number - 1

      s = vx ** 2 + vy ** 2

      break if s < 1
    end

    raiz = Math::sqrt( (-2 * Math::log(s)).fdiv(s) )

    normal_estandar_x = vx * raiz
    normal_estandar_y = vy * raiz

    [media + Math::sqrt(varianza) * normal_estandar_x, media + Math::sqrt(varianza) * normal_estandar_y]
  end

  # Genera valores aleatorios en base a una distribución normal a través del método del
  # teorema del límite central.
  # @param media [Numeric] media de la distribución
  # @param varianza [Numeric] varianza de la distribución
  # @param n [Integer] cantidad de iteraciones
  # @return [Numeric] valor perteneciente a la distribución
  def dist_normal_tlc(media = 0, varianza = 1, n = 200)
    num_aleatorios = Array.new(n) { SecureRandom.random_number }

    normal_estandar = (num_aleatorios.sum - n.fdiv(2)) * Math::sqrt(12.fdiv(n))

    media + Math::sqrt(varianza) * normal_estandar
  end

  # Genera valores aleatorios en base a una distribución chi cuadrado (X^2).
  # @param gr_libertad [Integer] grados de libertad de la distribución
  # @return [Numeric] valor perteneciente a la distribución
  def dist_chi_cuadrado(gr_libertad = 1)
    Array.new(gr_libertad) { dist_normal_box_muller[0] ** 2}.sum
  end

  # Genera valores aleatorios en base a una distribución t de Student.
  # @param gr_libertad [Integer] grados de libertad de la distribución
  # @return [Numeric] valor perteneciente a la distribución
  def dist_student(gr_libertad = 1)
    dist_normal_box_muller[0] * Math::sqrt(gr_libertad.fdiv(dist_chi_cuadrado(gr_libertad)))
  end

  # Genera valores aleatorios en base a una distribución logarítmica.
  # @param media [Numeric] media de la distribución
  # @param varianza [Numeric] varianza de la distribución
  # @param n [Integer] cantidad de iteraciones
  # @return [Numeric] valor perteneciente a la distribución
  def dist_logaritmica(media = 0, varianza = 1, n = 200)
    num_aleatorios = Array.new(n) { SecureRandom.random_number }

    normal_estandar = (num_aleatorios.sum - n.fdiv(2)) * Math::sqrt(12.fdiv(n))

    varianza_y = Math::log(1 + varianza.fdiv(media ** 2))
    media_y = Math::log(media) - varianza_y.fdiv(2)

    Math::exp(media_y + Math::sqrt(varianza_y) * normal_estandar)
  end

  # Genera valores aleatorios en base a una distribución de Erlang.
  # @param k [Integer] parámetro k de la distribución
  # @param lambdax [Numeric] parámetro lambda de la distribución
  # @return [Numeric] valor perteneciente a la distribución
  def dist_erlang(k = 1, lambdax = 1)
    -1.fdiv(lambdax) * Array.new(k) { Math::log(1 - SecureRandom.random_number) }.sum
  end

  # Genera valores aleatorios en base a una distribución gamma.
  # @param k [Numeric] parámetro k de la distribución
  # @param lambdax [Numeric] parámetro lambda de la distribución
  # @return [Numeric] valor perteneciente a la distribución
  def dist_gamma(k = 1, lambdax = 1)
    if (k == 1)
      # Distribución exponencial
      dist_exponencial(lambdax)
    elsif (k < 1)
      # Método de aceptación y rechazo de Ahrens y Dieter
      y = 0

      loop do
        u = SecureRandom.random_number
        v = SecureRandom.random_number

        limite = Math::E.fdiv(Math::E + k)

        if u > limite
          y = -Math::log((1 - u) * (Math::E + k).fdiv(Math::E * k))

          break if (y ** (k - 1)) > v
        else
          y = (u * (k + Math::E).fdiv(Math::E)) ** 1.fdiv(k)

          break if Math::exp(-y) > v
        end
      end

      y * 1.fdiv(lambdax)
    else
      # Método de aceptación y rechazo de Fishman
      eu = 0
      ev = 0

      loop do
        eu = -Math::log(1 - SecureRandom.random_number)
        ev = -Math::log(1 - SecureRandom.random_number)

        limite = (k - 1) * (eu - Math::log(eu) - 1)

        break if ev > limite
      end

      eu * k.fdiv(lambdax)
    end
  end

  # Genera valores aleatorios en base a una distribución beta.
  # @param alfa [Numeric] parámetro alfa de la distribución
  # @param beta [Numeric] parámetro beta de la distribución
  # @return [Numeric] valor perteneciente a la distribución
  def dist_beta(alfa = 1, beta = 1)
    yu = 0
    yv = 0

    loop do
      yu = SecureRandom.random_number ** 1.fdiv(alfa)
      yv = SecureRandom.random_number ** 1.fdiv(beta)

      break if (yu + yv) < 1
    end

    yu.fdiv(yu + yv)
  end

  # Genera valores aleatorios en base a una distribución de Laplace.
  # @param mu [Numeric] parámetro mu de la distribución
  # @param theta [Numeric] parámetro theta de la distribución
  # @return [Numeric] valor perteneciente a la distribución
  def dist_laplace(mu = 1, theta = 1)
    v = SecureRandom.random_number - 0.5

    if v > 0
      mu - theta * Math::log(1 - 2 * v.abs)
    else
      mu + theta * Math::log(1 - 2 * v.abs)
    end
  end
end
