

#### S3 Website: web/configuration.json
Relative to the root of the project
create web/configuration.json file
rake build
cd build/web/
s3cmd -P sync . s3://orca.pandastrike.com


