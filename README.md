ffi-xattr
=========

Ruby library to manage extended file attributes.

[![Build Status](https://secure.travis-ci.org/jarib/ffi-xattr.png)](http://travis-ci.org/jarib/ffi-xattr)


Example
-------

    xattr = Xattr.new("/path/to/file")
    xattr['user.foo'] = 'bar'

    xattr['user.foo'] #=> 'bar'
    xattr.list        #=> ["user.foo"]

    xattr.each { |key, value| ... }
    xattr.as_json     #=> {"user.foo" => "bar"}


Note on Patches/Pull Requests
-----------------------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
---------

Copyright 2011 Jari Bakken

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
