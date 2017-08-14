require 'spec_helper'

describe 'sigul', :type => 'class' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { should compile }
      it { should contain_class('sigul::install') }
      it { should contain_package('sigultest')
          .with_ensure('present')
      }
      it { should contain_user('sigultestuser')
          .with_ensure('present')
          .with_home('/test/sigulvar')
          .with_uid(5555)
          .with_gid('sigultestgroup')
      }
      it { should contain_group('sigultestgroup')
          .with_gid(7777)
      }
      it { should contain_file('/test/sigulvar')
          .with_ensure('directory')
          .with_mode('0700')
          .with_owner('sigultestuser')
          .with_group('sigultestgroup')
          .with_seltype('sigul_var_test_t')
      }
      it { should contain_file('/test/sigulconf')
          .with_ensure('directory')
          .with_mode('0700')
          .with_owner('root')
          .with_group('root')
          .with_seltype('sigul_conf_test_t')
      }
    end
  end
end
