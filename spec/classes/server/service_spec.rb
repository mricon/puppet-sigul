require 'spec_helper'

describe 'sigul::server', :type => 'class' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { should compile }
      it { should contain_class('sigul::server::service') }
      it { should contain_service('sigul_server_test')
          .with_ensure('stopped')
          .with_enable(false)
      }
    end
  end
end
