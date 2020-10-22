# ShinyCMS: copying data from Perl version to Ruby version

Incoherent notes follow...

## General

We're assuming MySQL at Perl end, Postgres at Ruby end.


## Tables (for features that have been re-implemented)

blog_post -> blog_posts
    id (int-> bigint)
    title
    url_title -> slug
    body
    hidden (tinyint -> boolean)
    blog -> blog_id
    author -> user_id
    posted -> posted_at, created_at, updated_at
    discussion -> [ gone - replaced by wibbly-wobbly polymorphy stuff ]

cms_page -> pages
    id (int-> bigint)
    name
    url_title -> slug
    title
    description
    template -> template_id
    section -> section_id
    menu_position -> sort_order
    hidden (tinyint -> boolean)
    -> hidden_from_menu
    created -> created_at, updated_at

cms_page_element -> page_elements
    id (int-> bigint)
    page - page_id
    name
    content
    type -> element_type
    created -> created_at, updated_at

cms_template -> page_templates
    id (int-> bigint)
    name
    -> description
    template_file -> filename
    created -> created_at, updated_at

cms_template_element -> page_template_elements
    id (int-> bigint)
    template -> template_id
    name
    -> content
    type -> element_type
    created -> created_at, updated_at

cms_section -> page_sections
    id (int-> bigint)
    name
    description
    -> title
    url_name -> slug
    default_page -> default_page_id
    -> section_id
    menu_position -> sort_order
    hidden (tinyint -> boolean)
    -> hidden_from_menu
    created -> created_at, updated_at

comment

comment_like

discussion

news_item -> news_posts

mail_recipient
mailing_list
subscription

newsletter
newsletter_element
newsletter_template
newsletter_template_element

shared_content -> insert_elements

tag
tagset -> taggings ??

user
role -> ???
user_role -> ???
