# Copyright (c) 2011 Ketan Padegaonkar.
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)
require 'yard'
YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']   # optional
  t.options = ['--any', '--extra', '--opts'] # optional
end
