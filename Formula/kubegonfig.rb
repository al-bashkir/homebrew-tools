class Kubegonfig < Formula
  desc "Manage and switch between Kubernetes configurations"
  homepage "https://github.com/al-bashkir/kubegonfig"
  license "AGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/al-bashkir/kubegonfig/releases/download/v0.9/kubegonfig-darwin-arm64"
      sha256 "3ca4da726b71cfdea4a202368db5b66b33184abd1c986193fd5015b1ac088585"
    end
    on_intel do
      url "https://github.com/al-bashkir/kubegonfig/releases/download/v0.9/kubegonfig-darwin-amd64"
      sha256 "3961fb6b55999962cc178f4ba18e6ac1ebb089209cb5f769239c530199dcba07"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/kubegonfig/releases/download/v0.9/kubegonfig-linux-arm64"
      sha256 "56e94040a7635bf439cd210d88c1cd696654782149858c992b2ed1166a6b1e83"
    end
    on_intel do
      url "https://github.com/al-bashkir/kubegonfig/releases/download/v0.9/kubegonfig-linux-amd64"
      sha256 "8296bbfe2a99c93d134b6e6134d735c8fb9be615fddd4dc7b1c51852d82fc671"
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
