namespace :services do

    task :build => :environment do 
        clean_up

        initialize_user_groups
        initialize_services
        initialize_service_policies

        create_biomark_policies
        create_super_admin_policies
        create_admin_policies
        create_finance_policies
        create_call_center_policies
        create_corporate_admin_policies
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
                name:"Superadmin"
            },
            {
                name:"BioMark"
            },
            {
                name:"Admin"
            },
            {
                name:"Finance"
            },
            {
                name:"Call Center"
            },
            {
                name:"Corporate Admin"
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
                resource_icon: "fas fa-users",
                resource_order: 5,
            },
            {
                name:"Test Sites",
                status: true, 
                resource_path: "admin.dashboard.locations",
                resource_icon: "fas fa-search-location",
                resource_order: 3,
            },
            {
                name:"Clinics",
                status: true, 
                resource_path: "admin.dashboard.clinics",
                resource_icon: "fas fa-clinic-medical",
                resource_order: 4,
            },
            {
                name:"Bookings",
                status: true, 
                resource_path: "admin.dashboard.bookings",
                resource_icon: "fas fa-calendar-check",
                resource_order: 2,
            },
            {
                name:"Dashboard",
                status: true, 
                resource_path: "admin.dashboard",
                resource_icon: "fas fa-tachometer-alt",
                resource_order: 1,
            },
            {
                name:"Settings",
                status: true, 
                resource_path: "admin.dashboard.settings",
                resource_icon: "fas fa-cog",
                resource_order: 6,
            },
            {
                name:"Audit Log",
                status: true, 
                resource_path: "admin.dashboard.audit",
                resource_icon: "fas fa-history",
                resource_order: 7,
            },
            {
                name:"Campaign",
                status: true, 
                resource_path: "admin.dashboard.campaign",
                resource_icon: "fas fa-briefcase",
                resource_order: 8,
            }
        ]
        Service.create _services
        p 'Services created'
    end

    def initialize_service_policies
        _servicePolicies = [
            {
                service_id: 1, #User service
                name: "View user module", #service_policy_id 1
                status: true
            },
            {
                service_id: 2, #Test site service
                name: "View test site module", #service_policy_id 2
                status: true
            },
            { 
                service_id: 2, #Test site service
                name: "Add new test site", #service_policy_id 3
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
            },
            {
                service_id: 5, #Dashboard service
                name: "View Dashboard", #service_policy_id 8
                status: true
            },
            {
                service_id: 6, #Settings service
                name: "View settings", #service_policy_id 9
                status: true
            },
            {
                service_id: 1, #User service
                name: "Edit user", #service_policy_id 10
                status: true
            },
            {
                service_id: 7, #Audit log service
                name: "View audit log", #service_policy_id 11
                status: true
            },
            {
                service_id: 4, #Booking service
                name: "Reschedule booking", #service_policy_id 12
                status: true
            },
            {
                service_id: 4, #Booking service
                name: "Confirm booking", #service_policy_id 13
                status: true
            },
            {
                service_id: 4, #Booking service
                name: "Cancel booking", #service_policy_id 14
                status: true
            },
            {
                service_id: 4, #Booking service
                name: "Mark as completed", #service_policy_id 15
                status: true
            },
            {
                service_id: 4, #Booking service
                name: "Mark as no show", #service_policy_id 16
                status: true
            },
            {
                service_id: 1, #Booking service
                name: "Add new user", #service_policy_id 17
                status: true
            },
            { 
                service_id: 2, #Test site service
                name: "Edit test site", #service_policy_id 18
                status: true
            },
            { 
                service_id: 2, #Test site service
                name: "Add test site schedule", #service_policy_id 19
                status: true
            },
            { 
                service_id: 2, #Test site service
                name: "Delete test site schedule", #service_policy_id 20
                status: true
            },
            { 
                service_id: 2, #Test site service
                name: "Link/Unlink clinics from test site", #service_policy_id 21
                status: true
            },
            {
                service_id: 3, #Clinic service
                name: "Edit clinic", #service_policy_id 22
                status: true
            },
            {
                service_id: 6, #Settings service
                name: "Edit settings", #service_policy_id 23
                status: true
            },
            {
                service_id: 8, #Campaign service
                name: "View Campaign Module", #service_policy_id 24
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
                service_id: 2, #Test site service
                service_policy_id: 2, #View location module
                status: true
            },
            { 
                user_group_id: _user_group_id,
                service_id: 2, #Test site service
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
            },
            {
                user_group_id: _user_group_id,
                service_id: 5, #Dashboard service
                service_policy_id: 8, #View dashboard
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 6, #Settings service
                service_policy_id: 9, #View settings
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 1, #User service
                service_policy_id: 10, #Edit user
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 7, #Audit log
                service_policy_id: 11, #View audit log
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 4, #Booking service
                service_policy_id: 12, #Reschedule booking
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 4, #Booking service
                service_policy_id: 13, #Confirm booking
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 4, #Booking service
                service_policy_id: 14, #Cancel booking
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 1, #User service
                service_policy_id: 17, #Add new user
                status: true
            },
            { 
                user_group_id: _user_group_id,
                service_id: 2, #Test site service
                service_policy_id: 18, #Edit test site
                status: true
            },
            { 
                user_group_id: _user_group_id,
                service_id: 2, #Test site service
                service_policy_id: 19, #Add test site schedule
                status: true
            },
            { 
                user_group_id: _user_group_id,
                service_id: 2, #Test site service
                service_policy_id: 20, #Delete test site schedule
                status: true
            },
            { 
                user_group_id: _user_group_id,
                service_id: 2, #Test site service
                service_policy_id: 21, #Link/Unlink clinics from test site
                status: true
            },
            { 
                user_group_id: _user_group_id,
                service_id: 3, #Clinic service
                service_policy_id: 22, #Edit clinic
                status: true
            },
            { 
                user_group_id: _user_group_id,
                service_id: 6, #Settings service
                service_policy_id: 23, #Edit settings
                status: true
            }
        ]
        RolePolicy.create _role_policies
        p 'Super admin policies created'
    end

    def create_biomark_policies
        _user_group_id = 2
        _role_policies = [
            {
                user_group_id: _user_group_id,
                service_id: 1, #User service
                service_policy_id: 1, #View user module
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 2, #Test site service
                service_policy_id: 2, #View location module
                status: true
            },
            { 
                user_group_id: _user_group_id,
                service_id: 2, #Test site service
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
            },
            {
                user_group_id: _user_group_id,
                service_id: 5, #Dashboard service
                service_policy_id: 8, #View dashboard
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 6, #Settings service
                service_policy_id: 9, #View settings
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 1, #User service
                service_policy_id: 10, #Edit user
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 7, #Audit log
                service_policy_id: 11, #View audit log
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 4, #Booking service
                service_policy_id: 12, #Reschedule booking
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 4, #Booking service
                service_policy_id: 13, #Confirm booking
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 4, #Booking service
                service_policy_id: 14, #Cancel booking
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 4, #Booking service
                service_policy_id: 15, #Mark as completed
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 4, #Booking service
                service_policy_id: 16, #Mark as no show
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 1, #User service
                service_policy_id: 17, #Add new user
                status: true
            },
            { 
                user_group_id: _user_group_id,
                service_id: 2, #Test site service
                service_policy_id: 18, #Edit test site
                status: true
            },
            { 
                user_group_id: _user_group_id,
                service_id: 2, #Test site service
                service_policy_id: 19, #Add test site schedule
                status: true
            },
            { 
                user_group_id: _user_group_id,
                service_id: 2, #Test site service
                service_policy_id: 20, #Delete test site schedule
                status: true
            },
            { 
                user_group_id: _user_group_id,
                service_id: 2, #Test site service
                service_policy_id: 21, #Link/Unlink clinics from test site
                status: true
            },
            { 
                user_group_id: _user_group_id,
                service_id: 3, #Clinic service
                service_policy_id: 22, #Edit clinic
                status: true
            },
            { 
                user_group_id: _user_group_id,
                service_id: 6, #Settings service
                service_policy_id: 23, #Edit settings
                status: true
            },
            { 
                user_group_id: _user_group_id,
                service_id: 8, #Campaign service
                service_policy_id: 24, #View Campaign module
                status: true
            }
        ]
        RolePolicy.create _role_policies
        p 'BioMark policies created'
    end


    def create_admin_policies
        _user_group_id = 3
        _role_policies = [
            {
                user_group_id: _user_group_id,
                service_id: 1, #User service
                service_policy_id: 1, #View user module
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 2, #Test site service
                service_policy_id: 2, #View location module
                status: true
            },
            { 
                user_group_id: _user_group_id,
                service_id: 2, #Test site service
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
            },
            {
                user_group_id: _user_group_id,
                service_id: 5, #Dashboard service
                service_policy_id: 8, #View dashboard
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 6, #Settings service
                service_policy_id: 9, #View settings
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 1, #User service
                service_policy_id: 10, #Edit user
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 7, #Audit log
                service_policy_id: 11, #View audit log
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 4, #Booking service
                service_policy_id: 12, #Reschedule booking
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 4, #Booking service
                service_policy_id: 13, #Confirm booking
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 4, #Booking service
                service_policy_id: 14, #Cancel booking
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 1, #User service
                service_policy_id: 17, #Add new user
                status: true
            },
            { 
                user_group_id: _user_group_id,
                service_id: 2, #Test site service
                service_policy_id: 18, #Edit test site
                status: true
            },
            { 
                user_group_id: _user_group_id,
                service_id: 2, #Test site service
                service_policy_id: 19, #Add test site schedule
                status: true
            },
            { 
                user_group_id: _user_group_id,
                service_id: 2, #Test site service
                service_policy_id: 20, #Delete test site schedule
                status: true
            },
            { 
                user_group_id: _user_group_id,
                service_id: 2, #Test site service
                service_policy_id: 21, #Link/Unlink clinics from test site
                status: true
            },
            { 
                user_group_id: _user_group_id,
                service_id: 3, #Clinic service
                service_policy_id: 22, #Edit clinic
                status: true
            },
            { 
                user_group_id: _user_group_id,
                service_id: 3, #Clinic service
                service_policy_id: 23, #Edit settings
                status: true
            }
        ]
        RolePolicy.create _role_policies
        p 'Admin policies created'
    end

    def create_finance_policies
        _user_group_id = 4
        _role_policies = [
            {
                user_group_id: _user_group_id,
                service_id: 5, #Dashboard service
                service_policy_id: 8, #View dashboard
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
            },
            {
                user_group_id: _user_group_id,
                service_id: 4, #Booking service
                service_policy_id: 12, #Reschedule booking
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 4, #Booking service
                service_policy_id: 13, #Confirm booking
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 4, #Booking service
                service_policy_id: 14, #Cancel booking
                status: true
            }
        ]
        RolePolicy.create _role_policies
        p 'Finance policies created'
    end

    def create_call_center_policies
        _user_group_id = 5
        _role_policies = [
            {
                user_group_id: _user_group_id,
                service_id: 5, #Dashboard service
                service_policy_id: 8, #View dashboard
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
                service_policy_id: 12, #Reschedule booking
                status: true
            },
            {
                user_group_id: _user_group_id,
                service_id: 4, #Booking service
                service_policy_id: 14, #Cancel booking
                status: true
            }
        ]
        RolePolicy.create _role_policies
        p 'Call center policies created'
    end

    def create_corporate_admin_policies
        _user_group_id = 6
        _role_policies = [
            { 
                user_group_id: _user_group_id,
                service_id: 8, #Campaign service
                service_policy_id: 24, #View Campaign module
                status: true
            }
        ]
        RolePolicy.create _role_policies
        p 'Corporate admin policies created'
    end



end