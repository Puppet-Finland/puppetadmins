#
# == Class: puppetadmins::acls
#
# Set the default POSIX Extended ACLs on the given directory recursively so that 
# all members of the puppet admin group can work with the same files without 
# permission errors.
#
# For details on POSIX ACLs and their Linux implementation look here:
#
# <http://users.suse.com/~agruen/acl/linux-acls/online>
#
# There _is_ at least one  Puppet module for managing ACLs:
#
# <https://github.com/dobbymoodge/puppet-acl>
#
# The above module is currently unmaintained and has one fatal flaw: when 
# managing ACLs recursively it does not detect changes to the underlying files, 
# only changes to the Puppet parameters. What this means is that if files with 
# wrong extended ACLs are added manually under the managed directory the module 
# won't fix them. Because Puppet modules are _not_ managed by Puppet, someone 
# will eventually "cp -a" something with wrong Extended ACLs under the module 
# directory, even if default ACLs are set correctly.
#
# Changes to Extended ACLs of any file in a directory could be detected like 
# this:
#
# $ getfacl --omit-header -R environments/|sha1sum
#
# Even in this case the hash from previous Puppet run would have to be stored 
# somewhere and compared to the new one in order to detect any changes. Even 
# this approach would produce useless Puppet runs if Extended ACLs not managed 
# by the Puppet module had changed. This can happen if the acl class parameter 
# $action is not set to 'exact'.
#
# To keep things simple this module just runs "setfacl" recursively _and_ 
# unconditionally from within an Exec.
#
class puppetadmins::acls
(
    $admingroup,
    $confdir,
    $envdir
)
{

    $acl_file = "${confdir}/puppetadmins-acl-list.txt"

    file { "puppetadmins-acl-list":
        name => "${acl_file}",
        content => template('puppetadmins/puppetadmins-acl-list.txt.erb'),
        owner => root,
        group => root,
        mode => 644,
        require => Class['puppetadmins::prequisites'],
    }

    exec { 'puppetadmins-set-acls':
        command => "setfacl -R -P -n -M ${acl_file} ${envdir} ${confdir}/.git",
        path => ['/bin', '/usr/bin', '/sbin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin'],
        require => File['puppetadmins-acl-list'],
    }
}
