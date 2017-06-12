# spec/Dockerfile_spec.rb

require "serverspec"
require "docker"

describe "Dockerfile" do
  before(:all) do
    image = Docker::Image.build_from_dir('.')

    set :os, family: :debian
    set :backend, :docker
    set :docker_image, image.id
  end

  it "installs the right version of Debian" do
    expect(os_version).to include("Debian")
  end

  def os_version
    command("cat /etc/issue").stdout
  end
end
