
Blog.create!([
  {id: 1, name: "ShinyBlog", description: "", title: "The ShinySite Blog", slug: "shinysite", hidden_from_menu: false, hidden: false, user_id: @shiny_admin.id}
])

BlogPost.create!([
  {id: 1, title: "Demo content", slug: "demo-content", body: "<p>I&#39;m never sure what to do about demo content for ShinyCMS. The Perl version ended up with a weird mixture of content about the CMS, extracts from a book with suitably friendly licensing, and word salad from the Futurama Lorem Ipsum generator.</p>\r\n\r\n<p>Now here we are with the Ruby version, and apparently I haven&#39;t learned my lesson - so I&#39;m starting with content about the CMS again. Or in this case, meta-content.</p>\r\n", hidden: false, blog_id: 1, user_id: @shiny_admin.id, discussion_id: nil, posted_at: "2020-02-08 07:24:27", tag_list: nil}
])

Discussion.create!([
  {id: 1, resource_type: "BlogPost", resource_id: 1, locked: false, hidden: false}
])

Comment.create!([
  {id: 1, discussion_id: 1, number: 1, parent_id: nil, author_type: "authenticated", user_id: @shiny_admin.id, author_name: "", author_email: "", author_url: "", title: "Properly nested comments...", body: "Ask for them by name - do not accept inferior substitutes!", ip_address: nil, locked: false, hidden: false, spam: false, posted_at: "2020-02-28 18:56:25"},
  {id: 2, discussion_id: 1, number: 2, parent_id: nil, author_type: "pseudonymous", user_id: @shiny_admin.id, author_name: "ShinyCMS", author_email: "", author_url: "https://shinycms.org", title: "", body: "Yes, this is indeed a comment thread. The nested comments feature was added to ShinyCMS (Ruby version) in February 2020.\r\n\r\n(And to the Perl version in August 2010)", ip_address: nil, locked: false, hidden: false, spam: false, posted_at: "2020-02-28 19:02:46"},
  {id: 3, discussion_id: 1, number: 3, parent_id: 1, author_type: "anonymous", user_id: nil, author_name: "", author_email: "", author_url: "", title: "Nested comments FTW!", body: "", ip_address: nil, locked: false, hidden: false, spam: false, posted_at: "2020-02-28 19:03:55"},
  {id: 4, discussion_id: 1, number: 4, parent_id: 3, author_type: "authenticated", user_id: @shiny_admin.id, author_name: "", author_email: "", author_url: "", title: "I agree with this mysterious stranger! ;)", body: "Nested comments are the only acceptable form of comment system in the 21st century. Or the 20th, for that matter.", ip_address: nil, locked: false, hidden: false, spam: false, posted_at: "2020-02-28 19:08:52"}
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
  {id: 1, name: "Home page", description: "Homepage using Halcyonic index template", title: "Home", slug: "home", template_id: 1, section_id: nil, sort_order: 1, hidden_from_menu: true, hidden: false},
  {id: 4, name: "Left sidebar", description: "", title: "Left Sidebar", slug: "left-sidebar", template_id: 4, section_id: 1, sort_order: 1, hidden_from_menu: false, hidden: false},
  {id: 2, name: "One column", description: "", title: "One Column", slug: "one", template_id: 2, section_id: nil, sort_order: 2, hidden_from_menu: false, hidden: false},
  {id: 3, name: "Right sidebar", description: "", title: "Right Sidebar", slug: "right-sidebar", template_id: 3, section_id: 1, sort_order: 2, hidden_from_menu: false, hidden: false},
  {id: 5, name: "Three column", description: "", title: "Three Column", slug: "three", template_id: 5, section_id: nil, sort_order: 4, hidden_from_menu: false, hidden: false}
])

PageElement.create!([
  {id: 1, page_id: 1, name: "banner_text", content: "<p><a href=\"https://shinycms.org/\">ShinyCMS</a> is a free and open source content-management system. This <a href=\"http://github.com/denny/ShinyCMS-ruby\">new version</a> is built with <a href=\"https://www.ruby-lang.org/\">Ruby</a> on <a href=\"https://rubyonrails.org/\">Rails</a> (the <a href=\"https://github.com/denny/ShinyCMS\">original version</a> is built with <a href=\"https://www.perl.org/\">Perl</a> and <a href=\"http://www.catalystframework.org/\">Catalyst</a>).</p>\r\n", content_type: "HTML"},
  {id: 2, page_id: 1, name: "banner_button_url", content: "https://github.com/denny/ShinyCMS-ruby", content_type: "Short Text"},
  {id: 3, page_id: 1, name: "banner_button_text", content: "ShinyCMS on GitHub", content_type: "Short Text"},
  {id: 4, page_id: 1, name: "banner_image", content: "banner.png", content_type: "Image"},
  {id: 5, page_id: 1, name: "image1", content: "pic01.jpg", content_type: "Image"},
  {id: 6, page_id: 1, name: "heading1", content: "Pages", content_type: "Short Text"},
  {id: 7, page_id: 1, name: "paragraph1", content: "The most basic requirement of any CMS, editable pages... about 3/4 working now!", content_type: "Long Text"},
  {id: 8, page_id: 1, name: "image2", content: "pic02.jpg", content_type: "Image"},
  {id: 9, page_id: 1, name: "heading2", content: "Sections", content_type: "Short Text"},
  {id: 10, page_id: 1, name: "paragraph2", content: "You can put your pages into sections and subsections - as many as you need, nested to any depth. Or you can keep them all at the top level on smaller, simpler sites.", content_type: "Long Text"},
  {id: 11, page_id: 1, name: "image3", content: "pic03.jpg", content_type: "Image"},
  {id: 12, page_id: 1, name: "heading3", content: "Templates", content_type: "Short Text"},
  {id: 13, page_id: 1, name: "paragraph3", content: "Pages are based on templates, which define the way the page looks, and the areas\r\n      that can and can't be edited. This means that non-technical users can update\r\n      their website content easily and with confidence.", content_type: "Long Text"},
  {id: 14, page_id: 1, name: "image4", content: "pic04.jpg", content_type: "Image"},
  {id: 15, page_id: 1, name: "heading4", content: "Shared content", content_type: "Short Text"},
  {id: 16, page_id: 1, name: "paragraph4", content: "Shared content lets you define editable fragments of text and HTML that you       can re-use all through your site - for instance, your contact details at the       bottom of every page.", content_type: "Long Text"},
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
