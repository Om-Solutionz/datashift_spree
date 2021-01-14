module DataShift

  class Downloader

    def initialize(file_name,download_file_name)
      @file_name = file_name
      @download_file_name = download_file_name
    end

    def save_to_directory
      preprare_directory
      file_io = File.read(@file_name)
      File.open(Rails.root.join('tmp', 'csv_uploads', @download_file_name), 'wb') do |file|
        file.write(file_io)
      end

    end

    def get_file_path
      Rails.root.join('tmp', 'csv_uploads',@download_file_name).to_s
    end

    def self.get_uploaded_file_names
      Dir.glob("#{Rails.root}/tmp/csv_uploads/**/*").map{ |s| File.basename(s) } rescue []
    end

    private

    def preprare_directory
      dir = Rails.root.join('tmp', 'csv_uploads')
      if Dir.exist?(dir)
        FileUtils.remove_dir(dir)
      end
      Dir.mkdir(dir)
    end

  end

end
