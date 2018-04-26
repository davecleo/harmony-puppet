class harmony::service {
    service {"cleod":
        ensure => "running",
        require => [ Exec["install service"], File["harmony license"], File['postgres jdbc'] ],
    }
}
