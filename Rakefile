require 'yard'

task :default => :test

task :test do
  Dir.glob('./test/*_test.rb').each { |file| require file }
end

YARD::Rake::YardocTask.new(:doc) do |task|
  task.files   = ['src/*.rb']
  task.options = ['-odocs']
end
