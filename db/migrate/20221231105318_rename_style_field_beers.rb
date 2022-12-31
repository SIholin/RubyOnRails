class RenameStyleFieldBeers < ActiveRecord::Migration[7.0]
  def change
    change_table :beers do |s|
      s.rename :style, :old_style
    end
  end
end
