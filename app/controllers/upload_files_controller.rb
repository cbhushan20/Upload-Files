class UploadFilesController < ApplicationController
  require 'aws-sdk-s3'
  before_action :require_client, only: [:index, :destroy]
  before_action :require_resources, only: [:create]

  def index
    @files = Imagefile.all.as_json
    @files.each do |file|
      begin
        @s3_client.get_object(bucket: @bucket_name, key: file['file_name'])
        file['url'] = "https://uploadfilesfolders.s3.us-west-2.amazonaws.com/#{file['file_name']}"
      rescue Exception => ex
        next
      end
    end
  end

  def create
    begin
      file_path = params[:files]
      if file_path.is_a? Array
        file_path.each do |file|
          is_created = object_uploaded?(@s3_resources, @bucket_name, file)
          if is_created
            Imagefile.create(:file_name => file.original_filename)
          end
        end
      end
      redirect_to request.referer, :notice => "Upload Successfull!"
    rescue Exception => ex
      puts ex.to_s
      redirect_to request.referer, :error => "ooops! somethingwent wrong!"
    end
  end

  def destroy
    begin
      file_obj = Imagefile.find_by(:_id => params['id'])
      puts file_obj['file_name']
      object_deleted?(@s3_client, @bucket_name, file_obj['file_name'])
      file_obj.delete
      render :json => {:msg => 'Successfully deleted!'}
    rescue Exception => ex
      puts ex.to_s
      render :json => {:msg => 'something went wrong!'}
    end
  end

  private

  def object_uploaded?(s3_resource, bucket_name, file_path)
    object = s3_resource.bucket(bucket_name).object(file_path.original_filename)
    object.upload_file(file_path)
    return true
  rescue StandardError => e
    puts "Error uploading object: #{e.message}"
    return false
  end

  def object_deleted?(s3_client, bucket_name, object_key)
    s3_client.delete_object({bucket: bucket_name, key: object_key})
    return true
  rescue StandardError => e
    return false
  end

  def require_client
    @s3_client = Aws::S3::Client.new(
        region: REGION,
        access_key_id: ACCESS_KEY_ID,
        secret_access_key: SECRET_ACCESS_KEY
    )
    @bucket_name = BUCKET
  end

  def require_resources
    @s3_resources = Aws::S3::Resource.new(
        region: REGION,
        access_key_id: ACCESS_KEY_ID,
        secret_access_key: SECRET_ACCESS_KEY
    )
    @bucket_name = BUCKET
  end

  def upload_file_params
    params.permit(file_elements: [:files])
  end
end