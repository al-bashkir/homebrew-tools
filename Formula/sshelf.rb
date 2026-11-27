class Sshelf < Formula
  desc "TUI for managing SSH connections"
  homepage "https://github.com/al-bashkir/sshelf"
  license "MIT"
  # Renamed from ssh-tui (last 1.3.4); version restarted at 0.1.0, so bump the scheme to upgrade migrated installs.
  version_scheme 1

  on_macos do
    on_arm do
      url "https://github.com/al-bashkir/sshelf/releases/download/v0.4.0/sshelf_v0.4.0_darwin_arm64.tar.gz"
      sha256 "c6640c11fa048c42fc26e461576ddd96412bf67c67b4e431c9b2b8485f99990c"
    end
    on_intel do
      url "https://github.com/al-bashkir/sshelf/releases/download/v0.4.0/sshelf_v0.4.0_darwin_amd64.tar.gz"
      sha256 "58bf1524814657faf2dce04d84dea3bf5de2f934670651dd59e17a0395a03a78"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/sshelf/releases/download/v0.4.0/sshelf_v0.4.0_linux_arm64.tar.gz"
      sha256 "55c0591a9206d3e071a4921ea2398e6002bc7e6e705751893de1935e77a3c472"
    end
    on_intel do
      url "https://github.com/al-bashkir/sshelf/releases/download/v0.4.0/sshelf_v0.4.0_linux_amd64.tar.gz"
      sha256 "14608de4fc42891068cbb6862ef1349a2756529e7d9a265ac00951cc24f9cf57"
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
