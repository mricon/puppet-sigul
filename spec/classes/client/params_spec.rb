require 'spec_helper'

describe 'sigul::client', :type => 'class' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { should compile }
      it { should contain_class('sigul::client::params') }
    end
  end
end
