#
# == Class: puppetadmins:prequisites
#
# Class that ensures that setting up Extended ACLs is possible
#
class puppetadmins::prequisites {

    if $osfamily == 'Debian' {
        include puppetadmins::prequisites::debian
    }
}
