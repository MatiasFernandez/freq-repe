# frozen_string_literal: true
require 'csv'
require 'active_support'
require 'active_support/core_ext'
class Exportador
  class << self
    def exportar_repes_en_csv(repetidoras, nombre_archivo)
      columnas = ["Nombre", "Localidad", "Frecuencia Salida (KHz)", "Frecuencia Entrada (KHz)", "Rango Protegido", "Distancia al RC (Km)"]
      csv = CSV.generate do |csv|
        csv << columnas
        repetidoras.each do |repe|
          csv << formatear_repetidora_para_csv(repe)
        end
      end
      File.write(nombre_archivo, csv)
    end

    def exportar_rangos_en_csv(rangos, nombre_archivo)
      columnas = ["Desde", "Hasta"]
      csv = CSV.generate do |csv|
        csv << columnas
        rangos.each do |rango|
          csv << [numero_con_separador(rango.begin), numero_con_separador(rango.end)]
        end
      end
      File.write(nombre_archivo, csv)
    end

    private

    def formatear_repetidora_para_csv(repetidora)
      {
        nombre: repetidora[:repetidora].nombre,
        localidad: repetidora[:repetidora].localidad,
      }.merge(
        freq_salida: numero_con_separador(repetidora[:repetidora].freq_salida),
        freq_entrada: numero_con_separador(repetidora[:repetidora].freq_entrada),
        rangos_protegidos: repetidora[:repetidora].rangos_protegidos.map { |r| formatear_rango(r) }.join(" | "),
        distancia: "#{repetidora[:distancia_en_km].round} km",
      ).values
    end

    def formatear_rango(rango)
      [
        numero_con_separador(rango.begin),
        numero_con_separador(rango.end),
      ].join(" - ")
    end

    def numero_con_separador(numero)
      numero.to_fs(:delimited).gsub(',','.')
    end
  end
end
