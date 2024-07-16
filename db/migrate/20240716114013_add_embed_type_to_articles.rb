class AddEmbedTypeToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :embed_type, :string
    rename_column :articles, :youtube_url, :embed_url
  end
end
