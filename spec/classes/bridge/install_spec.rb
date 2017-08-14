require 'spec_helper'

describe 'sigul::bridge', :type => 'class' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { should compile }
      it { should contain_class('sigul::bridge::install') }
      it { should contain_package('sigul-bridge-test')
          .with_ensure('present')
      }
    end
  end
end
