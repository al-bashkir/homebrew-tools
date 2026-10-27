class Kubegonfig < Formula
  desc "Manage and switch between Kubernetes configurations"
  homepage "https://github.com/al-bashkir/kubegonfig"
  license "AGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/al-bashkir/kubegonfig/releases/download/v0.8/kubegonfig-darwin-arm64"
      sha256 "755568c476c7bacfe74be96af8f14247c17d9a88f2c2b0102ca93e18311e6b4a"
    end
    on_intel do
      url "https://github.com/al-bashkir/kubegonfig/releases/download/v0.8/kubegonfig-darwin-amd64"
      sha256 "60d26aae8d72e158ccbcf66d70e35e918c920251e32f7ec2d80d596bce18af62"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/kubegonfig/releases/download/v0.8/kubegonfig-linux-arm64"
      sha256 "06793d45e29094b7195a4647e2c508939f6e33f891bece15e52f5dc8e4cca1ec"
    end
    on_intel do
      url "https://github.com/al-bashkir/kubegonfig/releases/download/v0.8/kubegonfig-linux-amd64"
      sha256 "7b8068ae7942ac20c103e091ca38a12080faabdea46f782f78cec88539f1080a"
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
