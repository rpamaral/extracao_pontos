require 'csv'
require 'haversine'

line_stops_path = "data_files/pontos_por_linha.csv";
stops_description_path ='data_files/stops_description.csv';
touristic_stops_path ='data_files/pontos_turisticos.csv';

line_stops = CSV.read(line_stops_path,  encoding: "ISO8859-1:utf-8");
stops_description = CSV.read(stops_description_path,  encoding: "ISO8859-1:utf-8");
touristic_stops = CSV.read(touristic_stops_path,  encoding: "ISO8859-1:utf-8");

# LATITUDE = 4
# LONGITUDE = 5
# LINE_ID = 0
# STOP_DESC = 2

# line_stops.each_with_index do |line, i|
#   stops_description.each_with_index do |stop, j|
#     unless ( i == 0 or j == 0)
#       stop_coord = [stop[LATITUDE].to_f, stop[LONGITUDE].to_f]
#       line_coord = [line[LATITUDE].to_f, line[LONGITUDE].to_f]
#       distance =  Haversine.distance(stop_coord, line_coord).to_meters;
#       if(distance < 10)
#         file = "linha_" + line[LINE_ID]+ ".csv"
#         file_path = File.join('linhas', file)
#         CSV.open(file_path, "a") do |csv|
#           csv << [line[LINE_ID], line[LATITUDE], line[LONGITUDE], stop[STOP_DESC], distance, get_tourist_stops(line_coord)]
#         end
#       end
#     end
#   end
# end

# def get_tourist_stops line_coord, touristic_stops
  TS_LAT = 5;
  TS_LONG = 6;
  TS_NAME = 0;
  line_old = 0;
  lines = 0
  line_stops.each_with_index do |line, j|
    near_ts = ""
    touristic_stops.each_with_index do |t_stop, i|
      unless ( i == 0 or j == 0)
        line_coord = [line[4].to_f, line[5].to_f]
        t_stop_coord = [t_stop[TS_LAT].to_f, t_stop[TS_LONG].to_f]
        distance =  Haversine.distance(t_stop_coord, line_coord).to_meters;
        if(distance < 500)
            near_ts += t_stop[TS_NAME]+";"
        end
      end
    end
    if near_ts != ''
      p near_ts
    end
    if(line_old != line[0].to_i)
      lines++
      line_old = line[0].to_i
    end
  end
  p lines
#end
