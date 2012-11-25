directory "build/web/js"
task "build:web:application" => "build/web/js"

directory "build/web/html"
task "build:web:pages" => "build/web/html"

task "build:web" => %w[
  build:web:application
  build:web:pages
]

task "build:web:application" => %w[
  build/web/js/application.js
]

file "build/web/js/application.js" => FileList["cs/web/**/*"] do
  sh "ark package < web/manifest.json > build/web/js/application.js"
end


# NOTE: the FileList glob only gets coffee files from the one directory
# If we wish to use a nested structure, we'll need to modify this task
task "build:web:pages" => FileList["web/html/*.coffee"].map do |source|
  destination = "build/web/#{source.chomp('.coffee')}.html"
  file destination => source do
    sh "bin/page #{File.expand_path source} > #{destination}" 
  end
  destination
end

task "web:dependencies" do
  Dir.chdir "web/" do
    sh "npm install"
  end
end
