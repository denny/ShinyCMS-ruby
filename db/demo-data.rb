
Blog.create!([
  {id: 1, name: "ShinyBlog", description: "", title: "The ShinySite Blog", slug: "shinysite", hidden_from_menu: false, hidden: false, user_id: @shiny_admin.id}
])

BlogPost.create!([
  {id: 1, title: "Demo content", slug: "demo-content", body: "<p>I&#39;m never sure what to do about demo content for ShinyCMS. The Perl version ended up with a weird mixture of content about the CMS, extracts from a book with suitably friendly licensing, and word salad from the Futurama Lorem Ipsum generator.</p>\r\n\r\n<p>Now here we are with the Ruby version, and apparently I haven&#39;t learned my lesson - so I&#39;m starting with content about the CMS again. Or in this case, meta-content.</p>\r\n", hidden: false, blog_id: 1, user_id: @shiny_admin.id, discussion_id: nil, posted_at: "2020-02-08 07:24:27", tag_list: nil},
  {id: 2, title: "Homepage updates", slug: "updates", body: "<p>I&#39;m not feeling very well this week - I don&#39;t think I&#39;ve got the dreaded corona virus, I&#39;m not coughing, but I&#39;m extremely wiped out. So, instead of tackling anything too brain-taxing in the odd bit of time I do feel up to looking at personal projects, I&#39;m just updating the demo site content a bit - specifically, I&#39;m updating the &#39;features&#39; block on the homepage, including making some screenshots.</p>\r\n\r\n<p>I thought there should probably be more than one post in the blog feature screenshot, so ... here we are ;)</p>\r\n", hidden: false, blog_id: 1, user_id: @shiny_admin.id, discussion_id: nil, posted_at: "2020-06-05 01:03:47", tag_list: nil}
])

NewsPost.create!([
  {id: 1, title: "No news is good news?", slug: "no-news", body: "Insert imaginative demo content here...", hidden: false, user_id: @shiny_admin.id, discussion_id: nil, posted_at: "2020-05-14 14:06:33", tag_list: nil}
])

Discussion.create!([
  {id: 1, resource_type: "BlogPost", resource_id: 1, locked: false, hidden: false},
  {id: 2, resource_type: "BlogPost", resource_id: 2, locked: false, hidden: false}
])

Comment.create!([
  {id: 1, discussion_id: 1, number: 1, parent_id: nil, author_type: "authenticated", user_id: @shiny_admin.id, author_name: "", author_email: "", author_url: "", title: "Properly nested comments...", body: "Ask for them by name - do not accept inferior substitutes!", ip_address: nil, locked: false, hidden: false, spam: false, posted_at: "2020-02-28 18:56:25"},
  {id: 2, discussion_id: 1, number: 2, parent_id: nil, author_type: "pseudonymous", user_id: @shiny_admin.id, author_name: "ShinyCMS", author_email: "", author_url: "https://shinycms.org", title: "", body: "Yes, this is indeed a comment thread. The nested comments feature was added to ShinyCMS (Ruby version) in February 2020.\r\n\r\n(And to the Perl version in August 2010)", ip_address: nil, locked: false, hidden: false, spam: false, posted_at: "2020-02-28 19:02:46"},
  {id: 3, discussion_id: 1, number: 3, parent_id: 1, author_type: "anonymous", user_id: nil, author_name: "", author_email: "", author_url: "", title: "Nested comments FTW!", body: "", ip_address: nil, locked: true, hidden: false, spam: false, posted_at: "2020-02-28 19:03:55"},
  {id: 4, discussion_id: 1, number: 4, parent_id: 3, author_type: "authenticated", user_id: @shiny_admin.id, author_name: "", author_email: "", author_url: "", title: "I agree with this mysterious stranger! ;)", body: "Nested comments are the only acceptable form of comment system in the 21st century. Or the 20th, for that matter.", ip_address: nil, locked: false, hidden: true, spam: false, posted_at: "2020-02-28 19:08:52"},
  {id: 5, discussion_id: 2, number: 1, parent_id: nil, author_type: "anonymous", user_id: nil, author_name: nil, author_email: nil, author_url: nil, title: "BEST BITCOIN ADVICE", body: "Prey on the misfortunate of others in the coolest ponzi scheme ever to sweep the Internet!!", ip_address: nil, locked: false, hidden: false, spam: true, posted_at: "2020-06-05 01:23:13"},
  {id: 6, discussion_id: 2, number: 2, parent_id: nil, author_type: "pseudonymous", user_id: nil, author_name: "Pill Pusher", author_email: nil, author_url: nil, title: nil, body: "Rise to every occasion with our bargain blue diamonds!", ip_address: nil, locked: false, hidden: false, spam: true, posted_at: "2020-06-05 22:56:48"},
  {id: 7, discussion_id: 2, number: 3, parent_id: nil, author_type: "pseudonymous", user_id: nil, author_name: "lorembomb", author_email: nil, author_url: nil, title: nil, body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Curabitur pretium tincidunt lacus. Nulla gravida orci a odio. Nullam varius, turpis et commodo pharetra, est eros bibendum elit, nec luctus magna felis sollicitudin mauris. Integer in mauris eu nibh euismod gravida. Duis ac tellus et risus vulputate vehicula. Donec lobortis risus a elit. Etiam tempor. Ut ullamcorper, ligula eu tempor congue, eros est euismod turpis, id tincidunt sapien risus a quam. Maecenas fermentum consequat mi. Donec fermentum. Pellentesque malesuada nulla a mi. Duis sapien sem, aliquet nec, commodo eget, consequat quis, neque. Aliquam faucibus, elit ut dictum aliquet, felis nisl adipiscing sapien, sed malesuada diam lacus eget erat. Cras mollis scelerisque nunc. Nullam arcu. Aliquam consequat. Curabitur augue lorem, dapibus quis, laoreet et, pretium ac, nisi. Aenean magna nisl, mollis quis, molestie eu, feugiat in, orci. In hac habitasse platea dictumst.", ip_address: nil, locked: false, hidden: false, spam: true, posted_at: "2020-06-05 23:01:17"}
])

PageTemplate.create!([
  {id: 1, name: "Index", description: "Home-page layout from the Halcyonic theme", filename: "index"},
  {id: 2, name: "No sidebar", description: "Single-column layout from the Halcyonic theme", filename: "no-sidebar"},
  {id: 3, name: "Right sidebar", description: "Two column layout (with sidebar on right) from the Halcyonic theme", filename: "right-sidebar"},
  {id: 4, name: "Left sidebar", description: "Two column layout (with sidebar on left) from the Halcyonic theme", filename: "left-sidebar"},
  {id: 5, name: "Double sidebar", description: "Three column layout (sidebars on both sides) from the Halcyonic theme", filename: "double-sidebar"}
])

PageTemplateElement.create!([
  {id: 1, template_id: 1, name: "banner_text", content: "", content_type: "HTML"},
  {id: 2, template_id: 1, name: "banner_button_url", content: "", content_type: "Short Text"},
  {id: 3, template_id: 1, name: "banner_button_text", content: "", content_type: "Short Text"},
  {id: 4, template_id: 1, name: "banner_image", content: "", content_type: "Image"},
  {id: 5, template_id: 1, name: "image1", content: "", content_type: "Image"},
  {id: 6, template_id: 1, name: "heading1", content: "", content_type: "Short Text"},
  {id: 7, template_id: 1, name: "paragraph1", content: "", content_type: "Long Text"},
  {id: 8, template_id: 1, name: "image2", content: "", content_type: "Image"},
  {id: 9, template_id: 1, name: "heading2", content: "", content_type: "Short Text"},
  {id: 10, template_id: 1, name: "paragraph2", content: "", content_type: "Long Text"},
  {id: 11, template_id: 1, name: "image3", content: "", content_type: "Image"},
  {id: 12, template_id: 1, name: "heading3", content: "", content_type: "Short Text"},
  {id: 13, template_id: 1, name: "paragraph3", content: "", content_type: "Long Text"},
  {id: 14, template_id: 1, name: "image4", content: "", content_type: "Image"},
  {id: 15, template_id: 1, name: "heading4", content: "", content_type: "Short Text"},
  {id: 16, template_id: 1, name: "paragraph4", content: "", content_type: "Long Text"},
  {id: 17, template_id: 1, name: "image5", content: "", content_type: "Image"},
  {id: 18, template_id: 1, name: "image6", content: "", content_type: "Image"},
  {id: 19, template_id: 1, name: "image7", content: "", content_type: "Image"},
  {id: 20, template_id: 1, name: "image8", content: "", content_type: "Image"},
  {id: 21, template_id: 2, name: "heading", content: nil, content_type: "Short Text"},
  {id: 22, template_id: 2, name: "subheading", content: nil, content_type: "Short Text"},
  {id: 23, template_id: 2, name: "text_content", content: nil, content_type: "Long Text"},
  {id: 24, template_id: 3, name: "heading", content: nil, content_type: "Short Text"},
  {id: 25, template_id: 3, name: "subheading", content: nil, content_type: "Short Text"},
  {id: 26, template_id: 3, name: "text_content", content: nil, content_type: "Long Text"},
  {id: 27, template_id: 4, name: "heading", content: nil, content_type: "Short Text"},
  {id: 28, template_id: 4, name: "subheading", content: nil, content_type: "Short Text"},
  {id: 29, template_id: 4, name: "text_content", content: nil, content_type: "Long Text"},
  {id: 30, template_id: 5, name: "heading", content: nil, content_type: "Short Text"},
  {id: 31, template_id: 5, name: "subheading", content: nil, content_type: "Short Text"},
  {id: 32, template_id: 5, name: "text_content", content: nil, content_type: "Long Text"}
])

PageSection.create!([
  {id: 1, name: "Two column", description: "", title: "Two Column", slug: "two", default_page_id: nil, section_id: nil, sort_order: 3, hidden_from_menu: false, hidden: false}
])

Page.create!([
  {id: 1, name: "Home", description: "Demo site home page - uses Halcyonic index template", title: "ShinyCMS Demo", slug: "home", template_id: 1, section_id: nil, sort_order: 1, hidden_from_menu: true, hidden: false},
  {id: 2, name: "One column", description: "", title: "One Column", slug: "one", template_id: 2, section_id: nil, sort_order: 2, hidden_from_menu: false, hidden: false},
  {id: 3, name: "Right sidebar", description: "", title: "Right Sidebar", slug: "right-sidebar", template_id: 3, section_id: 1, sort_order: 2, hidden_from_menu: false, hidden: false},
  {id: 4, name: "Left sidebar", description: "", title: "Left Sidebar", slug: "left-sidebar", template_id: 4, section_id: 1, sort_order: 1, hidden_from_menu: false, hidden: false},
  {id: 5, name: "Three column", description: "", title: "Three Column", slug: "three", template_id: 5, section_id: nil, sort_order: 4, hidden_from_menu: false, hidden: false}
])

PageElement.create!([
  {id: 1, page_id: 1, name: "banner_text", content: "<p><a href=\"https://shinycms.org/\">ShinyCMS</a> is a free and open source content-management system. This <a href=\"http://github.com/denny/ShinyCMS-ruby\">new version</a> is built with <a href=\"https://www.ruby-lang.org/\">Ruby</a> on <a href=\"https://rubyonrails.org/\">Rails</a> (the <a href=\"https://github.com/denny/ShinyCMS\">original version</a> is built with <a href=\"https://www.perl.org/\">Perl</a> and <a href=\"http://www.catalystframework.org/\">Catalyst</a>).</p>\r\n", content_type: "HTML"},
  {id: 2, page_id: 1, name: "banner_button_url", content: "https://github.com/denny/ShinyCMS-ruby", content_type: "Short Text"},
  {id: 3, page_id: 1, name: "banner_button_text", content: "ShinyCMS on GitHub", content_type: "Short Text"},
  {id: 4, page_id: 1, name: "banner_image", content: "banner.png", content_type: "Image"},
  {id: 5, page_id: 1, name: "image1", content: "pages.png", content_type: "Image"},
  {id: 6, page_id: 1, name: "heading1", content: "Pages", content_type: "Short Text"},
  {id: 7, page_id: 1, name: "paragraph1", content: "Template-drive brochure pages with a simple, easy to use admin interface - safely edit the content areas without any risk of disturbing the page layout. Can be organised into nested sections for larger, more complicated sites.", content_type: "Long Text"},
  {id: 8, page_id: 1, name: "image2", content: "blog.png", content_type: "Image"},
  {id: 9, page_id: 1, name: "heading2", content: "Blog", content_type: "Short Text"},
  {id: 10, page_id: 1, name: "paragraph2", content: "Add posts now, backdate them, or schedule them to appear in the future. Hide/show/edit/delete posts. Decide whether to allow/disable discussion feature (comments) by default, overridable on a per-post basis.", content_type: "Long Text"},
  {id: 11, page_id: 1, name: "image3", content: "nested-comments.png", content_type: "Image"},
  {id: 12, page_id: 1, name: "heading3", content: "Discussions / Comments", content_type: "Short Text"},
  {id: 13, page_id: 1, name: "paragraph3", content: "Currently enabled on blog posts and news posts, but can be added to any type of content. Show/hide and lock/unlock whole discussions or individual comments.", content_type: "Long Text"},
  {id: 14, page_id: 1, name: "image4", content: "spam-comment-moderation.png", content_type: "Image"},
  {id: 15, page_id: 1, name: "heading4", content: "Anti-spam features", content_type: "Short Text"},
  {id: 16, page_id: 1, name: "paragraph4", content: "Uses reCAPTCHA to detect and block bots. Uses Akismet to flag and hide potential spam comments. Moderation queue for flagged comments, with decisions fed back to Akismet to improve their accuracy.", content_type: "Long Text"},
  {id: 17, page_id: 1, name: "image5", content: "pic05.jpg", content_type: "Image"},
  {id: 18, page_id: 1, name: "image6", content: "pic06.jpg", content_type: "Image"},
  {id: 19, page_id: 1, name: "image7", content: "pic07.jpg", content_type: "Image"},
  {id: 20, page_id: 1, name: "image8", content: "pic08.jpg", content_type: "Image"},
  {id: 21, page_id: 2, name: "heading", content: "", content_type: "Short Text"},
  {id: 22, page_id: 2, name: "subheading", content: "", content_type: "Short Text"},
  {id: 23, page_id: 2, name: "text_content", content: "", content_type: "Long Text"},
  {id: 24, page_id: 3, name: "heading", content: "", content_type: "Short Text"},
  {id: 25, page_id: 3, name: "subheading", content: "", content_type: "Short Text"},
  {id: 26, page_id: 3, name: "text_content", content: "", content_type: "Long Text"},
  {id: 27, page_id: 4, name: "heading", content: "", content_type: "Short Text"},
  {id: 28, page_id: 4, name: "subheading", content: "", content_type: "Short Text"},
  {id: 29, page_id: 4, name: "text_content", content: "", content_type: "Long Text"},
  {id: 30, page_id: 5, name: "heading", content: "", content_type: "Short Text"},
  {id: 31, page_id: 5, name: "subheading", content: "", content_type: "Short Text"},
  {id: 32, page_id: 5, name: "text_content", content: "", content_type: "Long Text"}
])
