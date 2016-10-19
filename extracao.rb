require 'csv'
require 'haversine'

# line_stops_file = File.open("data_files/pontos_por_linha.csv", 'r:iso-8859-1:utf-8');

line_stops_path = "data_files/pontos_por_linha.csv"; 
stops_description_path ='data_files/stops_description.csv';

# line_stops = CSV.parse(line_stops_file, {:headers => false})

line_stops = CSV.read(line_stops_path,  encoding: "ISO8859-1:utf-8")
stops_description = CSV.read(stops_description_path,  encoding: "ISO8859-1:utf-8")


line_stops.each_with_index do |line, i|
    stops_description.each_with_index do |stop, j|
      if( i == 0 or j == 0)
        #do nothing
      else
        stop_coord = [stop[4].to_f, stop[5].to_f]
        line_coord = [line[4].to_f, line[5].to_f]

        distance =  Haversine.distance(stop_coord, line_coord).to_meters;
        if(distance < 10)
          file = "linha_" + line[0]+ ".csv"
          file_path = File.join('linhas', file)
            CSV.open(file_path, "a") do |csv|
            csv << [line[0], line[4], line[5], stop[2], distance]
          end
        end
      end
    end
  end


