namespace :branch do
  task update_url_slug: :environment do
    Branch.all.each(&:save)
    puts 'All branches url_slug updated'
  end
end
