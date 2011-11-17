require 'ffi-xattr'

describe Xattr do
  let(:path)  { "test.txt" }
  let(:xattr) { Xattr.new(path) }

  before { File.open(path, "w") { |io| io << "some content" } }
  after  { File.delete(path) }

  it "has an inital empty list of xattrs" do
    xattr.list.should be_kind_of(Array)
    xattr.list.should be_empty
  end

  it "can set and get attributes" do
    xattr.set "user.foo", "bar"
    xattr.set "user.bar", "boo"

    xattr.list.sort.should == ["user.bar", "user.foo"]

    xattr.get("user.foo").should == "bar"
    xattr.get("user.bar").should == "boo"
  end

  it "can get and set with #[] and #[]=" do
    xattr['user.foo'] = 'baz'
    xattr['user.foo'].should == 'baz'
  end

  it "can remove attributes" do
    xattr.set "user.foo", "bar"
    xattr.list.should == ["user.foo"]

    xattr.remove "user.foo"
    xattr.list.should == []
  end

  it "raises error when tries to remove inexistent attribute" do
    lambda { xattr.remove("inexisting") }.should raise_error
  end

  it "returns nil if the attribute is not set" do
    xattr.get("hello").should be_nil
  end

  it "can iterate over all attributes" do
    xattr.set("user.hello", "world")

    called = false
    xattr.each do |key, value|
      called = true

      key.should == "user.hello"
      value.should == "world"
    end

    called.should be_true
  end

  it "is Enumerable" do
    xattr.should be_kind_of(Enumerable)

    xattr['user.foo'] = 'bar'
    xattr.to_a.should == [['user.foo', 'bar']]
  end

  it "returns a Hash for #as_json" do
    xattr['user.foo'] = 'bar'
    xattr['user.bar'] = 'baz'

    xattr.as_json.should == {'user.foo' => 'bar', 'user.bar' => 'baz'}
  end

  it "raises Errno::ENOENT if the file doesn't exist" do
    lambda { Xattr.new("no-such-file") }.should raise_error(Errno::ENOENT)
  end

  it "should raise type error if initialized with object that can not be directly converted to string" do
    lambda{ Xattr.new(1) }.should raise_error(TypeError)
  end

  class SuperPath
    def initialize(path)
      @path = path
    end

    def to_str
      @path.dup
    end
  end

  it "should work with object that can be directly converted to string" do
    super_path = SuperPath.new(path)
    Xattr.new(super_path).set('user.foo', 'bar')
    Xattr.new(super_path).get('user.foo').should == 'bar'
  end

  describe "respecting :no_follow option" do
    let(:link)   { "link.txt" }
    let(:xattr_f) { Xattr.new(link, :no_follow => false) }
    let(:xattr_n) { Xattr.new(link, :no_follow => true) }

    before { File.symlink(path, link) }
    after  { File.delete(link) }

    case RUBY_PLATFORM
    when /linux/
      # http://linux.die.net/man/5/attr
      it "should allow getting extended attributes on any type" do
        xattr['user.a']
        xattr_f['user.b']
        xattr_n['user.c']
      end

      it "should fail setting extended attributes on symlink" do
        lambda { xattr['user.a'] = 'foo' }.should_not raise_error
        lambda { xattr_f['user.b'] = 'bar' }.should_not raise_error
        lambda { xattr_n['user.c'] = 'baz' }.should raise_error
      end
    when /darwin|bsd/
      it "should set and get attributes" do
        xattr['user.a'] = 'foo'
        xattr_f['user.b'] = 'bar'
        xattr_n['user.c'] = 'baz'

        xattr.list.sort.should == %w[user.a user.b]
        xattr_f.list.sort.should == %w[user.a user.b]
        xattr_n.list.sort.should == %w[user.c]

        xattr['user.a'].should == 'foo'
        xattr['user.b'].should == 'bar'
        xattr['user.c'].should be_nil
        xattr_f['user.a'].should == 'foo'
        xattr_f['user.b'].should == 'bar'
        xattr_f['user.c'].should be_nil
        xattr_n['user.a'].should be_nil
        xattr_n['user.b'].should be_nil
        xattr_n['user.c'].should == 'baz'
      end

      it "should remove attributes" do
        xattr['user.a'] = 'foo'
        xattr_f['user.b'] = 'bar'
        xattr_n['user.c'] = 'baz'
        xattr_n['user.d'] = 'ban'

        xattr.list.sort.should == %w[user.a user.b]
        xattr_f.list.sort.should == %w[user.a user.b]
        xattr_n.list.sort.should == %w[user.c user.d]

        xattr_f.remove('user.a')
        xattr_n.remove('user.c')

        xattr.list.sort.should == %w[user.b]
        xattr_f.list.sort.should == %w[user.b]
        xattr_n.list.sort.should == %w[user.d]
      end
    end
  end
end
