# Copyright (c) 2011 Ketan Padegaonkar.
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

require 'time'

namespace :release do
  
  desc 'Update the changelog'
  task :changelog do
    File.open('CHANGELOG', 'w+') do |changelog|
      `git log -z --abbrev-commit lib`.split("\0").each do |commit|
        next if commit =~ /^Merge: \d*/
        ref, author, time, _, title, _, message = commit.split("\n", 7)
        ref    = ref[/commit ([0-9a-f]+)/, 1]
        author = author[/Author: (.*)/, 1].strip
        time   = Time.parse(time[/Date: (.*)/, 1]).utc
        title.strip!

        changelog.puts "[#{ref} | #{time}] #{author}"
        changelog.puts '', "  * #{title}"
        changelog.puts '', message.rstrip if message
        changelog.puts
      end
    end
  end
  
  desc 'Create the dmon gem'
  task :gem => [:changelog, :copyright] do
    files = ['README.textile', 'MIT-LICENSE.txt', 'CHANGELOG']

    spec = Gem::Specification.new do |s|
      s.name              = "dmon"
      s.version           = "0.0.1a"
      s.author            = "Ketan Padegaonkar"
      s.email             = "ketanpadegaonkar@gmail.com"
      s.homepage          = "http://github.com/ketan/dmon"
      s.platform          = Gem::Platform::RUBY
      s.summary           = "Makes for easy process management across rubies and OSes"
      s.description       = "Makes for easy process management across rubies and OSes"
      s.files             = (`git ls-files`.split("\n") + ["#{s.name}.gemspec", "CHANGELOG"]).flatten.sort.uniq
      s.has_rdoc          = false

      s.extra_rdoc_files  = ["README.textile", "MIT-LICENSE.txt"]
    end
    File.open("#{spec.name}.gemspec", "w") { |f| f << spec.to_ruby }
    
    sh "gem build #{spec.name}.gemspec"
    
    rm_rf "pkg", :verbose => false
    mkdir "pkg", :verbose => false
    mv "#{spec.name}-#{spec.version}.gem", "pkg", :verbose => false
  end
  
  desc 'Push the gem out to gemcutter'
  task :push => [:test, :gem] do
    
    puts <<-INSTRUCTIONS
    
      ==============================================================
      Instructions before you push out:
      * Make sure everything is good
      * Bump the version number in the `gem.rake' file
      * Check in
      * Run this task again to:
        * verify everything is good
        * generate a new gem with the new version number
      * Create a tag in git:
        $ git tag -a -m 'Tag for version X.Y.Z' 'vX.Y.Z'
        $ gem push pkg/dmon-X.Y.Z.gem
      ==============================================================
    INSTRUCTIONS
    # sh("gem push pkg/*.gem") do |res, ok|
    #   raise 'Could not push gem' if !ok
    # end
  end

end
