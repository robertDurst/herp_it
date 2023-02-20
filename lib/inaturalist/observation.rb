module INaturalist
  class Observation
    attr_reader :quality_grade_label,
      :observed_at_month,
      :time_observed_at,
      :taxon_geoprivacy,
      :id,
      :positional_accuracy,
      :comments_count,
      :public_positional_accuracy,
      :num_identification_agreements,
      :coordinates,
      :identifications_count,
      :quality_metrics,
      :taxon_preferred_common_name,
      :taxon_name

    def initialize(observation_json:)
      @quality_grade_label = observation_json['quality_grade']
      @time_observed_at = observation_json['time_observed_at'].nil? ? nil : Time.parse(observation_json['time_observed_at'])
      @observed_at_month = time_observed_at.nil? ? 'Unknown' : Date::MONTHNAMES[time_observed_at.to_date.month]
      @taxon_geoprivacy = observation_json['taxon_geoprivacy']
      @id = observation_json['id']
      @positional_accuracy = observation_json['positional_accuracy'] || '?'
      @comments_count = observation_json['comments_count']
      @public_positional_accuracy = observation_json['public_positional_accuracy'] || '? '
      @num_identification_agreements = observation_json['num_identification_agreements']
      @coordinates = observation_json.key?('geojson') && !observation_json['geojson'].nil? && observation_json['geojson'].key?('coordinates') ? observation_json['geojson']['coordinates'] : []
      @identifications_count = observation_json['identifications_count']
      @quality_metrics = observation_json['quality_metrics']
      @taxon_preferred_common_name = observation_json['taxon']['preferred_common_name']
      @taxon_name = observation_json['taxon']['name']
    end

    def to_s
      formatted_string = "\n"
      formatted_string << "\nScientific Name: #{taxon_name}"
      formatted_string << "\nCommon Name: #{taxon_preferred_common_name}"
      formatted_string << "\n\t Month observed at: #{observed_at_month}"
      formatted_string << "\n\t Identification Agreements: #{num_identification_agreements}"
      formatted_string << "\n\t Comments: #{comments_count}"
      formatted_string << "\n\t Internal Positional Accuracy: #{positional_accuracy}m"
      formatted_string << "\n\t Public Positional Accuracy: #{public_positional_accuracy}m"
      formatted_string << "\n\t Quality Grade: #{quality_grade_label}"
      formatted_string << "\n\t Geoprivacy: #{taxon_geoprivacy}"
      formatted_string << "\n\t Coordinates: #{coordinates}"
      formatted_string << "\n\n"
    end

    def self.csv_row_header_s
      formatted_string = ""
      formatted_string << "Common Name,"
      formatted_string << "Scientific Name,"
      formatted_string << "Month observed at,"
      formatted_string << "Identification Agreements,"
      formatted_string << "Comments,"
      formatted_string << "Internal Positional Accuracy,"
      formatted_string << "Public Positional Accuracy,"
      formatted_string << "Quality Grade,"
      formatted_string << "Geoprivacy,"
      formatted_string << "Latitude,"
      formatted_string << "Longitude"
      formatted_string
    end

    def to_csv_row_s
      formatted_string = ""
      formatted_string << "#{taxon_preferred_common_name},"
      formatted_string << "#{taxon_name},"
      formatted_string << "#{observed_at_month},"
      formatted_string << "#{num_identification_agreements},"
      formatted_string << "#{comments_count},"
      formatted_string << "#{positional_accuracy},"
      formatted_string << "#{public_positional_accuracy},"
      formatted_string << "#{quality_grade_label},"
      formatted_string << "#{taxon_geoprivacy},"
      formatted_string << "#{coordinates[0]},"
      formatted_string << "#{coordinates[1]}"
    end
  end
end