require 'spec_helper'

describe 'filebeat::module' do
  let(:title) { 'apache' }
  let(:params) do
    {
      config: [
        'module': 'system',
	'syslog': {'enabled': true},
	'auth': {'enabled': true}
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
