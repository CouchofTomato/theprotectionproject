class ChangeCategoryToBeIntegerInBenefits < ActiveRecord::Migration[6.0]
  def up
    change_column :benefits, :category, :integer, using: 'category::integer'
  end

  def down
    change_column :benefits, :category, :string
  end
end
