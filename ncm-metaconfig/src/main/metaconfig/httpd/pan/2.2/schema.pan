structure template metaconfig/httpd/2.2/schema;

include 'metaconfig/httpd/types_simple';

# 2.2 specific types

type httpd_limit_base = {
    include httpd_limit
    "access" ? httpd_acl
};

type httpd_file_base = {
    include httpd_file_base
    "access" ? httpd_acl
};


include 'metaconfig/httpd/types_composed';
