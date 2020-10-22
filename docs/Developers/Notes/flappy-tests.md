# ShinyCMS

## Flappy tests

I'm seeing intermittent but recurring 404s in a few tests; they generally
don't recur when I run rspec again with the same seed.

For now I'm just making a note of the test output here, when I remember.

=====

Failures:

  1) Comment moderation PUT /admin/comment/1/hide hides the comment
     Failure/Error: expect( response      ).to     have_http_status :ok
       expected the response to have status code :ok (200) but it was :not_found (404)
     # ./spec/requests/admin/comments_spec.rb:131:in `block (3 levels) in <top (required)>'

Finished in 41.06 seconds (files took 2.47 seconds to load)
284 examples, 1 failure

Failed examples:

rspec ./spec/requests/admin/comments_spec.rb:125 # Comment moderation PUT /admin/comment/1/hide hides the comment

Randomized with seed 26338

=====

Failures:

  1) Comment moderation PUT /admin/comment/1/hide hides the comment
     Failure/Error: expect( response      ).to     have_http_status :ok
       expected the response to have status code :ok (200) but it was :not_found (404)
     # ./spec/requests/admin/comments_spec.rb:131:in `block (3 levels) in <top (required)>'

Finished in 35.11 seconds (files took 2.23 seconds to load)
285 examples, 1 failure

Failed examples:

rspec ./spec/requests/admin/comments_spec.rb:125 # Comment moderation PUT /admin/comment/1/hide hides the comment

Randomized with seed 33162

=====

Failures:

  1) Comment moderation PUT /admin/comment/1/hide hides the comment
     Failure/Error: expect( response      ).to     have_http_status :ok
       expected the response to have status code :ok (200) but it was :not_found (404)
     # ./spec/requests/admin/comments_spec.rb:131:in `block (3 levels) in <top (required)>'

Finished in 37.81 seconds (files took 2.33 seconds to load)
296 examples, 1 failure, 1 pending

Failed examples:

rspec ./spec/requests/admin/comments_spec.rb:125 # Comment moderation PUT /admin/comment/1/hide hides the comment

Randomized with seed 47403

=====

Failures:

  1) Comment moderation PUT /admin/comment/1/unhide unhides the comment
     Failure/Error: expect( response      ).to     have_http_status :ok
       expected the response to have status code :ok (200) but it was :not_found (404)
     # ./spec/requests/admin/comments_spec.rb:148:in `block (3 levels) in <top (required)>'

Finished in 34.82 seconds (files took 2.19 seconds to load)
284 examples, 1 failure

Failed examples:

rspec ./spec/requests/admin/comments_spec.rb:139 # Comment moderation PUT /admin/comment/1/unhide unhides the comment

Randomized with seed 44271

=====

Failures:

  1) Blog scopes can fetch the visible posts (not hidden, not future-dated)
     Failure/Error: expect( blog.posts.length ).to eq 1
     
       expected: 1
            got: 0
     
       (compared using ==)
     # ./spec/models/blog_spec.rb:21:in `block (3 levels) in <top (required)>'

Finished in 35.02 seconds (files took 2.24 seconds to load)
285 examples, 1 failure

Failed examples:

rspec ./spec/models/blog_spec.rb:15 # Blog scopes can fetch the visible posts (not hidden, not future-dated)

Randomized with seed 27241

=====

Failures:

  1) Blogs GET #recent returns a success response
     Failure/Error: expect( response.body ).to     have_css 'h2',      text: post2.title
       expected to find visible css "h2" with text "Highpoint" but there were no matches. Also found "\n      Now Look What You've Made Me Do\n    ", "\n            Recent Posts\n          ", "\n            Links\n          ", which matched the selector but not all filters. 
     # ./spec/requests/blogs_spec.rb:47:in `block (3 levels) in <top (required)>'

Finished in 49.17 seconds (files took 4.5 seconds to load)
296 examples, 1 failure, 1 pending

Failed examples:

rspec ./spec/requests/blogs_spec.rb:14 # Blogs GET #recent returns a success response

Randomized with seed 41103

=====

