require 'spec_helper'

describe 'sigul::bridge', :type => 'class' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { should compile }
      it { should contain_class('sigul::bridge') }
      it { should contain_anchor('sigul::bridge::begin') }
      it { should contain_class('sigul::bridge::install') }
      it { should contain_class('sigul::bridge::config') }
      it { should contain_class('sigul::bridge::service') }
      it { should contain_anchor('sigul::bridge::end') }
    end
  end
end
