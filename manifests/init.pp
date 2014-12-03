#
# == Class: puppetadmins
#
# A simple class for setting up a Puppet master into a state where several 
# system administrators can manage it simultaneously. Primarily targeted at 
# sites where the same Puppet modules are developed by several people using 
# their own user accounts.
#
# The technical implementation uses Extended POSIX ACLs; more details are 
# available in the puppetadmins::acls class. Optimally the puppetadmins::acls 
# part should be split into a separate module, but that's a future project.
#
# Note that the actual administrator user objects have to be managed outside 
# this module.
#
# == Parameters
#
# [*admingroup*]
#   Group into which the Puppet administrators belong. Will be created if it 
#   does not exist.
# [*confdir*]
#   The Puppet configuration directory. Defaults to '/etc/puppet'.
# [*envdir*]
#   The Puppet environment directory. Defaults to '/etc/puppet/environments'.
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
#
# == License
#
# BSD-license. See file LICENSE for details.
#
class puppetadmins
(
    $admingroup='puppetadmins',
    $confdir = '/etc/puppet',
    $envdir = '/etc/puppet/environments'
)
{
    include puppetadmins::prequisites

    class { 'puppetadmins::group':
        admingroup => $admingroup,
    }

    class { 'puppetadmins::acls':
        admingroup => $admingroup,
        confdir => $confdir,
        envdir => $envdir,
    }
}
