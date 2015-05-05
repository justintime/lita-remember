require "spec_helper"

describe Lita::Handlers::Remember, lita_handler: true do
  # Lookup routes
  it { is_expected.to route_command("What is foo bar").to(:lookup) }
  it { is_expected.to route_command("What are foo bars").to(:lookup) }
  it { is_expected.to route_command("what is foo bar").to(:lookup) }
  it { is_expected.to route_command("what are foo bars").to(:lookup) }

  # Remember routes
  it { is_expected.to route_command("Remember foo bar is baz").to(:remember) }
  it { is_expected.to route_command("Remember foo bars are baz").to(:remember) }
  it { is_expected.to route_command("remember foo bar is baz").to(:remember) }
  it { is_expected.to route_command("remember foo bars are baz").to(:remember) }

  # Forget routes
  it { is_expected.to route_command("Forget foo bar").to(:forget) }
  it { is_expected.to route_command("Forget about foo bar").to(:forget) }
  it { is_expected.to route_command("forget foo bar").to(:forget) }
  it { is_expected.to route_command("forget about foo bar").to(:forget) }

  # "All" routes
  it { is_expected.to route_command("What do you remember").to(:all_the_terms) }
  it { is_expected.to route_command("what do you remember").to(:all_the_terms) }
  it { is_expected.to route_command("What do you remember?").to(:all_the_terms) }
  it { is_expected.to route_command("what do you remember?").to(:all_the_terms) }

  # Search routes
  it { is_expected.to route_command("Search terms for foo").to(:search) }
  it { is_expected.to route_command("Search definitions for baz").to(:search) }
  it { is_expected.to route_command("search terms for foo").to(:search) }
  it { is_expected.to route_command("search definitions for baz").to(:search) }

  it "saves and remembers terms" do
    send_command("remember foo is bar")
    expect(replies.last).to eq("OK, I'll remember foo is bar")
    send_command("what is foo")
    expect(replies.last).to start_with("foo is bar")
  end

  it "treats terms as case insensitive and definitions as case sensitive" do
    send_command("remember FoO is bAr")
    send_command("what is fOo")
    expect(replies.last).to start_with("fOo is bAr")
  end

  it "deletes terms and returns a warning when an undefined term is accessed" do
    send_command("remember foo is bar")
    send_command("forget about foo")
    send_command("what is foo?")
    expect(replies.last).to start_with("I don't know what foo is")
  end

  it "lists terms" do
    send_command("remember foo is bar")
    send_command("remember baz is blah")
    send_command("remember carl is pug")
    send_command("what do you remember")
    expect(replies.last).to match(/.*baz.*carl.*foo/m)
  end

  describe "#search" do
    it "returns terms matching a term search" do
      send_command("remember foo is bar")
      send_command("remember bazfoo is bar")
      send_command("remember foobaz is bar")
      send_command("remember blahfoobaz is bar")
      send_command("remember hello.amaninacan is lol")
      send_command("search terms for foo")
      expect(replies.last).to match(/.*bazfoo.*blahfoobaz.*foo.*foobaz/m)
    end

    it "returns terms matching a definition search" do
      send_command("remember foo is bar")
      send_command("remember bazfoo is bar")
      send_command("remember foobaz is bar")
      send_command("remember blahfoobaz is bar")
      send_command("remember hello.amaninacan is lol")
      send_command("search definitions for bar")
      expect(replies.last).to match(/.*bazfoo.*blahfoobaz.*foo.*foobaz/m)
    end

    it "replies with a warning if there are no matching keys" do
      send_command("search terms for foo")
      expect(replies.last).to eq("No matching terms found.")
    end
  end

end
