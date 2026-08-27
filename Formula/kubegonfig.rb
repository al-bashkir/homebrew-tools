class Kubegonfig < Formula
  desc "Manage and switch between Kubernetes configurations"
  homepage "https://github.com/al-bashkir/kubegonfig"
  license "AGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/al-bashkir/kubegonfig/releases/download/v0.7/kubegonfig-darwin-arm64"
      sha256 "71eb22fc759d1deb047850c94960ef8af049010f07a7d509382e0a6d5f1cd8e8"
    end
    on_intel do
      url "https://github.com/al-bashkir/kubegonfig/releases/download/v0.7/kubegonfig-darwin-amd64"
      sha256 "d45a40409be4626ff40bc505dc3f248d5f72f68f22389c36b44d6cf054a976c3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/kubegonfig/releases/download/v0.7/kubegonfig-linux-arm64"
      sha256 "e837328bc20f3ba862e845cd276c20a26b2ac2cf5484e921e13d59761c2352a8"
    end
    on_intel do
      url "https://github.com/al-bashkir/kubegonfig/releases/download/v0.7/kubegonfig-linux-amd64"
      sha256 "dc759771531541d564224545446bc787619b58b242e28921461ffb512fecaeb9"
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
