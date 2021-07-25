# File Upload to S3
This project is for uploading/deleting files (i.e images/pdf/videos) to AWS s3 bucket directly.

# Technologies
- Rails
- MongoDB ('mongoid', '~> 7.0.6')
- AWS s3
- jquery
- Bootstrap

Project revisions are managed in *upload_files* repository on public server with [GIT]( https://github.com/cbhushan20/Upload-Files.git ).

### Installation
File Upload requires:
- Ruby v-2.6.5  
- Rails v-6.0.2

Clone the git repository and install packages.
- $ git clone https://github.com/cbhushan20/Upload-Files.git
- $ cd upload_files
- $ bundle install

### Setup database.
 - rails g mongoid:config (to create mongoid.yml)
 - mongoid.yml (Add credential as per yours)
 - config/initializers/s3_credentials.rb (Add credential as per yours)
 - rails s

