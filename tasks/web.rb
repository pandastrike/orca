task "clean" do
  rm_rf "build/web"
end

task "build" => "build:web"

directory "build/web/js"
directory "build/web/css"

task "build:web:pages" => "build/web"
task "build:web:css" => "build/web/css"
task "build:web:js" => "build/web/js"

task "build:web:application" => "build/web/js"
task "build:web:application" => "build/web/js/application.js"
task "build:web" => "web/configuration.json"

file "web/configuration.json" do
  puts "Build failed!"
  puts "You must create web/configuration.json"
  puts "Example:"
  puts File.read("config/examples/web_configuration.json")
  exit 1
end

task "build:web" => %w[
  build:web:js
  build:web:css
  build:web:application
  build:web:pages
]

task "build:web:js" => "build/web/js/jqplot.plugins.js"

js_files = %w[
  web/js/bootstrap.min.js
  web/js/jquery.jqplot.min.js
  ].map do |source|
  name = File.basename(source)
  destination = "build/web/js/#{name}"
  file destination => source do
    cp source, destination
  end
  destination
end

task "build:web:js" => js_files

css_files = FileList["web/css/*.css"].map do |source|
  name = File.basename(source)
  destination = "build/web/css/#{name}"
  file destination => source do
    cp source, destination
  end
  destination
end

task "build:web:css" => css_files

file "build/web/js/application.js" => FileList["web/**/*"] do
  sh "ark package < web/manifest.json > build/web/js/application.js"
end

plugins = %w[
  web/js/jqplot_plugins/jqplot.barRenderer.min.js
  web/js/jqplot_plugins/jqplot.categoryAxisRenderer.min.js
  web/js/jqplot_plugins/jqplot.pieRenderer.min.js
]
file "build/web/js/jqplot.plugins.js" => plugins do
  puts "Writing build/web/js/jqplot.plugins.js"
  File.open("build/web/js/jqplot.plugins.js", "w") do |destination|
    plugins.each do |file|
      string = File.read(file)
      destination.puts string
    end
  end
end

# NOTE: the FileList glob only gets coffee files from the one directory
# If we wish to use a nested structure, we'll need to modify this task
htmls = FileList["web/html/*.coffee"].map do |source|
  name = File.basename(source.chomp(".coffee"))
  destination = "build/web/#{name}.html"
  file destination => source do
    sh "coffee #{File.expand_path(source)} > #{destination}" 
  end
  destination
end

task "build:web:pages" => htmls

task "web:dependencies" do
  Dir.chdir "web/" do
    sh "npm install"
  end
end
