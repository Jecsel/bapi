namespace :user_group do
    task create: :environment do
        _groups = [
            {
                name:"Admin"
            }
        ]
        UserGroup.create _groups
    end
end
