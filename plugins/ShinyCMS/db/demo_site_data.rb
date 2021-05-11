ShinyBlog::Post.create!([
  {id: 1, title: "Demo content", slug: "demo-content", body: "<p>I&#39;m never sure what to do about demo content for ShinyCMS. The Perl version ended up with a weird mixture of content about the CMS, extracts from a book with suitably friendly licensing, and word salad from the Futurama Lorem Ipsum generator.</p>\r\n\r\n<p>Now here we are with the Ruby version, and apparently I haven&#39;t learned my lesson - so I&#39;m starting with content about the CMS again. Or in this case, meta-content.</p>\r\n", show_on_site: true, user_id: @shiny_admin.id, posted_at: "2020-02-08 07:24:27", deleted_at: nil},
  {id: 2, title: "Homepage updates", slug: "updates", body: "<p>I&#39;m not feeling very well this week - I don&#39;t think I&#39;ve got the dreaded corona virus, I&#39;m not coughing, but I&#39;m extremely wiped out. So, instead of tackling anything too brain-taxing in the odd bit of time I do feel up to looking at personal projects, I&#39;m just updating the demo site content a bit - specifically, I&#39;m updating the &#39;features&#39; block on the homepage, including making some screenshots.</p>\r\n\r\n<p>I thought there should probably be more than one post in the blog feature screenshot, so ... here we are ;)</p>\r\n", show_on_site: true, user_id: @shiny_admin.id, posted_at: "2020-06-05 01:03:47", deleted_at: nil}
])
ShinyCMS::ConsentVersion.create!([
  {id: 2, name: "Newsletter subscription (3rd September 2020)", slug: "newsletter-2020-09-03", display_text: "Your ideas are intriguing to me, and I wish to subscribe to your newsletter.", admin_notes: "Consent text for the homepage newsletter subscribe form (part of the demo site data).", deleted_at: nil}
])
ShinyForms::Form.create!([
  {id: 1, internal_name: "Contact Page", public_name: "Contact us", slug: "contact", description: nil, handler: "send_plain_email", email_to: nil, filename: nil, use_recaptcha: true, use_akismet: true, success_message: nil, redirect_to: nil, deleted_at: nil}
])
ShinyLists::List.create!([
  {id: 1, internal_name: "Newsletter list", public_name: "Monthly newsletter", slug: "newsletter", description: "", deleted_at: nil}
])
ShinyNews::Post.create!([
  {id: 1, title: "No news is good news?", slug: "no-news", body: "<p>Insert imaginative demo content here...</p>\r\n", show_on_site: true, user_id: @shiny_admin.id, posted_at: "2020-05-14 14:06:33", deleted_at: nil}
])
ShinyNewsletters::Template.create!([
  {id: 1, name: "Monthly newsletter", description: "Template for our monthly newsletter", filename: "an_example", deleted_at: nil}
])
ShinyPages::Section.create!([
  {id: 1, internal_name: "Halcyonic layout samples", public_name: "Halcyonic Theme", slug: "sample-page-layouts", description: "These are the page layouts provided by the Halcyonic theme", position: 3, show_in_menus: true, show_on_site: true, section_id: nil, default_page_id: nil, deleted_at: nil},
  {id: 2, internal_name: "Single sidebar", public_name: "", slug: "single", description: "To the left, or to the right?", position: 5, show_in_menus: true, show_on_site: true, section_id: 1, default_page_id: nil, deleted_at: nil}
])
ShinyPages::Template.create!([
  {id: 1, name: "Index", description: "Home-page layout from the Halcyonic theme", filename: "index", deleted_at: nil},
  {id: 2, name: "No sidebar", description: "Single-column layout from the Halcyonic theme", filename: "no-sidebar", deleted_at: nil},
  {id: 3, name: "Right sidebar", description: "Two column layout (with sidebar on right) from the Halcyonic theme", filename: "right-sidebar", deleted_at: nil},
  {id: 4, name: "Left sidebar", description: "Two column layout (with sidebar on left) from the Halcyonic theme", filename: "left-sidebar", deleted_at: nil},
  {id: 5, name: "Double sidebar", description: "Three column layout (sidebars on both sides) from the Halcyonic theme", filename: "double-sidebar", deleted_at: nil},
  {id: 6, name: "Contact form", description: "", filename: "contact-form", deleted_at: nil}
])
ShinyProfiles::Profile.create!([
  {id: 1, public_name: nil, public_email: nil, bio: nil, location: nil, postcode: nil, show_on_site: true, show_in_gallery: true, show_to_unauthenticated: false, user_id: @shiny_admin.id, deleted_at: nil}
])
ShinyCMS::PseudonymousAuthor.create!([
  {id: 1, name: "ShinyCMS", url: "https://shinycms.org", ip_address: "127.0.0.1", token: "6cfe74c8-5e99-4589-9430-ac0b70e7ec1f", email_recipient_id: nil, deleted_at: nil},
  {id: 2, name: "Pill Pusher", url: "http://spammy.website", ip_address: "127.0.0.1", token: "6de0eecc-8b3d-44ba-aee5-0e9ccbd42006", email_recipient_id: nil, deleted_at: nil},
  {id: 3, name: "Lorem Long", url: "", ip_address: "127.0.0.1", token: "99b0c809-899e-4394-8c62-92e520e51985", email_recipient_id: nil, deleted_at: nil}
])
ShinyNewsletters::TemplateElement.create!([
  {id: 1, name: "a_heading", content: "The ShinyCMS Newsletter!", element_type: "short_text", position: 1, template_id: 1, deleted_at: nil},
  {id: 2, name: "top_image", content: "", element_type: "image", position: 2, template_id: 1, deleted_at: nil},
  {id: 3, name: "top_alt_text", content: "", element_type: "short_text", position: 3, template_id: 1, deleted_at: nil},
  {id: 4, name: "top_title_text", content: "", element_type: "short_text", position: 4, template_id: 1, deleted_at: nil},
  {id: 5, name: "some_longer_text", content: "", element_type: "long_text", position: 5, template_id: 1, deleted_at: nil}
])
ShinyPages::TemplateElement.create!([
  {id: 1, name: "banner_text", content: "", element_type: "html", position: 1, template_id: 1, deleted_at: nil},
  {id: 2, name: "banner_button_url", content: "", element_type: "short_text", position: 2, template_id: 1, deleted_at: nil},
  {id: 3, name: "banner_button_text", content: "", element_type: "short_text", position: 3, template_id: 1, deleted_at: nil},
  {id: 4, name: "banner_image", content: "", element_type: "image", position: 4, template_id: 1, deleted_at: nil},
  {id: 21, name: "heading", content: nil, element_type: "short_text", position: 1, template_id: 2, deleted_at: nil},
  {id: 22, name: "subheading", content: nil, element_type: "short_text", position: 2, template_id: 2, deleted_at: nil},
  {id: 23, name: "text_content", content: nil, element_type: "long_text", position: 3, template_id: 2, deleted_at: nil},
  {id: 24, name: "heading", content: nil, element_type: "short_text", position: 1, template_id: 3, deleted_at: nil},
  {id: 25, name: "subheading", content: nil, element_type: "short_text", position: 2, template_id: 3, deleted_at: nil},
  {id: 26, name: "text_content", content: nil, element_type: "long_text", position: 3, template_id: 3, deleted_at: nil},
  {id: 27, name: "heading", content: nil, element_type: "short_text", position: 1, template_id: 4, deleted_at: nil},
  {id: 28, name: "subheading", content: nil, element_type: "short_text", position: 2, template_id: 4, deleted_at: nil},
  {id: 29, name: "text_content", content: nil, element_type: "long_text", position: 3, template_id: 4, deleted_at: nil},
  {id: 30, name: "heading", content: nil, element_type: "short_text", position: 1, template_id: 5, deleted_at: nil},
  {id: 31, name: "subheading", content: nil, element_type: "short_text", position: 2, template_id: 5, deleted_at: nil},
  {id: 32, name: "text_content", content: nil, element_type: "long_text", position: 3, template_id: 5, deleted_at: nil},
  {id: 20, name: "image8", content: "", element_type: "image", position: 28, template_id: 1, deleted_at: nil},
  {id: 9, name: "heading2", content: "", element_type: "short_text", position: 12, template_id: 1, deleted_at: nil},
  {id: 5, name: "image1", content: "", element_type: "image", position: 6, template_id: 1, deleted_at: nil},
  {id: 10, name: "paragraph2", content: "", element_type: "long_text", position: 13, template_id: 1, deleted_at: nil},
  {id: 11, name: "image3", content: "", element_type: "image", position: 14, template_id: 1, deleted_at: nil},
  {id: 33, name: "banner_img_alt", content: "", element_type: "short_text", position: 5, template_id: 1, deleted_at: nil},
  {id: 34, name: "img1_alt", content: "", element_type: "short_text", position: 7, template_id: 1, deleted_at: nil},
  {id: 36, name: "img2_alt", content: "", element_type: "short_text", position: 11, template_id: 1, deleted_at: nil},
  {id: 37, name: "img3_alt", content: "", element_type: "short_text", position: 15, template_id: 1, deleted_at: nil},
  {id: 38, name: "img4_alt", content: "", element_type: "short_text", position: 19, template_id: 1, deleted_at: nil},
  {id: 39, name: "img5_alt", content: "", element_type: "short_text", position: 23, template_id: 1, deleted_at: nil},
  {id: 40, name: "img6_alt", content: "", element_type: "short_text", position: 25, template_id: 1, deleted_at: nil},
  {id: 41, name: "img7_alt", content: "", element_type: "short_text", position: 26, template_id: 1, deleted_at: nil},
  {id: 12, name: "heading3", content: "", element_type: "short_text", position: 16, template_id: 1, deleted_at: nil},
  {id: 13, name: "paragraph3", content: "", element_type: "long_text", position: 17, template_id: 1, deleted_at: nil},
  {id: 14, name: "image4", content: "", element_type: "image", position: 18, template_id: 1, deleted_at: nil},
  {id: 6, name: "heading1", content: "", element_type: "short_text", position: 8, template_id: 1, deleted_at: nil},
  {id: 7, name: "paragraph1", content: "", element_type: "long_text", position: 9, template_id: 1, deleted_at: nil},
  {id: 8, name: "image2", content: "", element_type: "image", position: 10, template_id: 1, deleted_at: nil},
  {id: 42, name: "img8_alt", content: "", element_type: "short_text", position: 29, template_id: 1, deleted_at: nil},
  {id: 15, name: "heading4", content: "", element_type: "short_text", position: 20, template_id: 1, deleted_at: nil},
  {id: 16, name: "paragraph4", content: "", element_type: "long_text", position: 21, template_id: 1, deleted_at: nil},
  {id: 17, name: "image5", content: "", element_type: "image", position: 22, template_id: 1, deleted_at: nil},
  {id: 18, name: "image6", content: "", element_type: "image", position: 24, template_id: 1, deleted_at: nil},
  {id: 19, name: "image7", content: "", element_type: "image", position: 26, template_id: 1, deleted_at: nil}
])
ShinyNewsletters::Edition.create!([
  {id: 1, internal_name: "First Post", public_name: "", slug: "first", description: "Our first newsletter!", from_name: nil, from_email: nil, subject: nil, show_on_site: true, template_id: 1, published_at: nil, deleted_at: nil}
])
ShinyPages::Page.create!([
  {id: 1, internal_name: "Home", public_name: "ShinyCMS Demo", slug: "home", description: "Demo site home page - uses Halcyonic index template", position: 1, show_in_menus: false, show_on_site: true, section_id: nil, template_id: 1, deleted_at: nil},
  {id: 2, internal_name: "No sidebar", public_name: "", slug: "none", description: "", position: 3, show_in_menus: true, show_on_site: true, section_id: 1, template_id: 2, deleted_at: nil},
  {id: 3, internal_name: "Right sidebar", public_name: "", slug: "right", description: "", position: 6, show_in_menus: true, show_on_site: true, section_id: 2, template_id: 3, deleted_at: nil},
  {id: 4, internal_name: "Left sidebar", public_name: "", slug: "left", description: "", position: 5, show_in_menus: true, show_on_site: true, section_id: 2, template_id: 4, deleted_at: nil},
  {id: 5, internal_name: "Double sidebar", public_name: "", slug: "double", description: "Embrace the healing power of AND", position: 4, show_in_menus: true, show_on_site: true, section_id: 1, template_id: 5, deleted_at: nil},
  {id: 6, internal_name: "Contact Us", public_name: "", slug: "contact", description: "Contact form", position: 2, show_in_menus: true, show_on_site: true, section_id: nil, template_id: 6, deleted_at: nil}
])
ShinyNewsletters::EditionElement.create!([
  {id: 1, name: "a_heading", content: "The ShinyCMS Newsletter!", element_type: "short_text", position: 1, edition_id: 1, deleted_at: nil},
  {id: 2, name: "top_image", content: "", element_type: "image", position: 2, edition_id: 1, deleted_at: nil},
  {id: 3, name: "top_alt_text", content: "ShinyCMS!", element_type: "short_text", position: 3, edition_id: 1, deleted_at: nil},
  {id: 4, name: "top_title_text", content: "ShinyCMS!", element_type: "short_text", position: 4, edition_id: 1, deleted_at: nil},
  {id: 5, name: "some_longer_text", content: "Welcome, to the very first edition of the ShinyCMS monthly newsletter...\r\n\r\nWell, that's all we've got time for this month. We hope you enjoyed it as much as we did! :D", element_type: "long_text", position: 5, edition_id: 1, deleted_at: nil}
])
ShinyPages::PageElement.create!([
  {id: 1, name: "banner_text", content: "<p><a href=\"https://shinycms.org/\">ShinyCMS</a> is a free and open source content-management system. This <a href=\"http://github.com/denny/ShinyCMS-ruby\">new version</a> is built with <a href=\"https://www.ruby-lang.org/\">Ruby</a> on <a href=\"https://rubyonrails.org/\">Rails</a> (the <a href=\"https://github.com/denny/ShinyCMS\">original version</a> is built with <a href=\"https://www.perl.org/\">Perl</a> and <a href=\"http://www.catalystframework.org/\">Catalyst</a>).</p>\r\n", element_type: "html", position: 1, page_id: 1, deleted_at: nil},
  {id: 2, name: "banner_button_url", content: "https://github.com/denny/ShinyCMS-ruby", element_type: "short_text", position: 2, page_id: 1, deleted_at: nil},
  {id: 3, name: "banner_button_text", content: "ShinyCMS on GitHub", element_type: "short_text", position: 3, page_id: 1, deleted_at: nil},
  {id: 21, name: "heading", content: "", element_type: "short_text", position: 1, page_id: 2, deleted_at: nil},
  {id: 22, name: "subheading", content: "", element_type: "short_text", position: 2, page_id: 2, deleted_at: nil},
  {id: 23, name: "text_content", content: "", element_type: "long_text", position: 3, page_id: 2, deleted_at: nil},
  {id: 24, name: "heading", content: "", element_type: "short_text", position: 1, page_id: 3, deleted_at: nil},
  {id: 25, name: "subheading", content: "", element_type: "short_text", position: 2, page_id: 3, deleted_at: nil},
  {id: 26, name: "text_content", content: "", element_type: "long_text", position: 3, page_id: 3, deleted_at: nil},
  {id: 27, name: "heading", content: "", element_type: "short_text", position: 1, page_id: 4, deleted_at: nil},
  {id: 28, name: "subheading", content: "", element_type: "short_text", position: 2, page_id: 4, deleted_at: nil},
  {id: 29, name: "text_content", content: "", element_type: "long_text", position: 3, page_id: 4, deleted_at: nil},
  {id: 30, name: "heading", content: "", element_type: "short_text", position: 1, page_id: 5, deleted_at: nil},
  {id: 31, name: "subheading", content: "", element_type: "short_text", position: 2, page_id: 5, deleted_at: nil},
  {id: 32, name: "text_content", content: "", element_type: "long_text", position: 3, page_id: 5, deleted_at: nil},
  {id: 4, name: "banner_image", content: "", element_type: "image", position: 4, page_id: 1, deleted_at: nil},
  {id: 34, name: "img1_alt", content: "Screenshot of page admin interface", element_type: "short_text", position: 7, page_id: 1, deleted_at: nil},
  {id: 6, name: "heading1", content: "Pages", element_type: "short_text", position: 8, page_id: 1, deleted_at: nil},
  {id: 7, name: "paragraph1", content: "Template-drive brochure pages with a simple, easy to use admin interface - safely edit the content areas without any risk of disturbing the page layout. Can be organised into nested sections for larger, more complicated sites.", element_type: "long_text", position: 9, page_id: 1, deleted_at: nil},
  {id: 36, name: "img2_alt", content: "Screenshot of blog feature", element_type: "short_text", position: 11, page_id: 1, deleted_at: nil},
  {id: 12, name: "heading3", content: "Discussions / Comments", element_type: "short_text", position: 16, page_id: 1, deleted_at: nil},
  {id: 13, name: "paragraph3", content: "Currently enabled on blog posts and news posts, but can be added to any type of content. Show/hide and lock/unlock whole discussions or individual comments.", element_type: "long_text", position: 17, page_id: 1, deleted_at: nil},
  {id: 37, name: "img3_alt", content: "Screenshot of comment thread, showing multi-level nesting", element_type: "short_text", position: 15, page_id: 1, deleted_at: nil},
  {id: 38, name: "img4_alt", content: "Screenshot showing spam moderation interface", element_type: "short_text", position: 19, page_id: 1, deleted_at: nil},
  {id: 39, name: "img5_alt", content: "placeholder image", element_type: "short_text", position: 23, page_id: 1, deleted_at: nil},
  {id: 40, name: "img6_alt", content: "placeholder image", element_type: "short_text", position: 25, page_id: 1, deleted_at: nil},
  {id: 15, name: "heading4", content: "Anti-spam features", element_type: "short_text", position: 20, page_id: 1, deleted_at: nil},
  {id: 16, name: "paragraph4", content: "Uses reCAPTCHA to detect and block bots. Uses Akismet to flag and hide potential spam comments. Moderation queue for flagged comments, with decisions fed back to Akismet to improve their accuracy.", element_type: "long_text", position: 21, page_id: 1, deleted_at: nil},
  {id: 41, name: "img7_alt", content: "placeholder image", element_type: "short_text", position: 27, page_id: 1, deleted_at: nil},
  {id: 42, name: "img8_alt", content: "placeholder image", element_type: "short_text", position: 29, page_id: 1, deleted_at: nil},
  {id: 5, name: "image1", content: "", element_type: "image", position: 6, page_id: 1, deleted_at: nil},
  {id: 9, name: "heading2", content: "Blog", element_type: "short_text", position: 12, page_id: 1, deleted_at: nil},
  {id: 10, name: "paragraph2", content: "Add posts now, backdate them, or schedule them to appear in the future. Hide/show/edit/delete posts. Decide whether to allow/disable discussion feature (comments) by default, overridable on a per-post basis.", element_type: "long_text", position: 13, page_id: 1, deleted_at: nil},
  {id: 33, name: "banner_img_alt", content: "Screenshot of ShinyCMS user admin page, with ACL", element_type: "short_text", position: 5, page_id: 1, deleted_at: nil},
  {id: 8, name: "image2", content: "", element_type: "image", position: 10, page_id: 1, deleted_at: nil},
  {id: 11, name: "image3", content: "", element_type: "image", position: 14, page_id: 1, deleted_at: nil},
  {id: 14, name: "image4", content: "", element_type: "image", position: 18, page_id: 1, deleted_at: nil},
  {id: 17, name: "image5", content: "", element_type: "image", position: 22, page_id: 1, deleted_at: nil},
  {id: 18, name: "image6", content: "", element_type: "image", position: 24, page_id: 1, deleted_at: nil},
  {id: 19, name: "image7", content: "", element_type: "image", position: 26, page_id: 1, deleted_at: nil},
  {id: 20, name: "image8", content: "", element_type: "image", position: 28, page_id: 1, deleted_at: nil}
])
ShinyNewsletters::Send.create!([
  {id: 1, edition_id: 1, list_id: 1, send_at: nil, started_sending_at: nil, finished_sending_at: nil, deleted_at: nil}
])
ShinyCMS::Discussion.create!([
  {id: 1, resource_type: "ShinyBlog::Post", resource_id: 1, locked: false, show_on_site: true, deleted_at: nil},
  {id: 2, resource_type: "ShinyBlog::Post", resource_id: 2, locked: false, show_on_site: true, deleted_at: nil}
])
ShinyCMS::Comment.create!([
  {id: 1, discussion_id: 1, number: 1, parent_id: nil, title: "Properly nested comments...", body: "Ask for them by name - do not accept inferior substitutes!", ip_address: nil, locked: false, show_on_site: true, spam: false, author_type: "ShinyCMS::User", author_id: 1, posted_at: "2020-02-28 18:56:25", deleted_at: nil},
  {id: 2, discussion_id: 1, number: 2, parent_id: nil, title: "", body: "Yes, this is indeed a comment thread. The nested comments feature was added to ShinyCMS (Ruby version) in February 2020.\r\n\r\n(And to the Perl version in August 2010)", ip_address: nil, locked: false, show_on_site: true, spam: false, author_type: "ShinyCMS::PseudonymousAuthor", author_id: 1, posted_at: "2020-02-28 19:02:46", deleted_at: nil},
  {id: 3, discussion_id: 1, number: 3, parent_id: 1, title: "Nested comments FTW!", body: "", ip_address: nil, locked: true, show_on_site: true, spam: false, author_type: nil, author_id: nil, posted_at: "2020-02-28 19:03:55", deleted_at: nil},
  {id: 4, discussion_id: 1, number: 4, parent_id: 3, title: "I agree with this mysterious stranger! ;)", body: "Nested comments are the only acceptable form of comment system in the 21st century. Or the 20th, for that matter.", ip_address: nil, locked: false, show_on_site: false, spam: false, author_type: "ShinyCMS::User", author_id: 1, posted_at: "2020-02-28 19:08:52", deleted_at: nil},
  {id: 5, discussion_id: 2, number: 1, parent_id: nil, title: "BEST BITCOIN ADVICE", body: "Prey on the misfortunate of others in the coolest ponzi scheme ever to sweep the Internet!!", ip_address: nil, locked: false, show_on_site: true, spam: true, author_type: nil, author_id: nil, posted_at: "2020-06-05 01:23:13", deleted_at: nil},
  {id: 6, discussion_id: 2, number: 2, parent_id: nil, title: nil, body: "Rise to every occasion with our bargain blue diamonds!", ip_address: nil, locked: false, show_on_site: true, spam: true, author_type: "ShinyCMS::PseudonymousAuthor", author_id: 2, posted_at: "2020-06-05 22:56:48", deleted_at: nil},
  {id: 7, discussion_id: 2, number: 3, parent_id: nil, title: nil, body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Curabitur pretium tincidunt lacus. Nulla gravida orci a odio. Nullam varius, turpis et commodo pharetra, est eros bibendum elit, nec luctus magna felis sollicitudin mauris. Integer in mauris eu nibh euismod gravida. Duis ac tellus et risus vulputate vehicula. Donec lobortis risus a elit. Etiam tempor. Ut ullamcorper, ligula eu tempor congue, eros est euismod turpis, id tincidunt sapien risus a quam. Maecenas fermentum consequat mi. Donec fermentum. Pellentesque malesuada nulla a mi. Duis sapien sem, aliquet nec, commodo eget, consequat quis, neque. Aliquam faucibus, elit ut dictum aliquet, felis nisl adipiscing sapien, sed malesuada diam lacus eget erat. Cras mollis scelerisque nunc. Nullam arcu. Aliquam consequat. Curabitur augue lorem, dapibus quis, laoreet et, pretium ac, nisi. Aenean magna nisl, mollis quis, molestie eu, feugiat in, orci. In hac habitasse platea dictumst.", ip_address: nil, locked: false, show_on_site: true, spam: true, author_type: "ShinyCMS::PseudonymousAuthor", author_id: 3, posted_at: "2020-06-05 23:01:17", deleted_at: nil}
])
ActsAsTaggableOn::Tag.create!([
  {id: 1, name: "demo", taggings_count: 3},
  {id: 2, name: "news", taggings_count: 1},
  {id: 3, name: "first post", taggings_count: 2},
  {id: 4, name: "blog", taggings_count: 2},
  {id: 5, name: "meta", taggings_count: 1},
  {id: 6, name: "screenshots", taggings_count: 1}
])
ActsAsTaggableOn::Tagging.create!([
  {id: 1, tag_id: 1, taggable_type: "ShinyNews::Post", taggable_id: 1, tagger_type: nil, tagger_id: nil, context: "tags"},
  {id: 2, tag_id: 2, taggable_type: "ShinyNews::Post", taggable_id: 1, tagger_type: nil, tagger_id: nil, context: "tags"},
  {id: 3, tag_id: 3, taggable_type: "ShinyNews::Post", taggable_id: 1, tagger_type: nil, tagger_id: nil, context: "tags"},
  {id: 4, tag_id: 1, taggable_type: "ShinyBlog::Post", taggable_id: 1, tagger_type: nil, tagger_id: nil, context: "tags"},
  {id: 5, tag_id: 4, taggable_type: "ShinyBlog::Post", taggable_id: 1, tagger_type: nil, tagger_id: nil, context: "tags"},
  {id: 6, tag_id: 3, taggable_type: "ShinyBlog::Post", taggable_id: 1, tagger_type: nil, tagger_id: nil, context: "tags"},
  {id: 7, tag_id: 5, taggable_type: "ShinyBlog::Post", taggable_id: 1, tagger_type: nil, tagger_id: nil, context: "tags"},
  {id: 8, tag_id: 1, taggable_type: "ShinyBlog::Post", taggable_id: 2, tagger_type: nil, tagger_id: nil, context: "tags"},
  {id: 9, tag_id: 4, taggable_type: "ShinyBlog::Post", taggable_id: 2, tagger_type: nil, tagger_id: nil, context: "tags"},
  {id: 10, tag_id: 6, taggable_type: "ShinyBlog::Post", taggable_id: 2, tagger_type: nil, tagger_id: nil, context: "tags"}
])
ActiveStorage::Blob.create!([
  {id: 1, key: "1gnjgo1fpt0jr8xwbxwcmrnft16c", filename: "banner.png", content_type: "image/png", metadata: {"identified"=>true}, byte_size: 203393, checksum: "vxj9Z514JggEw282O3QH+g==", service_name: "local"},
  {id: 2, key: "pkq90885cmh9n5k6i2dke3v1h33w", filename: "pages.png", content_type: "image/png", metadata: {"identified"=>true}, byte_size: 176087, checksum: "hrMduxxNxkV26EkKlhimwg==", service_name: "local"},
  {id: 3, key: "hs8682kbfu6y13ky78wyui775nod", filename: "blog.png", content_type: "image/png", metadata: {"identified"=>true}, byte_size: 391167, checksum: "YaaNOr7GWayfoJSLRQpJUA==", service_name: "local"},
  {id: 4, key: "w112m1libndpm9hdjlz419xe7mka", filename: "nested-comments.png", content_type: "image/png", metadata: {"identified"=>true}, byte_size: 76843, checksum: "ogOwEnzdJBY82zYiWYH/tQ==", service_name: "local"},
  {id: 5, key: "3geflemmivc3y0p4cpdbiyklwpkp", filename: "spam-comment-moderation.png", content_type: "image/png", metadata: {"identified"=>true}, byte_size: 102164, checksum: "Hfbp6FOjcENdbnyYpgHVbw==", service_name: "local"},
  {id: 6, key: "wikgprk4p1wkh83p0nt1t37zedyj", filename: "pic05.jpg", content_type: "image/jpeg", metadata: {"identified"=>true}, byte_size: 3303, checksum: "ertDUTfVVXCzN7LyXVIwhg==", service_name: "local"},
  {id: 7, key: "m2g7wu7p44dlc4bc8maqfnitv3qq", filename: "pic06.jpg", content_type: "image/jpeg", metadata: {"identified"=>true}, byte_size: 1557, checksum: "ZNUE+uSMU2cXw1RusWPZDg==", service_name: "local"},
  {id: 8, key: "7yacs020k8xa52zi0nl2353muak0", filename: "pic07.jpg", content_type: "image/jpeg", metadata: {"identified"=>true}, byte_size: 1594, checksum: "mYzPOdIEPlSxliI3ap23wQ==", service_name: "local"},
  {id: 9, key: "zmbbq0ntamge31841f0bffhmh9zl", filename: "pic08.jpg", content_type: "image/jpeg", metadata: {"identified"=>true}, byte_size: 1672, checksum: "2NFqN8YfXdXKw0IUsXGU1Q==", service_name: "local"},
  {id: 10, key: "b861szoxlgr1z3rz1egybxgd8rm5", filename: "banner.png", content_type: "image/png", metadata: {"identified"=>true}, byte_size: 24871, checksum: "byL48+0tUs5yXTK1zJYOIA==", service_name: "local"},
  {id: 11, key: "mu27bjj29nwdyxefaukg83fevnt8", filename: "nested-comments.png", content_type: "image/png", metadata: {"identified"=>true}, byte_size: 10930, checksum: "BfkSrfQEoZpF8DzoihACPg==", service_name: "local"},
  {id: 12, key: "4m82xc7dtium86hnkviqh58ojwsx", filename: "pages.png", content_type: "image/png", metadata: {"identified"=>true}, byte_size: 18751, checksum: "eGAsBavMVZywy6oaVGTZWg==", service_name: "local"},
  {id: 13, key: "jzw56txm9vab03wr22azeu7huhbh", filename: "spam-comment-moderation.png", content_type: "image/png", metadata: {"identified"=>true}, byte_size: 22435, checksum: "g/HKkLG7Mgf/8B8Z8ovWpg==", service_name: "local"},
  {id: 14, key: "ustal8qqk9lfbd9xyv7kfuycbke5", filename: "blog.png", content_type: "image/png", metadata: {"identified"=>true}, byte_size: 29065, checksum: "LuZVRztP6i+n3oJXa6QytA==", service_name: "local"},
  {id: 15, key: "rcxg77k9tjhg7wel2d4qix5awp7i", filename: "pic06.jpg", content_type: "image/jpeg", metadata: {"identified"=>true}, byte_size: 1607, checksum: "0GgwDYSHxvN3mRjYvNjZ6w==", service_name: "local"},
  {id: 16, key: "2tunomfqz1nc3mxsftok5lbz977h", filename: "pic08.jpg", content_type: "image/jpeg", metadata: {"identified"=>true}, byte_size: 1749, checksum: "ttW8MAOQOouuvr7OiLnYNw==", service_name: "local"},
  {id: 17, key: "avuugui09f93yylid47dqtwioqjl", filename: "pic07.jpg", content_type: "image/jpeg", metadata: {"identified"=>true}, byte_size: 1648, checksum: "kmM3kLvcCkWGBnpdXEFAdg==", service_name: "local"},
  {id: 18, key: "bimea576udvoexjyr3r98l5b4sxh", filename: "pic05.jpg", content_type: "image/jpeg", metadata: {"identified"=>true}, byte_size: 3555, checksum: "hVVguOvnFkmKluo0SEhV+A==", service_name: "local"}
])
ActiveStorage::VariantRecord.create!([
  {id: 1, blob_id: 1, variation_digest: "uRxKmuVZ1tDHW8nIVUApI9rTCa8="},
  {id: 2, blob_id: 4, variation_digest: "uRxKmuVZ1tDHW8nIVUApI9rTCa8="},
  {id: 3, blob_id: 2, variation_digest: "uRxKmuVZ1tDHW8nIVUApI9rTCa8="},
  {id: 4, blob_id: 5, variation_digest: "uRxKmuVZ1tDHW8nIVUApI9rTCa8="},
  {id: 5, blob_id: 3, variation_digest: "uRxKmuVZ1tDHW8nIVUApI9rTCa8="},
  {id: 6, blob_id: 7, variation_digest: "1rYecvTNqece8xQeSStXDFfdaUM="},
  {id: 7, blob_id: 9, variation_digest: "1rYecvTNqece8xQeSStXDFfdaUM="},
  {id: 8, blob_id: 8, variation_digest: "1rYecvTNqece8xQeSStXDFfdaUM="},
  {id: 9, blob_id: 6, variation_digest: "1rYecvTNqece8xQeSStXDFfdaUM="}
])
ActiveStorage::Attachment.create!([
  {id: 1, name: "image", record_type: "ShinyPages::PageElement", record_id: 4, blob_id: 1},
  {id: 2, name: "image", record_type: "ShinyPages::PageElement", record_id: 5, blob_id: 2},
  {id: 3, name: "image", record_type: "ShinyPages::PageElement", record_id: 8, blob_id: 3},
  {id: 4, name: "image", record_type: "ShinyPages::PageElement", record_id: 11, blob_id: 4},
  {id: 5, name: "image", record_type: "ShinyPages::PageElement", record_id: 14, blob_id: 5},
  {id: 6, name: "image", record_type: "ShinyPages::PageElement", record_id: 17, blob_id: 6},
  {id: 7, name: "image", record_type: "ShinyPages::PageElement", record_id: 18, blob_id: 7},
  {id: 8, name: "image", record_type: "ShinyPages::PageElement", record_id: 19, blob_id: 8},
  {id: 9, name: "image", record_type: "ShinyPages::PageElement", record_id: 20, blob_id: 9},
  {id: 10, name: "image", record_type: "ActiveStorage::VariantRecord", record_id: 1, blob_id: 10},
  {id: 11, name: "image", record_type: "ActiveStorage::VariantRecord", record_id: 2, blob_id: 11},
  {id: 12, name: "image", record_type: "ActiveStorage::VariantRecord", record_id: 3, blob_id: 12},
  {id: 13, name: "image", record_type: "ActiveStorage::VariantRecord", record_id: 4, blob_id: 13},
  {id: 14, name: "image", record_type: "ActiveStorage::VariantRecord", record_id: 5, blob_id: 14},
  {id: 15, name: "image", record_type: "ActiveStorage::VariantRecord", record_id: 6, blob_id: 15},
  {id: 16, name: "image", record_type: "ActiveStorage::VariantRecord", record_id: 7, blob_id: 16},
  {id: 17, name: "image", record_type: "ActiveStorage::VariantRecord", record_id: 8, blob_id: 17},
  {id: 18, name: "image", record_type: "ActiveStorage::VariantRecord", record_id: 9, blob_id: 18}
])
