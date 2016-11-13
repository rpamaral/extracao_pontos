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

def write_csv_file(t_stop, line)
  file_path = File.join('pontos_turisticos','csv', line[LINE_ID]+".csv")
  CSV.open(file_path, "a") do |csv|
    csv << [t_stop[TS_NAME], t_stop[1], t_stop[2], t_stop[3], t_stop[5], t_stop[6]]
  end
end

line_old = "673"
json_final_content = []

LINE_STOPS.each_with_index do |line, i|
  line_coord = [line[LATITUDE].to_f, line[LONGITUDE].to_f]

  TOURISTIC_STOPS.each_with_index do |t_stop, j|
    unless ( i == 0 or j == 0 )
      t_stop_coord = [t_stop[TS_LAT].to_f, t_stop[TS_LONG].to_f]
      distance =  Haversine.distance(t_stop_coord, line_coord).to_m;

      if(distance < 500)
        
        if(line_old == line[LINE_ID])

          if !t_stop[2]
            t_stop[2] = "s/n"
          end
          ts_stop = {
            "nome" => t_stop[TS_NAME],
            "latitude" => t_stop[TS_LAT],
            "longitude" => t_stop[TS_LONG],
            "endereco" => t_stop[1]+", "+t_stop[2]+" - "+t_stop[3]
          }
          if !json_final_content.include?(ts_stop)
            json_final_content.push(ts_stop)
            #write_csv_file(t_stop, line)
          end
        else

          json_file_path = File.join('pontos_turisticos','json', line_old+".json")
          File.open(json_file_path, "a") do |json|
            if json_final_content
              json << json_final_content.to_json
            end
          end
          line_old = line[LINE_ID]
          json_final_content = []
        end
      end
    end
  end
end