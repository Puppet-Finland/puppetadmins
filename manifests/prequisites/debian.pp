#
# == Class: puppetadmins::prequisites::debian
#
# Preparations required on Debian-based operating systems
#
class puppetadmins::prequisites::debian {

    package { 'puppetadmins-acl':
        name => 'acl',
        ensure => installed,
    }
}
