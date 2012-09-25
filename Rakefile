task :default => :test

task :test do
  sh "find test -name '*_test.coffee' | xargs ./node_modules/mocha/bin/mocha --compilers 'coffee:coffee-script'"
end

task :deps do
  sh "npm install ."
end
