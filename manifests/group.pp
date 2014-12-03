#
# == Class: puppetadmins::group
#
# Ensure there's a group for the puppet administrators
#
class puppetadmins::group
(
    $admingroup
)
{
    group { "$admingroup":
        name => $admingroup,
        ensure => present,
    }
}
