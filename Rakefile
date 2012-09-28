task :default => :test

desc "run tests"
task :test do
  sh "./node_modules/mocha/bin/mocha --recursive --compilers 'coffee:coffee-script'"
end

desc "download dependencies"
task :deps do
  sh "npm install ."
end
