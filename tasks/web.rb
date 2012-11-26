directory "build/web/js"
task "build:web:application" => "build/web/js"

directory "build/web"
task "build:web:pages" => "build/web"

task "build:web" => %w[
  build:web:application
  build:web:pages
  build:web:css
]

task "build:web:application" => %w[
  build/web/js/application.js
]

file "build/web/js/application.js" => FileList["cs/web/**/*"] do
  sh "ark package < web/manifest.json > build/web/js/application.js"
end


# NOTE: the FileList glob only gets coffee files from the one directory
# If we wish to use a nested structure, we'll need to modify this task
htmls = FileList["web/html/*.coffee"].map do |source|
  name = File.basename(source.chomp(".coffee"))
  pp destination = "build/web/#{name}.html"
  file destination => source do
    sh "coffee #{File.expand_path(source)} > #{destination}" 
  end
  destination
end

require "pp"

task "build:web:pages" => htmls

task "web:dependencies" do
  Dir.chdir "web/" do
    sh "npm install"
  end
end
