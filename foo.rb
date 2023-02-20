require './inaturalist/api/client.rb'

INaturalist::API::Client.new.get_all_observations
