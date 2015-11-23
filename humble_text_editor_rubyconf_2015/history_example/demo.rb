require './history_steps.rb'
require './history.rb'
require './simple_buffer.rb'
require './editor.rb'

editor = Editor.new(SimpleBuffer.new)

# Perform a series of insertions and deletions.
editor.insert(0, 'hello')
      .insert(5, ' ')
      .insert(6, 'world')
      .delete(1, 3)
      .insert(2, 'wdy')

# Render the current state of the buffer.
puts "After a series of insertions and deletions:"
p editor.content
puts

# Undo twice then display the buffer content.
puts "Undo twice:"
p editor.undo_step
        .undo_step
        .content
puts

# Redo twice then display the buffer content.
puts "Redo twice:"
p editor.redo_step
        .redo_step
        .content
puts

# Perform an insertion after an undo, overwriting part of the history.
puts "Performing an edit midway through the history:"
p editor.undo_step
        .insert(2, 'la')
        .content
puts

# Recover what the last insertion overwrote by calling #undo_step
# followed by #alt_redo_step.
puts "Recovering the lost data:"
p editor.undo_step
        .alt_redo_step
        .content
puts

# Undo the previous recovery.
puts "Undo the recovery:"
p editor.undo_step
        .alt_redo_step
        .content
puts

# Undo past the start of the history to show that it will go to
# the first step in the history and then stop.
puts "Undoing past the start:"
p editor.undo_step.undo_step.undo_step.undo_step
        .undo_step.undo_step.undo_step.undo_step
        .content
puts

# Redo past the end of the history to show that it will go to
# the last step in the history and then stop.
puts "Undoing past the end:"
p editor.redo_step.redo_step.redo_step.redo_step
        .redo_step.redo_step.redo_step.redo_step
        .content
