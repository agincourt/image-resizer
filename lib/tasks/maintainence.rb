namespace :maintainence do
  desc "Wipe old images"
  task :cleanup => :environment do
    Asset.destroy_all(['created_at < ?', 7.days.ago])
  end
end