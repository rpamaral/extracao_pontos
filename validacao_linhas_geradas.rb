require 'csv'
require 'haversine'
require 'json'
require 'pry'



line_stops_path = "data_files/pontos_por_linha.csv"
stops_description_path ='data_files/stops.txt'
touristic_stops_path ='data_files/pontos_turisticos.csv'

LINE_STOPS = CSV.read(line_stops_path,  encoding: "ISO8859-1")
STOPS_DESCRIPTION = CSV.read(stops_description_path,  encoding: "utf-8")
TOURISTIC_STOPS = CSV.read(touristic_stops_path,  encoding: "ISO8859-1");

LATITUDE = 4
LONGITUDE = 5
LINE_ID = 0
STOP_DESC = 2
SEQUENCE = 3

# Touristic stops constants
TS_LAT = 5
TS_LONG = 6
TS_NAME = 0


def get_tourist_stops (line_coord)
  near_ts = []
  TOURISTIC_STOPS.each_with_index do |t_stop, i|
    unless ( i == 0 )
      t_stop_coord = [t_stop[TS_LAT].to_f, t_stop[TS_LONG].to_f]
      distance =  Haversine.distance(t_stop_coord, line_coord).to_m;

      if(distance < 2000)
          stop = {
            "nome" => t_stop[TS_NAME],
            "distancia" => distance.round(0)
          }
          near_ts.push(stop)
      end
    end
  end
  near_ts
end

def write_csv_file(line, stop, ts_stops)
  file_path = File.join('linhas','csv', line[LINE_ID]+".csv")
  CSV.open(file_path, "a") do |csv|
    csv << [line[LINE_ID], line[SEQUENCE], stop[LATITUDE], stop[LONGITUDE], stop[STOP_DESC], ts_stops]
  end
end

def create_json_module(line, stop, ts_stops)
  json_structure = {
    "linha" => line[LINE_ID],
    "descricao_ponto" => stop[STOP_DESC],
    "sequencia" => line[SEQUENCE],
    "latitude" => line[LATITUDE],
    "longitude" => line[LONGITUDE],
    "pontos_turisticos" => ts_stops
  }
  json_structure
end
line_old = "673"
cont_ts = 0
tem_ponto_turistico = false
json_final_content = []
all_stops_count = STOPS_DESCRIPTION.size-1


Dir["linhas/**/*.json"].each do |line|
  data_hash = JSON.parse(File.read(line))
  size = (data_hash.size/2).to_i
  check = Array.new(size, 0)
  cont = 0 
  data_hash.each do |stop|
    check[(stop['sequencia'].to_i)-1] += 1 if check[(stop['sequencia'].to_i)-1]
    cont += 1
  end
  round = 0
  circular = 0
  check.each do |i|
    if i == 2
      round +=1
    elsif i = 1
      circular +=1
    end
  end
  if round < (size-5) or circular != size
    p line
  end
end



# LINE_STOPS.each_with_index do |line, i|
#   line_coord = [line[LATITUDE].to_f, line[LONGITUDE].to_f]
#   ts_stops = get_tourist_stops(line_coord)
  
#   STOPS_DESCRIPTION.each_with_index do |stop, j|
   
#     unless ( i == 0 or j == 0)
#       stop_coord = [stop[LATITUDE].to_f, stop[LONGITUDE].to_f]
#       distance =  Haversine.distance(stop_coord, line_coord).to_m;

#       if(distance < 20 or j == all_stops_count)
#         if (distance > 20 and j == all_stops_count)
#           stop[LATITUDE] = line[LATITUDE]
#           stop[LONGITUDE] = line[LONGITUDE]
#           stop[STOP_DESC] = "Nome do ponto nao identificado"
#         end
#         write_csv_file(line, stop, ts_stops)
#         if(line_old == line[LINE_ID])
#           json_final_content.push(create_json_module(line, stop, ts_stops))
#         else
#           json_file_path = File.join('linhas','json', line_old+".json")
#           File.open(json_file_path, "a") do |json|
#             json << json_final_content.to_json
#           end
#           line_old = line[LINE_ID]
#           json_final_content = []
#         end
#         break
#       end
#     end
#   end
# end