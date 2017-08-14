require 'spec_helper'

describe 'sigul::client', :type => 'class' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { should compile }
      it { should contain_class('sigul::client::config') }
      it { should contain_file('/test/sigulconf/client.conf')
          .with_ensure('present')
          .with_owner('sigulclientusertest')
          .with_group('sigulclientgrouptest')
          .with_mode('0600')
          .with_seltype('sigul_conf_client_test_t')
          .with_show_diff(false)
          .with_content(/^bridge-hostname: test-client-bridge.example.com/)
          .with_content(/^bridge-port: 55515/)
          .with_content(/^client-cert-nickname: sigul-client-cert-test/)
          .with_content(/^server-hostname: test-client-server.example.com/)
          .with_content(/^user-name: testnobody/)
          .with_content(/^koji-config: testkoji.conf/)
          .with_content(/^koji-instances: ppc64 s390/)
          .with_content(/^koji-config-s390: testkoji-s390.conf/)
          .with_content(/^nss-dir: \/test\/sigulvar\/nss/)
          .with_content(/^nss-password: testpassword/)
      }
    end
  end
end
