class Sshelf < Formula
  desc "TUI for managing SSH connections"
  homepage "https://github.com/al-bashkir/sshelf"
  license "MIT"
  # Renamed from ssh-tui (last 1.3.4); version restarted at 0.1.0, so bump the scheme to upgrade migrated installs.
  version_scheme 1

  on_macos do
    on_arm do
      url "https://github.com/al-bashkir/sshelf/releases/download/v0.3.0/sshelf_v0.3.0_darwin_arm64.tar.gz"
      sha256 "a675e694109988f1f74ef5e6553821030f148c62a25092406ff3209bec6c0e26"
    end
    on_intel do
      url "https://github.com/al-bashkir/sshelf/releases/download/v0.3.0/sshelf_v0.3.0_darwin_amd64.tar.gz"
      sha256 "68c72d7b5d2396b29b1765291f05ac6acfc2ee80a4e2a134517eadef5049f7b3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/sshelf/releases/download/v0.3.0/sshelf_v0.3.0_linux_arm64.tar.gz"
      sha256 "ddb284a9335111e2db1367a812e33607794ecb3036d5883ba17e062035e646ed"
    end
    on_intel do
      url "https://github.com/al-bashkir/sshelf/releases/download/v0.3.0/sshelf_v0.3.0_linux_amd64.tar.gz"
      sha256 "04d2d2242e24945bd3aa3c8edf52f3bfba7c1902aec163b32a6cdcdb9eeeda78"
    end
  end

  def install
    bin.install "sshelf"
    generate_completions_from_executable(bin/"sshelf", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_path_exists bin/"sshelf"
    assert_predicate bin/"sshelf", :executable?
  end
end
