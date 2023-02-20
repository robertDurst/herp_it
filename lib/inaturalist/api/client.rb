require 'date'
require 'httparty'
require 'json'

require './inaturalist/observation.rb'

module INaturalist
  module API
    SNAKE_TAXON_ID = 85553
    MERICA_MEXICO_CENTER = [20.989668, -89.625711]

    class Client
      include HTTParty
      base_uri 'https://api.inaturalist.org/v1'

      attr_reader :options

      def initialize
        @options = {}
      end

      def get_all_observations
        all_observations = []

        page = 1
        per_page = 200
        result = observations(per_page: per_page, page: page)
        num_pages = (result[:num_results] / per_page).round(0)
        all_observations << result[:observations]

        while page <= num_pages
          page += 1
          result = observations(per_page: per_page, page: page)
          all_observations << result[:observations]
        end

        all_observations.flatten!
        observations = [INaturalist::Observation.csv_row_header_s].concat(all_observations.map { |observation| observation.to_csv_row_s }).join("\n")
        puts observations
      end

      def observations(per_page: 200, page: 1)
        path = '/observations'

        # where this is lat, lon
        center = []

        # radius: km from center
        radius = 100

        url = "#{path}?taxon_id=#{SNAKE_TAXON_ID}&page=#{page}&per_page=#{per_page}&lat=#{MERICA_MEXICO_CENTER[0]}&lng=#{MERICA_MEXICO_CENTER[1]}&radius=#{140}"

        response = JSON.parse(self.class.get(url, options).to_s)
        results = response['total_results']
        page = response['page']
        per_page = response['per_page']
        num_pages = (results/per_page).round(1)

        # puts "Found #{results}. Page #{page}/#{num_pages}"
        observations = response['results'].compact.map{ |observation_json| INaturalist::Observation.new(observation_json: observation_json) }

        {
          observations: observations,
          num_results: results,
        }
      end
    end
  end
end    
