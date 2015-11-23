# A class that wraps around the doubly linked list that stores the history,
# maintains a pointer to the current step, and orchestrates undos and redos.
class History
  def initialize
    @current_step = EmptyStep.new
  end

  def undo_step
    unless @current_step.none_before?
      @current_step.perform_undo
      @current_step = @current_step.previous
    end

    self
  end

  def redo_step
    unless @current_step.none_after?
      @current_step = @current_step.next
      @current_step.perform_redo
    end

    self
  end

  def alt_redo_step
    @current_step.alt_next_step
    redo_step
    self
  end

  def new_step(new_step)
    @current_step = @current_step.set_next(new_step)
    self
  end
end
