require 'spec_helper'

describe I18n::Lazy::Generator::ERB do
  subject { I18n::Lazy::Generator::ERB }

  describe '.substitute_erb_with' do
    it 'enumerates on each erb tag' do
      expect(subject.substitute_erb_with("Hello <%= there %>") do |content|
        content.reverse
      end).to eq "Hello #{'<%= there %>'.reverse}"
    end
  end

  describe '.escape_tags' do
    it 'removes ERB tags in start and end' do
      expect(subject.escape_tags("<%= lel %>")). to eq "lel"
    end
  end

  describe '.contains_link?' do
    context 'returns whether string contains erb links' do
      matches = {
        "Simple test" => false,
        '<a href="http://google.com">link</a>'  => false,
        '<%=link_to("rofl", "google.com")%>'    => true,
        '<%= link_to(rofl, "malware.soft") %>'  => true,
      }

      matches.each do |test, result|
        it "#{test} => #{result}" do
          expect(subject.contains_link?(test)).to eq result
        end
      end
    end
  end

  describe '.link?' do
    context 'shows whether string contains a link or not' do
      matches = {
        "<%= link_to 'rofl', 'google.com'%>"  => true,
        "link to simple test"                 => false
      }

      matches.each do |test, result|
        it "#{test} => #{result}" do
          expect(subject.link?(test)).to eq result
        end
      end
    end
  end

  describe '.last_identifier' do
    context 'returns last indentifier inside ERB' do
      matches = {
        'func(x)'           => 'func',
        'first.last'        => 'last',
        'first.second.last' => 'last',
        'fist.last x'       => 'last',
        'simple'            => 'simple',
        'func x'            => 'func'
      }

      matches.each do |test, result|
        it "#{test} => #{result}" do
          expect(subject.last_identifier(test)).to eq result
        end
      end
    end
  end

  describe '.link_label' do
    context "returns label of given 'link_to'" do
      matches = {
        "link_to('google', google_link)"  => "'google'",
        "link_to 'uber', superlink"       => "'uber'",
        "link_to ('rofl', something)"     => "'rofl'",
        "link_to(var, link)"              => "var"
      }

      matches.each do |test, result|
        it "#{test} => #{result}" do
          expect(subject.link_label(test)).to eq result
        end
      end
    end
  end
end