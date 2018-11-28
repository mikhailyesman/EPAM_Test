# # encoding: utf-8

# Inspec test for recipe task9::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe package("docker-ce") do
  it { should be_installed } 
end


# This is an example test, replace it with your own test.
describe port(80), :skip do
  it { should_not be_listening }
end
