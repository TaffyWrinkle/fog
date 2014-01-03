require 'fog/core/collection'
require 'fog/azure/models/compute/server'

module Fog
  module Compute
    class Azure

      class Servers < Fog::Collection

        model Fog::Compute::Azure::Server

        def all()
          servers = []
          service.list_virtual_machines.each do |vm|
            hash = {}
            vm.instance_variables.each {|var| hash[var.to_s.delete("@")] = vm.instance_variable_get(var) }
            hash[:storage_account_name] = vm.storage_account_name
            hash[:password] = vm.password
            hash[:vm_user] = vm.vm_user
            hash[:image] = vm.image
            hash[:virtual_network] = vm.virtual_network
            servers << hash
          end
          load(servers)
        end

        # def get(identity, zone=nil)
        #   response = nil
        #   if zone.nil?
        #     service.list_zones.body['items'].each do |zone|
        #       begin
        #         response = service.get_server(identity, zone['name'])
        #         break if response.status == 200
        #       rescue Fog::Errors::Error
        #       end
        #     end
        #   else
        #     response = service.get_server(identity, zone)
        #   end

        #   if response.nil? or response.status != 200
        #     nil
        #   else
        #     new(response.body)
        #   end
        # rescue Excon::Errors::NotFound
        #   nil
        # end

        # def bootstrap(new_attributes = {})
        #   defaults = {
        #     :name => "fog-#{Time.now.to_i}",
        #     :image_name => "debian-7-wheezy-v20131014",
        #     :machine_type => "n1-standard-1",
        #     :zone_name => "us-central1-b",
        #     :private_key_path => File.expand_path("~/.ssh/id_rsa"),
        #     :public_key_path => File.expand_path("~/.ssh/id_rsa.pub"),
        #     :username => ENV['USER'],
        #   }

        #   if new_attributes[:disks]
        #     new_attributes[:disks].each do |disk|
        #       defaults.delete :image_name if disk['boot']
        #     end
        #   end

        #   server = create(defaults.merge(new_attributes))
        #   server.wait_for { sshable? }

        #   server
        # end
      end
    end
  end
end
