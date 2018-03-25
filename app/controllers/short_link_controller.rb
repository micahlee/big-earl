require 'webshot'
require 'fileutils'

class ShortLinkController < ApplicationController
  skip_before_action :verify_authenticity_token

  THUMBNAIL_DIR = 'thumbnails'.freeze

  def new
    @short_link = ShortLink.new
  end

  def create
    # Create the new short URL record and generate a unique
    # code for it
    @short_link = ShortLink.new safe_params
    @short_link.code = generate_code

    unless @short_link.save
      render 'new'
      return
    end

    generate_thumbnail @short_link.code

    # If the request is from the browser, redirect
    # to the preview page. Otherwise, respond with a
    # JSON document containing the short URL
    respond_to do |format|
      format.html do
        redirect_to short_link_preview_path @short_link.code
      end
      format.json do
        render json: { short_url: short_link_url(@short_link.code) }
      end
    end
  end

  def show
    @short_link = ShortLink.find_by(code: params[:code])
    not_found if @short_link.nil?

    # If the request is coming from an API client
    # respond with a JSON document containing
    # the full url and the preview url.
    # Otherwise redirect to the full url.
    respond_to do |format|
      format.html do
        redirect_to @short_link.url
      end
      format.json do
        render json: {
          redirect_to: @short_link.url,
          preview_url: short_link_preview_url(@short_link.code)
        }
      end
    end
  end

  def preview
    @short_link = ShortLink.find_by(code: params[:code])
    not_found if @short_link.nil?
  end

  def thumbnail
    @short_link = ShortLink.find_by(code: params[:code])
    not_found if @short_link.nil?

    filename = "#{THUMBNAIL_DIR}/#{@short_link.code}.png"
    filename = (File.exist?(filename) ? filename : 'public/no_preview.png')

    send_file filename, type: 'image/png', disposition: 'inline'
  end

  private

  def safe_params
    params.require(:short_link).permit(:url)
  end

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end

  def generate_code(desired_length = 4)
    length = desired_length
    begin
      # Generate a random alphabetic short code
      code = (0...length).map { ('a'..'z').to_a[rand(26)] }.join

      # Increment the length if a unique code is not found
      length += 1
    end while ShortLink.exists?(code: code)
    code
  end

  def generate_thumbnail(code)
    # Create thumbnail directory if it doesn't exist
    dirname = THUMBNAIL_DIR
    FileUtils.mkdir_p(dirname) unless File.directory?(dirname)

    # Fetch a snapshot of webpage
    filename = "#{dirname}/#{@short_link.code}.png"
    ws = Webshot::Screenshot.instance
    ws.capture @short_link.url, filename, width: 800, height: 500, timeout: 2

  rescue StandardError => e
    puts "Failed to generate thumbnail for #{code}: #{e.message}"
  end
end
