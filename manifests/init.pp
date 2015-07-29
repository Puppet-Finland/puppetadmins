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
# this module. In particular, the module assumes they're created by a private 
# class called "localusers", which sets up (admin) users and groups. Without 
# that explicit localusers dependency Puppet runs would initially fail.
#
# Also note that this module assumes that $confdir/.git exists and manages ACLs
# for it. This is necessary because on newer versions of Git it is possible to
# add submodules to any directory, not just the root of the Git repository. This
# means that the actual Git indices are stored outside $envdir (e.g.
# /etc/puppet/environments), and a normal user won't be able to write to them
# without setting proper ACLs in the Git root directory.
#
# == Parameters
#
# [*admingroup*]
#   Group into which the Puppet administrators belong. The group will not be 
#   created if it does not exist. The group must be defined elsewhere as a 
#   Puppet resource
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

    class { 'puppetadmins::acls':
        admingroup => $admingroup,
        confdir => $confdir,
        envdir => $envdir,
        # Ensure the $admingroup is defined before setting ACLs
        require => Group[$admingroup],
    }
}
