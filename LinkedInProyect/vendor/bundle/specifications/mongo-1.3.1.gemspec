# -*- encoding: utf-8 -*-
# stub: mongo 1.3.1 ruby lib

Gem::Specification.new do |s|
  s.name = "mongo"
  s.version = "1.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jim Menard", "Mike Dirolf", "Kyle Banker"]
  s.date = "2011-05-11"
  s.description = "A Ruby driver for MongoDB. For more information about Mongo, see http://www.mongodb.org."
  s.email = "mongodb-dev@googlegroups.com"
  s.executables = ["mongo_console"]
  s.extra_rdoc_files = ["README.md"]
  s.files = ["README.md", "bin/mongo_console"]
  s.homepage = "http://www.mongodb.org"
  s.rdoc_options = ["--main", "README.md", "--inline-source"]
  s.rubygems_version = "2.4.6"
  s.summary = "Ruby driver for the MongoDB"

  s.installed_by_version = "2.4.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<bson>, [">= 1.3.1"])
    else
      s.add_dependency(%q<bson>, [">= 1.3.1"])
    end
  else
    s.add_dependency(%q<bson>, [">= 1.3.1"])
  end
end
