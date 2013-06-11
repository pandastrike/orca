# Deploy Orca Website

#### Create a Configuration File

Inside the `web/` directory we need to create a configuration.json file
This file will be used by the Rake build:web task to build the website files

######  Example web/configuration.json file

```json
{
   "service":{
      "url":"http://orca1-lead1.pandastrike.com"
   }
}
```

#### Run the Rake Task

From the project root run `rake build:web`

#### Copy the Website Files

The Rake task will have created the website files in the `build/web` directory

Copy the files from the build/web directory to wherever you will host the website, such as an Amazon S3 bucket



