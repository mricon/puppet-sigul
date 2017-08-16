require 'spec_helper'

describe 'sigul::server', :type => 'class' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { should compile }
      it { should contain_class('sigul::server::database') }
      it { should contain_exec('sigul_server_create_db')
          .with_command('/sbin/funky_create_db')
          .with_creates('/test/sigulvar/funky_server.sqlite')
          .with_user('sigultestuser')
      }
    end
  end
end
