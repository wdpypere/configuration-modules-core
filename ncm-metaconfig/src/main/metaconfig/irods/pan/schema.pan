declaration template metaconfig/irods/schema;

include 'pan/types';

@{ type for configuring the irods_environment.json config file for clients @}
type irods_environment_client_config = {
    'irods_host' :  type_hostname
    'irods_port' : type_port
    'irods_user_name' : string
    'irods_zone_name' : string
};
@{ type for configuring the irods_environment.json config file for service accounts @}
type irods_environment_server_config = {
    include irods_environment_client_config
    "irods_client_server_negotiation" : choice("none", "request_server_negotiation") = "request_server_negotiation"
    "irods_client_server_policy" : choice("CS_NEG_DONT_CARE", "CS_NEG_REFUSE") = "CS_NEG_REFUSE"
    "irods_cwd": string = "/UGent/home/rods"
    "irods_default_hash_scheme": choice('SHA256', 'MD5') = "SHA256"
    "irods_default_number_of_transfer_threads": long =  4
    "irods_default_resource": string = "demoResc"
    "irods_encryption_algorithm": string = "AES-256-CBC"
    "irods_encryption_key_size": long = 32
    "irods_encryption_num_hash_rounds" : long = 16
    "irods_encryption_salt_size" : long = 8
    "irods_home": string = "/UGent/home/rods"
    "irods_match_hash_policy": choice('strict', 'compatible') = "compatible"
    "irods_maximum_size_for_single_buffer_in_megabytes": long = 32
    "irods_server_control_plane_encryption_algorithm": string = "AES-256-CBC"
    "irods_server_control_plane_encryption_num_hash_rounds": long = 16
    "irods_server_control_plane_key": string
    "irods_server_control_plane_port": long = 1248
    "irods_transfer_buffer_size_for_parallel_transfer_in_megabytes": long = 4
    "schema_name": choice('irods_environment') = 'irods_environment'
    "schema_version": choice('v3') = 'v3'
};

@{ type for configuring the irods_hosts.json address config section @}
type irods_host_entry_address = {
    'address' : type_hostname
};

@{ type for configuring the irods_hosts.json host_entries config section @}
type irods_host_entry = {
    'address_type' : choice('local', 'remote')
    'addresses' : irods_host_entry_address[]
};

@{ type for configuring the irods_hosts.json config file @}
type irods_hosts_config = {
    'host_entries' : irods_host_entry[]
};
