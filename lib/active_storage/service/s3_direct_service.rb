require 'active_storage/service/s3_service'
require 'uri'

# Generate direct links (possibly to custom domain name) if AWS_HOSTNAME is set
# rubocop:disable Metrics/LineLength
class ActiveStorage::Service::S3DirectService < ActiveStorage::Service::S3Service
  private

  def public_url( key, ** )
    return object_for( key ).public_url if ENV['AWS_HOSTNAME'].blank?

    uri = URI( object_for( key ).public_url )
    "#{uri.scheme}://#{ENV['AWS_HOSTNAME']}/#{uri.path}"
  end
end
# rubocop:enable Metrics/LineLength
