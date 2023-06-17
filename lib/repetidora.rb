# frozen_string_literal: true
class Repetidora
  attr_reader :nombre, :ubicacion, :localidad, :freq_salida, :freq_entrada
  def initialize(nombre:, ubicacion:, localidad:, freq_salida:, freq_entrada:)
    @nombre = nombre
    @ubicacion = ubicacion
    @localidad = localidad
    @freq_salida = freq_salida
    @freq_entrada = freq_entrada
  end

  def rangos_protegidos
    [
      rango_de_seguridad_para(freq_salida),
      rango_de_seguridad_para(freq_entrada),
    ]
  end

  private

  def rango_de_seguridad_para(frecuencia)
    borde_inferior = frecuencia - 15
    borde_superior = frecuencia + 15

    borde_inferior..borde_superior
  end
end
