Some random minor util code I like.

The gem stuff:

* `rake gem:rubygems_login` - log me in to rubygems

* `rake gem:bump_version` - increments patch level; will also re-run
  `bundle install` with whatever's committed to the current checkout
* `rake gem:build_the_gem` - creates the gem artifact
* `rake gem:push_to_github` - just does `git push github master`
* `rake gem:push_to_rubygems` - uploads to rubygems

* `rake gem:rubygems_logout` - log me out of rubygems
