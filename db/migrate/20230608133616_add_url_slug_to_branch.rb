class AddUrlSlugToBranch < ActiveRecord::Migration[7.0]
  def change
    add_column :branches, :url_slug, :string
  end
end
