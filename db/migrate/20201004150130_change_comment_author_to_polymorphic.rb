class ChangeCommentAuthorToPolymorphic < ActiveRecord::Migration[6.0]
  def change
    Comment.where( author_type: 'anonymous'    ).update_all( author_type: nil             )
    Comment.where( author_type: 'pseudonymous' ).update_all( author_type: 'CommentAuthor' )
    Comment.where( author_type: 'verified'     ).update_all( author_type: 'User'          )

    Comment.where( author_type: 'CommentAuthor' ).each do |comment|
      author = CommentAuthor.create!(
        name: comment.author_name,
        website: comment.author_url,
        ip_address: comment.ip_address
      )
      comment.update!( user_id: author.id )

      if comment.author_email.present?
        author.email_recipient.create!(
          name: comment.author_name,
          email: comment.author_email
        )
      end
    end

    remove_column :comments, :author_name
    remove_column :comments, :author_email
    remove_column :comments, :author_url

    rename_column :comments, :user_id, :author_id

    add_index :comments, [ :author_id, :author_type ]
  end
end
