class DeleteFreignKey < ActiveRecord::Migration[7.0]
  def change
    change_table :beers do |t|
      t.remove :style_id
    end
  end
end
