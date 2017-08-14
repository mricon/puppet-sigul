require 'spec_helper'

describe 'sigul::bridge', :type => 'class' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { should compile }
      it { should contain_class('sigul::bridge::config') }
      it { should contain_file('/test/sigulconf/bridge.conf')
          .with_ensure('present')
          .with_owner('root')
          .with_group('root')
          .with_mode('0600')
          .with_seltype('sigul_conf_test_t')
          .with_show_diff(false)
          .with_content(/^bridge-cert-nickname: sigul-bridge-cert-test/)
          .with_content(/^client-listen-port: 55522/)
          .with_content(/^server-listen-port: 55512/)
          .with_content(/^max-rpms-payload-size: 5551212/)
          .with_content(/^koji-config: testkoji.conf/)
          .with_content(/^required-fas-group-s390: s390-signers-test/)
          .with_content(/^koji-instances: ppc64 s390/)
          .with_content(/^koji-config-s390: testkoji-s390.conf/)
          .with_content(/^nss-dir: \/test\/sigulvar\/nss/)
          .with_content(/^nss-password: testpassword/)
      }
    end
  end
end
