namespace :services do

    task :build => :environment do 
        clean_up

        initialize_user_groups
        initialize_services
        initialize_service_policies

        create_super_admin_policies
        create_admin_policies
    end

    def clean_up
        #Clean up service table
        p "Cleaning table" 
        ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS = 0")
        ActiveRecord::Base.connection.execute("TRUNCATE service_policies")
        ActiveRecord::Base.connection.execute("TRUNCATE role_policies")
        ActiveRecord::Base.connection.execute("TRUNCATE user_groups")
        ActiveRecord::Base.connection.execute("TRUNCATE services")
        ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS = 1")
        p 'Tables cleaned'

    end

    def initialize_user_groups
        _groups = [
            {
                name:"SuperAdmin"
            },
            {
                name:"Admin"
            }
        ]
        UserGroup.create _groups
        p 'User groups created'
    end

    def initialize_services
        _services = [
            {
                name:"Users",
                status: true, 
                resource_path: "admin.dashboard.users",
                resource_icon: "fas fa-users"
            },
            {
                name:"Locations",
                status: true, 
                resource_path: "admin.dashboard.locations",
                resource_icon: "fas fa-search-location"
            },
            {
                name:"Clinics",
                status: true, 
                resource_path: "admin.dashboard.clinics",
                resource_icon: "fas fa-clinic-medical"
            },
            {
                name:"Bookings",
                status: true, 
                resource_path: "admin.dashboard.bookings",
                resource_icon: "fas fa-calendar-check"
            },
        ]
        Service.create _services
        p 'Services created'
    end

    def initialize_service_policies
        _roleId = 1 #SuperAdmin
        _servicePolicies = [
            {
                service_id: 1, #User service
                name: "View user module", #service_policy_id 1
                status: true
            },
            {
                service_id: 2, #Location service
                name: "View location module", #service_policy_id 2
                status: true
            },
            { 
                service_id: 2, #Location service
                name: "Add new location", #service_policy_id 3
                status: true
            },
            {
                service_id: 3, #Clinic service
                name: "View clinic module", #service_policy_id 4
                status: true
            },
            {
                service_id: 3, #Clinic service
                name: "Add new clinic", #service_policy_id 5
                status: true
            },
            {
                service_id: 4, #Booking service
                name: "View booking module", #service_policy_id 6
                status: true
            },
            {
                service_id: 4, #Booking service
                name: "Export csv policy", #service_policy_id 7
                status: true
            }
        ]
        ServicePolicy.create _servicePolicies
        p 'Service policies created'
    end

    def create_super_admin_policies
        _user_group_id = 1
        _role_policies = [
            {
                user_group_id: _user_group_id,
                service_id: 1, #User service
                service_policy_id: 1, #View user module
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 2, #Location service
                service_policy_id: 2, #View location module
                status: true
            },
            { 
                user_group_id: _user_group_id,
                service_id: 2, #Location service
                service_policy_id: 3, #Add location
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 3, #Clinic service
                service_policy_id: 4, #View clinic module
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 3, #Clinic service
                service_policy_id: 5, #Add clinic
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 4, #Booking service
                service_policy_id: 6, #View booking module
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 4, #Booking service
                service_policy_id: 7, #Export csv
                status: true
            }
        ]
        RolePolicy.create _role_policies
        p 'Super admin policies created'
    end

    def create_admin_policies
        _user_group_id = 2
        _role_policies = [
            {
                user_group_id: _user_group_id,
                service_id: 2, #Location service
                service_policy_id: 2, #View location module
                status: true
            },
            { 
                user_group_id: _user_group_id,
                service_id: 2, #Location service
                service_policy_id: 3, #Add location
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 3, #Clinic service
                service_policy_id: 4, #View clinic module
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 3, #Clinic service
                service_policy_id: 5, #Add clinic
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 4, #Booking service
                service_policy_id: 6, #View booking module
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 4, #Booking service
                service_policy_id: 7, #Export csv
                status: true
            }
        ]
        RolePolicy.create _role_policies
        p 'Super admin policies created'
    end



end