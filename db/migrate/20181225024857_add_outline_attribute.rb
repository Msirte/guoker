class AddOutlineAttribute < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :outline, :text, :default => "本课程暂无大纲"
  end
end