
Gem::Specification.new do |s|
  s.name = "radiant-page_reader_group_permissions-extension"
  s.version = "1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matt Freels", "Nikos Dimitrakopoulos", "Jim Gay", "Matthew Bass", "Andrew vonderLuft", "Craig Amborse"]
  s.date = "2013-03-14"
  s.description = "To apply group-based edit permissions to the page hierarchy using the groups supplied by the readers extension."
  s.email = "craig@enspiral.com"
  s.extra_rdoc_files = [
    "README.textile"
  ]
  s.files = ["README.textile", "Rakefile","VERSION"] +
    Dir.glob("{app|config|db|lib|public|spec}/**/*")
  s.homepage = "https://github.com/enspiral/radiant-page_reader_group_permissions-extension"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.25"
  s.summary = "Page Reader Group Permissions Extension for Radiant CMS"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<radiant>, [">= 0.9.1"])
    else
      s.add_dependency(%q<radiant>, [">= 0.9.1"])
    end
  else
    s.add_dependency(%q<radiant>, [">= 0.9.1"])
  end
end

