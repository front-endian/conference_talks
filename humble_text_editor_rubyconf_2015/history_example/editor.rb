# A wrapper that coordinates a buffer with a history of all insertions and
# deletions done on it, providing a clean interface for other objects to use.
class Editor
  def initialize(buffer)
    @buffer  = buffer
    @history = History.new
  end

  def insert(start, content)
    new_step(
      InsertStep,
      start,
      @buffer.insert!(start, content)
    )
  end

  def delete(start, length)
    new_step(
      DeleteStep,
      start,
      @buffer.delete!(start, length)
    )
  end

  def content
    @buffer.content
  end

  def undo_step
    @history.undo_step
    self
  end

  def redo_step
    @history.redo_step
    self
  end

  def alt_redo_step
    @history.alt_redo_step
    self
  end

  private

  def new_step(step_class, start, content)
    @history.new_step(
      step_class.new(start, content, @buffer)
    )

    self
  end
end
