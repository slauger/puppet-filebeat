require 'puppet'
Facter.add(:filebeat_version) do
  setcode do
    if Facter::Util::Resolution.which('filebeat')
      filebeat_version = Facter::Util::Resolution.exec('filebeat version 2>&1')
      %r{^filebeat version ([\w\.]+)}.match(filebeat_version)[1]
    elsif Facter::Util::Resolution.which('rpm')
      Facter::Util::Resolution.exec('rpm -q filebeat --qf \'%{VERSION}\'')
    elsif Facter::Util::Resolution.which('dpkg-query')
      Facter::Util::Resolution.exec('dpkg-query -W -f=\'${Version}\n\' filebeat')
    end
  end
end
