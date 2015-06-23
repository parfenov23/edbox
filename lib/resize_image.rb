class ResizeImage
  def self.crop(path)
    img = MiniMagick::Image.open(path)
    img.format "jpg"
    img = self.resize350(img)
    img_center = center(img, 256, 256)
    img.crop(img_center)
    img
  end

  def self.resize350(img)
    size = [img.width, img.height].min
    img_center = center(img, size, size)
    img.crop(img_center)
    img.resize('350x350')
  end

  def self.center(img, w, h)
    img_width = img[:width]
    img_height = img[:height]
    center_w = img_width/2
    center_h = img_height/2
    crop_w = center_w - (w/2)
    crop_h = center_h - (h/2)
    "#{w}x#{h}+#{crop_w}+#{crop_h}"
  end
end