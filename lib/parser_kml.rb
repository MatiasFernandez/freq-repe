# frozen_string_literal: true
require 'geo/coord'
require 'nokogiri'
class ParserKml
  def initialize(nombre_archivo)
    @doc = Nokogiri::XML(File.open(nombre_archivo))
  end

  def parsear_coordenadas(coordenadas)
    coordenadas_formateadas = coordenadas.split(" ").reverse.join(", ")
    coordenadas_formateadas = coordenadas_formateadas.gsub(/°/, '° ').gsub(/´/, '\' ').gsub(/"/, '" ')
    Geo::Coord.parse_dms(coordenadas_formateadas)
  end

  def repes_2_metros
    nodos_2_metros.map { |n| parsear_placemark(n) }
  end

  def ubicacion_radio_club
    parsear_coordenadas(nodos_2_metros.find { |r| !r.at('name:contains("LU4EV")').nil? }.at('address').text)
  end

  private

  def nodos_2_metros
    @nodos_2_metros ||= @doc.at('Folder:contains("2 Metros")').search('Placemark')
  end
  def parsear_placemark(nodo)
    freq_salida = (nodo.at('Data[name="Frecuencia de Salida [MHz]"]').text.strip.to_d * 1000).to_i
    freq_entrada = (nodo.at('Data[name="Frecuencia de Entrada [MHz]"]').text.strip.to_d * 1000).to_i

    Repetidora.new(
      nombre: nodo.at('name').text,
      ubicacion: parsear_coordenadas(nodo.at('address').text),
      localidad: nodo.at('Data[name="Localidad"]').text.strip,
      freq_salida: freq_salida,
      freq_entrada: freq_entrada,
    )
  end
end
