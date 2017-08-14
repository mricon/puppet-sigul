require 'spec_helper'

describe 'sigul::bridge', :type => 'class' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { should compile }
      it { should contain_class('sigul::bridge::params') }
    end
  end
end
