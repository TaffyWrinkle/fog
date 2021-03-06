Shindo.tests("Fog::Compute::HPV2 | key pair requests", ['hp', 'v2', 'compute']) do

  service = Fog::Compute.new(:provider => 'HP', :version => :v2)

  tests('success') do

    @keypair_format = {
      'public_key'   => String,
      'fingerprint'  => String,
      'name'         => String
    }

    @keypairs_format = {
      'keypairs' => [{
        'keypair' => {
          'public_key'   => String,
          'fingerprint'  => String,
          'name'         => Fog::Nullable::String
        }
      }]
    }

    @key_pair_name = 'fog_create_key_pair'
    @public_key_material = 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA1SL+kgze8tvSFW6Tyj3RyZc9iFVQDiCKzjgwn2tS7hyWxaiDhjfY2mBYSZwFdKN+ZdsXDJL4CPutUg4DKoQneVgIC1zuXrlpPbaT0Btu2aFd4qNfJ85PBrOtw2GrWZ1kcIgzZ1mMbQt6i1vhsySD2FEj+5kGHouNxQpI5dFR5K+nGgcTLFGnzb/MPRBk136GVnuuYfJ2I4va/chstThoP8UwnoapRHcBpwTIfbmmL91BsRVqjXZEUT73nxpxFeXXidYwhHio+5dXwE0aM/783B/3cPG6FVoxrBvjoNpQpAcEyjtRh9lpwHZtSEW47WNzpIW3PhbQ8j4MryznqF1Rhw=='

    tests("#create_key_pair('#{@key_pair_name}')").formats({'keypair' => @keypair_format.merge({'private_key' => String, 'user_id' => String})}) do
      body = service.create_key_pair(@key_pair_name).body
      tests("private_key").returns(OpenSSL::PKey::RSA, "is a valid private RSA key") do
        OpenSSL::PKey::RSA.new(body['keypair']['private_key']).class
      end
      body
    end

    tests('#list_key_pairs').formats(@keypairs_format) do
      service.list_key_pairs.body
    end

    tests("#get_key_pair(#{@key_pair_name})").formats({'keypair' => @keypair_format}) do
      service.get_key_pair(@key_pair_name).body
    end

    tests("#delete_key_pair('#{@key_pair_name}')").succeeds do
      service.delete_key_pair(@key_pair_name)
    end

    tests("#create_key_pair('fog_import_key_pair', '#{@public_key_material}')").formats({'keypair' => @keypair_format.merge({'user_id' => String})}) do
      service.create_key_pair('fog_import_key_pair', @public_key_material).body
    end

    tests("#delete_key_pair('fog_import_key_pair)").succeeds do
      service.delete_key_pair('fog_import_key_pair')
    end

  end
  tests('failure') do

    tests("#get_key_pair('not_a_key_name')").raises(Fog::Compute::HPV2::NotFound) do
      service.get_key_pair('not_a_key_name')
    end

    tests("#delete_key_pair('not_a_key_name')").raises(Fog::Compute::HPV2::NotFound) do
      service.delete_key_pair('not_a_key_name')
    end
  end

end
