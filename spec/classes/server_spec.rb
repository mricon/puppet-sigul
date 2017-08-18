require 'spec_helper'

describe 'sigul::server', :type => 'class' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { should compile }
      it { should contain_class('sigul::server') }
      it { should contain_class('sigul::server::install') }
      it { should contain_sigul__server__instance('__default__')
          .with_ensure('absent')
      }
      it { should contain_sigul__server__instance('instance1')
          .with_ensure('present')
      }
      it { should contain_sigul__server__instance('instance2')
          .with_ensure('present')
      }
      it { should contain_sigul__server__instance('instance3')
          .with_ensure('absent')
      }
      it { should contain_exec('sigul-server-create-db-instance1')
          .with_command('/sbin/sigul_server_create_db -c /test/sigulconf/server-instance1.conf')
          .with_creates('/test/sigulvar/funky_server.sqlite')
          .with_user('sigultestuser')
      }
      it { should contain_file('/test/sigulconf/server.conf')
          .with_ensure('absent')
      }
      it { should contain_file('/test/sigulconf/server-instance1.conf')
          .with_ensure('present')
          .with_owner('sigultestuser')
          .with_group('sigultestgroup')
          .with_mode('0600')
          .with_seltype('sigul_conf_test_t')
          .with_show_diff(false)
          .with_content(/^bridge-hostname: bridge-instance1.example.com/)
          .with_content(/^bridge-port: 55512/)
          .with_content(/^max-file-payload-size: 5551212/)
          .with_content(/^max-memory-payload-size: 5551213/)
          .with_content(/^max-rpms-payload-size: 5551214/)
          .with_content(/^server-cert-nickname: sigul-server-test-cert/)
          .with_content(/^signing-timeout: 66/)
          .with_content(/^nss-dir: \/etc\/pki\/sigul/)
          .with_content(/^database-path: \/test\/sigulvar\/funky_server.sqlite/)
          .with_content(/^nss-password: testpassword/)
      }
      it { should contain_file('/test/sigulconf/server-instance2.conf')
          .with_ensure('present')
          .with_content(/^bridge-hostname: bridge-instance2.example.com/)
      }
      it { should contain_file('/test/sigulconf/server-instance3.conf')
          .with_ensure('absent')
      }
      it { should contain_file('/usr/lib/systemd/system/sigul_server@.service')
          .with_ensure('present')
      }
      it { should contain_service('sigul_server_test')
          .with_ensure('stopped')
          .with_enable(false)
      }
      it { should contain_service('sigul_server@instance1')
          .with_ensure('running')
          .with_enable(true)
      }
      it { should contain_service('sigul_server@instance2')
          .with_ensure('running')
          .with_enable(true)
      }
      it { should contain_service('sigul_server@instance3')
          .with_ensure('stopped')
          .with_enable(false)
      }
      it { should contain_file('/etc/tmpfiles.d/sigul-server-instance1.conf')
          .with_ensure('present')
          .with_content(/^d \/run\/sigul-instance1 0755 root root/)
      }
      it { should contain_file('/etc/tmpfiles.d/sigul-server-instance2.conf')
          .with_ensure('present')
      }
      it { should contain_file('/etc/tmpfiles.d/sigul-server-instance3.conf')
          .with_ensure('absent')
      }
      it { should contain_file('/run/sigul-instance1')
          .with_ensure('directory')
      }
      it { should contain_file('/run/sigul-instance2')
          .with_ensure('directory')
      }
      it { should contain_file('/var/log/sigul-instance1')
          .with_ensure('directory')
      }
      it { should contain_file('/var/log/sigul-instance2')
          .with_ensure('directory')
      }
    end
  end
end
