# A very naive implementation of an edit buffer.
class SimpleBuffer
  attr_reader :content

  def initialize(string = '')
    @content = string
  end

  def insert!(start, content)
    @content.insert(start, content)
    content
  end

  def delete!(start, length)
    @content.slice!(start, length)
  end
end
