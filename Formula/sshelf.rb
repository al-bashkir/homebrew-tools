class Sshelf < Formula
  desc "TUI for managing SSH connections"
  homepage "https://github.com/al-bashkir/sshelf"
  license "MIT"
  # Renamed from ssh-tui (last 1.3.4); version restarted at 0.1.0, so bump the scheme to upgrade migrated installs.
  version_scheme 1

  on_macos do
    on_arm do
      url "https://github.com/al-bashkir/sshelf/releases/download/v0.2.0/sshelf_v0.2.0_darwin_arm64.tar.gz"
      sha256 "cdb773d884d4b8b125d67204d71acc01ee7bb42b2fd888f206b46a63691fef4e"
    end
    on_intel do
      url "https://github.com/al-bashkir/sshelf/releases/download/v0.2.0/sshelf_v0.2.0_darwin_amd64.tar.gz"
      sha256 "f80573e1532a161fc2e23a7455c5c5a89dc6f8a90c37fa0057be5a2c4a6e168d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/sshelf/releases/download/v0.2.0/sshelf_v0.2.0_linux_arm64.tar.gz"
      sha256 "c3109d0e11984c8078f1ce18d3facb99f187241789dcd54f118b21dc918ea579"
    end
    on_intel do
      url "https://github.com/al-bashkir/sshelf/releases/download/v0.2.0/sshelf_v0.2.0_linux_amd64.tar.gz"
      sha256 "09ac8087a63fed8e26efb31ed2a8db1e4c82b8f60eef38d66a7c7bf9ded4d5ba"
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
