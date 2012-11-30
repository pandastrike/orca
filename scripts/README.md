

#### S3 Website: web/configuration.json
Relative to the root of the project
create web/configuration.json file
rake build
cd build/web/
s3cmd -P sync . s3://orca.pandastrike.com

#### Install Configuration Files
./run.rb all shell install_orca_config_test.sh

