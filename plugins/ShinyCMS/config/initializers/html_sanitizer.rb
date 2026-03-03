# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Default configuration for the HTML sanitizer

# a, abbr, acronym, address, b, big, blockquote, br, cite, code, dd, del, dfn, div, dt, em, h1, h2, h3, h4, h5, h6,
# hr, i, img, ins, kbd, li, ol, p, pre, samp, small, span, strong, sub, sup, tt, ul, var, video
ActionView::Base.sanitized_allowed_tags = %w[
  a
  p br
  h1 h2 h3 h4 h5 h6
  ul ol li
  blockquote code pre span
  img video source
  b i strong em
  small
]

# abbr, alt, cite, class, datetime, height, href, name, src, title, width, xml:lang
ActionView::Base.sanitized_allowed_attributes = %w[
  class
  href src
  name type
  title alt
  height width
]
