# Copyright:: (c) Autotelik B.V 2020
# Author ::   Tom Statter
# License::   MIT
#
# Details::   Specific support for Loading Spree data
#
module DatashiftSpree

  class ImagePopulator < ::DataShift::Populator

    include DataShift::ImageLoading

    # Global path to prefix to load paths coming from import data
    attr_accessor :image_path_prefix

    def initialize(image_path_prefix: nil)
      @image_path_prefix = image_path_prefix
    end
    # If no owner class specified will attach Image to Spree image Owner (varies depending on version)
    #
    # Special case for Images
    #
    # A list of entries for Images.
    #
    # Multiple image items can be delimited by multi_assoc_delim
    #
    # Each item can  contain optional attributes for the Image class within {}. 
    # 
    # For example to supply the optional 'alt' text, or position for an image
    #
    #   Example => path_1{:alt => text}|path_2{:alt => more alt blah blah,
    # :position => 5}|path_3{:alt => the alt text for this path}
    #
    def call(load_data, record, owner = nil )

      owner ||=  record.is_a?(Spree::Product) ? record.master : record

      load_data.to_s.split(multi_assoc_delim).each do |image|

        begin
          image_url = image
          filename  = File.basename(URI.parse(image_url).path)
          file      = URI.open(image_url)
          new_image = record.images.new
          new_image.attachment.attach(io: file, filename: filename)
          new_image.save(validate: false)
          # owner.images << attachment
          logger.debug("Product assigned Image from : #{image_url}")
        rescue => e
          logger.error("Failed to assign attachment to #{owner.class} #{owner.id}")
          logger.error(e.message)
        end

      end
    end
  end
end
