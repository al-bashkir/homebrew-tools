class Kubegonfig < Formula
  desc "Manage and switch between Kubernetes configurations"
  homepage "https://github.com/al-bashkir/kubegonfig"
  license "AGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/al-bashkir/kubegonfig/releases/download/v0.10/kubegonfig-darwin-arm64"
      sha256 "6f258d70e3c9810a31d2c130d23d83c83e0d029b9348fb0000d0c7399e4db9e7"
    end
    on_intel do
      url "https://github.com/al-bashkir/kubegonfig/releases/download/v0.10/kubegonfig-darwin-amd64"
      sha256 "4b863b3e20d1e111a3678f7d5a95891f281e3ebc172d2368f6da3d3fb44c7bdc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/kubegonfig/releases/download/v0.10/kubegonfig-linux-arm64"
      sha256 "19b4063a2aee9cc8d2e71b8aa10dd7299fd13478f4311dbe80d5f17ccf3b80b8"
    end
    on_intel do
      url "https://github.com/al-bashkir/kubegonfig/releases/download/v0.10/kubegonfig-linux-amd64"
      sha256 "e36b7dd5c20f70ea6e39407a89459a7bd3faee867c342763780c95a83e4633cb"
    end
  end

  def install
    bin.install Dir["kubegonfig-*"].first => "kubegonfig"
    (bin/"kubegonfig").chmod 0555 # bare release binary ships without the exec bit
    generate_completions_from_executable(bin/"kubegonfig", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_path_exists bin/"kubegonfig"
    assert_predicate bin/"kubegonfig", :executable?
  end
end
