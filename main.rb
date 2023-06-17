require 'multi_range'
require_relative 'lib/repetidora'
require_relative 'lib/exportador'
require_relative 'lib/parser_kml'

def filtrar_por_distancia(repetidoras, rango_en_km, punto_referencia)
  repetidoras.map do |repetidora|
    { repetidora: repetidora, distancia_en_km: repetidora.ubicacion.distance(punto_referencia) / 1000 }
  end.select { |r| r[:distancia_en_km] <= rango_en_km }
end

def rangos_frequencias_protegidas(repetidoras)
  rangos_frecuencias = repetidoras.flat_map { |r| r[:repetidora].rangos_protegidos }
  MultiRange.new(rangos_frecuencias).merge_overlaps.ranges
end

parser = ParserKml.new("repes/repetidoras.kml")

repes_cercanas = filtrar_por_distancia(parser.repes_2_metros, 200, parser.ubicacion_radio_club)

Exportador.exportar_repes_en_csv(repes_cercanas, 'out/repetidoras_cercanas.csv')

rangos_reservados = rangos_frequencias_protegidas(repes_cercanas)

Exportador.exportar_rangos_en_csv(rangos_reservados, 'out/rangos_reservados.csv')

