# A module for creating a doubly linked list element with alternative next
# items. Slighly modified from what is seen in the presentation.
module HistoryStep
  attr_reader :previous, :next

  def initialize(*_)
    @previous   = self
    @next       = self
    @alternates = []
  end

  def alt_next_step
    @alternates << @next
    @next = @alternates.shift
  end

  def set_next(new_next_step)
    @alternates << @next unless @next == self

    new_next_step.set_previous(self)
    @next = new_next_step
  end

  def none_after?
    @next == self
  end

  def none_before?
    @previous == self
  end

  protected

  def set_previous(new_prev_step)
    @previous = new_prev_step
  end
end



# EmptyStep is needed at the start of a history chain because the
# first step will never have #perform_undo or #perform_redo called.
class EmptyStep
  include HistoryStep
end



class InsertStep
  include HistoryStep

  def initialize(start, content, buffer)
    super
    @buffer  = buffer
    @content = content
    @start   = start
    @length  = content.length
  end

  def perform_undo
    delete_content
  end

  def perform_redo
    insert_content
  end

  private

  def insert_content
    @buffer.insert!(@start, @content)
  end

  def delete_content
    @buffer.delete!(@start, @length)
  end
end



# A DeleteStep is the same as a InsertStep but
# #perform_undo and #perform_redo are swapped.
class DeleteStep < InsertStep
  def perform_undo
    insert_content
  end

  def perform_redo
    delete_content
  end
end
