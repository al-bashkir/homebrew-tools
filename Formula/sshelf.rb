class Sshelf < Formula
  desc "TUI for managing SSH connections"
  homepage "https://github.com/al-bashkir/sshelf"
  license "MIT"
  # Renamed from ssh-tui (last 1.3.4); version restarted at 0.1.0, so bump the scheme to upgrade migrated installs.
  version_scheme 1

  on_macos do
    on_arm do
      url "https://github.com/al-bashkir/sshelf/releases/download/v0.1.0/sshelf_v0.1.0_darwin_arm64.tar.gz"
      sha256 "92aeda0930909286798a81e39f08d0ed6ea6fa550f506742a009fb95fc0b62a6"
    end
    on_intel do
      url "https://github.com/al-bashkir/sshelf/releases/download/v0.1.0/sshelf_v0.1.0_darwin_amd64.tar.gz"
      sha256 "c9e1649ec42f8876b8ed025e5b0718b0fc3d150a05a6ad33ff6f1d8e817bbc9e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/sshelf/releases/download/v0.1.0/sshelf_v0.1.0_linux_arm64.tar.gz"
      sha256 "cff3173a83b9fec713329f1fa01f50ba7de4b227b0be1cad76f6b0304961850e"
    end
    on_intel do
      url "https://github.com/al-bashkir/sshelf/releases/download/v0.1.0/sshelf_v0.1.0_linux_amd64.tar.gz"
      sha256 "239273ffac0af8286e2c2755d9ef2d27d2475f5731e3cd425d47283ff89959e4"
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
