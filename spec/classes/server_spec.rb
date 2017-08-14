require 'spec_helper'

describe 'sigul::server', :type => 'class' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { should compile }
      it { should contain_class('sigul::server') }
      it { should contain_anchor('sigul::server::begin') }
      it { should contain_class('sigul::server::install') }
      it { should contain_class('sigul::server::config') }
      it { should contain_class('sigul::server::service') }
      it { should contain_anchor('sigul::server::end') }
    end
  end
end
