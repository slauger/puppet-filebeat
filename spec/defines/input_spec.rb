require 'spec_helper'

describe 'filebeat::input' do
  let(:title) { 'apache' }
  let(:params) do
    {
      config: [
        'type': 'log',
	'enabled': 'true',
	'paths': ['/var/log/httpd/*_access.log', '/var/log/httpd/*_access_ssl.log']
      ]
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
