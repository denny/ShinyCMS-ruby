class ChangeCommentAuthorToPolymorphic < ActiveRecord::Migration[6.0]
  def change
    Comments.where( author_type: 'anonymous'    ).update_all!( author_type: nil             )
    Comments.where( author_type: 'pseudonymous' ).update_all!( author_type: 'CommentAuthor' )
    Comments.where( author_type: 'verified'     ).update_all!( author_type: 'User'          )

    Comments.where( author_type: 'CommentAuthor' ).each do |comment|
      author = CommentAuthor.create!(
        name: comment.author_name,
        website: comment.author_url,
      )
      comment.update!( author_id: author.id )

      if comment.author_email.present?
        author.email_recipient.create!(
          name: comment.author_name,
          email: comment.author_email
        )
      end
    end

    drop_column :comments, :author_name
    drop_column :comments, :author_email
    drop_column :comments, :author_url

    rename column :comments, :user_id, :author_id

    add_index :comments, [ :author_id, :author_type ]
  end
end
