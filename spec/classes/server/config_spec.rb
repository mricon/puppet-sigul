require 'spec_helper'

describe 'sigul::server', :type => 'class' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { should compile }
      it { should contain_class('sigul::server::config') }
      it { should contain_file('/test/sigulconf/server.conf')
          .with_ensure('present')
          .with_owner('root')
          .with_group('root')
          .with_mode('0600')
          .with_seltype('sigul_conf_test_t')
          .with_show_diff(false)
          .with_content(/^bridge-hostname: test.example.com/)
          .with_content(/^bridge-port: 55512/)
          .with_content(/^max-file-payload-size: 5551212/)
          .with_content(/^max-memory-payload-size: 5551213/)
          .with_content(/^max-rpms-payload-size: 5551214/)
          .with_content(/^server-cert-nickname: sigul-server-test-cert/)
          .with_content(/^signing-timeout: 66/)
          .with_content(/^nss-dir: \/test\/sigulvar\/nss/)
          .with_content(/^database-path: \/test\/sigulvar\/server.sqlite/)
          .with_content(/^nss-password: testpassword/)
      }
    end
  end
end
