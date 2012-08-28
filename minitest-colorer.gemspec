Gem::Specification.new do |s|
  s.name = %q{minitest-colorer}
  s.description = "Colors your MiniTest output"
  s.summary = s.description
  s.version = "0.1.1"
  s.date = %q{2012-06-04}
  s.authors = ["Chris Moore"]
  s.homepage = %q{https://github.com/moorecp/minitest-colorer}
  s.require_paths = ["lib"]
  s.files = `git ls-files`.split($/)

  s.add_dependency('minitest')
end
