class NonNullEbooksColumns < ActiveRecord::Migration[8.1]
  def up
    change_column_default :ebooks, :status, "draft"

    Ebook.where(title: nil).update_all(title: "")
    Ebook.where(year: nil).update_all(year: 0)
    Ebook.where(author: nil).update_all(author: "Unknown")
    Ebook.where(status: nil).update_all(status: "draft")

    change_column_null :ebooks, :title, false
    change_column_null :ebooks, :year, false
    change_column_null :ebooks, :author, false
    change_column_null :ebooks, :status, false
  end

  def down
    change_column_null :ebooks, :title, true
    change_column_null :ebooks, :year, true
    change_column_null :ebooks, :author, true
    change_column_null :ebooks, :status, true
    change_column_default :ebooks, :status, nil
  end
end
